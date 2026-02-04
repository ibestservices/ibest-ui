import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { COLOR_TYPE, ColorType } from '../../theme-chalk/src/color.type'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import {
    HeaderItemType,
    IBestCalendarConfirmResult,
    IBestCalendarDataSource,
    IBestCalendarDay,
    IBestCalendarDayItem,
    SelectedStyleType,
    SelectType,
    WeekDayType
} from './index.type'
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { isBeforeToday, set16ToRgb } from './utils'
import { IBestCalendarColor } from './color'
import { IBestIcon } from '../icon'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import dateUtils, { DateUtils } from '../../utils/dateUtils'
import lunar from '../../utils/lunar'

@Extend(Text) function ibestCalendarHeaderStyle(itemWidth: IBestStringNumber){
    .width(getSizeByUnit(itemWidth))
    .height(CONTAINER_SIZE.FULL)
    .textAlign(TextAlign.Center)
    .fontColor(IBestCalendarColor.textColor)
}
@Extend(Text) function ibestCalendarClockStyle(fontSize: IBestStringNumber, fontColor: ResourceColor){
    .fontSize(fontSize)
    .fontColor(fontColor)
}
@Component
struct CalendarItem {
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
    @State fontColor: ResourceColor = IBestCalendarColor.textColor
    @State bgColor: ResourceColor = "transparent"
    @ObjectLink @Watch("itemChange") dayItem: IBestCalendarDay
    @Prop index: number
    @Consume daysList: IBestCalendarDataSource
    @Consume swiperIndex: number
    @Consume itemWidth: IBestStringNumber
    @Consume isShowLunar: boolean
    @Consume type: ColorType
    @Consume selectType: SelectType
    @Consume selectedStyleType: SelectedStyleType
    @Consume selectedColor: string
    @Consume @Watch("itemChange") selectedList: IBestCalendarDay[]
    @Consume clock: boolean
    @Consume clockSuccessText: ResourceStr
    @Consume isShowUnClock: boolean
    @Consume unClockText: ResourceStr
	@BuilderParam dayItemBuilder?: ($$: IBestCalendarDayItem) => void

    aboutToAppear(): void {
        this.itemChange()
    }
    isToday(){
        return this.dayItem.dateStr == dateUtils().format('YYYY-MM-DD')
    }
    itemChange(){
        let item = this.dayItem
        if(item.isDisabled){
            this.fontColor = GRAY_COLOR.GRAY_7
            this.bgColor = IBestCalendarColor.disabledBg
        }else if(this.selectType == "range"){ // 范围选择
            if(this.clock){
                this.fontColor = item.isClock ? IBestCalendarColor.textWhite : item.isCurMonthDay ? this.isToday() ? this.baseStyle[this.type] : IBestCalendarColor.textColor : GRAY_COLOR.GRAY_7
                this.bgColor = item.isClock ? this.baseStyle[this.type] : "transparent"
            }else if(this.selectedList.length){
                let dateStr = item.dateStr
                let first = this.selectedList[0]
                let last = this.selectedList[this.selectedList.length - 1]
                this.fontColor = item.isSelected ? dateStr == first.dateStr || dateStr == last.dateStr ? IBestCalendarColor.textWhite : this.selectedColor || this.baseStyle[this.type] : item.isCurMonthDay ? IBestCalendarColor.textColor : GRAY_COLOR.GRAY_7
                this.bgColor = item.isSelected ? dateStr == first.dateStr || dateStr == last.dateStr ? this.selectedColor || this.baseStyle[this.type]
                    : this.selectedColor ? set16ToRgb(this.selectedColor) : this.baseStyle[this.type + "Opacity"] : "transparent"
            }else{
                this.fontColor = item.isSelected ? this.selectedColor || IBestCalendarColor.textColor : item.isCurMonthDay ? IBestCalendarColor.textColor : GRAY_COLOR.GRAY_7
                this.bgColor = item.isSelected ? this.selectedColor ? set16ToRgb(this.selectedColor) : this.baseStyle[this.type + "Opacity"] : "transparent"
            }
        }else{
            this.fontColor = item.isCurMonthDay ? this.dayItem.isSelected ? IBestCalendarColor.textWhite : IBestCalendarColor.textColor : GRAY_COLOR.GRAY_7
            this.bgColor = item.isSelected ? this.selectedColor || this.baseStyle[this.type] : "transparent"
        }
    }
    getMultipleBorderRadius (): Length | BorderRadiuses{
        let borderRadius = this.baseStyle.borderRadiusMd
        if (this.dayItem.isSelected) {
            const prevDay = this.daysList.getData(this.swiperIndex)[this.index - 1]
            const nextDay = this.daysList.getData(this.swiperIndex)[this.index + 1]
            const prevSelected = prevDay?.isSelected
            const nextSelected = nextDay?.isSelected
            if (prevSelected && nextSelected) {
                return ""
            }
            if (prevSelected) {
                return {
                    topRight: borderRadius,
                    bottomRight: borderRadius
                }
            }
            if (nextSelected) {
                return {
                    topLeft: borderRadius,
                    bottomLeft: borderRadius
                }
            }
            return borderRadius
        }
        return ''
    }
    getDisabledBorderRadius(): Length | BorderRadiuses{
        let borderRadius = this.baseStyle.borderRadiusMd
        const prevDay = this.daysList.getData(this.swiperIndex)[this.index - 1]
        const nextDay = this.daysList.getData(this.swiperIndex)[this.index + 1]
        const prevDisabled = prevDay?.isDisabled
        const nextDisabled = nextDay?.isDisabled

        if (prevDisabled && nextDisabled) {
            return ""
        }
        if (prevDisabled) {
            return {
                topRight: borderRadius,
                bottomRight: borderRadius
            }
        }
        if (nextDisabled) {
            return {
                topLeft: borderRadius,
                bottomLeft: borderRadius
            }
        }
        return borderRadius
    }
    getOutBorderRadius(): Length | BorderRadiuses {
        if(this.dayItem.isDisabled){
            return this.getDisabledBorderRadius()
        }else if(this.selectedList.length <= 1){
            return this.baseStyle.borderRadiusMd
        }else {
            return this.getMultipleBorderRadius()
        }
    }

