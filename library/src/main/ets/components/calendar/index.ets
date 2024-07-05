import dayjs, { Dayjs } from "@hview/dayjs"
import {Lunar} from 'lunar'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { IbestUIBaseStyleObjType, IbestUIBaseStyleValue } from '../../theme-chalk/src/index.type'
import { ColorType, COLOR_TYPE } from '../../theme-chalk/src/color.type'
import { ConfirmResultType } from './index.type'
import { FONT_SIZE } from '../../theme-chalk/src/font.type'
import { spaceData } from '../../theme-chalk/src/space'
import { borderRadiusData } from '../../theme-chalk/src/border'
import { fontSizeData } from '../../theme-chalk/src/font'

class DayItemObj{
    date: Dayjs = dayjs()
    dateStr: string = ""
    year: string = ""
    month: string = ""
    day: string = ""
    weekNum: number = 0
    lunarMonth: string = ""
    lunarDay: string = ""
    isCurMonthDay: boolean = false
    isSelected: boolean = false
}
@Observed
class DayItemType extends DayItemObj{
    constructor(value?: DayItemObj){
        super()
        if(value){
            this.date = value.date
            this.dateStr = value.dateStr
            this.weekNum = value.weekNum
            this.lunarMonth = value.lunarMonth
            this.lunarDay = value.lunarDay
            this.year = value.year
            this.month = value.month
            this.day = value.day
            this.isCurMonthDay = value.isCurMonthDay
            this.isSelected = value.isSelected
        }
    }
}
interface HeaderItemType{
    text: string
    key: number
}
type SelectType = "single" | "multiple" | "range"
type SelectedStyleType = "normal" | "circle"
type WeekDayType = "一" | "二" | "三" | "四" | "五" | "六" | "日"

@Extend(Text) function headerStyle(){
    .width("13%")
    .textAlign(TextAlign.Center)
    .fontSize(fontSizeData.fontSizeSm)
    .fontColor("#999")
}
@Component
struct CalendarItem {
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IbestUIBaseStyleObjType = getDefaultBaseStyle();
    @State fontColor: string | IbestUIBaseStyleValue = "#333"
    @State bgColor: string | IbestUIBaseStyleValue = "#fff"
    @ObjectLink @Watch("itemChange") dayItem: DayItemType
    @Consume isShowLunar: boolean
    @Consume type: ColorType
    @Consume selectType: SelectType
    @Consume selectedStyleType: SelectedStyleType
    @Consume selectedColor: string
    @Consume @Watch("itemChange") selectedList: Array<DayItemType>

