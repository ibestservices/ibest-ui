import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { COLOR_TYPE, ColorType } from '../../theme-chalk/src/color.type'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { SIZE, SizeType } from '../../theme-chalk/src/size.type'
import { BtnSizeType } from './index.type'
import { IBestLoading } from '../loading/index'
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils'
import { IBestButtonColor } from './color'
import { IBestIcon } from '../icon'
import { IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestButton {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 类型，可选值为 primary success warning danger 默认值为default
	 */
	@Prop type: ColorType = COLOR_TYPE.DEFAULT
	/**
	 * 大小，可选值为 large normal small mini
	 */
	@Prop buttonSize: SizeType = SIZE.NORMAL
	/**
	 * 是否为朴素按钮
	 */
	@Prop plain: boolean = false
	/**
	 * 是否为方形按钮
	 */
	@Prop square: boolean = false
	/**
	 * 是否为圆形按钮
	 */
	@Prop round: boolean = false
	/**
	 * 是否使用 0.5px 边框
	 */
	@Prop hairline: boolean = false
	/**
	 * 是否显示为加载状态
	 */
	@Prop loading: boolean = false
	/**
	 * loading加载的文案
	 */
	@Prop loadingText: ResourceStr = ""
	/**
	 * 按钮展示的文字
	 */
	@Prop text: ResourceStr
	/**
	 * 是否禁用
	 */
	@Prop disabled: boolean = false
	/**
	 * 按钮颜色
	 */
	@Prop @Watch('handleColorChange') color: ResourceColor = ''
	/**
	 * 加载图标的大小, 如果为-1就是默认值 默认值跟随字体大小
	 */
	@Prop loadingSize: IBestStringNumber = -1
	/**
	 * 按钮宽度
	 */
	@Prop btnWidth: IBestStringNumber
	/**
	 * 按钮高度
	 */
	@Prop btnHeight: IBestStringNumber
	/**
	 * 按钮文字大小
	 */
	@Prop btnFontSize: IBestStringNumber
	/**
	 * 按钮图标
	 * @since 2.0.1
	 */
	@Prop icon: ResourceStr = ""
	/**
	 * 按钮文字颜色
	 * @since 2.0.1
	 */
	@Prop fontColor: ResourceColor = ""
	/**
	 * 按钮边框颜色
	 * @since 2.0.1
	 */
	@Prop btnBorderColor: ResourceColor = ""
	/**
	 * 按钮圆角
	 * @since 2.0.1
	 */
	@Prop btnBorderRadius: IBestStringNumber = ""
	/**
	 * 图标位置
	 * @since 2.0.3
     */
	@Prop iconPosition: 'left' | 'right' | 'top' | 'bottom' = 'left'
	/**
	 * 文字与图标间距
	 * @since 2.0.7
     */
	@Prop space: IBestStringNumber = this.baseStyle.spaceBase as string
	/**
	 * defaultSlot 默认插槽
	 */
	@BuilderParam defaultBuilder: CustomBuilder
	/**
	 * 图标的builder
	 */
	@BuilderParam iconBuilder: CustomBuilder
	/**
	 * 加载图标的builder
	 */
	@BuilderParam loadingIconBuilder: CustomBuilder
	/**
	 * 点击按钮，且按钮状态不为加载或禁用时触发
	 * @deprecated since 2.0.8
	 * @useinstead onBtnClick
	 */
	onClickBtn: () => void = () => {}
	/**
	 * 点击按钮，且按钮状态不为加载或禁用时触发
	 * @since 2.0.8
	 */
	onBtnClick: () => void = () => {}

	@Builder iconContent() {
		if (this.loading) {
			if (this.loadingIconBuilder) {
				this.loadingIconBuilder()
			} else {
				IBestLoading({
					loadingSize: this.getLoadingSize(),
					loadingColor: this.getBtnTextColor()
				}).margin({
					left: this.iconPosition == "right" && (this.text || this.loadingText) ? getSizeByUnit(this.space) : 0,
					right: this.iconPosition == "left" && (this.text || this.loadingText) ? getSizeByUnit(this.space) : 0,
					bottom: this.iconPosition == "top" && (this.text || this.loadingText) ? getSizeByUnit(this.space) : 0,
					top: this.iconPosition == "bottom" && (this.text || this.loadingText) ? getSizeByUnit(this.space) : 0
				})
			}
		} else if (this.iconBuilder) {
			this.iconBuilder()
		} else if (this.icon) {
			IBestIcon({
				name: this.icon,
				iconSize: this.getBtnSize()?.fontSize,
				color: this.getBtnTextColor()
			}).margin({
				left: this.iconPosition == "right" && (this.text || this.loadingText) ? getSizeByUnit(this.space) : 0,
				right: this.iconPosition == "left" && (this.text || this.loadingText) ? getSizeByUnit(this.space) : 0,
				bottom: this.iconPosition == "top" && (this.text || this.loadingText) ? getSizeByUnit(this.space) : 0,
				top: this.iconPosition == "bottom" && (this.text || this.loadingText) ? getSizeByUnit(this.space) : 0
			})
		}
	}

	// 根据buttonSize换对应的按钮尺寸
	getBtnSize(): BtnSizeType {
		if (this.btnWidth || this.btnHeight) {
			return {
				width: this.btnWidth || "auto",
				height: this.btnHeight || convertDimensionsWidthUnit(44),
				padding: convertDimensionsWidthUnit(15),
				fontSize: this.btnFontSize || this.baseStyle.fontSizeMd as string
			}
		}
		const buttonSize = this.buttonSize
		switch (buttonSize) {
			case SIZE.MINI:
				return {
					width: "auto",
					height: convertDimensionsWidthUnit(24),
					padding: this.baseStyle.spaceBase as string,
					fontSize: this.btnFontSize || this.baseStyle.fontSizeXs as string
				}
			case SIZE.SMALL:
				return {
					width: "auto",
					height: convertDimensionsWidthUnit(32),
					padding: this.baseStyle.spaceXs as string,
					fontSize: this.btnFontSize || this.baseStyle.fontSizeSm as string
				}
			case SIZE.LARGE:
				return {
					width: CONTAINER_SIZE.FULL,
					height: convertDimensionsWidthUnit(50),
					padding: this.baseStyle.spaceXs as string,
					fontSize: this.btnFontSize || this.baseStyle.fontSizeLg as string
				}
			default:
				return {
					width: "auto",
					height: convertDimensionsWidthUnit(44),
					padding: convertDimensionsWidthUnit(15),
					fontSize: this.btnFontSize || this.baseStyle.fontSizeMd as string
				}
		}
	}
	getBtnFontSize() {
		return this.btnFontSize != undefined ? getSizeByUnit(this.btnFontSize, true) : ""
	}
	// 获取按钮的borderRadius
	getBtnBorderRadius() {
		return getSizeByUnit(this.btnBorderRadius) || (this.square ? 0 : this.baseStyle[`borderRadius${this.round ? 'Max' : 'Md'}`])
	}
	// 获取按钮边框的颜色
	getBorderColor() {
		return this.btnBorderColor || (this.color ? this.color : this.type === COLOR_TYPE.DEFAULT ? GRAY_COLOR.GRAY_4 : this.baseStyle[this.type])
	}
	// 获取按钮文字的颜色
	getBtnTextColor() {
		if (this.fontColor) {
			return this.fontColor
		}
		if (this.plain) {
			return this.color ? this.color : this.type === COLOR_TYPE.DEFAULT ? IBestButtonColor.textColor : this.baseStyle[this.type]
		}
		return this.type === COLOR_TYPE.DEFAULT ? IBestButtonColor.textColor : IBestButtonColor.whiteColor
	}
	// 根据颜色type获取背景色
	getBackgroundColor() {
		return this.plain ? "transparent" : this.color ? this.color : this.type == "default" ? IBestButtonColor.defaultBg : this.baseStyle[this.type]
	}
	// 获取loading的大小
	getLoadingSize() {
		return this.loadingSize != -1 ? getSizeByUnit(this.loadingSize) : this.getBtnSize()?.fontSize as string
	}
	// 当传入自定义颜色时 设置type保证颜色渲染正常
	handleColorChange() {
		if (this.color) {
			this.type = 'primary'
		}
	}
	aboutToAppear() {
		this.handleColorChange()
	}
	build() {
		Button({ type: ButtonType.Normal }) {
			if (this.defaultBuilder) {
				this.defaultBuilder()
			} else {
				if(['left', 'right'].includes(this.iconPosition)){
					Row() {
						if(this.iconPosition == "left"){
							this.iconContent()
						}
						Text(this.loading ? this.loadingText ?? this.text : this.text)
							.fontSize(this.getBtnSize()?.fontSize)
							.fontColor(this.getBtnTextColor())
						if(this.iconPosition == "right"){
							this.iconContent()
						}
					}
				}else{
					Column(){
						if(this.iconPosition == "top"){
							this.iconContent()
						}
						Text(this.loading ? this.loadingText ?? this.text : this.text)
							.fontSize(this.getBtnSize()?.fontSize)
							.fontColor(this.getBtnTextColor())
						if(this.iconPosition == "bottom"){
							this.iconContent()
						}
					}
				}
			}
		}
		.width(getSizeByUnit(this.getBtnSize().width))
		.height(getSizeByUnit(this.getBtnSize().height))
		.padding({ left: getSizeByUnit(this.getBtnSize().padding), right: getSizeByUnit(this.getBtnSize().padding), top: 0, bottom: 0 })
		.borderWidth(convertDimensionsWidthUnit(this.hairline ? 0.5 : 1))
		.borderRadius(this.getBtnBorderRadius())
		.fontColor(this.getBtnTextColor())
		.backgroundColor(this.getBackgroundColor())
		.borderColor(this.getBorderColor())
		.hitTestBehavior(this.loading ? HitTestMode.None : HitTestMode.Default)
		.enabled(!this.disabled)
		.opacity(this.disabled && this.plain ? 0.5 : 1)
		.onTouch(event => {
			if(event.type == TouchType.Up){
				this.onClickBtn()
				this.onBtnClick()
			}
		})
		.animation({ duration: this.baseStyle.animationDuration as number })
	}
}