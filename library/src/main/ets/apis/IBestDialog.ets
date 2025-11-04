import { ComponentContent, ImmersiveMode, LengthMetrics, LevelMode, PromptAction } from '@kit.ArkUI'
import { generateId, handleBeforeFunction } from '../utils/utils'
import { IBestDialogView } from '../components/dialog/dialog'
import { IBestAwaitable, IBestStringNumber } from '../model/Global.type'
import GlobalStore from '../utils/globalStore'
class IBestDialogOption {
	/**
	 * 弹窗宽度
	 */
	dialogWidth?: IBestStringNumber
	/**
	 * 弹窗border-radius
	 */
	dialogBorderRadius?: Length | BorderRadiuses | LocalizedBorderRadiuses
	/**
	 * 背景图片
	 * @since 2.0.8
	 */
	bgColor?: ResourceColor
	/**
	 * 背景图片
	 * @since 2.0.7
	 */
	bgImage?: ResourceStr
	/**
	 * 标题
	 */
	title?: ResourceStr
	/**
	 * 标题的fontSize
	 */
	titleFontSize?: IBestStringNumber
	/**
	 * 标题颜色
	 */
	titleColor?: ResourceColor
	/**
	 * 标题的padding-top值
	 */
	titlePaddingTop?: IBestStringNumber
	/**
	 * 标题的padding-left与padding-right值
	 */
	titlePaddingX?: IBestStringNumber
	/**
	 * 标题的padding-top值
	 */
	titleLineHeight?: IBestStringNumber
	/**
	 * 标题的对齐方式
	 */
	titleTextAlign?: 'left' | 'center' | 'right'
	/**
	 * 文本内容，支持通过 \n 换行
	 */
	message?: ResourceStr
	/**
	 * 内容区域的padding-left与padding-right值
	 */
	messagePaddingX?: IBestStringNumber
	/**
	 * 内容区域的padding-top值
	 */
	messagePaddingTop?: IBestStringNumber
	/**
	 * 内容区域的padding-bottom值
	 */
	messagePaddingBottom?: IBestStringNumber
	/**
	 * 内容区域的fontColor
	 */
	messageFontColor?: ResourceColor
	/**
	 * 内容区域的fontSize
	 */
	messageFontSize?: IBestStringNumber
	/**
	 * 内容区域的行高 lineHeight
	 */
	messageLineHeight?: IBestStringNumber
	/**
	 * 内容区域的文字对齐方式
	 */
	messageTextAlign?: 'left' | 'center' | 'right'
	/**
	 * 内容区域的滚动区域最大高度
	 */
	messageMaxHeight?: IBestStringNumber
	/**
	 * 样式风格
	 */
	theme?: 'default' | 'round-button'
	/**
	 * 按钮间距
	 */
	buttonSpace?: IBestStringNumber
	/**
	 * 是否展示确认按钮
	 */
	showConfirmButton?: boolean
	/**
	 * 是否展示取消按钮
	 */
	showCancelButton?: boolean
	/**
	 * 确认按钮文案
	 */
	confirmButtonText?: ResourceStr
	/**
	 * 取消按钮的文案
	 */
	cancelButtonText?: ResourceStr
	/**
	 * 按钮的文字大小
	 */
	buttonFontSize?: IBestStringNumber
	/**
	 * 确认按钮的颜色
	 */
	confirmButtonColor?: ResourceColor
	/**
	 * 确认按钮字重
	 * @since 2.0.9
	 */
	confirmButtonFontWeight?: FontWeight
	/**
	 * 确认按钮的背景颜色
	 * @since 1.16.0
	 */
	confirmButtonBgColor?: ResourceColor
	/**
	 * 取消按钮的颜色
	 */
	cancelButtonColor?: ResourceColor
	/**
	 * 取消按钮的背景颜色
	 * @since 1.16.0
	 */
	cancelButtonBgColor?: ResourceColor
	/**
	 * 取消按钮的loading
	 */
	cancelButtonLoading?: boolean
	/**
	 * 确认按钮的loading
	 */
	confirmButtonLoading?: boolean
	/**
	 * 弹窗是否为模态窗口，模态窗口有蒙层，非模态窗口无蒙层
	 */
	showOverlay?: boolean
	/**
	 * 自定义蒙层颜色。默认值: 0x33000000
	 */
	overlayColor?: ResourceColor
	/**
	 * 某弹框需要显示在主窗口之外时，是否在子窗口显示此弹窗
	 */
	showInSubWindow?: boolean
	/**
	 * 是否在点击遮罩层后关闭弹窗
	 */
	closeOnClickOverlay?: boolean
	/**
	 * 是否允许返回键关闭
	 */
	closeOnBackPress?: boolean
	/**
	 * 弹窗在竖直方向上的对齐方式 默认center
	 */
	alignment?: 'center' | 'top' | 'bottom'
	/**
	 * 弹窗相对alignment所在位置的横向偏移量
	 */
	offsetX?: IBestStringNumber
	/**
	 * 弹窗相对alignment所在位置的纵向偏移量。
	 */
	offsetY?: IBestStringNumber
	/**
	 * 设置弹窗是否在拉起软键盘时进行自动避让
	 * @since 2.1.0
	 */
	keyboardAvoidMode?: KeyboardAvoidMode
	/**
	 * 弹窗避让键盘后，和键盘之间的距离
	 * @since 2.0.8
     */
	keyboardAvoidDistance?: LengthMetrics
	/**
	 * 弹窗显示层级
	 * @since 2.0.8
	 */
	levelMode?: LevelMode
	/**
	 * 页面级弹窗需要显示的层级下的节点 uniqueId, 仅当levelMode属性设置为LevelMode.EMBEDDED时生效
	 * @since 2.0.8
	 */
	levelUniqueId?: number
	/**
	 * 标题区域的builder
	 */
	titleBuilder?: CustomBuilder
	/**
	 * 内容区域的builder
	 */
	defaultBuilder?: CustomBuilder
	/**
	 * 底部区域的builder
	 */
	footerBuilder?: CustomBuilder
	/**
	 * 关闭前的回调函数，返回 false 可阻止关闭，支持返回 Promise
	 */
	beforeClose?: (action: 'cancel' | 'confirm') => IBestAwaitable
	/**
	 * 点击取消的回调
	 */
	onCancel?: () => void
	/**
	 * 点击确认的的回调
	 */
	onConfirm?: () => void
	/**
	 * 弹框打开回调
	 * @since 1.16.0
	 */
	onOpen?: () => void = () => {}
	/**
	 * 弹框关闭回调
	 * @since 1.16.0
	 */
	onClose?: () => void = () => {}
}