    build() {
        Row() {
			if(this.dayItemBuilder){
				this.dayItemBuilder({
					date: this.dayItem.date,
					dateStr: this.dayItem.dateStr,
					day: this.dayItem.day,
					month: this.dayItem.month,
					year: this.dayItem.year,
					weekNum: this.dayItem.weekNum,
					lunarMonth: this.dayItem.lunarMonth,
					lunarDay: this.dayItem.lunarDay,
					isSelected: this.dayItem.isSelected,
					isCurMonthDay: this.dayItem.isCurMonthDay,
					isDisabled: this.dayItem.isDisabled,
					isClock: this.dayItem.isClock
				})
			}else {
				Column({ space: this.baseStyle.spaceMini }) {
					Text(this.dayItem.day)
						.fontSize(this.baseStyle.fontSizeMd)
						.fontColor(this.fontColor)
					if (this.isShowLunar) {
						Text(this.dayItem.lunarDay)
							.ibestCalendarClockStyle(this.baseStyle.fontSizeSm as string, this.fontColor)
					}else if(this.clock && this.dayItem.isCurMonthDay && isBeforeToday(this.dayItem.date)){
						if(this.dayItem.isClock){
							Text(this.clockSuccessText)
								.ibestCalendarClockStyle(this.baseStyle.fontSizeSm as string, this.fontColor)
						}else if(this.isShowUnClock){
							Text(this.unClockText)
								.ibestCalendarClockStyle(this.baseStyle.fontSizeSm as string, this.fontColor)
						}
					}
				}
				.width(getSizeByUnit(this.itemWidth))
				.aspectRatio(1)
				.backgroundColor(this.selectType == "single" ? this.bgColor : "")
				.borderRadius(this.selectedStyleType == "circle" ? this.baseStyle.borderRadiusMax : this.baseStyle.borderRadiusMd)
				.justifyContent(FlexAlign.Center)
			}
        }
        .width(CONTAINER_SIZE.FULL)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.selectType == "single" || this.dayItemBuilder ? "" : this.bgColor)
        .borderRadius(this.getOutBorderRadius())
    }
}

