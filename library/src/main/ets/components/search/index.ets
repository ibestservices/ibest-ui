import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils'
import { IBestIcon } from '../icon'
import { IBestSearchColor } from './color'

@Component
export struct IBestSearch {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	// 是否聚焦
	@State isFocus: boolean = false
	// 清除锁
	@State clearLock: boolean = false
	/**
	 * 左侧文本
	 */
	@Prop label: string = ''
	/**
	 * 左侧文本颜色
	 * @since 2.0.1
     */
	@Prop labelColor: ResourceColor = IBestSearchColor.labelColor
	/**
	 * 输入框绑定值
	 */
	@Link value: string
	/**
	 * 输入框文字颜色
	 * @since 1.18.0
     */
	@Prop textColor: ResourceColor = IBestSearchColor.textColor
	/**
	 * 输入框文字大小
	 * @since 2.0.1
     */
	@Prop textFontSize: number | string = this.baseStyle.fontSizeMd as string
	/**
	 * 输入框 placeholder 提示文字
	 */
	@Prop placeholder: string = '请输入搜索关键词'
	/**
	 * placeholder 提示文字颜色
	 */
	@Prop placeholderColor: ResourceColor = GRAY_COLOR.GRAY_5
	/**
	 * 搜索框高度
	 */
	@Prop contentHeight: number | string = convertDimensionsWidthUnit(34)
	/**
	 * 外侧背景色
	 */
	@Prop outBgColor: ResourceColor = IBestSearchColor.outerBg
	/**
	 * 内侧背景色
	 */
	@Prop innerBgColor: ResourceColor = IBestSearchColor.innerBg
	/**
	 * 是否为圆形搜索框
	 */
	@Prop isRound: boolean = false
	/**
	 * 圆角大小
	 */
	@Prop radius: number | string = 0
	/**
	 * 左侧图标
	 */
	@Prop leftIcon: ResourceStr = "search"
	/**
	 * 左侧图标颜色
	 */
	@Prop leftIconColor: ResourceColor = IBestSearchColor.leftIconColor
	/**
	 * 是否可清除
	 */
	@Prop clearable: boolean = true
	/**
	 * 清除图片地址
	 */
	@Prop clearIcon: ResourceStr = "clear"
	/**
	 * 清除图标显示时机
	 */
	@Prop clearTrigger: "always" | "focus" = 'focus'
	/**
	 * 自动获取焦点
	 */
	@Prop autoFocus: boolean = false
	/**
	 * 是否显示右侧按钮
	 */
	@Prop showRightButton: boolean = false
	/**
	 * 右侧按钮文字
	 */
	@Prop rightButtonText: string = '取消'
	/**
	 * 是否禁用
	 */
	@Prop disabled: boolean = false
	/**
	 * 是否只读
	 */
	@Prop readOnly: boolean = false
	/**
	 * 输入法回车键类型
	 */
	@Prop enterKeyType: EnterKeyType = EnterKeyType.Search
	/**
	 * 右侧按钮背景色
	 * @since 2.0.1
     */
	@Prop rightBtnBgColor: ResourceColor = IBestSearchColor.outerBg
	/**
	 * 右侧按钮按压背景色
	 * @since 2.0.1
     */
	@Prop rightBtnPressBgColor: ResourceColor = IBestSearchColor.activeBg
	/**
	 * 自定义右侧按钮
	 */
	@BuilderParam customRightButton?: CustomBuilder
	/**
	 * 输入回调
	 */
	onInput: (value: string) => void = () => {}
	/**
	 * 搜索回调
	 */
	onSearch: () => void = () => {}
	/**
	 * 失焦回调
	 */
	onInputBlur: () => void = () => {}
	/**
	 * 聚焦回调
	 */
	onInputFocus: () => void = () => {}
	/**
	 * 清除回调
	 */
	onClear: () => void = () => {}
	/**
	 * 右侧按钮点击回调
	 */
	onRightButtonClick: () => void = () => {}

	clear(){
		this.clearLock = true
		this.value = ""
		this.onClear()
		setTimeout(() => {
			this.clearLock = false
		}, 10)
	}

	build() {
		Row(){
			Row(){
				Row(){
					if(this.label){
						Text(this.label)
							.fontSize(this.baseStyle.fontSizeMd)
							.fontColor(this.labelColor)
							.margin({ right: this.baseStyle.spaceBase })
					}
					IBestIcon({
						name: this.leftIcon,
						iconSize: convertDimensionsWidthUnit(18),
						color: this.leftIconColor
					}).margin({ right: this.baseStyle.spaceBase })
					TextInput({ text: $$this.value, placeholder: this.placeholder })
						.layoutWeight(1)
						.padding(0)
						.borderRadius(0)
						.fontColor(this.textColor)
						.fontSize(this.textFontSize)
						.placeholderFont({
							size: this.textFontSize
						})
						.placeholderColor(this.placeholderColor)
						.backgroundColor("transparent")
						.enableAutoFill(false)
						.defaultFocus(this.autoFocus)
						.enterKeyType(this.enterKeyType)
						.focusable(!(this.disabled || this.readOnly))
						.onChange((value: string) => {
							if(!this.clearLock){
								this.onInput(value)
							}
						})
						.onSubmit(() => {
							this.onSearch()
						})
						.onFocus(() => {
							this.isFocus = true
							this.onInputFocus()
						})
						.onBlur(() => {
							this.isFocus = false
							this.onInputBlur()
						})
					if(this.clearable){
						Row(){
							IBestIcon({
								name: this.clearIcon,
								iconSize: convertDimensionsWidthUnit(18),
								color: GRAY_COLOR.GRAY_5
							}).onClick(() => {
								this.clear()
							})
						}
						.padding({ left: this.baseStyle.spaceXs, right: this.baseStyle.spaceXs })
						.visibility(this.value && (this.clearTrigger == "always" || this.isFocus) ? Visibility.Visible : Visibility.None)
						.onClick(() => {
							this.clear()
						})
					}
				}
				.layoutWeight(1)
				.height(CONTAINER_SIZE.FULL)
				.backgroundColor(this.innerBgColor)
				.borderRadius(this.isRound ? this.baseStyle.borderRadiusMax : getSizeByUnit(this.radius))
				.padding({ left: this.baseStyle.spaceSm })
				.alignItems(VerticalAlign.Center)
				if(this.customRightButton){
					this.customRightButton()
				}else if(this.showRightButton){
					Text(this.rightButtonText)
						.constraintSize({minWidth: convertDimensionsWidthUnit(44)})
						.height(CONTAINER_SIZE.FULL)
						.fontSize(this.baseStyle.fontSizeMd)
						.padding({ left: this.baseStyle.spaceXs, right: this.baseStyle.spaceXs })
						.stateStyles({
							normal: {
								.backgroundColor(this.rightBtnBgColor)
							},
							pressed: {
								.backgroundColor(this.rightBtnPressBgColor)
							}
						})
						.onClick(() => {
							this.onRightButtonClick()
						})
				}
			}
			.height(getSizeByUnit(this.contentHeight))
		}
		.width(CONTAINER_SIZE.FULL)
		.padding({ left: this.baseStyle.spaceSm, right: this.customRightButton || this.showRightButton ? 0 : this.baseStyle.spaceSm, top: convertDimensionsWidthUnit(10), bottom: convertDimensionsWidthUnit(10) })
		.backgroundColor(this.outBgColor)
		.enabled(!this.disabled)
	}
}