class IBestDialogParams extends IBestDialogOption {
	id: string = ""
	contentNode?: ComponentContent<IBestDialogParams>
	close: (id: string) => void = () => {}
	constructor(option: IBestDialogOption) {
		super()
		this.dialogWidth = option.dialogWidth
		this.dialogBorderRadius = option.dialogBorderRadius
		this.bgColor = option.bgColor
		this.bgImage = option.bgImage
		this.title = option.title
		this.titleColor = option.titleColor
		this.titlePaddingTop = option.titlePaddingTop
		this.titlePaddingX = option.titlePaddingX
		this.titleLineHeight = option.titleLineHeight
		this.titleFontSize = option.titleFontSize
		this.titleTextAlign = option.titleTextAlign
		this.message = option.message
		this.messagePaddingX = option.messagePaddingX
		this.messagePaddingTop = option.messagePaddingTop
		this.messagePaddingBottom = option.messagePaddingBottom
		this.messageFontColor = option.messageFontColor
		this.messageFontSize = option.messageFontSize
		this.messageLineHeight = option.messageLineHeight
		this.messageTextAlign = option.messageTextAlign
		this.messageMaxHeight = option.messageMaxHeight
		this.theme = option.theme
		this.buttonSpace = option.buttonSpace
		this.showConfirmButton = option.showConfirmButton ?? true
		this.showCancelButton = option.showCancelButton
		this.confirmButtonText = option.confirmButtonText
		this.cancelButtonText = option.cancelButtonText
		this.buttonFontSize = option.buttonFontSize
		this.confirmButtonColor = option.confirmButtonColor
		this.confirmButtonFontWeight = option.confirmButtonFontWeight
		this.confirmButtonBgColor = option.confirmButtonBgColor
		this.cancelButtonColor = option.cancelButtonColor
		this.cancelButtonBgColor = option.cancelButtonBgColor
		this.confirmButtonLoading = option.confirmButtonLoading
		this.cancelButtonLoading = option.cancelButtonLoading
		this.closeOnClickOverlay = option.closeOnClickOverlay
		this.titleBuilder = option.titleBuilder
		this.defaultBuilder = option.defaultBuilder
		this.footerBuilder = option.footerBuilder
		this.beforeClose = option.beforeClose
		this.onCancel = option.onCancel
		this.onConfirm = option.onConfirm
	}
}

