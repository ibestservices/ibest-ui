import { IBestPicker } from '../picker'
import { IBestPickerOption } from '../picker/index.type'
import { COMPONENT_NAME, IBestTimePickerColumnType, TIME_PICKER_EVENT_NAME } from './index.type'
import ibestEmitter from '../../utils/eventEmitter'
import { convertDimensionsWidthUnit, getEventName, getResourceStr } from '../../utils/utils'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestTimePicker {
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
	@Prop minTime: string = "00:00:00"
	/**
	 * 最大时间
	 */
	@Prop maxTime: string = "23:59:59"
	/**
	 * 列表类型
     */
	@Prop listType: IBestTimePickerColumnType[] = ["hour", "minute", "second"]
	/**
	 * 是否显示单位
	 */
	@Prop showUnit: boolean = false
	/**
	 * 标题
	 */
	@Prop title: ResourceStr = ""
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
	filter: (type: IBestTimePickerColumnType, options: IBestPickerOption[]) => IBestPickerOption[] = (type, options) => options
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

	// 唯一id
	@State uniId: number = 0
	// 选项列表
	@State options: IBestPickerOption[][] = []

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		this.init()
		if(this.groupId){
			ibestEmitter.on(getEventName(COMPONENT_NAME, TIME_PICKER_EVENT_NAME.COLUMN_CHANGE, this.groupId), this.uniId, (uniId: number, selectedValues: string[]): void => this.handleGroupTimeChange(uniId, selectedValues))
		}
	}
	aboutToDisappear(): void {
		if(this.groupId) {
			ibestEmitter.off(getEventName(COMPONENT_NAME, TIME_PICKER_EVENT_NAME.COLUMN_CHANGE, this.groupId), this.uniId)
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
		this.listType.forEach((item) => {
			let list = item == "hour" ? this.getHoursList() : item == "minute" ? this.getMinutesList() : this.getSecondsList()
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
	getValue(type: IBestTimePickerColumnType): string{
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
	getHoursList(): IBestPickerOption[] {
		let list: IBestPickerOption[] = []
		let min = Number(this.minTime.slice(0, 2))
		let max = Number(this.maxTime.slice(0, 2))
		let unit = this.showUnit ? getResourceStr($r("app.string.ibest_hour")) : ""
		for(let i = min; i <= max; i++){
			list.push({
				value: this.formatValue(i),
				text: this.formatValue(i) + unit
			})
		}
		return this.filter("hour", list)
	}
	// 获取分钟列表
	getMinutesList(): IBestPickerOption[] {
		let monthsList: IBestPickerOption[] = []
		let hour = this.getValue("hour")
		let min = this.isMinHour(hour) ? Number(this.minTime.slice(3, 5)) : 0
		let max = this.isMaxHour(hour) ? Number(this.maxTime.slice(3, 5)) : 59
		let unit = this.showUnit ? getResourceStr($r("app.string.ibest_minute")) : ""
		for(let i = min; i <= max; i++){
			monthsList.push({
				value: this.formatValue(i),
				text: this.formatValue(i) + unit
			})
		}
		return this.filter("minute", monthsList)
	}
	// 获取日期列表
	getSecondsList(): IBestPickerOption[] {
		let daysList: IBestPickerOption[] = []
		let hour = this.getValue("hour")
		let minute = this.getValue("minute")
		let min = this.isMinHour(hour) && this.isMinMinute(minute) ? Number(this.minTime.slice(6)) : 0
		let max = this.isMaxHour(hour) && this.isMaxMinute(minute) ? Number(this.maxTime.slice(6)) : 59
		let unit = this.showUnit ? getResourceStr($r("app.string.ibest_second")) : ""
		for(let i = min; i <= max; i++){
			daysList.push({
				value: this.formatValue(i),
				text: this.formatValue(i) + unit
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
			ibestEmitter.emit(getEventName(COMPONENT_NAME, TIME_PICKER_EVENT_NAME.COLUMN_CHANGE, this.groupId), this.uniId, this.value)
		}
	}
	// 处理同组时间变化
	handleGroupTimeChange(uniId: number, selectedValues: string[]) {
		if(this.uniId > uniId){
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
			onConfirm: (selectedValues) => {
				this.onConfirm(selectedValues as string[])
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