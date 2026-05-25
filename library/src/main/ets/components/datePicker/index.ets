import { IBestPicker } from '../picker'
import { IBestPickerOption } from '../picker/index.type'
import { COMPONENT_NAME, DATE_PICKER_EVENT_NAME, DatePickerColumnType, IBestDatePickerResult } from './index.type'
import ibestEmitter from '../../utils/eventEmitter'
import { convertDimensionsWidthUnit, getEventName, getResourceStr } from '../../utils/utils'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import dateUtils from '../../utils/dateUtils'
import lunar, { Lunar, LUNAR_DAY_NAMES, LUNAR_MONTH_NAMES } from '../../utils/lunar'

@Component
export struct IBestDatePicker {
    @StorageProp(IBestStorageKey.LANGUAGE) @Watch("init") language: string = "zh"
	/**
	 * 分组id
	 */
	@Prop groupId: IBestStringNumber = ""
	/**
	 * 已选择的值
	 */
	@Link value: string[]
	/**
	 * 最小时间
	 */
	@Prop minDate: Date = dateUtils().subtract(10, 'year').toDate()
	/**
	 * 最大时间
	 */
	@Prop maxDate: Date = dateUtils().add(10, 'year').toDate()
	/**
	 * 是否显示日列
	 */
	@Prop isShowDay: boolean = true
	/**
	 * 是否显示单位
	 */
	@Prop showUnit: boolean = false
	/**
	 * 标题
	 */
	@Prop title: string = ""
	/**
	 * 单项高度
	 */
	@Prop itemHeight: IBestStringNumber = convertDimensionsWidthUnit(44)
	/**
	 * 确认按钮文字
	 */
	@Prop confirmText: ResourceStr = $r("app.string.ibest_text_confirm")
	/**
	 * 取消按钮文字
	 */
	@Prop cancelText: ResourceStr = $r("app.string.ibest_text_cancel")
	/**
	 * 是否显示顶部栏
	 */
	@Prop showToolBar: boolean = true
	/**
	 * 可见选项数量
  	 */
	@Prop visibleItemCount: number = 6
	/**
	 * 是否横向
	 * @since 2.0.0
	 */
	@Prop horizontal: boolean
	/**
	 * 单项宽度, 仅横向时生效
	 * @since 2.0.0
	 */
	@Prop itemWidth: IBestStringNumber
	/**
	 * 高度, 仅横向时生效
	 * @since 2.0.0
	 */
	@Prop contentHeight: IBestStringNumber
	/**
	 * 选项字体大小
	 * @since 2.0.0
	 */
	@Prop optionFontSize: IBestStringNumber
	/**
	 * 是否显示农历日期
	 * @since 2.1.3
     */
	@Prop @Watch("lunarChange") lunar: boolean
	/**
	 * 外部圆角
	 * @since 2.1.5
	 */
	@Prop radius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0
	/**
	 * 未选中字体颜色
	 * @since 2.2.5
	 */
	@Prop fontColor: ResourceColor
	/**
	 * 未选中字体字重
	 * @since 2.2.5
	 */
	@Prop fontWeight: FontWeight
	/**
	 * 选中字体大小
	 * @since 2.2.5
	 */
	@Prop selectedFontSize: IBestStringNumber
	/**
	 * 选中文字颜色
	 * @since 2.2.5
	 */
	@Prop selectedFontColor: ResourceColor
	/**
	 * 选项文字字重
	 * @since 2.2.5
	 */
	@Prop selectedFontWeight: FontWeight
	/**
	 * 过滤器
	 */
	filter: (type: DatePickerColumnType, options: IBestPickerOption[]) => IBestPickerOption[] = (_, options) => options
	/**
	 * 确认按钮点击事件
	 */
	onConfirm: (value: IBestDatePickerResult) => void = () => {}
	/**
	 * 取消按钮点击事件
	 */
	onCancel: () => void = () => {}
	/**
	 * 选中项改变事件
	 */
	onChange: (value: IBestDatePickerResult) => void = () => {}

