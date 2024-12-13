import { IBestPicker } from '../picker'
import { IBestPickerOption } from '../picker/index.type'
import { COMPONENT_NAME, TimePickerColumnType, TIME_PICKER_EVENT_NAME } from './index.type'
import { emitter } from '../../utils/EventEmitter'
import { clamp, convertDimensionsWidthUnit, getEventName } from '../../utils/utils'

@Component
export struct IBestTimePicker {
	/**
	 * 分组id
	 */
	@Prop groupId: string = ""
	/**
	 * 唯一id
	 */
	@State uniId: number = 0
	/**
	 * 已选择的值
	 */
	@Link value: Array<string>
	/**
	 * 选项列表
	 */
	@State options: IBestPickerOption[][] = []
	/**
	 * 最小时间
	 */
	@Prop minTime: string = "00:00:00"
	/**
	 * 最大时间
	 */
	@Prop maxTime: string = "23:59:59"
	/**
	 * 列表类型
     */
	@Prop listType: Array<TimePickerColumnType> = ["hour", "minute", "second"]
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
	@Prop itemHeight: number | string = convertDimensionsWidthUnit(44)
	/**
	 * 确认按钮文字
	 */
	@Prop confirmText: string = "确定"
	/**
	 * 取消按钮文字
	 */
	@Prop cancelText: string = "取消"
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
	@Prop itemWidth: number | string
	/**
	 * 高度, 仅横向时生效
	 * @since 2.0.0
	 */
	@Prop contentHeight: number | string
	/**
	 * 选项字体大小
	 * @since 2.0.0
	 */
	@Prop optionFontSize: number | string
	/**
	 * 过滤器
	 */
	filter: (type: TimePickerColumnType, options: IBestPickerOption[]) => IBestPickerOption[] = (type: TimePickerColumnType, options: IBestPickerOption[]) => options
	/**
	 * 确认按钮点击事件
	 */
	onConfirm: (value: string[]) => void = () => {}
	/**
	 * 取消按钮点击事件
	 */
	onCancel: () => void = () => {}
	/**
	 * 选中项改变事件
	 */
	onChange: (value: string[]) => void = () => {}

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		this.init()
		if(this.groupId){
			// 监听日期picker变化
			emitter.on(getEventName(COMPONENT_NAME, this.groupId, TIME_PICKER_EVENT_NAME.COLUMN_CHANGE), (uniId: number, selectedValues: Array<string>): void => this.handleGroupTimeChange(uniId, selectedValues))
		}
	}
	aboutToDisappear(): void {
		if(this.groupId) {
			emitter.off(getEventName(COMPONENT_NAME, this.groupId, TIME_PICKER_EVENT_NAME.COLUMN_CHANGE), (uniId: number, selectedValues: Array<string>): void => this.handleGroupTimeChange(uniId, selectedValues))
		}
	}
	// 初始化
	init(){
		let reg = /^(?:([01]?[0-9]|2[0-3]):)?([0-5]?[0-9]):([0-5]?[0-9])$/
		this.options = []
		if(!reg.test(this.minTime)){
			this.minTime = "00:00:00"
		}
		if(!reg.test(this.maxTime)){
			this.maxTime = "23:59:59"
		}
		this.listType.forEach((item,index) => {
			let list = item == "hour" ? this.getHoursList() : item == "minute" ? this.getMinutesList() : this.getSecondsList()
			let min = list[0].value
			let max = list[list.length-1].value
			let newValue = this.value[index] || min
			let i = list.findIndex((item) => item.value == newValue)
			if(i == -1){
				this.value[index] = this.formatValue(clamp(Number(newValue), Number(min), Number(max)))
			}
			this.options.push(list)
		})
	}
	// 是否是最小小时
	isMinHour = (hour: string): boolean => hour === this.minTime.slice(0, 2)
	// 是否是最大小时
	isMaxHour = (hour: string): boolean => hour === this.maxTime.slice(0, 2)
	// 是否是最小分钟
	isMinMinute = (minute: string): boolean => minute === this.minTime.slice(3, 5)
	// 是否是最大分钟
	isMaxMinute = (minute: string): boolean => minute === this.maxTime.slice(3, 5)
	// 格式化数值
	formatValue(value: number): string {
		return value < 10 ? "0" + value : (value + "")
	}
	getValue(type: TimePickerColumnType): string{
		let minTime = this.minTime
		let columnsType = this.listType
		const index = columnsType.indexOf(type)
		const value = this.value[index]
		if (value) {
			return value
		}
		switch (type) {
			case 'hour':
				return minTime.slice(0, 2)
			case 'minute':
				return minTime.slice(3, 5)
			case 'second':
				return minTime.slice(6)
		}
	}
	// 获取小时列表
	getHoursList(): Array<IBestPickerOption> {
		let list: Array<IBestPickerOption> = []
		let min = Number(this.minTime.slice(0, 2))
		let max = Number(this.maxTime.slice(0, 2))
		for(let i = min; i <= max; i++){
			list.push({
				value: this.formatValue(i),
				text: this.formatValue(i) + (this.showUnit ? "时" : "")
			})
		}
		return this.filter("hour", list)
	}
	// 获取分钟列表
	getMinutesList(): Array<IBestPickerOption> {
		let monthsList: Array<IBestPickerOption> = []
		let hour = this.getValue("hour")
		let min = this.isMinHour(hour) ? Number(this.minTime.slice(3, 5)) : 0
		let max = this.isMaxHour(hour) ? Number(this.maxTime.slice(3, 5)) : 59
		for(let i = min; i <= max; i++){
			monthsList.push({
				value: this.formatValue(i),
				text: this.formatValue(i) + (this.showUnit ? "分" : "")
			})
		}
		return this.filter("minute", monthsList)
	}
	// 获取日期列表
	getSecondsList(): Array<IBestPickerOption> {
		let daysList: Array<IBestPickerOption> = []
		let hour = this.getValue("hour")
		let minute = this.getValue("minute")
		let min = this.isMinHour(hour) && this.isMinMinute(minute) ? Number(this.minTime.slice(6)) : 0
		let max = this.isMaxHour(hour) && this.isMaxMinute(minute) ? Number(this.maxTime.slice(6)) : 59
		for(let i = min; i <= max; i++){
			daysList.push({
				value: this.formatValue(i),
				text: this.formatValue(i) + (this.showUnit ? "秒" : "")
			})
		}
		return this.filter("second", daysList)
	}
	// 列变化
	changeColumn(columnIndex: number){
		if(columnIndex < this.options.length - 1){
			this.init()
		}
		this.onChange(this.value)
		if(this.groupId) {
			emitter.emit(getEventName(COMPONENT_NAME, this.groupId, TIME_PICKER_EVENT_NAME.COLUMN_CHANGE), this.uniId, this.value)
		}
	}
	// 处理同组时间变化
	handleGroupTimeChange(uniId: number, selectedValues: Array<string>) {
		if(this.uniId > uniId){
			// console.log("监听到同组前一个datePicker值变化", `当前组件${this.uniId}`, uniId, selectedValues.join("-"))
			let selectTime = selectedValues.join(":")
			this.minTime = selectTime
			if(selectTime > this.maxTime || selectTime < this.minTime){
				this.value = selectedValues
			}
			this.init()
		}
	}

	build() {
		IBestPicker({
			groupId: this.groupId,
			value: $value,
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
			onConfirm: (selectedValues: Array<string>) => {
				this.onConfirm(selectedValues)
			},
			onCancel: () => {
				this.onCancel()
			},
			onChange: (selectedValues: Array<string>, selectTexts: Array<string>, columnIndex: number) => {
				this.changeColumn(columnIndex)
			}
		})
	}
}