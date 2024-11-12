import { ComponentContent, PromptAction, window } from '@kit.ArkUI'
import { generateId } from '../assets/ets/utils'
import { IBestDialogView } from '../components/dialog/dialog'
import { GRAY_COLOR } from '../theme-chalk/src/color.type'
class IBestDialogOption {
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
	 * 弹窗宽度
	 */
	dialogWidth?: string
	/**
	 * 弹窗border-radius 默认 32lpx
	 */
	dialogBorderRadius?: string
	/**
	 * 标题
	 */
	title?: string
	/**
	 * 标题颜色
	 */
	titleColor?: ResourceColor
	/**
	 * 标题的padding-top值
	 */
	titlePaddingTop?: string
	/**
	 * 标题的padding-left与padding-right值 默认48lpx
	 */
	titlePaddingX?: string
	/**
	 * 标题的padding-top值
	 */
	titleLineHeight?: string
	/**
	 * 标题的fontSize
	 */
	titleFontSize?: string
	/**
	 * 标题的对齐方式
	 */
	titleTextAlign?: 'left' | 'center' | 'right'
	/**
	 * 文本内容，支持通过 \n 换行
	 */
	message?: string
	/**
	 * 内容区域的padding-left与padding-right值 默认48lpx
	 */
	messagePaddingX?: string
	/**
	 * 内容区域的padding-top值 默认16lpx
	 */
	messagePaddingTop?: string
	/**
	 * 内容区域的padding-bottom值 默认52lpx
	 */
	messagePaddingBottom?: string
	/**
	 * 内容区域的fontColor 默认#323233
	 */
	messageFontColor?: string
	/**
	 * 内容区域的fontSize
	 */
	messageFontSize?: string
	/**
	 * 内容区域的行高 lineHeight 默认 40lpx
	 */
	messageLineHeight?: string
	/**
	 * 内容区域的文字对齐方式
	 */
	messageTextAlign?: 'left' | 'center' | 'right'
	/**
	 * 内容区域的滚动区域最大高度
	 */
	messageMaxHeight?: string
	/**
	 * 样式风格
	 */
	theme?: 'default' | 'round-button'
	/**
	 * 按钮间距 单位lpx
	 */
	buttonSpace?: number
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
	confirmButtonText?: string
	/**
	 * 取消按钮的文案
	 */
	cancelButtonText?: string
	/**
	 * 确认按钮的颜色
	 */
	confirmButtonColor?: ResourceColor
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
	 * 按钮的文字大小
	 */
	buttonFontSize?: string
	/**
	 * 取消按钮的loading
	 */
	cancelButtonLoading?: boolean
	/**
	 * 确认按钮的loading
	 */
	confirmButtonLoading?: boolean
	/**
	 * 弹窗是否为模态窗口，模态窗口有蒙层，非模态窗口无蒙层。
	 * API11+
	 */
	showOverlay?: boolean = true;
	/**
	 * 某弹框需要显示在主窗口之外时，是否在子窗口显示此弹窗。
	 * 默认值：false，弹窗显示在应用内，而非独立子窗口。
	 * API 10 +
	 */
	showInSubWindow?: boolean = false;
	/**
	 * 自定义蒙层颜色。默认值: 0x33000000 API10以上支持
	 */
	overlayColor?: ResourceColor = '0x33000000'
	/**
	 * 是否在点击遮罩层后关闭弹窗
	 */
	closeOnClickOverlay?: boolean = false;
	/**
	 * 是否允许返回键关闭
	 */
	closeOnBackPress?: boolean = false
	/**
	 * 关闭前的回调函数，返回 false 可阻止关闭，支持返回 Promise
	 */
	beforeClose?: (action: 'cancel' | 'confirm') => Promise<boolean> | boolean
	/**
	 * 点击取消的回调
	 */
	onCancel?: (event?: ClickEvent) => void
	/**
	 * 点击确认的的回调
	 */
	onConfirm?: (event?: ClickEvent) => void
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
		this.titleBuilder = option.titleBuilder
		this.defaultBuilder = option.defaultBuilder
		this.footerBuilder = option.footerBuilder
		this.dialogWidth = option.dialogWidth || "640lpx"
		this.dialogBorderRadius = option.dialogBorderRadius || "32lpx"
		this.title = option.title || ""
		this.titleColor = option.titleColor || GRAY_COLOR.GRAY_8
		this.titlePaddingTop = option.titlePaddingTop || "52lpx"
		this.titlePaddingX = option.titlePaddingX || "48lpx"
		this.titleLineHeight = option.titleLineHeight || "48lpx"
		this.titleFontSize = option.titleFontSize || "32lpx"
		this.titleTextAlign = option.titleTextAlign || "center"
		this.message = option.message || ""
		this.messagePaddingX = option.messagePaddingX || "48lpx"
		this.messagePaddingTop = option.messagePaddingTop || "16lpx"
		this.messagePaddingBottom = option.messagePaddingBottom || "52lpx"
		this.messageFontColor = option.messageFontColor || "#323233"
		this.messageFontSize = option.messageFontSize || "28lpx"
		this.messageLineHeight = option.messageLineHeight || "40lpx"
		this.messageTextAlign = option.messageTextAlign || "center"
		this.messageMaxHeight = option.messageMaxHeight || "60%"
		this.theme = option.theme || 'default'
		this.buttonSpace = option.buttonSpace || 0
		this.showConfirmButton = option.showConfirmButton || true
		this.showCancelButton = option.showCancelButton || false
		this.confirmButtonText = option.confirmButtonText || '确认'
		this.cancelButtonText = option.cancelButtonText || '取消'
		this.confirmButtonColor = option.confirmButtonColor || (this.theme == 'round-button' ? '#fff' : '#3D8AF2')
		this.confirmButtonBgColor = option.confirmButtonBgColor || (this.theme == 'round-button' ? '#3D8AF2' : '#fff')
		this.cancelButtonColor = option.cancelButtonColor || '#646566'
		this.cancelButtonBgColor = option.cancelButtonBgColor || '#fff'
		this.buttonFontSize = option.buttonFontSize || "32lpx"
		this.confirmButtonLoading = option.confirmButtonLoading || false
		this.showOverlay = option.showOverlay || true
		this.showInSubWindow = option.showInSubWindow || false
		this.overlayColor = option.overlayColor || '0x33000000'
		this.closeOnClickOverlay = option.closeOnClickOverlay || false
		this.closeOnBackPress = option.closeOnBackPress || false
		this.beforeClose = option.beforeClose
		this.onCancel = option.onCancel
		this.onConfirm = option.onConfirm
		this.onOpen = option.onOpen
		this.onClose = option.onClose
	}
}
/**
 * 处理按钮点击
 */
