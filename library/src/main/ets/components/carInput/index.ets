import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { CarKeyboard } from '../carKeyboard';
import { IBestCarInputModel, IBestCarKeyboardConfig, IBestInputHighlightType } from './index.type';
import { FocusController } from '@ohos.arkui.UIContext';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
import { IBestCarInputColor } from './color';
import { IBestStringNumber } from '../../model/Global.type';

@Extend(TextInput) function ibestCarInputStyle(){
	.width(CONTAINER_SIZE.FULL)
	.height(CONTAINER_SIZE.FULL)
	.copyOption(CopyOptions.None)
	.selectionMenuHidden(true)
	.enableAutoFill(false)
	.opacity(0)
}

@Component
export struct IBestCarInput {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 值
	 */
	@Link @Watch("formatInputList") value: string
	/**
	 * 自动聚焦
     */
	@Prop autoFocus: boolean = false
	/**
	 * 是否显示闪烁光标
	 */
	@Provide({allowOverride: "showCursor"}) showCursor: boolean = true
	/**
	 * 光标位置
     */
	@Provide({allowOverride: "cursorPosition"}) cursorPosition: 'center' | 'bottom' = 'center'
	/**
	 * 光标颜色
     */
	@Provide({allowOverride: "cursorColor"}) cursorColor: ResourceColor = ''
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
	 * 高亮类型
	 */
	@Provide({allowOverride: "highlightType"}) highlightType: IBestInputHighlightType = "border"
	/**
	 * 高亮颜色
	 */
	@Provide({allowOverride: "highlightColor"}) highlightColor: ResourceColor = this.baseStyle.primary
	/**
	 * 键盘配置
	 */
	@Prop keyboardConfig: IBestCarKeyboardConfig
	/**
	 * 是否显示边框线
	 */
	@Provide({allowOverride: "isShowBorder"}) isShowBorder: boolean = true
	/**
	 * 边框线颜色
	 */
	@Provide({allowOverride: "bdColor"}) bdColor: ResourceColor = IBestCarInputColor.borderColor
	/**
	 * 背景色
	 */
	@Provide({allowOverride: "bgColor"}) bgColor: ResourceColor = IBestCarInputColor.bg
	/**
	 * 文字颜色
	 */
	@Provide({allowOverride: "cellTextColor"}) textColor: ResourceColor = IBestCarInputColor.textColor
	/**
	 * 文字大小
	 */
	@Provide({allowOverride: "textFontSize"}) fontSize: IBestStringNumber = this.baseStyle.fontSizeXl as string
	/**
	 * 完成
	 */
	onConfirm: (value: string) => void = () => {}

