import dayjs, { Dayjs } from "@hview/dayjs"
import {Lunar} from 'lunar'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType, IbestUIBaseStyleValue } from '../../theme-chalk/src/index.type'
import { ColorType, COLOR_TYPE } from '../../theme-chalk/src/color.type'
import { GRAY_COLOR } from '../../theme-chalk/src/color.type'
import { CalendarConfirmResultType, SelectedStyleType, SelectType, WeekDayType } from './index.type'
import { FONT_SIZE } from '../../theme-chalk/src/font.type'
import { spaceData } from '../../theme-chalk/src/space'
import { borderRadiusData } from '../../theme-chalk/src/border'
import { fontSizeData } from '../../theme-chalk/src/font'
import promptAction from '@ohos.promptAction'
import { getComponentsInfo, getIsLandscape } from '../../assets/ets/utils'
import { UIContext } from '@kit.ArkUI'
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
    isDisabled?: boolean = false
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
            this.isDisabled = value.isDisabled
        }
    }
}
interface HeaderItemType{
    text: string
    key: number
}

@Extend(Text) function headerStyle(itemWidth: string){
    .width(itemWidth)
    .textAlign(TextAlign.Center)
    .fontSize(fontSizeData.fontSizeSm)
    .fontColor("#999")
}
@Component
struct CalendarItem {
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
    // 是否横屏
    @State isLandscape: boolean = getIsLandscape(getContext(this))
    @State fontColor: string | IbestUIBaseStyleValue = "#333"
    @State bgColor: string | IbestUIBaseStyleValue = "transparent"
    @ObjectLink @Watch("itemChange") dayItem: DayItemType
    @Consume itemWidth: string
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
        if(item.isDisabled){
            this.fontColor = "#ccc"
            this.bgColor = GRAY_COLOR.GRAY_2
        }else if(this.selectType == "range"){ // 范围选择
            if(this.selectedList.length){
                let first = this.selectedList[0]
                let last = this.selectedList[this.selectedList.length - 1]
                this.fontColor = item.isSelected ? dateStr == first.dateStr || dateStr == last.dateStr ? this
                    .baseStyle.default : this.selectedColor || this.baseStyle[this.type] : item.isCurMonthDay ? "#333" : "#999"
                this.bgColor = item.isSelected ? dateStr == first.dateStr || dateStr == last.dateStr ? this.selectedColor || this.baseStyle[this.type]
                    : this.selectedColor ? this.set16ToRgb(this.selectedColor) : this.baseStyle[this.type + "Opacity"] :
                    "transparent"
            }else{
                this.fontColor = item.isSelected ? this.selectedColor || this.baseStyle[this.type] : item.isCurMonthDay ? "#333" : "#999"
                this.bgColor = item.isSelected ? this.selectedColor ? this.set16ToRgb(this.selectedColor) : this.baseStyle[this.type + "Opacity"] : "transparent"
            }
        }else{
            this.fontColor = this.dayItem.isCurMonthDay ? this.dayItem.isSelected ? this.baseStyle.default : "#333" : "#999"
            this.bgColor = this.dayItem.isSelected ? this.selectedColor || this.baseStyle[this.type] : "transparent"
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
        .width(this.itemWidth)
        .aspectRatio(this.isLandscape ? 0 : 1)
        .borderRadius(this.selectedStyleType == "circle" ? 8888 : borderRadiusData.borderRadiusSm)
        .backgroundColor(this.bgColor)
        .justifyContent(FlexAlign.Center)
        .margin({bottom: this.baseStyle.spaceBase})
    }
}

@CustomDialog
@Component
export struct IBestCalendar{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    // 唯一id
    @State uniId: number = 0
    // 是否横屏
    @State isLandscape: boolean = getIsLandscape(getContext(this))
    /*
     * 默认选中日期
     */
    @Prop defaultSelectedDate: Array<string> = []
    /*
     * 单项宽度
     */
    @Provide itemWidth: string = "13%"
    /*
     * 每周第一天是周几
     */
    @Prop weekFirstDay: WeekDayType = "一"
    /*
     * 是否显示农历
     */
    @Provide isShowLunar: boolean = false
    /*
     * 当前点击选择的年月日
     */
    @State @Watch("selectDateChange") curSelectedDate: string = dayjs().format('YYYY-MM-DD')
    /*
     * 当前所在年月份
     */
    @State @Watch("monthChange") curYearMonth: string = dayjs().format('YYYY-MM')
    /*
     * 当前月份
     */
    @State curMonth: string = ""
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
    // 日期区域高度
    @State contentHeight: number = 0
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
     * 日期区间最多可选天数 默认无限制
     */
    @Prop maxRange: number = -1
    /*
     * 最小日期
     */
    @Prop minDate: Date
    /*
     * 最大日期
     */
    @Prop maxDate: Date
    /*
     * 是否显示月份背景水印
     */
    @Prop isShowMark: boolean = false
    /*
     * 是否显示头部
     */
    @Prop isShowHeader: boolean = true
    /*
     * 是否显示底部确定按钮
     */
    @Prop isShowConfirmBtn: boolean = false
    /*
     * 确认按钮颜色
     */
    @Prop confirmBtnColor: string = this.baseStyle[this.type] as string
    /*
     * 确认按钮文案
     */
    @Prop confirmBtnText: string = "确认"
    /*
     * 选择回调
     */
    onConfirm: (value: Array<CalendarConfirmResultType>) => void = () => {}
    controller?: CustomDialogController
    private context: UIContext = this.getUIContext()