@Component
struct DialogContent{
	@Prop option: IBestDialogParams
	async handleBtnClick(action: 'cancel' | 'confirm') {
		if (this.option.beforeClose) {
			action == 'cancel' ? this.option.cancelButtonLoading = true : this.option.confirmButtonLoading = true
			this.option.contentNode?.update(this.option)
			let status = await handleBeforeFunction(this.option.beforeClose, action)
			action == 'cancel' ? this.option.cancelButtonLoading = false : this.option.confirmButtonLoading = false
			this.option.contentNode?.update(this.option)
			if (!status) {
				return
			}
		}
		this.option.close(this.option.id)
		if(action == 'confirm' && this.option.onConfirm){
			this.option.onConfirm()
		}
		if(action == 'cancel' && this.option.onCancel){
			this.option.onCancel()
		}
	}
	build() {
		IBestDialogView({
			dialogWidth: this.option.dialogWidth,
			dialogBorderRadius: this.option.dialogBorderRadius,
			bgImage: this.option.bgImage,
			bgColor: this.option.bgColor,
			title: this.option.title,
			titleFontSize: this.option.titleFontSize,
			titleColor: this.option.titleColor,
			titlePaddingTop: this.option.titlePaddingTop,
			titlePaddingX: this.option.titlePaddingX,
			titleLineHeight: this.option.titleLineHeight,
			titleTextAlign: this.option.titleTextAlign,
			message: this.option.message,
			messageFontColor: this.option.messageFontColor,
			messageFontSize: this.option.messageFontSize,
			messagePaddingX: this.option.messagePaddingX,
			messagePaddingTop: this.option.messagePaddingTop,
			messagePaddingBottom: this.option.messagePaddingBottom,
			messageLineHeight: this.option.messageLineHeight,
			messageTextAlign: this.option.messageTextAlign,
			messageMaxHeight: this.option.messageMaxHeight,
			theme: this.option.theme,
			buttonSpace: this.option.buttonSpace,
			showConfirmButton: this.option.showConfirmButton,
			showCancelButton: this.option.showCancelButton,
			confirmButtonText: this.option.confirmButtonText,
			cancelButtonText: this.option.cancelButtonText,
			buttonFontSize: this.option.buttonFontSize,
			confirmButtonColor: this.option.confirmButtonColor,
			confirmButtonFontWeight: this.option.confirmButtonFontWeight,
			confirmButtonBgColor: this.option.confirmButtonBgColor,
			cancelButtonColor: this.option.cancelButtonColor,
			cancelButtonBgColor: this.option.cancelButtonBgColor,
			confirmButtonLoading: this.option.confirmButtonLoading,
			cancelButtonLoading: this.option.cancelButtonLoading,
			titleBuilder: this.option.titleBuilder,
			defaultBuilder: this.option.defaultBuilder,
			footerBuilder: this.option.footerBuilder,
			onCancel: () => {
				this.handleBtnClick('cancel')
			},
			onConfirm: () => {
				this.handleBtnClick('confirm')
			},
			onClickOverlay: () => {
				if(this.option.closeOnClickOverlay){
					this.handleBtnClick('cancel')
				}
			}
		})
	}
}
/**
 * 默认内容 Builder
 */