	@State uniId: number = 0
	// 最大长度
	@Provide maxLength: number = 8
	// 输入框列表
	@State inputList: IBestCarInputModel[] = []
	// 当前聚焦的输入框下标
	@State currentFocusIndex: number = 0
	// 输入框是否聚焦
	@State focused: boolean = false
	private textInputController: TextInputController = new TextInputController()
	private focusController: FocusController = this.getUIContext().getFocusController()
	@Builder carKeyboardBuilder(){
		CarKeyboard({
			value: $value,
			maxLength: this.maxLength,
			title: this.keyboardConfig?.title,
			confirmBtnText: this.keyboardConfig?.confirmBtnText,
			keyHeight: this.keyboardConfig?.keyHeight,
			onClose: () => {
				this.stopEdit()
			},
			onConfirm: () => {
				this.onConfirm(this.value)
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
		if(value.length > this.maxLength){
			this.value = value.slice(0, this.maxLength)
		}else{
			this.inputList = Array(this.maxLength).fill("").map((_: string, index: number) => new IBestCarInputModel(value[index] || ""))
			this.currentFocusIndex = value.length
		}
	}
	// 输入框结束编辑
	stopEdit(){
		this.textInputController.stopEditing()
	}
	build() {
		Column({ space: this.baseStyle.spaceMd as string }){
			Stack(){
				TextInput({ text: $$this.value, controller: this.textInputController })
					.defaultFocus(this.autoFocus)
					.maxLength(this.maxLength)
					.id(`ibest_passwordInput_${this.uniId}`)
					.ibestCarInputStyle()
					.customKeyboard(this.carKeyboardBuilder, { supportAvoidance: true })
					.onFocus(() => {
						this.focused = true
					})
					.onBlur(() => {
						this.focused = false
						this.stopEdit()
					})
				Row({ space: getSizeByUnit(this.space) }){
					ForEach(this.inputList, (item: IBestCarInputModel, index: number) => {
						InputField({
							item: item,
							index: index,
							focused: this.focused,
							currentFocusIndex: this.currentFocusIndex
						})
					}, (item: IBestCarInputModel) => item.id)
				}
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
				.border({ width: this.isShowBorder && this.space == 0 ? 1 : 0, color: this.bdColor })
				.justifyContent(FlexAlign.SpaceBetween)
				.onClick(() => {
					this.focusController.requestFocus(`ibest_passwordInput_${this.uniId}`)
				})
			}
			.width(CONTAINER_SIZE.FULL)
			.height(getSizeByUnit(this.inputHeight))
		}
		.width(CONTAINER_SIZE.FULL)
		.padding(convertDimensionsWidthUnit(5))
	}
}

@Component
struct InputField {
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@Consume maxLength: number
	@Consume space: IBestStringNumber
	@Consume radius: IBestStringNumber
	@Consume isHighlightCurrent: boolean
	@Consume highlightType: IBestInputHighlightType
	@Consume highlightColor: ResourceColor
	@Consume isShowBorder: boolean
	@Consume bdColor: ResourceColor
	@Consume bgColor: ResourceColor
	@Consume textColor: ResourceColor
	@Consume fontSize: IBestStringNumber
	@Consume showCursor: boolean
	@Consume cursorPosition: 'center' | 'bottom'
	@Consume cursorColor: ResourceColor
	@Prop item: IBestCarInputModel
	@Prop index: number = 0
	@Prop focused: boolean
	@Prop currentFocusIndex: number
	// 光标透明度
	@State cursorOpacity: number = 0
	// 光标闪烁时长
	@State cursorBlinkDuration: number = 500
	private uiContext = this.getUIContext()
	// 当前输入框是否聚焦
	getIsFocus(){
		return this.isHighlightCurrent && this.focused && this.space && this.currentFocusIndex == this.index
	}
	// 光标闪烁
	cursorBlink(){
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
			Text("新能源")
				.fontSize(this.baseStyle.fontSizeXs)
				.fontColor(this.baseStyle.success)
				.visibility(this.index == this.maxLength - 1 && !this.item.value ? Visibility.Visible : Visibility.None)
			Text(this.item.value)
				.fontSize(getSizeByUnit(this.fontSize, true))
				.fontColor(this.textColor)
				.visibility(this.item.value ? Visibility.Visible : Visibility.None)
			if(this.showCursor && this.focused && this.currentFocusIndex == this.index){
				Divider()
					.strokeWidth(2)
					.width(this.cursorPosition == 'bottom' ? '50%' : '')
					.height(this.cursorPosition == 'center' ? '50%' : '')
					.vertical(this.cursorPosition == 'center')
					.position(this.cursorPosition == 'bottom' ? { left: '25%', bottom: 10 } : { x: '50%', y: '25%' })
					.color(this.cursorColor || this.textColor)
					.opacity(this.cursorOpacity)
					.onAppear(() => {
						this.cursorBlink()
					})
			}
		}
		.layoutWeight(1)
		.height(CONTAINER_SIZE.FULL)
		.justifyContent(FlexAlign.Center)
		.backgroundColor(this.bgColor)
		.border(this.space ? {
			width: this.isShowBorder ? 1 : 0,
			color: this.getIsFocus() ? this.highlightType == 'border' ? this.highlightColor : '' : this.bdColor
		} : {
			width: { left: this.index > 0 && this.isShowBorder ? 1 : 0 },
			color: this.bdColor
		})
		.borderRadius(this.space ? getSizeByUnit(this.radius) : 0)
		.shadow({
			radius: this.highlightType == 'shadow' && this.getIsFocus() ? 20 : 0,
			color: this.highlightColor
		})
	}
}