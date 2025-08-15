import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { accAdd, accSub, convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils'
import { IBestStepperColor } from './color'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { IBestIcon } from '../icon'

enum STEPPER_BTN_TYPE {
	PLUS = 'PLUS',
	REDUCE = 'REDUCE'
}
@Component
export struct IBestStepper {
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 绑定值
	 * @since 2.0.1
	 */
	@Link @Watch("valueChange") value: number
	/**
	 * 输入框宽度
	 */
	@Prop inputWidth: IBestStringNumber = convertDimensionsWidthUnit(32)
	/**
	 * 按钮大小以及输入框高度
	 */
	@Prop buttonSize: IBestStringNumber = convertDimensionsWidthUnit(27)
	/**
	 * 图标大小
	 */
	@Prop iconSize: IBestStringNumber = convertDimensionsWidthUnit(20)
	/**
	 * 加减按钮图标的左右radius值
	 */
	@Prop buttonRadius: IBestStringNumber = this.baseStyle.borderRadiusSm as string
	/**
	 * 默认值
	 * @deprecated since 2.0.1 请使用 value
	 */
	@Prop defaultValue: number = 1
	/**
	 * 最小值
	 */
	@Prop min: number = 1
	/**
	 * 最大值
	 */
	@Prop max: number = Infinity
	/**
	 * 多少毫秒触发校验修正 0时不校验
	 */
	@Prop validateTime: number = 1000
	/**
	 * 是否自动校正超出限制范围的数值，设置为 false 后输入超过限制范围的数值将不会自动校正
	 */
	@Prop autoFixed: boolean = true
	/**
	 * 步长，每次点击时改变的值
	 */
	@Prop step: number = 1
	/**
	 * 固定显示的小数位数
	 */
	@Prop decimalLength: number = 0
	/**
	 * 是否禁用步进器
	 */
	@Prop disabled: boolean = false
	/**
	 *  是否禁用增加按钮
	 */
	@Prop disablePlus: boolean = false
	/**
	 *  是否禁用减少按钮
	 */
	@Prop disableMinus: boolean = false
	/**
	 * 是否禁用输入框
	 */
	@Prop disableInput: boolean = false
	/**
	 * 是否显示增加地址
	 */
	@Prop showPlus: boolean = true
	/**
	 * 是否显示增加地址
	 */
	@Prop showMinus: boolean = true
	/**
	 * 是否显示增加地址
	 */
	@Prop showInput: boolean = true
	/**
	 * 是否开启长按手势，开启后可以长按增加和减少按钮
	 */
	@Prop longPress: boolean = true
	/**
	 * 改变的回调
	 */
	onChange: (val: number) => void = () => {}
	/**
	 * 点击增加按钮的回调
	 */
	onPlus: () => void = () => {}
	/**
	 * 点击减少按钮的回调
	 */
	onMinus: () => void = () => {}
	// 输入框的值
	@State inputNumValue: string = Number(this.value).toFixed(this.decimalLength)
	// 减少按钮是否禁用
	@State reduceBtnDisabled: boolean = false
	// 增加按钮是否禁用
	@State plusBtnDisabled: boolean = false
	// 上一次输入正确的值
	private preValue: string = this.inputNumValue
	// 自动纠正的时间id
	private validateTimeId: number = 0

	@Builder stepperBtn(type: 'plus' | 'minus'){
		Button() {
			IBestIcon({
				name: type,
				iconSize: this.iconSize,
				color: IBestStepperColor.textColor
			})
		}
		.type(ButtonType.Normal)
		.backgroundColor(this.disabled ? IBestStepperColor.disabledBg : IBestStepperColor.bg)
		.width(getSizeByUnit(this.buttonSize))
		.height(getSizeByUnit(this.buttonSize))
		.borderRadius({
			topLeft: getSizeByUnit(this.buttonRadius),
			topRight: getSizeByUnit(this.buttonRadius),
			bottomLeft: getSizeByUnit(this.buttonRadius),
			bottomRight: getSizeByUnit(this.buttonRadius)
		})
		.enabled(!this.getBtnDisabled(type))
		.onClick(() => {
			this.handleClickStepperBtn(type == 'plus' ? STEPPER_BTN_TYPE.PLUS : STEPPER_BTN_TYPE.REDUCE)
		})
		.gesture(
			LongPressGesture({ repeat: true, duration: 200 })
				.onAction((event: GestureEvent) => {
					if (event && event.repeat) {
						this.handleClickStepperBtn(type == 'plus' ? STEPPER_BTN_TYPE.PLUS : STEPPER_BTN_TYPE.REDUCE)
					}
				})
		)
	}

	aboutToAppear() {
		this.handleInputNumChange('init', this.inputNumValue)
	}
	aboutToDisappear() {
		clearTimeout(this.validateTimeId)
	}
	valueChange(){
		this.handleInputNumChange('valueChange', this.value.toString())
	}
	// value变化
	handleInputNumChange(trigger: string, val: string) {
		if (val == '') {
			this.validateTimeId = setTimeout(() => {
				if (this.validateTime !== 0) {
					this.inputNumValue = this.preValue
					this.inputValueChange()
					if(trigger != 'init'){
						this.onChange(this.value)
					}
				}
				this.handleSetStepperBtnStatus()
				clearTimeout(this.validateTimeId)
			}, this.validateTime)
			return
		}
		// 超过范围是否自动纠正
		if (this.autoFixed) {
			if (parseFloat(val) > this.max) {
				val = String(this.max)
			}
			if (parseFloat(val) < this.min) {
				val = String(this.min)
			}
		}
		// 数据限制展示多少位
		if (trigger != 'init' && this.decimalLength > 0) {
			val = Number(val).toFixed(this.decimalLength)
		}
		this.preValue = this.inputNumValue = val.toString()
		this.handleSetStepperBtnStatus()
		if(trigger != 'valueChange'){
			this.inputValueChange()
			if(trigger != 'init'){
				this.onChange(this.value)
			}
		}
	}
	// 监听inputNumChange改变按钮状态
	handleSetStepperBtnStatus() {
		const val = parseFloat(this.inputNumValue)
		this.reduceBtnDisabled = val <= this.min
		this.plusBtnDisabled = val >= this.max
	}
	// 当点击加减按钮时
	handleClickStepperBtn(btnType: STEPPER_BTN_TYPE) {
		if (this.disabled) {
			return
		}
		let nextValue = '0'
		if (btnType === STEPPER_BTN_TYPE.PLUS) {
			if (this.disablePlus) {
				return
			}
			nextValue = String(accAdd(Number(this.inputNumValue), this.step))
			this.onPlus()
		} else {
			if (this.disableMinus) {
				return
			}
			nextValue = String(accSub(Number(this.inputNumValue), this.step))
			this.onMinus()
		}
		this.handleInputNumChange('change', nextValue)
	}
	inputValueChange(){
		this.value = parseFloat(this.inputNumValue)
	}
	getBtnDisabled(type: 'plus' | 'minus'){
		return this.disabled || (type == 'minus' ? this.reduceBtnDisabled || this.disableMinus : this.plusBtnDisabled || this.disablePlus)
	}
	build() {
		Row() {
			if (this.showMinus) {
				this.stepperBtn("minus")
			}
			// 输入框
			if (this.showInput) {
				TextInput({ text: $$this.inputNumValue })
					.type(this.decimalLength > 0 ? InputType.NUMBER_DECIMAL : InputType.Number)
					.width(getSizeByUnit(this.inputWidth))
					.height(getSizeByUnit(this.buttonSize))
					.padding(0)
					.margin({
						top: 0,
						bottom: 0,
						left: convertDimensionsWidthUnit(2),
						right: convertDimensionsWidthUnit(2)
					})
					.fontSize(this.baseStyle.fontSizeMd)
					.fontColor(this.disabled ? IBestStepperColor.disabledTextColor : IBestStepperColor.textColor)
					.backgroundColor(IBestStepperColor.bg)
					.borderRadius(0)
					.textAlign(TextAlign.Center)
					.onBlur(() => this.handleInputNumChange('blur', this.inputNumValue))
					.focusable(!(this.disabled || this.disableInput))
			}
			if (this.showPlus) {
				this.stepperBtn("plus")
			}
		}
	}
}