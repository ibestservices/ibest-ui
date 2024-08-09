import dayjs from '@hview/dayjs'
import { IBestPicker } from '../picker'
import { IBestPickerOption } from '../picker/index.type'
import { DatePickerColumnType, getPickerEventName, PICKER_EVENT_NAME } from './index.type'
import { emitter } from '../../assets/ets/EventEmitter'
@Component
export struct IBestDatePicker {
	/*
	 * 分组id
	 */
	@Prop groupId: string = ""
	/*
	 * 唯一id
	 */
	@State uniId: number = 0
	/*
	 * 已选择的值
	 */
	@Link value: Array<string>
	/*
	 * 选项列表
	 */
	@State options: IBestPickerOption[][] = []
	/*
	 * 最小时间
	 */
	@Prop minDate: Date = dayjs().subtract(10, 'year').toDate()
	/*
	 * 最大时间
	 */
	@Prop maxDate: Date = dayjs().add(10, 'year').toDate()
	/*
	 * 列表类型
	 */
	@Prop listType: Array<DatePickerColumnType> = ["year", "month", "day"]

	/*
	 * 标题
	 */
	@Prop title: string = ""
	/*
	 * 单项高度
	 */
	@Prop itemHeight: number = 88
	/*
	 * 确认按钮文字
	 */
	@Prop confirmText: string = "确定"
	/*
	 * 取消按钮文字
	 */
	@Prop cancelText: string = "取消"
	/*
	 * 是否显示顶部栏
	 */
	@Prop showToolBar: boolean = true
	/*
	 * 可见选项数量
  	 */
	@Prop visibleItemCount: number = 6
	/*
	 * 确认按钮点击事件
	 */
	onConfirm: (selectedValues: Array<string>, selectTexts: Array<string>) => void = () => {}
	/*
	 * 取消按钮点击事件
	 */
	onCancel: () => void = () => {}
	/*
	 * 选中项改变事件
	 */
	onChange: (selectedValues: Array<string>, selectTexts: Array<string>, columnIndex: number) => void = () => {}

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		console.log("datePicker aboutToAppear", this.uniId)
		this.init()
		if(this.groupId){
			// 监听日期picker变化
			emitter.on(getPickerEventName(this.groupId, PICKER_EVENT_NAME.COLUMN_CHANGE), (uniId: number, selectedValues: Array<string>) => {
				if(this.uniId > uniId){
					console.log("监听到同组前一个datePicker值变化", `当前组件${this.uniId}`, uniId, selectedValues.join("-"))
				}
			})
		}
	}
	aboutToDisappear(): void {
		emitter.off(getPickerEventName(this.groupId, PICKER_EVENT_NAME.COLUMN_CHANGE), () => {})
	}
	// 初始化
	init(){
		this.options = []
		if(this.listType.length){
			this.listType.forEach((item,index) => {
				let list = item == "year" ? this.getYearsList() : item == "month" ? this.getMonthsList() : this.getDaysList()
				let max = list[list.length-1].value
				if(Number(this.value[index]) > Number(max)){
					this.value[index] = max
				}
				this.options.push(list)
			})
		}
	}
	// 是否是最小年份
	isMinYear = (year: number): boolean => year === this.minDate.getFullYear()
	// 是否是最大年份
	isMaxYear = (year: number): boolean => year === this.maxDate.getFullYear()
	// 是否是最小月份
	isMinMonth = (month: number): boolean => this.isMinYear(this.getValue("year")) && month === this.minDate.getMonth() + 1
	// 是否是最大月份
	isMaxMonth = (month: number): boolean => this.isMaxYear(this.getValue("year")) && month === this.maxDate.getMonth() + 1
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
	getYearsList(): Array<IBestPickerOption> {
		let yearsList: Array<IBestPickerOption> = []
		for(let i = this.minDate.getFullYear(); i <= this.maxDate.getFullYear(); i++){
			yearsList.push({
				value: i + "",
				text: i + ""
			})
		}
		return yearsList
	}
	// 获取月份列表
	getMonthsList(): Array<IBestPickerOption> {
		let monthsList: Array<IBestPickerOption> = []
		let year = this.getValue("year")
		let minMonth = this.isMinYear(year) ? this.minDate.getMonth() + 1 : 1
		let maxMonth = this.isMaxYear(year) ? this.maxDate.getMonth() + 1 : 12
		for(let i = minMonth; i <= maxMonth; i++){
			monthsList.push({
				value: this.formatValue(i),
				text: this.formatValue(i)
			})
		}
		return monthsList
	}
	// 获取日期列表
	getDaysList(): Array<IBestPickerOption> {
		let daysList: Array<IBestPickerOption> = []
		let year = this.getValue("year")
		let month = this.getValue("month")
		let minDay = this.isMinYear(year) && this.isMinMonth(month) ? this.minDate.getDate() : 1
		let maxDay = this.isMaxYear(year) && this.isMaxMonth(month) ? this.maxDate.getDate() : dayjs(year+" "+month).daysInMonth()
		for(let i = minDay; i <= maxDay; i++){
			daysList.push({
				value: this.formatValue(i),
				text: this.formatValue(i)
			})
		}
		return daysList
	}
	// 列变化
	changeColumn(selectedValues: Array<string>, selectTexts: Array<string>, columnIndex: number){
		if(columnIndex < 2){
			this.init()
		}
		this.onChange(selectedValues, selectTexts, columnIndex)
		if(this.groupId) {
			emitter.emit(getPickerEventName(this.groupId, PICKER_EVENT_NAME.COLUMN_CHANGE), this.uniId, selectedValues)
		}
	}

	build() {
		IBestPicker({
			value: $value,
			options: this.options,
			showToolBar: this.showToolBar,
			visibleItemCount: this.visibleItemCount,
			itemHeight: this.itemHeight,
			confirmText: this.confirmText,
			cancelText: this.cancelText,
			onConfirm: (selectedValues: Array<string>, selectTexts: Array<string>) => {
				this.onConfirm(selectedValues, selectTexts)
			},
			onCancel: () => {
				this.onCancel()
			},
			onChange: (selectedValues: Array<string>, selectTexts: Array<string>, columnIndex: number) => {
				this.changeColumn(selectedValues, selectTexts, columnIndex)
			}
		})
	}
}