async function handleBtnClick(option: IBestDialogParams, action: 'cancel' | 'confirm') {
	if (option.beforeClose) {
		action == 'cancel' ? option.cancelButtonLoading = true : option.confirmButtonLoading = true
		option.contentNode?.update(option)
		const status = await option.beforeClose(action)
		// console.log('status', status)
		action == 'cancel' ? option.cancelButtonLoading = false : option.confirmButtonLoading = false
		option.contentNode?.update(option)
		if (!status) {
			return
		}
	}
	option.close(option.id)
	if(action == 'confirm' && option.onConfirm){
		option.onConfirm()
	}
	if(action == 'cancel' && option.onCancel){
		option.onCancel()
	}
}

/**
 * 默认内容 Builder
 */
@Builder
function defaultContentBuilder(option: IBestDialogParams) {
	IBestDialogView({
		titleBuilder: option.titleBuilder,
		defaultBuilder: option.defaultBuilder,
		footerBuilder: option.footerBuilder,
		dialogWidth: option.dialogWidth,
		dialogBorderRadius: option.dialogBorderRadius,
		title: option.title,
		titleColor: option.titleColor,
		titlePaddingTop: option.titlePaddingTop,
		titlePaddingX: option.titlePaddingX,
		titleLineHeight: option.titleLineHeight,
		titleFontSize: option.titleFontSize,
		titleTextAlign: option.titleTextAlign,
		message: option.message,
		messagePaddingX: option.messagePaddingX,
		messagePaddingTop: option.messagePaddingTop,
		messagePaddingBottom: option.messagePaddingBottom,
		messageFontColor: option.messageFontColor,
		messageFontSize: option.messageFontSize,
		messageLineHeight: option.messageLineHeight,
		messageTextAlign: option.messageTextAlign,
		messageMaxHeight: option.messageMaxHeight,
		theme: option.theme,
		buttonSpace: option.buttonSpace,
		showConfirmButton: option.showConfirmButton,
		showCancelButton: option.showCancelButton,
		confirmButtonText: option.confirmButtonText,
		cancelButtonText: option.cancelButtonText,
		confirmButtonColor: option.confirmButtonColor,
		confirmButtonBgColor: option.confirmButtonBgColor,
		cancelButtonColor: option.cancelButtonColor,
		cancelButtonBgColor: option.cancelButtonBgColor,
		buttonFontSize: option.buttonFontSize,
		confirmButtonLoading: option.confirmButtonLoading,
		cancelButtonLoading: option.cancelButtonLoading,
		onCancel: () => {
			handleBtnClick(option, 'cancel')
		},
		onConfirm: () => {
			handleBtnClick(option, 'confirm')
		}
	})
}

