import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
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
	 * 输入框绑定值
	 */
	@Link value: string
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
	@Prop contentHeight: number = 108
	/**
	 * 外侧背景色
	 */
	@Prop outBgColor: ResourceColor = this.baseStyle.default as string
	/**
	 * 内侧背景色
	 */
	@Prop innerBgColor: ResourceColor = GRAY_COLOR.GRAY_1
	/**
	 * 是否为圆形搜索框
	 */
	@Prop isRound: boolean = false
	/**
	 * 圆角大小
	 */
	@Prop radius: number = 0
	/**
	 * 左侧图标
	 */
	@Prop leftIcon: string | Resource = $r("app.media.icon_search")
	/**
	 * 左侧图标颜色
	 */
	@Prop leftIconColor: ResourceColor = GRAY_COLOR.GRAY_6
	/**
	 * 是否可清除
	 */
	@Prop clearable: boolean = true
	/**
	 * 清除图片地址
	 */
	@Prop clearIcon: string | Resource = $r("app.media.icon_clear")
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

	build() {
		Row(){
			Row(){
				if(this.label){
					Text(this.label)
						.fontSize(this.baseStyle.fontSizeMd)
						.fontColor(GRAY_COLOR.GRAY_8)
						.margin({ right: this.baseStyle.spaceBase })
				}
				Image(this.leftIcon)
					.width("36lpx")
					.margin({ right: this.baseStyle.spaceBase })
					.fillColor(this.leftIconColor)
				TextInput({ text: $$this.value, placeholder: this.placeholder })
					.layoutWeight(1)
					.padding(0)
					.borderRadius(0)
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
						Image(this.clearIcon)
							.width("36lpx")
							.fillColor(GRAY_COLOR.GRAY_5)
					}
					.padding({ left: this.baseStyle.spaceXs, right: this.baseStyle.spaceXs })
					.visibility(this.value && (this.clearTrigger == "always" || this.isFocus) ? Visibility.Visible : Visibility.None)
					.onClick(() => {
						this.clearLock = true
						this.value = ""
						this.onClear()
						setTimeout(() => {
							this.clearLock = false
						}, 10)
					})
				}
			}
			.layoutWeight(1)
			.height(CONTAINER_SIZE.FULL)
			.backgroundColor(this.innerBgColor)
			.borderRadius(this.radius ? `${this.radius}lpx` : this.isRound ? 999999 : 0)
			.padding({ left:  this.baseStyle.spaceSm })
			.alignItems(VerticalAlign.Center)
			if(this.customRightButton){
				this.customRightButton()
			}else if(this.showRightButton){
				Text(this.rightButtonText)
					.width("88lpx")
					.height(CONTAINER_SIZE.FULL)
					.fontSize(this.baseStyle.fontSizeMd)
					.padding({ left: this.baseStyle.spaceXs, right: this.baseStyle.spaceXs })
					.stateStyles({
						normal: {
							.backgroundColor(this.baseStyle.default)
						},
						pressed: {
							.backgroundColor(GRAY_COLOR.GRAY_2)
						}
					})
					.onClick(() => {
						this.onRightButtonClick()
					})
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.height(`${this.contentHeight}lpx`)
		.padding({ left: this.baseStyle.spaceSm, right: this.customRightButton || this.showRightButton ? 0 : this.baseStyle.spaceSm, top: "20lpx", bottom: "20lpx" })
		.backgroundColor(this.outBgColor)
		.enabled(!this.disabled)
	}
}