@Component
export struct IBestCalendar{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @StorageProp(IBestStorageKey.IS_LANDSCAPE) isLandscape: boolean = false
    /**
     * 默认选中日期
     * @deprecated since 2.1.8
     * @useinstead value
     */
    @Prop @Watch("selectedDateChange") defaultSelectedDate: string[] = []
    /**
     * 已选日期
     * @since 2.1.8
     */
    @Link @Watch("selectedDateChange") value: string | string[]
    /**
     * 单项宽度
     */
    @Provide({allowOverride: "itemWidth"}) itemWidth: IBestStringNumber = convertDimensionsWidthUnit(50)
    /**
     * 每周第一天是周几
     */
    @Prop weekFirstDay: WeekDayType = 1
    /**
     * 是否显示农历
     */
    @Provide({allowOverride: "isShowLunar"}) isShowLunar: boolean = false
    /**
     * 选择类型
     */
    @Provide({allowOverride: "selectType"}) selectType: SelectType = "single"
    /**
     * 选中样式
     */
    @Provide({allowOverride: "selectedStyleType"}) selectedStyleType: SelectedStyleType = "normal"
    /**
     * 选中主题颜色
     */
    @Provide({allowOverride: "type"}) type: ColorType = COLOR_TYPE.PRIMARY
    /**
     * 自定义选中颜色
     */
    @Provide({allowOverride: "selectedColor"}) selectedColor: string = ""
    /**
     * 日期区间最多可选天数 默认无限制
     */
    @Prop maxRange: number = -1
    /**
     * 最小日期
     */
    @Prop minDate: Date
    /**
     * 最大日期
     */
    @Prop maxDate: Date
    /**
     * 是否显示月份背景水印
     */
    @Prop isShowMark: boolean = false
    /**
     * 是否显示头部
     */
    @Prop isShowHeader: boolean = true
    /**
     * 是否显示底部确定按钮
     */
    @Prop isShowConfirmBtn: boolean = false
    /**
     * 确认按钮颜色
     */
    @Prop confirmBtnColor: ResourceColor = ""
    /**
     * 确认按钮文案
     */
    @Prop confirmBtnText: ResourceStr = $r("app.string.ibest_text_confirm")
    /**
     * 圆角
     */
    @Prop cornerRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = this.baseStyle.borderRadiusXl as string
    /**
     * 打卡模式
     * @since 2.0.1
     */
    @Provide({allowOverride: "clock"}) clock: boolean = false
    /**
     * 打卡成功提示
     * @since 2.0.1
     */
    @Provide({allowOverride: "clockSuccessText"}) clockSuccessText: ResourceStr = $r("app.string.ibest_calendar_clocked")
    /**
     * 是否显示未打卡
     * @since 2.0.1
     */
    @Provide({allowOverride: "isShowUnClock"}) isShowUnClock: boolean = true
    /**
     * 未打卡提示
     * @since 2.0.1
     */
    @Provide({allowOverride: "unClockText"}) unClockText: ResourceStr = $r("app.string.ibest_calendar_unclock")
	/**
	 * 是否显示其他月份日期
	 * @since 2.1.3
     */
	@Prop showOtherMonthDate: boolean = true
	/**
	 * 自定义日期项插槽
	 * @since 2.0.9
     */
	@BuilderParam dayItemBuilder: ($$: IBestCalendarDayItem) => void
    /**
     * 选择回调
     */
    onConfirm: (value: IBestCalendarConfirmResult[]) => void = () => {}

    @State curYearMonth: string = ''
    @State headerList: HeaderItemType[] = [
        {
            text: $r("app.string.ibest_monday_omit"),
            key: 1
        },
        {
            text: $r("app.string.ibest_tuesday_omit"),
            key: 2
        },
        {
            text: $r("app.string.ibest_wednesday_omit"),
            key: 3
        },
        {
            text: $r("app.string.ibest_thursday_omit"),
            key: 4
        },
        {
            text: $r("app.string.ibest_friday_omit"),
            key: 5
        },
        {
            text: $r("app.string.ibest_saturday_omit"),
            key: 6
        },
        {
            text: $r("app.string.ibest_sunday_omit"),
            key: 0
        }
    ]
    @State contentHeight: number = 0
    @State swipeChangeLock: boolean = false
    @Provide daysList: IBestCalendarDataSource = new IBestCalendarDataSource()
    @Provide swiperIndex: number = 1
    @Provide selectedList: IBestCalendarDay[] = []
    private swiperController: SwiperController = new SwiperController()