interface DialogMapValue{
	contentNode: ComponentContent<IBestDialogParams>
	promptAction: PromptAction
	params: IBestDialogParams
}
/**
 * 弹窗管理器
 */
class Dialog{
	private contentNodeMap: Map<string, DialogMapValue> = new Map()
	/**
	 * 打开弹框
	 */
	public async open(option: IBestDialogOption): Promise<string> {
		let key = this.getUniKey()
		let windowClass: window.Window = await window.getLastWindow(getContext())
		let uiContext = windowClass.getUIContext()
		let promptAction = uiContext.getPromptAction()
		let params = new IBestDialogParams(option)
		params.id = key
		params.close = (id: string): void => this.close(id)
		let contentNode = new ComponentContent(uiContext, wrapBuilder(defaultContentBuilder), params)
		params.contentNode = contentNode
		this.contentNodeMap.set(key, {
			contentNode: contentNode,
			promptAction: promptAction,
			params: params
		})
		await promptAction.openCustomDialog(contentNode, {
			alignment: DialogAlignment.Center,
			isModal: params.showOverlay,
			maskColor: params.overlayColor,
			onWillDismiss: async(dismissDialogAction: DismissDialogAction)=> {
				// 1 点击遮罩返回  0 物理返回(左滑右滑、返回键)
				let reason = dismissDialogAction.reason
				if (reason == DismissReason.PRESS_BACK && !params.closeOnBackPress || reason == DismissReason.TOUCH_OUTSIDE && !params.closeOnClickOverlay) {
					return
				}
				if (params.beforeClose) {
					const status = await params.beforeClose("cancel")
					if (!status) {
						return
					}
				}
				dismissDialogAction.dismiss()
				params.onClose?.()
			}
		})
		params.onOpen?.()
		return key
	}
	/**
	 * 关闭弹框
	 */
	public close(id?: string){
		let key = id || this.getLastKey()
		if(this.contentNodeMap.has(key)){
			let dialog = this.contentNodeMap.get(key)
			dialog?.promptAction?.closeCustomDialog(dialog?.contentNode).then(() => {
				dialog?.contentNode?.dispose()
				dialog?.params.onClose?.()
			})
		}
	}
	private getUniKey(): string{
		let key = generateId()
		if(this.contentNodeMap.has(key)){
			return this.getUniKey()
		}
		return key
	}
	private getLastKey(): string{
		return Array.from(this.contentNodeMap.keys()).pop() || ""
	}
}

export default new Dialog()