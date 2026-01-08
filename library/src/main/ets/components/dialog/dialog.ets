import { IBestDialogColor } from './color'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
@Extend(Button) function ibestDialogDefaultBtnStyles(theme: 'default' | 'round-button') {
	.layoutWeight(1)
	.height(convertDimensionsWidthUnit(theme == 'default' ? 48 : 36))
}

@Component
export struct IBestDialogView {
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@StorageProp(IBestStorageKey.COLOR_MODE) @Watch("colorModeChange") colorMode: ColorMode = ColorMode.LIGHT
	/**
	 * 弹窗宽度
	 */
	@Prop dialogWidth: IBestStringNumber = convertDimensionsWidthUnit(320)
	/**
	 * 弹窗圆角
	 */
	@Prop dialogBorderRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = this.baseStyle.spaceMd as string
	/**
	 * 背景图片
	 * @since 2.0.8
	 */
	@Prop bgColor: ResourceColor = ''
	/**
	 * 背景图片
	 * @since 2.0.7
	 */
	@Prop bgImage: ResourceStr = ''
	/**
	 * 标题
	 */
	@Prop title: ResourceStr = ""
	/**
	 * 标题颜色
	 */
	@Prop titleColor: ResourceColor = ''
	/**
	 * 标题的fontSize
	 */
	@Prop titleFontSize: IBestStringNumber = this.baseStyle.fontSizeLg as string
	/**
	 * 标题的padding-top值
	 */
	@Prop titlePaddingTop: IBestStringNumber = convertDimensionsWidthUnit(26)
	/**
	 * 标题的padding-left与padding-right值
	 */
	@Prop titlePaddingX: IBestStringNumber = this.baseStyle.spaceLg as string
	/**
	 * 标题的padding-top值
	 */
	@Prop titleLineHeight: IBestStringNumber = this.baseStyle.spaceLg as string
	/**
	 * 标题的对齐方式
	 */
	@Prop titleTextAlign: 'left' | 'center' | 'right' = 'center'
	/**
	 * 文本内容，支持通过 \n 换行
	 */
	@Prop message: ResourceStr = ""
	/**
	 * 内容区域的fontColor 默认#323233
	 */
	@Prop messageFontColor: ResourceColor = ''
	/**
	 * 内容区域的fontSize
	 */
	@Prop messageFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
	/**
	 * 内容区域的行高 lineHeight
	 */
	@Prop messageLineHeight: IBestStringNumber = this.baseStyle.lineHeightMd as string
	/**
	 * 内容区域的padding-top值
	 */
	@Prop messagePaddingTop: IBestStringNumber = this.baseStyle.spaceXs as string
	/**
	 * 内容区域的padding-left与padding-right值
	 */
	@Prop messagePaddingX: IBestStringNumber = this.baseStyle.spaceLg as string
	/**
	 * 内容区域的padding-bottom值
	 */
	@Prop messagePaddingBottom: IBestStringNumber = convertDimensionsWidthUnit(26)
	/**
	 * 内容区域的文字对齐方式
	 */
	@Prop messageTextAlign: 'left' | 'center' | 'right' = 'center'
	/**
	 * 内容区域最大高度
	 */
	@Prop messageMaxHeight: IBestStringNumber = 'auto'
	/**
	 * 样式风格
	 * @since 1.16.0
	 */
	@Prop theme: 'default' | 'round-button' = 'default'
	/**
	 * 按钮间距
	 * @since 1.16.0
	 */
	@Prop buttonSpace: IBestStringNumber = 0
	/**
	 * 是否展示确认按钮
	 */
	@Prop showConfirmButton: boolean = true
	/**
	 * 是否展示取消按钮
	 */
	@Prop showCancelButton: boolean = false
	/**
	 * 确认按钮文案
	 */
	@Prop confirmButtonText: ResourceStr = $r("app.string.ibest_text_confirm")
	/**
	 * 取消按钮的文案
	 */
	@Prop cancelButtonText: ResourceStr = $r("app.string.ibest_text_cancel")
	/**
	 * 按钮的文字大小
	 */
	@Prop buttonFontSize: IBestStringNumber = this.baseStyle.fontSizeLg as string
	/**
	 * 确认按钮的字体颜色
	 */
	@Prop confirmButtonColor: ResourceColor = ''
	/**
	 * 确认按钮字重
	 * @since 2.0.9
     */
	@Prop confirmButtonFontWeight: FontWeight = FontWeight.Normal
	/**
	 * 确认按钮的背景颜色
	 * @since 1.16.0
	 */
	@Prop confirmButtonBgColor: ResourceColor = ''
	/**
	 * 取消按钮的字体颜色
	 */
	@Prop cancelButtonColor: ResourceColor = ''
	/**
	 * 取消按钮的背景颜色
	 * @since 1.16.0
	 */
	@Prop cancelButtonBgColor: ResourceColor = ""
	/**
	 * 是否禁用确认按钮
	 */
	@Prop confirmButtonDisabled: boolean = false
	/**
	 * 是否禁用取消按钮
	 */
	@Prop cancelButtonDisabled: boolean = false
	/**
	 * 确认按钮的loading
	 */
	@Prop confirmButtonLoading: boolean = false
	/**
	 * 取消按钮的loading
	 */
	@Prop cancelButtonLoading: boolean = false
	/**
	 * 标题区域的builder
	 */
	@BuilderParam titleBuilder: CustomBuilder
	/**
	 * 内容区域的builder
	 */
	@BuilderParam defaultBuilder: CustomBuilder
	/**
	 * 底部区域的builder
	 */
	@BuilderParam footerBuilder: CustomBuilder
	/**
	 * 点击取消的回调
	 */
	onCancel: () => void = () => {}
	/**
	 * 点击确认的的回调
	 */
	onConfirm: () => void = () => {}
	/**
	 * 点击遮罩
     */
	onClickOverlay: () => void = () => {}

