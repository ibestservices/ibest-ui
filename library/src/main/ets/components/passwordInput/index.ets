import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { NumberKeyboard } from '../numberKeyboard';
import { IBestPasswordInputModel, NumberKeyboardConfig } from './index.type';
import { FocusController } from '@ohos.arkui.UIContext';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
import { IBestPasInputColor } from './color';
import { IBestStringNumber } from '../../model/Global.type';

@Extend(TextInput) function ibestPasswordInputStyle(id: number, inputLength: number){
	.width(CONTAINER_SIZE.FULL)
	.height(CONTAINER_SIZE.FULL)
	.maxLength(inputLength)
	.copyOption(CopyOptions.None)
	.selectionMenuHidden(true)
	.enableAutoFill(false)
	.opacity(0)
	.id(`ibest_passwordInput_${id}`)
}

@Component
export struct IBestPasswordInput {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 唯一id
	 */
	@State uniId: number = 0
	/**
	 * 值
	 */
	@Link @Watch("formatInputList") value: string
	/**
	 * 长度
	 */
	@Prop inputLength: number = 6
	/**
	 * 输入框列表
	 */
	@State inputList: IBestPasswordInputModel[] = []
	/**
	 * 当前聚焦的输入框下标
	 */
	@State currentFocusIndex: number = 0
	/**
	 * 输入框是否聚焦
	 */
	@State focused: boolean = false
	/**
	 * 输入框高度
	 */
	@Prop inputHeight: IBestStringNumber = convertDimensionsWidthUnit(50)
	/**
	 * 格子间距
	 */
	@Provide({allowOverride: "space"}) space: IBestStringNumber = 0
	/**
	 * 圆角, 仅有间距时有效
	 */
	@Provide({allowOverride: "radius"}) radius: IBestStringNumber = convertDimensionsWidthUnit(5)
	/**
	 * 是否高亮当前正在输入的格子
	 */
	@Provide({allowOverride: "isHighlightCurrent"}) isHighlightCurrent: boolean = true
	/**
	 * 高亮颜色
	 */
	@Provide({allowOverride: "highlightColor"}) highlightColor: ResourceColor = this.baseStyle.primary
	/**
	 * 是否隐藏内容
	 */
	@Provide({allowOverride: "isHidden"}) isHidden: boolean = true
	/**
	 * 提示文字
	 */
	@Prop tip: string = ""
	/**
	 * 错误提示
	 */
	@Prop errorTip: string = ""
	/**
	 * 是否使用系统键盘
	 */
	@Prop useSystemKeyboard: boolean = false
	/**
	 * 自定义键盘配置
	 */
	@Prop numberKeyboardConfig: NumberKeyboardConfig
	/**
	 * 是否显示边框线
	 * @since 1.19.0
     */
	@Provide({allowOverride: "isShowBorder"}) isShowBorder: boolean = true
	/**
	 * 边框线颜色
	 * @since 1.19.0
     */
	@Provide({allowOverride: "bdColor"}) bdColor: ResourceColor = IBestPasInputColor.borderColor
	/**
	 * 格子背景色
	 * @since 1.19.0
     */
	@Provide({allowOverride: "cellBgColor"}) cellBgColor: ResourceColor = IBestPasInputColor.bg
	/**
	 * 格子内文字颜色
	 * @since 1.19.0
     */
	@Provide({allowOverride: "cellTextColor"}) cellTextColor: ResourceColor = IBestPasInputColor.textColor
	/**
	 * 黑点大小
	 * @since 1.19.0
     */
	@Provide({allowOverride: "dotFontSize"}) dotFontSize: IBestStringNumber = convertDimensionsWidthUnit(40)
	/**
	 * 明文展示时文字大小
	 * @since 1.19.0
     */
	@Provide({allowOverride: "textFontSize"}) textFontSize: IBestStringNumber = this.baseStyle.fontSizeXl as string
	/**
	 * 提示文字大小
	 * @since 1.19.0
	 */
	@Prop tipFontSize: IBestStringNumber = this.baseStyle.fontSizeLg as string
	/**
	 * 区域点击
	 */
	onFieldClick: () => void = () => {}
	/**
	 * 输入完成
	 * @since 2.0.8
     */
	onFinish: () => void = () => {}

