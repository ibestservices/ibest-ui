import { emitter } from '../../utils/EventEmitter'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { CHECKBOX_GROUP_EVENT_NAME, COMPONENT_NAME } from '../checkboxGroup/index.type'
import { IBestCheckboxBuilderParams, IBestCheckboxMaxChangeParams } from './index.type'
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit } from '../../utils/utils'
import { IBestCheckboxColor } from './color'
import { IBestIcon } from '../icon'
import { IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestCheckbox {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 组名
	 */
	@Prop group: IBestStringNumber = ''
	/**
	 * 标识符，通常为一个唯一的字符串或数字
	 */
	@Prop name: IBestStringNumber = ''
	/**
	 * 默认是否选中 非双向绑定
	 * 如果要更改数据请从onChange回调中获取最新的值
	 */
	@Prop value: boolean = false
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
	 * 自定义文本插槽
	 */
	@BuilderParam defaultBuilder: (data: IBestCheckboxBuilderParams) => void
	/**
	 * 自定义图标插槽
	 */
	@BuilderParam iconBuilder: (data: IBestCheckboxBuilderParams) => void
	/**
	 * 改变的回调
	 */
	onChange: (checked: boolean) => void = () => {}
	/**
	 * 改变前的回调
	 * @since 2.0.8
	 */
	beforeChange?: (value: boolean) => Promise<boolean> | boolean
	// 受checkboxgroup的最大可选数量禁用的
	@State @Watch('getIsDisabled') checkboxGroupMaxDisabled: boolean = false
	// 合并disabled与checkboxGroupMaxDisabled的最终结果
	@State mergeDisabled: boolean = false
	// 是否展示不确定状态的按钮
	@State isShowIndeterminateImg: boolean = false
	@State uniId: number = 0
	// 当不确定图标从显示变隐藏时 等待动画结束后再变
	private isShowIndeterminateTimeId: number | null = null

	@Builder LabelContain() {
		Row() {
			if (this.defaultBuilder) {
				this.defaultBuilder({ checked: this.value, disabled: this.mergeDisabled })
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

	aboutToAppear() {
		this.uniId = this.getUniqueId()
		if (this.group) {
			emitter.on(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.INIT_CHILDREN, this.group), this.uniId, (actives: IBestStringNumber[]): void => this.init(actives))
			emitter.on(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE, this.group), this.uniId, (data: IBestCheckboxMaxChangeParams): void => this.handleMaxChange(data))
			emitter.emit(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.GET_ALL_NAME, this.group), this.name)
		} else {
			this.getIsDisabled()
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
	init(actives: IBestStringNumber[]) {
		this.value = actives.includes(this.name)
	}
	// 是否展示背景色
	isShowBackground() {
		return this.value || this.indeterminate
	}
	// 获取背景色
	getBackgroundColor() {
		if (this.mergeDisabled) {
			return IBestCheckboxColor.borderColor
		} else {
			return this.isShowBackground() ? (this.checkedColor || this.baseStyle.primary as string) : this.bgColor
		}
	}
	// 获取边框色
	getBorderColor() {
		if (this.mergeDisabled) {
			return GRAY_COLOR.GRAY_5
		} else {
			return this.isShowBackground() ? (this.checkedColor || this.baseStyle.primary as string) : this.bdColor
		}
	}
	// 获取label的颜色
	getLabelColor() {
		return this.mergeDisabled ? IBestCheckboxColor.disabledLabelColor : IBestCheckboxColor.labelColor
	}
	// 获取图标的颜色
	getIconColor() {
		return this.mergeDisabled ? IBestCheckboxColor.disabledIconColor : IBestCheckboxColor.whiteColor
	}
	// 是否是在左边的label
	isLeftLabel() {
		return this.labelPosition === 'left'
	}
	updateGroup() {
		if (this.group) {
			emitter.emit(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.ITEM_CHANGE, this.group), this.name, this.value)
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
	async handleCheckedChange(status = !this.value) {
		if (this.mergeDisabled) {
			return
		}
		let state = await this.handleBeforeClose(status)
		if(!state){
			return
		}
		this.value = status
		this.onChange(this.value)
		this.updateGroup()
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
		this.mergeDisabled = this.disabled || this.checkboxGroupMaxDisabled
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
				if (typeof this.iconBuilder === 'function') {
					this.iconBuilder({ checked: this.value, disabled: this.mergeDisabled })
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
		}.enabled(!this.mergeDisabled)
	}
}