@Builder function defaultContentBuilder(option: IBestDialogParams) {
	DialogContent({option})
}

interface DialogMapValue{
	key: string
	contentNode: ComponentContent<IBestDialogParams>
	promptAction: PromptAction
	params: IBestDialogParams
}
function getAlignment(type: string) {
	switch (type) {
		case 'top':
			return DialogAlignment.Top
		case 'bottom':
			return DialogAlignment.Bottom
		default:
			return DialogAlignment.Center
	}
}
/**
 * 弹窗管理器
 */
class Dialog{
	private contentNodeArr: DialogMapValue[] = []
	/**
	 * 打开弹框
	 */
	public async open(option: IBestDialogOption): Promise<string> {
		let key = this.getUniKey()
		let windowClass = GlobalStore.getMainWindow()
		let uiContext = windowClass.getUIContext()
		let promptAction = uiContext.getPromptAction()
		let params = new IBestDialogParams(option)
		params.id = key
		params.close = (id: string): void => this.close(id)
		let contentNode = new ComponentContent(uiContext, wrapBuilder(defaultContentBuilder), params)
		params.contentNode = contentNode
		this.contentNodeArr.push({
			key,
			contentNode,
			promptAction,
			params
		})
		await promptAction.openCustomDialog(contentNode, {
			alignment: getAlignment(option.alignment),
			offset: {
				dx: option.offsetX,
				dy: option.offsetY
			},
			isModal: option.showOverlay ?? true,
			maskColor: option.overlayColor,
			showInSubWindow: option.showInSubWindow,
			keyboardAvoidMode: option.keyboardAvoidMode ?? KeyboardAvoidMode.DEFAULT,
			keyboardAvoidDistance: option.keyboardAvoidDistance ?? LengthMetrics.vp(16),
			levelMode: option.levelMode ?? 0,
			levelUniqueId: option.levelUniqueId,
			immersiveMode: ImmersiveMode.EXTEND,
			onDidAppear: () => {
				option.onOpen?.()
			},
			onDidDisappear: () => {
				option.onClose?.()
			},
			onWillDismiss: async (dismissDialogAction: DismissDialogAction) => {
				// 1 点击遮罩返回  0 物理返回(左滑右滑、返回键)
				let reason = dismissDialogAction.reason
				if (reason == DismissReason.PRESS_BACK && !(option.closeOnBackPress ?? true) || reason == DismissReason.TOUCH_OUTSIDE && !option.closeOnClickOverlay) {
					return
				}
				let status = await handleBeforeFunction(params.beforeClose, "cancel")
				if (!status) {
					return
				}
				this.close(key)
			}
		})
		return key
	}
	/**
	 * 关闭弹框
	 */
	public close(id?: string){
		let key = id || this.getLastKey()
		if(this.contentNodeArr.some(e => e.key == key)){
			let index = this.contentNodeArr.findIndex(e => e.key == key)
			let dialog = this.contentNodeArr[index]
			dialog.promptAction.closeCustomDialog(dialog.contentNode).then(() => {
				dialog.contentNode.dispose()
				this.contentNodeArr.splice(index, 1)
			})
		}
	}
	private getUniKey(): string{
		let key = generateId()
		if(this.contentNodeArr.some(e => e.key == key)){
			return this.getUniKey()
		}
		return key
	}
	private getLastKey(): string{
		return this.contentNodeArr[this.contentNodeArr.length - 1].key
	}
}

export default new Dialog()