    @Builder contentBuilder(daysList: IBestCalendarDay[]){
        Stack({alignContent: Alignment.Top}) {
            Text(this.getCurMonth(daysList))
                .fontSize(convertDimensionsWidthUnit(150, true))
                .height(convertDimensionsWidthUnit(this.contentHeight))
                .fontColor(IBestCalendarColor.markTextColor)
                .visibility(this.isShowMark ? Visibility.Visible : Visibility.Hidden)
            GridRow({ columns: 7, gutter: { x: 0, y: convertDimensionsWidthUnit(5) }}) {
                ForEach(daysList, (item: IBestCalendarDay, index: number) => {
                    GridCol() {
						if(item.isCurMonthDay || this.showOtherMonthDate){
							CalendarItem({
								dayItem: item,
								index: index,
								dayItemBuilder: this.dayItemBuilder
							})
								.enabled(!(this.clock || item.isDisabled))
								.onClick(() => {
									this.selectDate(item)
								})
						}
                    }
                })
            }
            .width(CONTAINER_SIZE.FULL)
            .onAreaChange((oldVal, newVal) => {
                if(newVal.height != oldVal.height){
                    this.contentHeight = newVal.height as number
                }
            })
        }
        .padding(this.isLandscape ? undefined : {left: this.baseStyle.spaceXs, right: this.baseStyle.spaceXs})
    }

