import dayjs from '@hview/dayjs'
import { IBestPicker } from '../picker'
import { IBestPickerOption } from '../picker/index.type'
import { COMPONENT_NAME, DATE_PICKER_EVENT_NAME, DatePickerColumnType, IBestDatePickerResultType } from './index.type'
import { emitter } from '../../utils/EventEmitter'
import { clamp, convertDimensionsWidthUnit, getEventName, getResourceStr } from '../../utils/utils'
import { IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestDatePicker {
    @StorageProp("IBestLanguage") @Watch("init") IBestLanguage: string = "zh"
	/**
	 * 分组id
	 */
	@Prop groupId: IBestStringNumber = ""
	/**
	 * 唯一id
	 */
	@State uniId: number = 0
	/**
	 * 已选择的值
	 */
	@Link value: string[]
	/**
	 * 选项列表
	 */
	@State options: IBestPickerOption[][] = []
	/**
	 * 最小时间
	 */
	@Prop minDate: Date = dayjs().subtract(10, 'year').toDate()
	/**
	 * 最大时间
	 */
	@Prop maxDate: Date = dayjs().add(10, 'year').toDate()
	/**
	 * 是否显示日列
	 */
	@Prop isShowDay: boolean = true
	// 列表类型
	@State listType: DatePickerColumnType[] = ["year", "month", "day"]
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
	 * 过滤器
	 */
	filter: (type: DatePickerColumnType, options: IBestPickerOption[]) => IBestPickerOption[] = (type, options) => options
	/**
	 * 确认按钮点击事件
	 */
	onConfirm: (value: IBestDatePickerResultType) => void = () => {}
	/**
	 * 取消按钮点击事件
	 */
	onCancel: () => void = () => {}
	/**
	 * 选中项改变事件
	 */
	onChange: (value: IBestDatePickerResultType) => void = () => {}

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		this.init()
		if(this.groupId){
			// 监听日期picker变化
			emitter.on(getEventName(COMPONENT_NAME, DATE_PICKER_EVENT_NAME.COLUMN_CHANGE, this.groupId),this.uniId, (uniId: number, selectedValues: string[]): void => this.handleGroupChange(uniId, selectedValues))
		}
	}
	aboutToDisappear(): void {
		if(this.groupId) {
			emitter.off(getEventName(COMPONENT_NAME, DATE_PICKER_EVENT_NAME.COLUMN_CHANGE, this.groupId), this.uniId)
		}
	}
	// 初始化
	init(){
		this.options = []
		if(!this.isShowDay){
			this.listType = ["year", "month"]
		}
		this.listType.forEach((item,index) => {
			let list = item == "year" ? this.getYearsList() : item == "month" ? this.getMonthsList() : this.getDaysList()
			let min = list.length ? list[0].value.toString() : ""
			let max = list.length ? list[list.length-1].value.toString() : ""
			let newValue = this.value[index] || min
			let i = list.findIndex((item) => item.value === newValue)
			if(i == -1){
				if(list.length) {
					this.value[index] = this.formatValue(clamp(Number(newValue), Number(min), Number(max)))
				}else{
					this.value[index] = ''
				}
			}else{
				this.value[index] = newValue
			}
			this.value = this.value.filter(e => e)
			this.options.push(list)
		})
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
		return value < 10 ? "0" + value : (value + "")
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
		for(let i = this.minDate.getFullYear(); i <= this.maxDate.getFullYear(); i++){
			yearsList.push({
				value: i + "",
				text: i + (this.showUnit ? getResourceStr($r("app.string.ibest_year")) : "")
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
		for(let i = minMonth; i <= maxMonth; i++){
			monthsList.push({
				value: this.formatValue(i),
				text: this.formatValue(i) + (this.showUnit ? getResourceStr($r("app.string.ibest_month")) : "")
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
		let maxDay = this.isMaxYear(year) && this.isMaxMonth(month) ? this.maxDate.getDate() : dayjs(year+"-"+month).daysInMonth()
		// console.log("获取日期列表", year, month, minDay, maxDay)
		for(let i = minDay; i <= maxDay; i++){
			daysList.push({
				value: this.formatValue(i),
				text: this.formatValue(i) + (this.showUnit ? getResourceStr($r("app.string.ibest_day")) : "")
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
			emitter.emit(getEventName(COMPONENT_NAME, DATE_PICKER_EVENT_NAME.COLUMN_CHANGE, this.groupId), this.uniId, this.value)
		}
	}
	// 获取组件结果
	getResult(): IBestDatePickerResultType {
		let dateStr = this.value.join("-")
		let date = dayjs(dateStr).toDate()
		let result: IBestDatePickerResultType = {
			date,
			dateStr,
			year: this.value[0],
			month: this.value[1]
		}
		if(this.isShowDay){
			result.day = this.value[2]
		}
		return result
	}
	// 处理同组日期变化
	handleGroupChange(uniId: number, selectedValues: string[]) {
		if(this.uniId > uniId){
			let selectDate = dayjs(selectedValues.join("-")).toDate()
			this.minDate = dayjs(selectedValues.join("-")).toDate()
			if(selectDate > dayjs(this.maxDate).toDate() || selectDate < dayjs(this.minDate).toDate()){
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