	private textInputController: TextInputController = new TextInputController()
	private focusController: FocusController = this.getUIContext().getFocusController()
	@Builder numberKeyboardBuilder(){
		NumberKeyboard({
			value: $value,
			title: this.numberKeyboardConfig?.title,
			extraKey: this.numberKeyboardConfig?.extraKey,
			closeBtnText: this.numberKeyboardConfig?.closeBtnText,
			deleteButtonText: this.numberKeyboardConfig?.deleteButtonText,
			styleType: this.numberKeyboardConfig?.styleType,
			isRandomKeyOrder: this.numberKeyboardConfig?.isRandomKeyOrder,
			maxLength: this.inputLength,
			onClose: () => {
				this.stopEdit()
			}
		})
	}

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		this.formatInputList()
	}
	// 格式化inputList
	formatInputList(){
		let value = this.value
		if(/\s/g.test(value)){
			this.value = value.replace(/\s/g, "")
		}else if(value.length > this.inputLength){
			this.value = value.slice(0, this.inputLength)
		}else{
			this.inputList = Array(this.inputLength).fill("").map((_: string, index: number) => new IBestPasswordInputModel(value[index] || ""))
			this.currentFocusIndex = value.length
		}
		if(this.value.length == this.inputLength){
			this.onFinish()
		}
	}
	// 输入框结束编辑
	stopEdit(){
		this.textInputController.stopEditing()
	}
	build() {
		Column({ space: this.baseStyle.spaceMd as string }){
			Stack(){
				if(this.useSystemKeyboard){
					TextInput({ text: $$this.value, controller: this.textInputController })
						.ibestPasswordInputStyle(this.uniId, this.inputLength)
						.onFocus(() => {
							this.focused = true
						})
						.onBlur(() => {
							this.focused = false
						})
				}else{
					TextInput({ text: $$this.value, controller: this.textInputController })
						.ibestPasswordInputStyle(this.uniId, this.inputLength)
						.customKeyboard(this.numberKeyboardBuilder, { supportAvoidance: true })
						.onFocus(() => {
							this.focused = true
						})
						.onBlur(() => {
							this.focused = false
							this.stopEdit()
						})
				}
				Row({ space: getSizeByUnit(this.space) }){
					ForEach(this.inputList, (item: IBestPasswordInputModel, index: number) => {
						InputField({
							item: item,
							index: index,
							focused: this.focused,
							currentFocusIndex: this.currentFocusIndex
						})
					}, (item: IBestPasswordInputModel) => item.id)
				}
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
				.border({ width: this.isShowBorder && this.space == 0 ? 1 : 0, color: this.bdColor })
				.justifyContent(FlexAlign.SpaceBetween)
				.onClick(() => {
					this.onFieldClick()
					this.focusController.requestFocus(`ibest_passwordInput_${this.uniId}`)
				})
			}
			.width(CONTAINER_SIZE.FULL)
			.height(getSizeByUnit(this.inputHeight))
			// 提示信息
			if(this.tip || this.errorTip){
				Text(this.value.length == this.inputLength && this.errorTip ? this.errorTip : this.tip)
					.width(CONTAINER_SIZE.FULL)
					.textAlign(TextAlign.Center)
					.fontSize(getSizeByUnit(this.tipFontSize, true))
					.fontColor(this.value.length == this.inputLength && this.errorTip ? this.baseStyle.danger : GRAY_COLOR.GRAY_6)
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.padding(convertDimensionsWidthUnit(5))
	}
}

@Component
struct InputField {
	@Consume isHidden: boolean
	@Consume space: number
	@Consume radius: number
	@Consume isHighlightCurrent: boolean
	@Consume highlightColor: ResourceColor
	@Consume isShowBorder: boolean
	@Consume bdColor: ResourceColor
	@Consume cellBgColor: ResourceColor
	@Consume cellTextColor: ResourceColor
	@Consume dotFontSize: IBestStringNumber
	@Consume textFontSize: IBestStringNumber
	@Prop focused: boolean
	@Prop currentFocusIndex: number
	@Prop index: number = 0
	@Prop item: IBestPasswordInputModel
	// 光标透明度
	@State cursorOpacity: number = 0
	// 光标闪烁时长
	@State cursorBlinkDuration: number = 500
	private uiContext = this.getUIContext()
	// 光标闪烁
	cursorBlink(): void{
		this.uiContext.keyframeAnimateTo({ iterations: -1 }, [
			{
				duration: this.cursorBlinkDuration,
				event: () => {
					this.cursorOpacity = 1
				}
			},
			{
				duration: this.cursorBlinkDuration,
				event: () => {
					this.cursorOpacity = 0
				}
			}
		])
	}
	build() {
		Row(){
			Text(this.isHidden ? "•" : this.item.value)
				.fontSize(getSizeByUnit(this.isHidden ? this.dotFontSize : this.textFontSize, true))
				.fontColor(this.cellTextColor)
				.visibility(this.item.value ? Visibility.Visible : Visibility.None)
			if(this.focused && this.currentFocusIndex == this.index){
				Divider()
					.strokeWidth(1)
					.height("50%")
					.vertical(true)
					.color(this.cellTextColor)
					.opacity(this.cursorOpacity)
					.onAppear(() => {
						this.cursorBlink()
					})
			}
		}
		.layoutWeight(1)
		.height(CONTAINER_SIZE.FULL)
		.justifyContent(FlexAlign.Center)
		.backgroundColor(this.cellBgColor)
		.border(this.space ? {
			width: this.isShowBorder ? 1 : 0,
			color: this.bdColor
		} : {
			width: { left: this.index > 0 && this.isShowBorder ? 1 : 0 },
			color: this.bdColor
		})
		.borderRadius(this.space ? getSizeByUnit(this.radius) : 0)
		.shadow({
			radius: this.isHighlightCurrent && this.focused && this.space && this.currentFocusIndex == this.index ? 20 : 0,
			color: this.highlightColor,
			type: ShadowType.COLOR
		})
	}
}