	@State whiteColor: ResourceColor = IBestDialogColor.white
	@State contentBg: ResourceColor = this.bgColor || IBestDialogColor.contentBg
	@State titleDefaultColor: ResourceColor = IBestDialogColor.titleColor
	@State messageColor: ResourceColor = IBestDialogColor.messageColor
	@State cancelTextColor: ResourceColor = IBestDialogColor.cancelTextColor
	@State bdColor: ResourceColor = IBestDialogColor.borderColor
	@Builder placeRow(){
		Blank()
			.onClick(() => {
				this.onClickOverlay()
			})
	}
	// 颜色模式切换
	colorModeChange() {
		this.whiteColor = IBestDialogColor.white
		this.contentBg = this.bgColor || IBestDialogColor.contentBg
		this.titleDefaultColor = IBestDialogColor.titleColor
		this.messageColor = IBestDialogColor.messageColor
		this.cancelTextColor = IBestDialogColor.cancelTextColor
		this.bdColor = IBestDialogColor.borderColor
	}
	// 标题对齐
	getTitleAlign() {
		switch (this.titleTextAlign) {
			case 'left':
				return FlexAlign.Start
			case 'right':
				return FlexAlign.End
			default:
				return FlexAlign.Center
		}
	}
	// 内容对齐
	getMessageAlign(){
		switch (this.messageTextAlign) {
			case 'left':
				return TextAlign.Start
			case 'right':
				return TextAlign.End
			default:
				return TextAlign.Center
		}
	}
	getTitleColor() {
		return this.titleColor || this.titleDefaultColor
	}
	// 获取内容区域文字颜色
	getMsgColor() {
		return this.messageFontColor || (this.title ? GRAY_COLOR.GRAY_7 : this.messageColor)
	}
	// 确认按钮的文字颜色
	getConfirmBtnFontColor() {
		return this.confirmButtonColor || (this.theme == 'round-button' ? this.whiteColor : this.baseStyle.primary)
	}
	// 确认按钮背景色
	getConfirmBtnBgColor() {
		return this.confirmButtonBgColor || (this.theme == 'round-button' ? this.baseStyle.primary : "transparent")
	}
	// 取消按钮的文字颜色
	getCancelBtnFontColor() {
		return this.cancelButtonColor || this.cancelTextColor
	}
	// 取消按钮背景色
	getCancelBtnBgColor() {
		return this.cancelButtonBgColor || "transparent"
	}
	build() {
		Row(){
			this.placeRow()
			Column() {
				if (this.titleBuilder) {
					this.titleBuilder()
				} else {
					if (this.title) {
						Row(){
							Text(this.title)
								.fontSize(getSizeByUnit(this.titleFontSize, true))
								.fontWeight(FontWeight.Medium)
								.lineHeight(getSizeByUnit(this.titleLineHeight))
								.padding({
									top: getSizeByUnit(this.titlePaddingTop),
									left: getSizeByUnit(this.titlePaddingX),
									right: getSizeByUnit(this.titlePaddingX)
								})
								.fontColor(this.getTitleColor())
						}
						.width(CONTAINER_SIZE.FULL)
						.justifyContent(this.getTitleAlign())
					}
				}
				if (this.defaultBuilder) {
					this.defaultBuilder()
				} else {
					Scroll() {
						Text(this.message)
							.width(CONTAINER_SIZE.FULL)
							.padding({
								top: getSizeByUnit(this.messagePaddingTop),
								left: getSizeByUnit(this.messagePaddingX),
								right: getSizeByUnit(this.messagePaddingX),
								bottom: getSizeByUnit(this.messagePaddingBottom)
							})
							.margin({ top: this.title ? 0 : getSizeByUnit(this.messagePaddingBottom) })
							.textAlign(this.getMessageAlign())
							.lineHeight(getSizeByUnit(this.messageLineHeight))
							.fontSize(getSizeByUnit(this.messageFontSize, true))
							.fontColor(this.getMsgColor())
					}
					.scrollBarColor(this.baseStyle.scrollBarColor as string)
					.edgeEffect(EdgeEffect.None)
					.constraintSize({
						maxHeight: getSizeByUnit(this.messageMaxHeight)
					})
				}
				if (this.footerBuilder) {
					this.footerBuilder()
				} else {
					Row({ space: getSizeByUnit(this.buttonSpace) }) {
						// 取消按钮
						if (this.showCancelButton) {
							Button({ type: ButtonType.Normal }) {
								if (this.cancelButtonLoading) {
									LoadingProgress()
										.width(getSizeByUnit(this.buttonFontSize))
										.color(this.getCancelBtnFontColor())
										.transition({ type: TransitionType.Insert, opacity: 1 })
										.transition({ type: TransitionType.Delete, opacity: 0 })
								} else {
									Text(this.cancelButtonText)
										.fontColor(this.getCancelBtnFontColor())
										.fontSize(getSizeByUnit(this.buttonFontSize, true))
										.transition({ type: TransitionType.Insert, opacity: 1 })
										.transition({ type: TransitionType.Delete, opacity: 0 })
								}
							}
							.border({
								width: this.theme == 'default' ? { right: this.showConfirmButton ? 1 : 0 } : 1,
								color: this.bdColor
							})
							.enabled(!this.cancelButtonDisabled || !this.cancelButtonLoading)
							.ibestDialogDefaultBtnStyles(this.theme)
							.backgroundColor(this.getCancelBtnBgColor())
							.borderRadius(this.theme == "round-button" ? {
								topLeft: 999,
								bottomLeft: 999,
								topRight: this.showConfirmButton && this.buttonSpace == 0 ? 0 : 999,
								bottomRight: this.showConfirmButton && this.buttonSpace == 0 ? 0 : 999
							} : 0)
							.onClick(() => {
								this.onCancel()
							})
						}
						// 确认按钮
						if (this.showConfirmButton) {
							Button({ type: ButtonType.Normal }) {
								if (this.confirmButtonLoading) {
									LoadingProgress()
										.width(getSizeByUnit(this.buttonFontSize))
										.color(this.getConfirmBtnFontColor())
										.transition({ type: TransitionType.Insert, opacity: 1 })
										.transition({ type: TransitionType.Delete, opacity: 0 })
								} else {
									Text(this.confirmButtonText)
										.fontColor(this.getConfirmBtnFontColor())
										.fontSize(getSizeByUnit(this.buttonFontSize, true))
										.fontWeight(this.confirmButtonFontWeight)
										.transition({ type: TransitionType.Insert, opacity: 1 })
										.transition({ type: TransitionType.Delete, opacity: 0 })
								}
							}
							.enabled(!this.confirmButtonDisabled || !this.confirmButtonLoading)
							.ibestDialogDefaultBtnStyles(this.theme)
							.backgroundColor(this.getConfirmBtnBgColor())
							.borderRadius(this.theme == "round-button" ? {
								topLeft: this.showCancelButton && this.buttonSpace == 0 ? 0 : 999,
								bottomLeft: this.showCancelButton && this.buttonSpace == 0 ? 0 : 999,
								topRight: 999,
								bottomRight: 999
							} : 0)
							.onClick(() => {
								this.onConfirm()
							})
						}
					}
					.border({ width: { top: this.theme == 'default' ? 1 : 0 }, color: this.bdColor })
					.padding(this.theme == "round-button" ? {
						top: this.baseStyle.spaceXs,
						left: this.baseStyle.spaceLg,
						right: this.baseStyle.spaceLg,
						bottom: this.baseStyle.spaceMd
					} : "")
				}
			}
			.width(getSizeByUnit(this.dialogWidth))
			.backgroundColor(this.contentBg)
			.backgroundImage(this.bgImage)
			.backgroundImageSize(ImageSize.FILL)
			.borderRadius(getSizeByUnit(this.dialogBorderRadius))
			.animation({ duration: 200, curve: Curve.EaseInOut })
			.clip(true)
			this.placeRow()
		}
		.width(CONTAINER_SIZE.FULL)
	}
}