    aboutToAppear(){
        this.init()
        this.initDaysList()
    }
    init(){
        if(this.clock){
            this.selectType = "range"
        }
        let index = this.headerList.findIndex(e => e.key == this.weekFirstDay)
        index = index == -1 ? 1 : index
        this.headerList = this.headerList.slice(index).concat(this.headerList.slice(0, index))
        this.initSelectedList()
    }
    initSelectedList(){
        let list: IBestCalendarDay[] = []
        let dateList = this.value || this.defaultSelectedDate
        if(dateList.length){
            if(typeof dateList === 'string'){
                dateList = [dateList]
            }
            if(dateList.some(e => !dateUtils(e).isValid())){
                return
            }
            dateList.forEach(e => {
                if(!this.getIsDisabled(dateUtils(e))){
                    list.push(new IBestCalendarDay({
                        date: dateUtils(e).toDate(),
                        dateStr: e,
                        weekNum: this.getWeekNum(dateUtils(e)),
                        lunarMonth: lunar(dateUtils(e).toDate()).getMonthInChinese(),
                        lunarDay: lunar(dateUtils(e).toDate()).getDayInChinese(),
                        year: dateUtils(e).format('YYYY'),
                        month: dateUtils(e).format('MM'),
                        day: dateUtils(e).format('D'),
                        isCurMonthDay: true,
                        isSelected: true
                    }))
                }
            })
        }
        if(!this.curYearMonth){
            this.curYearMonth = dateUtils(dateList[0] || new Date()).format('YYYY-MM')
        }
        this.selectedList = list
    }
    isSelect(dateStr: string){
        return this.selectedList.some(e => e.dateStr == dateStr)
    }
    selectedDateChange(){
        this.initSelectedList()
        this.daysList.getAllList().forEach(e => {
            e.forEach(f => {
                f.isSelected = this.clock ? isBeforeToday(f.date) && this.isSelect(f.dateStr) : this.isSelect(f.dateStr)
                if(this.clock && f.isCurMonthDay){
                    f.isClock = isBeforeToday(f.date) ? this.isSelect(f.dateStr) : false
                }
            })
        })
    }
    getCurMonth(daysList: IBestCalendarDay[]): string{
        return dateUtils(daysList.find(e => e.isCurMonthDay)!.dateStr).format('M')
    }
    initDaysList(){
        this.daysList.setList([this.getDaysList(dateUtils(this.curYearMonth).subtract(1, 'month').format('YYYY-MM')), this.getDaysList(this.curYearMonth), this.getDaysList(dateUtils(this.curYearMonth).add(1, 'month').format('YYYY-MM'))])
        this.selectedList = this.refreshListParam(this.selectedList)
        this.swiperIndex = 1
        this.swipeChangeLock = false
    }
    getDaysList(yearMonth: string): IBestCalendarDay[]{
        let list: IBestCalendarDay[] = []
        const date = dateUtils(yearMonth)
        const firstDayWeekNum = this.getWeekNum(date.date(1))
        const curMonthDays = date.daysInMonth()
        const preMonthDays: number = this.headerList.findIndex((item) => item.key == firstDayWeekNum)
        const nextMonthDays: number = 42 - preMonthDays - curMonthDays
        if(preMonthDays){
            let day = dateUtils(yearMonth).subtract(1, 'month')
            let preMonthDaysNum = day.daysInMonth()
            for(let i = preMonthDaysNum - preMonthDays + 1; i <= preMonthDaysNum; i++){
                let val = day.date(i)
                let dateStr = val.format('YYYY-MM-DD')
                let lunarDate = lunar(val.toDate())
                let lunarMonth = lunarDate.getMonthInChinese() + '月'
                let dayItem = new IBestCalendarDay({
                    date: val.toDate(),
                    dateStr,
                    weekNum: this.getWeekNum(val),
                    lunarMonth,
                    lunarDay: lunarDate.getDay() == 1 ? lunarMonth : lunarDate.getDayInChinese(),
                    year: val.format('YYYY'),
                    month: val.format('MM'),
                    day: val.format('D'),
                    isCurMonthDay: false,
                    isSelected: this.selectedList.some((item) => item.dateStr === dateStr),
                    isDisabled: this.getIsDisabled(val)
                })
                list.push(dayItem)
            }
        }
        for (let i = 1; i <= curMonthDays; i++) {
            let val = date.date(i)
            let dateStr = val.format('YYYY-MM-DD')
            let lunarDate = lunar(val.toDate())
            let lunarMonth = lunarDate.getMonthInChinese() + '月'
            let dayItem = new IBestCalendarDay({
                date: val.toDate(),
                dateStr,
                weekNum: this.getWeekNum(val),
                lunarMonth,
                lunarDay: lunarDate.getDay() == 1 ? lunarMonth : lunarDate.getDayInChinese(),
                year: val.format('YYYY'),
                month: val.format('MM'),
                day: val.format('D'),
                isCurMonthDay: true,
                isSelected: this.selectedList.some((item) => item.dateStr === dateStr),
                isDisabled: this.getIsDisabled(val),
                isClock: this.clock && isBeforeToday(val) ? this.selectedList.some((item) => item.dateStr === dateStr) : false
            })
            list.push(dayItem)
        }
        for (let i = 1; i <= nextMonthDays; i++) {
            let val = dateUtils(yearMonth).add(1, 'month').date(i)
            let dateStr = val.format('YYYY-MM-DD')
            let lunarDate = lunar(val.toDate())
            let lunarMonth = lunarDate.getMonthInChinese() + '月'
            let dayItem = new IBestCalendarDay({
                date: val.toDate(),
                dateStr,
                weekNum: this.getWeekNum(val),
                lunarMonth,
                lunarDay: lunarDate.getDay() == 1 ? lunarMonth : lunarDate.getDayInChinese(),
                year: val.format('YYYY'),
                month: val.format('MM'),
                day: val.format('D'),
                isCurMonthDay: false,
                isSelected: this.selectedList.some((item) => item.dateStr === dateStr),
                isDisabled: this.getIsDisabled(val)
            })
            list.push(dayItem)
        }
        return list
    }
    changeSwiperByDate(dateStr: string){
        if(dateUtils(dateStr).isBefore(this.curYearMonth)){
            this.changeYearMonth("preMonth")
        }else{
            this.changeYearMonth("nextMonth")
        }
    }
    changeSwiper(index: number){
        this.swiperController.changeIndex(index, true)
    }
    onSwiperChange(index: number){
        if(this.swipeChangeLock){
            return
        }
        this.curYearMonth = this.daysList.getData(index).find((item) => item.isCurMonthDay)!.dateStr.slice(0, 7)
        if(index == 0){
            this.swipeChangeLock = true
            this.daysList.unshiftData(this.getDaysList(dateUtils(this.curYearMonth).subtract(1, 'month').format('YYYY-MM')))
            this.swiperIndex = 1
            setTimeout(() => {
                this.swipeChangeLock = false
            }, 30)
        }else if(index == this.daysList.totalCount() - 1){
            this.swipeChangeLock = true
            this.daysList.pushData(this.getDaysList(dateUtils(this.curYearMonth).add(1, 'month').format('YYYY-MM')))
            this.swipeChangeLock = false
        }
    }
    refreshListParam(list: IBestCalendarDay[]): IBestCalendarDay[]{
        list.forEach((item: IBestCalendarDay) => {
            item.isCurMonthDay = item.dateStr == this.curYearMonth
        })
        return list
    }
    getIsDisabled(day: DateUtils): boolean{
        return this.minDate && dateUtils(day).isBefore(this.minDate) || this.maxDate && dateUtils(day).isAfter(this.maxDate)
    }
    getWeekNum(date?: string | DateUtils): number{
        return dateUtils(date).day()
    }
    changeYearMonth(type: string){
        if(this.swipeChangeLock) return
        switch (type){
            case "preYear":
                this.swipeChangeLock = true
                this.curYearMonth = dateUtils(this.curYearMonth).subtract(1, 'year').format('YYYY-MM')
                this.initDaysList()
                break
            case "preMonth":
                this.changeSwiper(this.swiperIndex - 1)
                break
            case "nextYear":
                this.swipeChangeLock = true
                this.curYearMonth = dateUtils(this.curYearMonth).add(1, 'year').format('YYYY-MM')
                this.initDaysList()
                break
            case "nextMonth":
                this.changeSwiper(this.swiperIndex + 1)
                break
        }
    }
    selectDate(item: IBestCalendarDay){
        switch(this.selectType){
            case "single":
                this.daysList.getData(this.swiperIndex).forEach(e => {
                    e.isSelected = false
                })
                if(item.isCurMonthDay){
                    item.isSelected = true
                }else {
                    this.changeSwiperByDate(item.dateStr)
                }
                this.selectedList = [item]
                this.value = item.dateStr
                !this.isShowConfirmBtn && this.confirm()
                break
            case "multiple":
                if(item.isCurMonthDay){
                    item.isSelected = !item.isSelected
                    let index = this.selectedList.findIndex(e => e.dateStr == item.dateStr)
                    if(index == -1){
                        this.selectedList.push(item)
                    }else{
                        this.selectedList.splice(index, 1)
                    }
                }else{
                    this.changeSwiperByDate(item.dateStr)
                    let index = this.selectedList.findIndex(e => e.dateStr == item.dateStr)
                    if(index == -1){
                        this.selectedList.push(item)
                    }else{
                        this.selectedList.splice(index, 1)
                    }
                }
                this.selectedList.sort((a, b) => {
                    return dateUtils(a.date).isBefore(b.date) ? -1 : 1
                })
                this.value = this.selectedList.map(e => e.dateStr)
                !this.isShowConfirmBtn && this.confirm()
                break
            case "range":
                if(this.selectedList.length == 1){
                    let days: IBestCalendarDay[] = []
                    let isOutRange = false
                    if(dateUtils(item.date).isBefore(this.selectedList[0].date)){
                        days = this.getDateListBetween(item.date, this.selectedList[0].date)
                        isOutRange = this.maxRange > 2 && days.length > this.maxRange
                        if(isOutRange){
                            days = days.slice(-this.maxRange)
                        }
                    }else if(dateUtils(item.date).isAfter(this.selectedList[0].date)){
                        days = this.getDateListBetween(this.selectedList[0].date, item.date)
                        isOutRange = this.maxRange > 2 && days.length > this.maxRange
                        if(isOutRange){
                            days = days.slice(0, this.maxRange)
                        }
                    }
                    if(isOutRange){
                        this.getUIContext().getPromptAction().showToast({
                            message: $r("app.string.ibest_maximum_limit", this.maxRange),
                            duration: 2000
                        })
                    }
                    this.selectedList = days
                    this.value = this.selectedList.map(e => e.dateStr)
                    !this.isShowConfirmBtn && this.confirm()
                }else{
                    item.isSelected = true
                    this.selectedList = [item]
                }
                this.daysList.getAllList().forEach(e => {
                    e.forEach(f => {
                        f.isSelected = this.selectedList.some(g => g.dateStr == f.dateStr)
                    })
                })
                if(!item.isCurMonthDay){
                    this.changeSwiperByDate(item.dateStr)
                }
                break
            }
    }
    getDateListBetween(startDate: Date, endDate: Date): IBestCalendarDay[]{
        let dateArray: IBestCalendarDay[] = []
        let start = dateUtils(startDate)
        while (!start.isAfter(endDate)) {
            dateArray.push(new IBestCalendarDay({
                date: start.toDate(),
                dateStr: start.format('YYYY-MM-DD'),
                weekNum: this.getWeekNum(start),
                lunarMonth: lunar(start.toDate()).getMonthInChinese(),
                lunarDay: lunar(start.toDate()).getDayInChinese(),
                year: start.format('YYYY'),
                month: start.format('MM'),
                day: start.format('D'),
                isCurMonthDay: start.format('YYYY-MM-DD') == this.curYearMonth,
                isSelected: true
            }))
            start = start.add(1, 'day')
        }
        return dateArray
    }
    confirm(){
         this.onConfirm(this.selectedList.map(e => {
            let obj: IBestCalendarConfirmResult = {
                date: e.date,
                dateStr: e.dateStr
            }
            if(this.isShowLunar){
                obj.lunarMonth = e.lunarMonth
                obj.lunarDay = e.lunarDay
            }
            return obj
        }))
    }

