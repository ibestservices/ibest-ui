import { emitter } from '../../utils/EventEmitter'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { CHECKBOX_GROUP_EVENT_NAME, COMPONENT_NAME } from '../checkboxGroup/index.type'
import { IBestCheckboxBuilderParams, IBestCheckboxMaxChangeParams } from './index.type'
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit } from '../../utils/utils'
import { IBestCheckboxColor } from './color'
import { IBestIcon } from '../icon'
import { IBestAwaitable, IBestStorageKey, IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestCheckbox {
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 组名
	 */
	@Prop group: IBestStringNumber = ''
	/**
	 * 标识符，通常为一个唯一的字符串或数字
	 */
	@Prop name: IBestStringNumber = ''
	/**
	 * 默认是否选中, 非双向绑定, 仅单独使用时有效
	 * 如果要更改数据请从onChange回调中获取最新的值
	 * @since 2.1.7 开始支持 string number类型
	 */
	@Prop value: IBestStringNumber | boolean = false
	/**
	 * 形状
	 */
	@Prop shape: 'square' | 'round' = 'round'
	/**
	 * 选中状态颜色
	 */
	@Prop checkedColor: ResourceColor = ""
	/**
	 * 图标大小
	 */
	@Prop iconSize: IBestStringNumber = convertDimensionsWidthUnit(18)
	/**
	 * 是否禁用
	 */
	@Prop @Watch('getIsDisabled') disabled: boolean = false
	/**
	 * 显示的文本
	 */
	@Prop label: ResourceStr = ''
	/**
	 * 文本大小
	 * @since 1.18.0
	 */
	@Prop labelFontSize: IBestStringNumber = convertDimensionsWidthUnit(16)
	/**
	 * 文本位置，可选值为 left
	 */
	@Prop labelPosition: 'left' | 'right' = 'right'
	/**
	 * 是否禁用复选框文本点击
	 */
	@Prop labelDisabled: boolean = false
	/**
	 * 是否为不确定状态
	 */
	@Prop @Watch('handleIndeterminateChange') indeterminate: boolean = false
	/**
	 * 背景色
	 * @since 2.0.7
	 */
	@Prop bgColor: ResourceColor = ''
	/**
	 * 边框色
	 * @since 2.0.7
     */
	@Prop bdColor: ResourceColor = IBestCheckboxColor.borderColor
	/**
	 * 选中时的值，仅单独使用时生效
	 * @since 2.1.7
     */
	@Prop trueValue: IBestStringNumber = '1'
	/**
	 * 没有选中时的值，仅单独使用时生效
	 * @since 2.1.7
     */
	@Prop falseValue: IBestStringNumber = '0'
	/**
	 * 自定义文本插槽
	 */
	@BuilderParam defaultBuilder: ($$: IBestCheckboxBuilderParams) => void
	/**
	 * 自定义图标插槽
	 */
	@BuilderParam iconBuilder: ($$: IBestCheckboxBuilderParams) => void
	/**
	 * 改变的回调
	 */
	onChange: (checked: IBestStringNumber | boolean) => void = () => {}
	/**
	 * 改变前的回调
	 * @since 2.0.8
	 */
	beforeChange?: (value: boolean) => IBestAwaitable

	@State uniId: number = 0
	@State localValue: boolean = false
	// 受checkboxgroup的最大可选数量禁用的
	@State checkboxGroupMaxDisabled: boolean = false
	// 分组禁用
	@State groupDisabled: boolean = false
	// 是否展示不确定状态的按钮
	@State isShowIndeterminateImg: boolean = false
	// 当不确定图标从显示变隐藏时 等待动画结束后再变
	private isShowIndeterminateTimeId: number | null = null

	@Builder LabelContain() {
		if(this.defaultBuilder || this.label) {
			Row() {
				if (this.defaultBuilder) {
					this.defaultBuilder({ checked: this.getBooleanValue(), disabled: this.getIsDisabled() })
				} else {
					Text(this.label)
						.fontColor(this.getLabelColor())
						.fontSize(getSizeByUnit(this.labelFontSize, true))
				}
			}
			.margin({
				left: this.isLeftLabel() ? 0 : this.baseStyle.spaceXs,
				right: this.isLeftLabel() ? this.baseStyle.spaceXs : 0
			})
			.onClick(() => {
				!this.labelDisabled && this.handleCheckedChange()
			})
		}
	}

	aboutToAppear() {
		this.uniId = this.getUniqueId()
		if (this.group) {
			emitter.on(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.INIT_CHILDREN, this.group), this.uniId, (actives: IBestStringNumber[], disabled: boolean): void => this.init(actives, disabled))
			emitter.on(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE, this.group), this.uniId, (data: IBestCheckboxMaxChangeParams): void => this.handleMaxChange(data))
			emitter.emit(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.GET_ALL_NAME, this.group), this.name)
		}
		this.handleIndeterminateChange()
	}
	aboutToDisappear() {
		if (this.group) {
			emitter.off(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.INIT_CHILDREN, this.group), this.uniId)
			emitter.off(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE, this.group), this.uniId)
		}
		clearTimeout(this.isShowIndeterminateTimeId)
	}
	init(actives: IBestStringNumber[], disabled: boolean) {
		this.localValue = actives.includes(this.name)
		this.groupDisabled = disabled
	}
	getValue(){
		if(this.group){
			return this.localValue
		}
		return this.value
	}
	getBooleanValue(){
		if(this.group){
			return this.localValue
		}
		return typeof this.value === 'boolean' ? this.value : this.value === this.trueValue
	}
	// 是否展示背景色
	isShowBackground() {
		let value = this.getValue()
		return (typeof value === 'boolean' ? value : value === this.trueValue) || this.indeterminate
	}
	// 获取背景色
	getBackgroundColor() {
		if (this.getIsDisabled()) {
			return IBestCheckboxColor.borderColor
		} else {
			return this.isShowBackground() ? (this.checkedColor || this.baseStyle.primary as string) : this.bgColor
		}
	}
	// 获取边框色
	getBorderColor() {
		if (this.getIsDisabled()) {
			return GRAY_COLOR.GRAY_5
		} else {
			return this.isShowBackground() ? (this.checkedColor || this.baseStyle.primary as string) : this.bdColor
		}
	}
	// 获取label的颜色
	getLabelColor() {
		return this.getIsDisabled() ? IBestCheckboxColor.disabledLabelColor : IBestCheckboxColor.labelColor
	}
	// 获取图标的颜色
	getIconColor() {
		return this.getIsDisabled() ? IBestCheckboxColor.disabledIconColor : IBestCheckboxColor.whiteColor
	}
	// 是否是在左边的label
	isLeftLabel() {
		return this.labelPosition === 'left'
	}
	updateGroup(value: boolean) {
		if (this.group) {
			emitter.emit(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.ITEM_CHANGE, this.group), this.name, value)
		}
	}
	async handleBeforeClose(value: boolean) {
		let status = true
		try {
			if (this.beforeChange) {
				status = await this.beforeChange(value)
			}
		} catch (e) {
			status = false
		}
		return status
	}
	// 改变选中状态的回调
	async handleCheckedChange() {
		if (this.getIsDisabled()) {
			return
		}
		let value = this.getValue()
		let booleanValue = typeof value == 'boolean' ? !value : value === this.trueValue ? value === this.falseValue : value === this.trueValue
		let changedValue = typeof value == 'boolean' ? !value : value === this.trueValue ? this.falseValue : this.trueValue
		let state = await this.handleBeforeClose(booleanValue)
		if(!state){
			return
		}
		this.onChange(changedValue)
		this.updateGroup(booleanValue)
	}
	// 当选中的最大数量变化时 或者选中的数据变化时
	handleMaxChange(data: IBestCheckboxMaxChangeParams) {
		if (data.max <= 0) {
			this.checkboxGroupMaxDisabled = false
			return
		}
		const length = data.checkedList.length
		const index = data.checkedList.findIndex(item => item === this.name)
		if (index > -1) {
			return
		}
		this.checkboxGroupMaxDisabled = length >= data.max
	}
	// 获取是否禁用
	getIsDisabled() {
		return this.groupDisabled || this.disabled || this.checkboxGroupMaxDisabled
	}
	// 当不确定状态发生改变时 响应按钮UI状态图标变化
	handleIndeterminateChange() {
		clearTimeout(this.isShowIndeterminateTimeId)
		if (!this.value && !this.indeterminate) {
			this.isShowIndeterminateTimeId = setTimeout(() => {
				this.isShowIndeterminateImg = false
			}, this.baseStyle.animationDuration as number)
			return
		}
		this.isShowIndeterminateImg = this.indeterminate
	}
	build() {
		Row() {
			if (this.labelPosition === 'left') {
				this.LabelContain()
			}
			Column() {
				if (this.iconBuilder) {
					this.iconBuilder({ checked: this.getBooleanValue(), disabled: this.getIsDisabled() })
				} else {
					IBestIcon({
						name: this.isShowIndeterminateImg ? "minus" : "success",
						iconSize: this.iconSize,
						color: this.getIconColor()
					})
						.opacity(this.isShowBackground() ? 1 : 0)
						.animation({
							duration: this.baseStyle.animationDuration as number,
						})
				}
			}
			.padding(1)
			.justifyContent(FlexAlign.Center)
			.alignItems(HorizontalAlign.Center)
			.border({ color: this.getBorderColor(), width: 1 })
			.borderRadius(this.shape === 'round' ? this.baseStyle.borderRadiusMax : 0)
			.backgroundColor(this.getBackgroundColor())
			.clip(true)
			.animation({
				duration: this.baseStyle.animationDuration as number
			})
			.onTouch(event => {
				if(event.type == TouchType.Up){
					this.handleCheckedChange()
				}
			})
			if (this.labelPosition === 'right') {
				this.LabelContain()
			}
		}.enabled(!this.getIsDisabled())
	}
}