    selectDateChange(){
        this.curYearMonth = dayjs(this.curSelectedDate).format('YYYY-MM')
    }
    monthChange(){
        this.curMonth = dayjs(this.curYearMonth).format('M')
    }

    aboutToAppear(){
        this.uniId = this.getUniqueId()
        this.init()
        this.initDaysList()
    }
    /*
     * 初始化本地数据
     */
    init(){
        let list: Array<DayItemType> = []
        let index = this.headerList.findIndex(e => e.text == this.weekFirstDay)
        this.monthChange()
        // index 变更 headerList顺序
        this.headerList = this.headerList.slice(index).concat(this.headerList.slice(0, index))
        // 初始化selectedList
        if(this.defaultSelectedDate.length){
            if(this.defaultSelectedDate.some(e => !dayjs(e).isValid())){
                return
            }
            this.curSelectedDate = this.defaultSelectedDate[0]
            this.defaultSelectedDate.forEach(e => {
                if(dayjs(e).isValid() && !this.getIsDisabled(dayjs(e))){
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
        }
        this.selectedList = list
    }
    /*
     * 初始化日历列表
     */
    initDaysList(){
        this.daysList = []
        let list: Array<DayItemType> = []
        // 获取当前月份1号是周几
        let firstDayWeekNum = this.getWeekNum(dayjs(this.curYearMonth).date(1))
        // console.log(`本月第一天周${firstDayWeekNum}`)
        // 获取本月多少天
        let curMonthDays = dayjs(this.curYearMonth).daysInMonth()
        // 需补上月多少天
        let preMonthDays: number = this.headerList.findIndex((item) => item.key == firstDayWeekNum)
        // console.log(`需补上月preMonthDays ${preMonthDays}天`)
        // 需补下月多少天
        let nextMonthDays: number = 42 - preMonthDays - curMonthDays
        // console.log(`需补下月nextMonthDays ${nextMonthDays}天`)
        if(preMonthDays){
            let day = dayjs(this.curYearMonth).subtract(1, 'month')
            // 获取上月多少天
            let preMonthDaysNum = day.daysInMonth()
            // console.log(`上月${preMonthDaysNum}天`)
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
                    isSelected: this.selectedList.some((item) => item.dateStr === dateStr),
                    isDisabled: this.getIsDisabled(day)
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
                isSelected: this.selectedList.some((item) => item.dateStr === dateStr),
                isDisabled: this.getIsDisabled(val)
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
                isSelected: this.selectedList.some((item) => item.dateStr === dateStr),
                isDisabled: this.getIsDisabled(val)
            })
            list.push(dayItem)
        }
        this.daysList = list
        this.selectedList = this.refreshListParam(this.selectedList)
        this.getDateAreaHeight()
    }
    /*
     * 获取日期区域高度
     */
    getDateAreaHeight(){
        if(this.isShowMark){
            setTimeout(()=>{
                this.contentHeight = getComponentsInfo(this.context, `calender_${this.uniId}`).height
            }, 0)
        }
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
    /*
     * 获取日期是否禁用
     */
    getIsDisabled(day: Dayjs): boolean{
        return this.minDate && dayjs(day).isBefore(this.minDate, 'day') || this.maxDate && dayjs(day).isAfter(this
            .maxDate, 'day')
    }
    /*
     * 获取日期是周几 0123456
     */
    getWeekNum(date?: string | Dayjs): number{
        return dayjs(date).day()
    }
    /*
     * 切换年、月份
     */
    changeYearMonth(type: string){
        switch (type){
            case "preYear":
                this.curYearMonth = dayjs(this.curYearMonth).subtract(1, 'year').format('YYYY-MM')
                break
            case "preMonth":
                this.curYearMonth = dayjs(this.curYearMonth).subtract(1, 'month').format('YYYY-MM')
                break
            case "nextYear":
                this.curYearMonth = dayjs(this.curYearMonth).add(1, 'year').format('YYYY-MM')
                break
            case "nextMonth":
                this.curYearMonth = dayjs(this.curYearMonth).add(1, 'month').format('YYYY-MM')
                break
        }
        this.initDaysList()
    }
    /*
     * 点击选择日期
     */
    selectDate(item: DayItemType){
        // console.log(JSON.stringify(item))
        if(!item.isDisabled){
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
                    this.selectedList = [item]
                    !this.isShowConfirmBtn && this.confirm()
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
                    // 排序
                    this.selectedList.sort((a, b) => {
                        return dayjs(a.date).isBefore(dayjs(b.date)) ? -1 : 1
                    })
                    !this.isShowConfirmBtn && this.confirm()
                    break
                case "range":
                    this.curSelectedDate = item.dateStr
                    if(this.selectedList.length == 1){  // 已选起始日期 选择结束日期
                        let days: DayItemType[] = []
                        let isOutRange = false
                        if(item.date.isBefore(this.selectedList[0].date)){
                            days = this.getDateListBetween(item.date, this.selectedList[0].date)
                            isOutRange = this.maxRange > 2 && days.length > this.maxRange
                            if(isOutRange){
                                days = days.slice(-this.maxRange)
                            }
                        }else if(item.date.isAfter(this.selectedList[0].date)){
                            days = this.getDateListBetween(this.selectedList[0].date, item.date)
                            isOutRange = this.maxRange > 2 && days.length > this.maxRange
                            if(isOutRange){
                                days = days.slice(0, this.maxRange)
                            }
                        }
                        if(isOutRange){
                            promptAction.showToast({
                                message: `最多选择${this.maxRange}天`,
                                duration: 2000
                            })
                        }
                        this.selectedList = days
                        !this.isShowConfirmBtn && this.confirm()
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
    confirm(){
         this.onConfirm(this.selectedList.map(e => {
            let obj: CalendarConfirmResultType = {
                date: e.date.toDate(),
                dateStr: e.dateStr
            }
            if(this.isShowLunar){
                obj.lunarMonth = e.lunarMonth
                obj.lunarDay = e.lunarDay
            }
            return obj
        }))
    }
    /*
     * 获取按钮背景颜色
     */
    private getBtnBgColor() {
        let reg = /^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$/
        return this.confirmBtnColor && reg.test(this.confirmBtnColor as string) ? this.confirmBtnColor : this
            .baseStyle[this.type]
    }
    build() {
        Column(){
            Row(){
                Row(){
                    Image($r("app.media.arrow_left_double"))
                        .width("28lpx")
                        .onClick(() => {
                            this.changeYearMonth("preYear")
                        })
                    Image($r("app.media.arrow_left"))
                        .width("28lpx")
                        .onClick(() => {
                            this.changeYearMonth("preMonth")
                        })
                }
                Text(this.curYearMonth)
                    .fontSize(this.baseStyle.fontSizeMd)
                Row(){
                    Image($r("app.media.arrow_right"))
                        .width("28lpx")
                        .onClick(() => {
                            this.changeYearMonth("nextMonth")
                        })
                    Image($r("app.media.arrow_right_double"))
                        .width("28lpx")
                        .onClick(() => {
                            this.changeYearMonth("nextYear")
                        })
                }
            }
            .width('100%')
            .height(this.isLandscape ? "40lpx" : "80lpx")
            .padding({left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd})
            .justifyContent(FlexAlign.SpaceBetween)
            .visibility(this.isShowHeader ? Visibility.Visible : Visibility.None)
            Row() {
                ForEach(this.headerList, (item: HeaderItemType) => {
                    Text(item.text).headerStyle(this.itemWidth)
                }, (item: HeaderItemType) => item.text)
            }
            .width('100%')
            .height(this.isLandscape ? "40lpx" : "80lpx")
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({left: this.baseStyle.spaceXs, right: this.baseStyle.spaceXs})
            Scroll() {
                Stack({alignContent: Alignment.Top}) {
                    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
                        ForEach(this.daysList, (item: DayItemType) => {
                            CalendarItem({ dayItem: item })
                                .onClick(() => {
                                    this.selectDate(item)
                                })
                        }) // 这里写 (item: DayItemType) => item.dateStr 渲染会有问题  不知为啥！！！！！
                    }
                    .id(`calender_${this.uniId}`)
                    Text(this.curMonth)
                        .fontSize("300lpx")
                        .height(`${this.contentHeight}lpx`)
                        .fontColor(GRAY_COLOR.GRAY_2)
                        .zIndex(-1)
                        .visibility(this.isShowMark ? Visibility.Visible : Visibility.Hidden)
                }
            }
            .scrollable(this.isLandscape ? ScrollDirection.Vertical : ScrollDirection.None)
            .layoutWeight(this.isLandscape ? 1 : 0)
            .padding({left: this.baseStyle.spaceXs, right: this.baseStyle.spaceXs})
            Button(this.confirmBtnText)
                .type(ButtonType.Capsule)
                .width('90%')
                .height(this.isLandscape ? "40lpx" : "60lpx")
                .fontSize(this.baseStyle.fontSizeSm)
                .margin({top: this.baseStyle.spaceXs})
                .backgroundColor(this.getBtnBgColor())
                .visibility(this.isShowConfirmBtn ? Visibility.Visible : Visibility.None)
                .onClick(() => {
                    this.confirm()
                })
        }
        .width('100%')
        .padding({top: this.baseStyle.spaceXs, bottom: this.baseStyle.spaceXs})
        .backgroundColor("#fff")
    }
}