    build() {
        Column(){
            Row(){
                Row(){
                    IBestIcon({
                        name: "arrow-double-left",
                        iconSize: convertDimensionsWidthUnit(14),
                        color: IBestCalendarColor.textColor
                    }).onClick(() => {
                        this.changeYearMonth("preYear")
                    })
                    IBestIcon({
                        name: "arrow-left",
                        iconSize: convertDimensionsWidthUnit(14),
                        color: IBestCalendarColor.textColor
                    }).onClick(() => {
                        this.changeYearMonth("preMonth")
                    })
                }
                Text(this.curYearMonth)
                    .fontSize(this.baseStyle.fontSizeMd)
                    .fontColor(IBestCalendarColor.textColor)
                Row(){
                    IBestIcon({
                        name: "arrow",
                        iconSize: convertDimensionsWidthUnit(14),
                        color: IBestCalendarColor.textColor
                    }).onClick(() => {
                        this.changeYearMonth("nextMonth")
                    })
                    IBestIcon({
                        name: "arrow-double-right",
                        iconSize: convertDimensionsWidthUnit(14),
                        color: IBestCalendarColor.textColor
                    }).onClick(() => {
                        this.changeYearMonth("nextYear")
                    })
                }
            }
            .width(CONTAINER_SIZE.FULL)
            .height(convertDimensionsWidthUnit(40))
            .padding({left: this.baseStyle.spaceLg, right: this.baseStyle.spaceLg})
            .justifyContent(FlexAlign.SpaceBetween)
            .visibility(this.isShowHeader ? Visibility.Visible : Visibility.None)
            GridRow({ columns: 7 }) {
                ForEach(this.headerList, (item: HeaderItemType) => {
                    GridCol() {
                        Text(item.text)
                            .fontSize(this.baseStyle.fontSizeSm)
                            .ibestCalendarHeaderStyle(this.itemWidth)
                    }
                }, (_: HeaderItemType, index: number) => index.toString())
            }
            .width(CONTAINER_SIZE.FULL)
            .height(convertDimensionsWidthUnit(30))
            .padding({left: this.baseStyle.spaceXs, right: this.baseStyle.spaceXs})
            Swiper(this.swiperController){
                LazyForEach(this.daysList, (item: IBestCalendarDay[]) => {
                    if(this.isLandscape){
                        Scroll() {
                            this.contentBuilder(item)
                        }
                        .height(CONTAINER_SIZE.FULL)
                        .padding({left: this.baseStyle.spaceXs, right: this.baseStyle.spaceXs})
                    }else {
                        this.contentBuilder(item)
                    }
                }, (item: IBestCalendarDay[]) => item[0].dateStr)
            }
            .width(CONTAINER_SIZE.FULL)
            .height(this.isLandscape ? "60%" : '')
            .index($$this.swiperIndex)
            .indicator(false)
            .loop(false)
            .effectMode(EdgeEffect.None)
            .cachedCount(3)
            .disableSwipe(this.swipeChangeLock)
            .onChange(index => {
                this.onSwiperChange(index)
            })
            if(this.isShowConfirmBtn && !this.clock){
                Button(this.confirmBtnText)
                    .type(ButtonType.Capsule)
                    .width('90%')
                    .height(convertDimensionsWidthUnit(30))
                    .fontSize(this.baseStyle.fontSizeSm)
                    .margin({top: this.baseStyle.spaceXs})
                    .backgroundColor(this.confirmBtnColor || this.baseStyle[this.type])
                    .onClick(() => {
                        this.confirm()
                    })
            }
        }
        .width(CONTAINER_SIZE.FULL)
        .backgroundColor(IBestCalendarColor.bgColor)
        .borderRadius(getSizeByUnit(this.cornerRadius))
    }
}