    aboutToAppear(): void {
        this.itemChange()
    }
    itemChange(){
        let item = this.dayItem
        let dateStr = item.dateStr
        if(this.selectType == "range"){ // 范围选择
            let first = this.selectedList[0]
            let last = this.selectedList[this.selectedList.length - 1]
            // console.log("第一个", first.dateStr, "最后一个", last.dateStr, item.isSelected)
            this.fontColor = item.isSelected ? dateStr == first.dateStr || dateStr == last.dateStr ? "#fff" : this
                .selectedColor || this.baseStyle[this.type] : item.isCurMonthDay ? "#333" : "#999"
            this.bgColor = item.isSelected ? dateStr == first.dateStr || dateStr == last.dateStr ? this.selectedColor || this.baseStyle[this.type]
                : this.selectedColor ? this.set16ToRgb(this.selectedColor) : this.baseStyle[this.type + "Opacity"] :
                "#fff"
        }else{
            this.fontColor = this.dayItem.isCurMonthDay ? this.dayItem.isSelected ? "#fff" : "#333" : "#999"
            this.bgColor = this.dayItem.isSelected ? this.selectedColor || this.baseStyle[this.type] : "#fff"
        }
    }
    // 16进制转rgb
    set16ToRgb(str:string){
        let reg = /^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$/
        if(!reg.test(str)) return
        let newStr = (str.toLowerCase()).replace(/\#/g,'')
        let len = newStr.length
        if(len == 3){
            let t = ''
            for(let i = 0; i < len; i++){
                t += newStr.slice(i,i+1).concat(newStr.slice(i,i+1))
            }
            newStr = t
        }
        let arr: Array<number> = []
        for(let i = 0; i < 6; i = i + 2){
            let s = newStr.slice(i,i+2)
            arr.push(parseInt("0x" + s))
        }
        return 'rgba(' + arr.join(",")  + ', 0.2)'
    }

    build() {
        Column({space: spaceData.spaceMini}){
            Text(this.dayItem.day)
                .fontSize(FONT_SIZE.MD)
                .fontColor(this.fontColor)
            if(this.isShowLunar){
                Text(this.dayItem.lunarDay)
                    .fontSize(FONT_SIZE.SM)
                    .fontColor(this.fontColor)
            }
        }
        .width("13%")
        .aspectRatio(1)
        .borderRadius(this.selectedStyleType == "circle" ? 100 : borderRadiusData.borderRadiusSm)
        .backgroundColor(this.bgColor)
        .justifyContent(FlexAlign.Center)
        .margin({bottom: 4})
    }
}

@Component
export struct IBestCalendar{
    /*
     * 默认选中日期
     */
    @Prop defaultSelectedDate: Array<string> = []
    /*
     * 每周第一天是周几
     */
    @State weekFirstDay: WeekDayType = "一"
    /*
     * 每周第一天是周几
     */
    @State weekFirstNum: number = 1
    /*
     * 是否显示农历
     */
    @Provide isShowLunar: boolean = true
    /*
     * 今日日期
     */
    @State todayDate: string = dayjs().format('YYYY-MM-DD')
    /*
     * 当前点击选择的年月日
     */
    @State @Watch("selectDateChange") curSelectedDate: string = dayjs().format('YYYY-MM-DD')
    /*
     * 当前所在年月份
     */
    @State curYearMonth: string = dayjs().format('YYYY-MM')
    /*
     * 日历头部
     */
    @State headerList: Array<HeaderItemType> = [
        {
            text: "一",
            key: 1
        },
        {
            text: "二",
            key: 2
        },
        {
            text: "三",
            key: 3
        },
        {
            text: "四",
            key: 4
        },
        {
            text: "五",
            key: 5
        },
        {
            text: "六",
            key: 6
        },
        {
            text: "日",
            key: 0
        }
    ]
    /*
     * 列表日期
     */
    @State daysList: Array<DayItemType> = []
    /*
     * 选择类型
     */
    @Provide selectType: SelectType = "single"
    /*
     * 已选的日期列表
     */
    @Provide selectedList: Array<DayItemType> = []
    /*
     * 选中样式
     */
    @Provide selectedStyleType: SelectedStyleType = "normal"
    /*
     * 选中主题颜色
     */
    @Provide type: ColorType = COLOR_TYPE.PRIMARY
    /*
     * 自定义选中颜色
     */
    @Provide selectedColor: string = ""
    /*
     * 选择回调
     */
    onConfirm: (value: ConfirmResultType | Array<ConfirmResultType>) => void = () => {}

    selectDateChange(){
        this.curYearMonth = dayjs(this.curSelectedDate).format('YYYY-MM')
    }