	@State uniId: number = 0
	@State options: IBestPickerOption[][] = []
	@State listType: DatePickerColumnType[] = ["year", "month", "day"]

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		this.init()
		if(this.groupId){
			ibestEmitter.on(getEventName(COMPONENT_NAME, DATE_PICKER_EVENT_NAME.COLUMN_CHANGE, this.groupId),this.uniId, (uniId: number, selectedValues: string[]): void => this.handleGroupChange(uniId, selectedValues))
		}
	}
	aboutToDisappear(): void {
		if(this.groupId) {
			ibestEmitter.off(getEventName(COMPONENT_NAME, DATE_PICKER_EVENT_NAME.COLUMN_CHANGE, this.groupId), this.uniId)
		}
	}
	init(){
		if(!this.isShowDay){
			this.listType = ["year", "month"]
		}
		this.options = []
		this.listType.forEach(item => {
			switch(item){
				case "year":
					this.options.push(this.getYearsList())
					break
				case "month":
					this.options.push(this.getMonthsList())
					if(this.value.length && this.options[1].findIndex(item => item.value === this.value[1]) == -1){
						this.value[1] = this.options[1][0].value.toString()
					}
					break
				case "day":
					this.options.push(this.getDaysList())
					if(this.value.length && this.options[2].findIndex(item => item.value === this.value[2]) == -1){
						this.value[2] = this.options[2][0].value.toString()
					}
					break
			}
		})
	}
	lunarChange(){
		if(this.value.length){
			if(this.lunar){
				const lunarDate = lunar(new Date(this.value.join("-")))
				this.value = [this.value[0], lunarDate.getMonthInChinese(), lunarDate.getDayInChinese()]
			}else{
				const date = this.lunarToGregorian()
				this.value = [this.value[0], (date.getMonth() + 1).toString(), date.getDate().toString()]
			}
		}
		this.init()
	}
	isMinYear = (year: number): boolean => year === this.minDate.getFullYear()
	isMaxYear = (year: number): boolean => year === this.maxDate.getFullYear()
	isMinMonth = (month: number): boolean => month === this.minDate.getMonth() + 1
	isMaxMonth = (month: number): boolean => month === this.maxDate.getMonth() + 1
	formatValue(value: number): string {
		return value < 10 ? "0" + value : value.toString()
	}
	getValue(type: DatePickerColumnType): number{
		let minDate = this.minDate
		let columnsType = this.listType
		const index = columnsType.indexOf(type)
		const value = this.value[index]
		if (value) {
			return Number(value)
		}
		switch (type) {
			case 'year':
				return minDate.getFullYear()
			case 'month':
				return minDate.getMonth() + 1
			case 'day':
				return minDate.getDate()
		}
	}
	getYearsList(): IBestPickerOption[] {
		const yearsList: IBestPickerOption[] = []
		const unit = this.showUnit ? getResourceStr($r("app.string.ibest_year")) : ""
		for(let i = this.minDate.getFullYear(); i <= this.maxDate.getFullYear(); i++){
			yearsList.push({
				value: i.toString(),
				text: i + unit
			})
		}
		return this.filter("year", yearsList)
	}
	getMonthsList(): IBestPickerOption[] {
		const monthsList: IBestPickerOption[] = []
		const year = this.getValue("year")
		const minMonth = this.isMinYear(year) ? this.minDate.getMonth() + 1 : 1
		const maxMonth = this.isMaxYear(year) ? this.maxDate.getMonth() + 1 : 12
		const unit = this.showUnit ? getResourceStr($r("app.string.ibest_month")) : ""
		if(this.lunar){
			let arr: string[] = []
			for(let i = minMonth; i <= maxMonth; i++){
				const minDay = this.isMinYear(year) && this.isMinMonth(i) ? this.minDate.getDate() : 1
				const maxDay = this.isMaxYear(year) && this.isMaxMonth(i) ? this.maxDate.getDate() : dateUtils(year+"-"+i).daysInMonth()
				const minMonth = lunar(dateUtils(year+"-"+i+"-"+minDay).toDate()).getMonthInChinese()
				const maxMonth = lunar(dateUtils(year+"-"+i+"-"+maxDay).toDate()).getMonthInChinese()
				if(!arr.includes(minMonth)){
					arr.push(minMonth)
				}
				if(!arr.includes(maxMonth)){
					arr.push(maxMonth)
				}
			}
			for(let i = 0; i < arr.length; i++){
				monthsList.push({
					value: arr[i],
					text: arr[i] + unit
				})
			}
		}else {
			for(let i = minMonth; i <= maxMonth; i++){
				monthsList.push({
					value: this.formatValue(i),
					text: this.formatValue(i) + unit
				})
			}
		}
		return this.filter("month", monthsList)
	}
	getDaysList(): IBestPickerOption[] {
		const daysList: IBestPickerOption[] = []
		const year = this.getValue("year")
		const unit = this.showUnit ? getResourceStr($r("app.string.ibest_day")) : ""
		if(this.lunar){
			const monthVal = this.value[1]
			if(monthVal){
				const monthArr = monthVal.split("")
				const lunarMonth = monthArr.length > 1 ? monthArr[1] : monthArr[0]
				const monthIndex = LUNAR_MONTH_NAMES.indexOf(lunarMonth) + 1
				const dayIndex = LUNAR_DAY_NAMES.indexOf(this.value[2]) + 1
				const lunarDate = new Lunar(Number(this.value[0]), monthIndex, dayIndex, monthArr.includes("闰"))
				const days = lunarDate.getLunarMonthDays()
				const minDay = this.isMinYear(year) && lunarMonth == this.options[1][0].value ? lunar(this.minDate).getDay()-1 : 0
				const maxDay = this.isMaxYear(year) && lunarMonth == this.options[1][this.options[1].length-1].value ? lunar(this.maxDate).getDay()-1 : days
				for(let i = minDay; i < maxDay; i++){
					daysList.push({
						value: LUNAR_DAY_NAMES[i],
						text: LUNAR_DAY_NAMES[i]
					})
				}
			}else {
				const month = this.getValue("month")
				const minDay = this.isMinYear(year) && this.isMinMonth(month) ? this.minDate.getDate() : 1
				const maxDay = this.isMaxYear(year) && this.isMaxMonth(month) ? this.maxDate.getDate() : dateUtils(year+"-"+month).daysInMonth()
				for(let i = minDay; i <= maxDay; i++){
					const lunarDay = lunar(dateUtils(year+"-"+month+"-"+i).toDate()).getDayInChinese()
					daysList.push({
						value: lunarDay,
						text: lunarDay
					})
				}
			}
		}else {
			const month = this.getValue("month")
			const minDay = this.isMinYear(year) && this.isMinMonth(month) ? this.minDate.getDate() : 1
			const maxDay = this.isMaxYear(year) && this.isMaxMonth(month) ? this.maxDate.getDate() : dateUtils(year+"-"+month).daysInMonth()
			for(let i = minDay; i <= maxDay; i++){
				daysList.push({
					value: this.formatValue(i),
					text: this.formatValue(i) + unit
				})
			}
		}
		return this.filter("day", daysList)
	}
	lunarToGregorian(): Date {
		const monthArr = this.value[1].split("")
		const monthIndex = LUNAR_MONTH_NAMES.indexOf(monthArr.length > 1 ? monthArr[1] : monthArr[0]) + 1
		const dayIndex = LUNAR_DAY_NAMES.indexOf(this.value[2]) + 1
		return new Lunar(Number(this.value[0]), monthIndex, dayIndex, monthArr.includes("闰")).toDate()
	}
	changeColumn(columnIndex: number){
		if(columnIndex < this.options.length - 1){
			this.init()
		}
		this.onChange(this.getResult())
		if(this.groupId) {
			ibestEmitter.emit(getEventName(COMPONENT_NAME, DATE_PICKER_EVENT_NAME.COLUMN_CHANGE, this.groupId), this.uniId, this.value)
		}
	}
	getResult() {
		const result: IBestDatePickerResult = {
			date: new Date(),
			dateStr: '',
			year: this.value[0],
			month: '',
			day: '',
			lunarMonth: '',
			lunarDay: ''
		}
		if(this.lunar){
			const date = this.lunarToGregorian()
			result.date = date
			result.dateStr = dateUtils(date).format()
			result.month = (date.getMonth() + 1).toString()
			result.day = date.getDate().toString()
			result.lunarMonth = this.value[1]
			result.lunarDay = this.value[2]
		}else {
			const dateStr = this.value.join("-")
			const date = dateUtils(dateStr).toDate()
			const lunarDate = lunar(date)
			result.date = date
			result.dateStr = dateStr
			result.month = this.value[1]
			result.day = this.value[2]
			result.lunarMonth = lunarDate.getMonthInChinese()
			result.lunarDay = lunarDate.getDayInChinese()
		}
		return result
	}
	handleGroupChange(uniId: number, selectedValues: string[]) {
		if(this.uniId > uniId){
			let selectDate = dateUtils(selectedValues.join("-")).toDate()
			this.minDate = selectDate
			if(selectDate > this.maxDate || selectDate < this.minDate){
				this.value = selectedValues
			}
			this.init()
		}
	}

	build() {
		IBestPicker({
			groupId: this.groupId,
			value: $value,
			title: this.title,
			options: this.options,
			showToolBar: !this.groupId && this.showToolBar,
			visibleItemCount: this.visibleItemCount,
			itemHeight: this.itemHeight,
			confirmText: this.confirmText,
			cancelText: this.cancelText,
			horizontal: this.horizontal,
			itemWidth: this.itemWidth,
			contentHeight: this.contentHeight,
			optionFontSize: this.optionFontSize,
			radius: this.radius,
			fontColor: this.fontColor,
			fontWeight: this.fontWeight,
			selectedFontSize: this.selectedFontSize,
			selectedFontColor: this.selectedFontColor,
			selectedFontWeight: this.selectedFontWeight,
			onConfirm: () => {
				this.onConfirm(this.getResult())
			},
			onCancel: () => {
				this.onCancel()
			},
			onChange: (selectedValues, selectTexts, columnIndex) => {
				this.changeColumn(columnIndex)
			}
		})
	}
}