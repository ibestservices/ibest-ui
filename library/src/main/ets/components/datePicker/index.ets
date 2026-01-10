import { IBestPicker } from '../picker'
import { IBestPickerOption } from '../picker/index.type'
import { COMPONENT_NAME, DATE_PICKER_EVENT_NAME, DatePickerColumnType, IBestDatePickerResult } from './index.type'
import ibestEmitter from '../../utils/eventEmitter'
import { convertDimensionsWidthUnit, getEventName, getResourceStr } from '../../utils/utils'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import dateUtils from '../../utils/dateUtils'
import lunar from '../../utils/lunar'

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
	@Prop @Watch("init") lunar: boolean
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
	// 初始化
	init(){
		let arr: IBestPickerOption[][] = []
		this.options = []
		if(!this.isShowDay){
			this.listType = ["year", "month"]
		}
		this.listType.forEach((item) => {
			let list = item == "year" ? this.getYearsList() : item == "month" ? this.getMonthsList() : this.getDaysList()
			arr.push(list)
		})
		this.options = arr
	}
	// 是否是最小年份
	isMinYear = (year: number): boolean => year === this.minDate.getFullYear()
	// 是否是最大年份
	isMaxYear = (year: number): boolean => year === this.maxDate.getFullYear()
	// 是否是最小月份
	isMinMonth = (month: number): boolean => month === this.minDate.getMonth() + 1
	// 是否是最大月份
	isMaxMonth = (month: number): boolean => month === this.maxDate.getMonth() + 1
	// 格式化数值
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
	// 获取年份列表
	getYearsList(): IBestPickerOption[] {
		let yearsList: IBestPickerOption[] = []
		let unit = this.showUnit ? getResourceStr($r("app.string.ibest_year")) : ""
		for(let i = this.minDate.getFullYear(); i <= this.maxDate.getFullYear(); i++){
			yearsList.push({
				value: i.toString(),
				text: i + unit
			})
		}
		return this.filter("year", yearsList)
	}
	// 获取月份列表
	getMonthsList(): IBestPickerOption[] {
		let monthsList: IBestPickerOption[] = []
		let year = this.getValue("year")
		let minMonth = this.isMinYear(year) ? this.minDate.getMonth() + 1 : 1
		let maxMonth = this.isMaxYear(year) ? this.maxDate.getMonth() + 1 : 12
		let unit = this.showUnit ? getResourceStr($r("app.string.ibest_month")) : ""
		for(let i = minMonth; i <= maxMonth; i++){
			let value = this.formatValue(i)
			let text = ''
			if(this.lunar){
				text = lunar(new Date(year, i, 1)).getMonthInChinese()
			}else {
				text = this.formatValue(i)
			}
			monthsList.push({
				value,
				text: text + unit
			})
		}
		return this.filter("month", monthsList)
	}
	// 获取日期列表
	getDaysList(): IBestPickerOption[] {
		let daysList: IBestPickerOption[] = []
		let year = this.getValue("year")
		let month = this.getValue("month")
		let minDay = this.isMinYear(year) && this.isMinMonth(month) ? this.minDate.getDate() : 1
		let maxDay = this.isMaxYear(year) && this.isMaxMonth(month) ? this.maxDate.getDate() : dateUtils(year+"-"+month).daysInMonth()
		let unit = this.showUnit ? getResourceStr($r("app.string.ibest_day")) : ""
		for(let i = minDay; i <= maxDay; i++){
			let value = this.formatValue(i)
			let text = ''
			if(this.lunar){
				text = lunar(dateUtils(year+"-"+month+"-"+i).toDate()).getDayInChinese()
			}else{
				text = this.formatValue(i) + unit
			}
			daysList.push({
				value,
				text: text
			})
		}
		return this.filter("day", daysList)
	}
	// 列变化
	changeColumn(columnIndex: number){
		if(columnIndex < this.options.length - 1){
			this.init()
		}
		this.onChange(this.getResult())
		if(this.groupId) {
			ibestEmitter.emit(getEventName(COMPONENT_NAME, DATE_PICKER_EVENT_NAME.COLUMN_CHANGE, this.groupId), this.uniId, this.value)
		}
	}
	// 获取组件结果
	getResult() {
		let dateStr = this.value.join("-")
		let date = dateUtils(dateStr).toDate()
		let result: IBestDatePickerResult = {
			date,
			dateStr,
			year: this.value[0],
			month: this.value[1]
		}
		if(this.isShowDay){
			result.day = this.value[2]
		}
		if(this.lunar){
			const lunarDate = lunar(date)
			result.lunarMonth = lunarDate.getMonthInChinese()
			result.lunarDay = lunarDate.getDayInChinese()
		}
		return result
	}
	// 处理同组日期变化
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