    aboutToAppear(){
        this.init()
        this.initDaysList()
    }
    init(){
        let list: Array<DayItemType> = []
        let index = this.headerList.findIndex(e => e.text == this.weekFirstDay)
        this.weekFirstNum = index == -1 ? 1 : this.headerList[index].key
        // index 变更 headerList顺序
        this.headerList = this.headerList.slice(index).concat(this.headerList.slice(0, index))
        // 初始化selectedList
        if(this.defaultSelectedDate.length){
            if(this.defaultSelectedDate.some(e => !dayjs(e).isValid())){
                return
            }
            this.curSelectedDate = this.defaultSelectedDate[0]
            this.defaultSelectedDate.forEach(e => {
                if(dayjs(e).isValid()){
                    list.push(new DayItemType({
                        date: dayjs(e),
                        dateStr: e,
                        weekNum: this.getWeekNum(dayjs(e)),
                        lunarMonth: Lunar.fromDate(dayjs(e).toDate()).getMonthInChinese(),
                        lunarDay: Lunar.fromDate(dayjs(e).toDate()).getDayInChinese(),
                        year: dayjs(e).format('YYYY'),
                        month: dayjs(e).format('MM'),
                        day: dayjs(e).format('D'),
                        isCurMonthDay: true,
                        isSelected: true
                    }))
                }
            })
        }else{
            let val = dayjs(this.curSelectedDate)
            list = [
                new DayItemType({
                    date: val,
                    dateStr: val.format('YYYY-MM-DD'),
                    weekNum: this.getWeekNum(val),
                    lunarMonth: Lunar.fromDate(val.toDate()).getMonthInChinese(),
                    lunarDay: Lunar.fromDate(val.toDate()).getDayInChinese(),
                    year: val.format('YYYY'),
                    month: val.format('MM'),
                    day: val.format('D'),
                    isCurMonthDay: true,
                    isSelected: true
                })
            ]
            if(this.selectType == "range"){
                let curMonth = val.format('MM')
                let nextDay = val.add(1, 'day')
                let nextMonth = nextDay.format('MM')
                list.push(new DayItemType({
                    date: nextDay,
                    dateStr: nextDay.format('YYYY-MM-DD'),
                    weekNum: this.getWeekNum(nextDay),
                    lunarMonth: Lunar.fromDate(nextDay.toDate()).getMonthInChinese(),
                    lunarDay: Lunar.fromDate(nextDay.toDate()).getDayInChinese(),
                    year: nextDay.format('YYYY'),
                    month: nextDay.format('MM'),
                    day: nextDay.format('D'),
                    isCurMonthDay: nextMonth == curMonth,
                    isSelected: true
                }))
            }
        }
        this.selectedList = list
    }
    initDaysList(){
        this.daysList = []
        let list: Array<DayItemType> = []
        // 获取当前月份1号是周几
        let firstDayWeekNum = this.getWeekNum(dayjs(this.curYearMonth).date(1))
        console.log(`本月第一天周${firstDayWeekNum}`)
        // 获取本月多少天
        let curMonthDays = dayjs(this.curYearMonth).daysInMonth()
        // 获取当前月份最后一天是周几
        let lastDayWeekNum = this.getWeekNum(dayjs(this.curYearMonth).date(curMonthDays))
        console.log(`本月最后一天周${lastDayWeekNum}`)
        // 需补上月多少天
        let preMonthDays: number = this.headerList.findIndex((item) => item.key == firstDayWeekNum)
        console.log(`需补上月preMonthDays ${preMonthDays}天`)
        // 需补下月多少天
        let nextMonthDays: number = 42 - preMonthDays - curMonthDays
        console.log(`需补下月nextMonthDays ${nextMonthDays}天`)
        if(preMonthDays){
            let day = dayjs(this.curYearMonth).subtract(1, 'month')
            // 获取上月多少天
            let preMonthDaysNum = day.daysInMonth()
            console.log(`上月${preMonthDaysNum}天`)
            for(let i = preMonthDaysNum - preMonthDays + 1; i <= preMonthDaysNum; i++){
                let val = day.date(i)
                let dateStr = val.format('YYYY-MM-DD')
                let dayItem = new DayItemType({
                    date: val,
                    dateStr,
                    weekNum: this.getWeekNum(val),
                    lunarMonth: Lunar.fromDate(val.toDate()).getMonthInChinese(),
                    lunarDay: Lunar.fromDate(val.toDate()).getDayInChinese(),
                    year: val.format('YYYY'),
                    month: val.format('MM'),
                    day: val.format('D'),
                    isCurMonthDay: false,
                    isSelected: this.selectedList.some((item) => item.dateStr === dateStr)
                })
                list.push(dayItem)
            }
        }
        for (let i = 1; i <= curMonthDays; i++) {
            let val = dayjs(this.curYearMonth).date(i)
            let dateStr = val.format('YYYY-MM-DD')
            let dayItem = new DayItemType({
                date: val,
                dateStr,
                weekNum: this.getWeekNum(val),
                lunarMonth: Lunar.fromDate(val.toDate()).getMonthInChinese(),
                lunarDay: Lunar.fromDate(val.toDate()).getDayInChinese(),
                year: val.format('YYYY'),
                month: val.format('MM'),
                day: val.format('D'),
                isCurMonthDay: true,
                isSelected: this.selectedList.some((item) => item.dateStr === dateStr)
            })
            list.push(dayItem)
        }
        for (let i = 1; i <= nextMonthDays; i++) {
            let val = dayjs(this.curYearMonth).add(1, 'month').date(i)
            let dateStr = val.format('YYYY-MM-DD')
            let dayItem = new DayItemType({
                date: val,
                dateStr,
                weekNum: this.getWeekNum(val),
                lunarMonth: Lunar.fromDate(val.toDate()).getMonthInChinese(),
                lunarDay: Lunar.fromDate(val.toDate()).getDayInChinese(),
                year: val.format('YYYY'),
                month: val.format('MM'),
                day: val.format('D'),
                isCurMonthDay: false,
                isSelected: this.selectedList.some((item) => item.dateStr === dateStr)
            })
            list.push(dayItem)
        }
        this.daysList = list
        this.selectedList = this.refreshListParam(this.selectedList)
    }
    /*
     * 刷新字段
     */
    refreshListParam(list: Array<DayItemType>): Array<DayItemType>{
        list.forEach((item: DayItemType) => {
            item.isCurMonthDay = item.date.format('YYYY-MM') == this.curYearMonth
        })
        return list
    }
    /**
     * 获取日期是周几 0123456
     */
    getWeekNum(date?: string | Dayjs): number{
        return dayjs(date).day()
    }
    /*
     * 切换年份
     */
    changeYear(type: string){
        if(type == "pre"){
            this.curYearMonth = dayjs(this.curYearMonth).subtract(1, 'year').format('YYYY-MM')
        }else{
            this.curYearMonth = dayjs(this.curYearMonth).add(1, 'year').format('YYYY-MM')
        }
        this.initDaysList()
    }
    /*
     * 切换月份
     */
    changeMonth(type: string){
        if(type == "pre"){
            this.curYearMonth = dayjs(this.curYearMonth).subtract(1, 'month').format('YYYY-MM')
        }else{
            this.curYearMonth = dayjs(this.curYearMonth).add(1, 'month').format('YYYY-MM')
        }
        this.initDaysList()
    }
    /*
     * 点击选择日期
     */
    selectDate(item: DayItemType){
        console.log(JSON.stringify(item))
        switch(this.selectType){
            case "single":
                if(item.isCurMonthDay){
                    this.daysList.forEach(e => {
                        e.isSelected = false
                    })
                    item.isSelected = true
                    this.curSelectedDate = item.dateStr
                }else{
                    this.curSelectedDate = item.dateStr
                    this.initDaysList()
                }
                let obj: ConfirmResultType = {
                    date: item.date.toDate(),
                    dateStr: item.dateStr
                }
                if(this.isShowLunar){
                    obj.lunarMonth = item.lunarMonth
                    obj.lunarDay = item.lunarDay
                }
                this.confirm(obj)
                break
            case "multiple":
                if(item.isCurMonthDay){
                    item.isSelected = !item.isSelected
                    if(item.isSelected){
                        this.curSelectedDate = item.dateStr
                    }
                    let index = this.selectedList.findIndex(e => e.dateStr == item.dateStr)
                    if(index == -1){
                        this.selectedList.push(item)
                    }else{
                        this.selectedList.splice(index, 1)
                    }
                }else{
                    this.curSelectedDate = item.dateStr
                    let index = this.selectedList.findIndex(e => e.dateStr == item.dateStr)
                    if(index == -1){
                        this.selectedList.push(item)
                    }else{
                        this.selectedList.splice(index, 1)
                    }
                    this.initDaysList()
                }
                this.confirm(this.selectedList.map(e => {
                    let obj: ConfirmResultType = {
                        date: e.date.toDate(),
                        dateStr: e.dateStr
                    }
                    if(this.isShowLunar){
                        obj.lunarMonth = e.lunarMonth
                        obj.lunarDay = e.lunarDay
                    }
                    return obj
                }))
                break
            case "range":
                this.curSelectedDate = item.dateStr
                if(this.selectedList.length == 1){  // 已选起始日期 选择结束日期
                    if(item.date.isBefore(this.selectedList[0].date)){
                        this.selectedList = this.getDateListBetween(item.date, this.selectedList[0].date)
                    }else if(item.date.isAfter(this.selectedList[0].date)){
                        this.selectedList = this.getDateListBetween(this.selectedList[0].date, item.date)
                    }
                    this.confirm(this.selectedList.map(e => {
                        let obj: ConfirmResultType = {
                            date: e.date.toDate(),
                            dateStr: e.dateStr
                        }
                        if(this.isShowLunar){
                            obj.lunarMonth = e.lunarMonth
                            obj.lunarDay = e.lunarDay
                        }
                        return obj
                    }))
                }else{  // 已选结束日期  重选
                    item.isSelected = true
                    this.selectedList = [item]
                }
                this.daysList.forEach(e => e.isSelected = this.selectedList.some(f => f.dateStr == e.dateStr))
                if(!item.isCurMonthDay){
                    this.initDaysList()
                }
                break
        }
    }
    /*
     * 获取两个日期之间的所有日期
     */
    getDateListBetween(startDayjs: Dayjs, endDayjs: Dayjs): DayItemType[]{
        let dateArray: Array<DayItemType> = []
        let start = dayjs(startDayjs)
        let end = dayjs(endDayjs)
        while (!start.isAfter(end, 'day')) {
            // 将当前迭代的日期添加到数组中
            dateArray.push(new DayItemType({
                date: start,
                dateStr: start.format('YYYY-MM-DD'),
                weekNum: this.getWeekNum(start),
                lunarMonth: Lunar.fromDate(start.toDate()).getMonthInChinese(),
                lunarDay: Lunar.fromDate(start.toDate()).getDayInChinese(),
                year: start.format('YYYY'),
                month: start.format('MM'),
                day: start.format('D'),
                isCurMonthDay: start.format('YYYY-MM-DD') == this.curYearMonth,
                isSelected: true
            }))
            // 将开始日期增加一天
            start = start.add(1, 'day')
        }
        return dateArray
    }
    /*
     * 提交
     */
    confirm(value: ConfirmResultType | Array<ConfirmResultType>){
        typeof this.onConfirm == 'function' && this.onConfirm(value)
    }
    build() {
        Column(){
            Row(){
                Image($r("app.media.title_back"))
                    .width(14)
                    .onClick(() => {
                        this.changeMonth("pre")
                    })
                Text(this.curYearMonth)
                Image($r("app.media.arrow_right"))
                    .width(14)
                    .onClick(() => {
                        this.changeMonth("next")
                    })
            }
            .width('100%')
            .height(40)
            .padding({left: 12, right: 12})
            .justifyContent(FlexAlign.SpaceBetween)
            Column(){
                Row(){
                    ForEach(this.headerList, (item: HeaderItemType) => {
                        Text(item.text).headerStyle()
                    }, (item: HeaderItemType) => item.text)
                }
                .width('100%')
                .height(40)
                .justifyContent(FlexAlign.SpaceBetween)
                Flex({wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween}){
                    ForEach(this.daysList, (item: DayItemType) => {
                        CalendarItem({dayItem: item})
                            .onClick(() => {
                                this.selectDate(item)
                            })
                    })  // 这里写 (item: DayItemType) => item.dateStr 渲染会有问题  不知为啥！！！！！
                }
            }
            .width('100%')
            .padding({left: 10, right: 10})
        }
        .width('100%')
    }
}