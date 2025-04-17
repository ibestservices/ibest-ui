import { IBestDialogView } from './dialog';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { convertDimensionsWidthUnit, sleep } from '../../utils/utils';
import { IBestStringNumber } from '../../model/Global.type';
import { ImmersiveMode, LengthMetrics, LevelMode } from '@kit.ArkUI';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
@Component
export struct IBestDialog {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 弹框展示状态
	 * @since 1.16.0
	 */
	@Link @Watch("visibleChange") visible: boolean
	/**
	 * 弹窗宽度
	 */
	@Prop dialogWidth: IBestStringNumber = convertDimensionsWidthUnit(320)
	/**
	 * 弹窗圆角
	 */
	@Prop dialogBorderRadius: IBestStringNumber = this.baseStyle.spaceMd as string
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
	@Prop title: ResourceStr
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
	@Prop titlePaddingX: IBestStringNumber = convertDimensionsWidthUnit(24)
	/**
	 * 标题的padding-top值
	 */
	@Prop titleLineHeight: IBestStringNumber = convertDimensionsWidthUnit(24)
	/**
	 * 标题的对齐方式
	 */
	@Prop titleTextAlign: 'left' | 'center' | 'right' = 'center'
	/**
	 * 文本内容，支持通过 \n 换行
	 */
	@Prop message: ResourceStr = ''
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
	@Prop messagePaddingTop: IBestStringNumber = convertDimensionsWidthUnit(8)
	/**
	 * 内容区域的padding-left与padding-right值
	 */
	@Prop messagePaddingX: IBestStringNumber = convertDimensionsWidthUnit(24)
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
	 * 弹窗是否为模态窗口，模态窗口有蒙层，非模态窗口无蒙层
	 */
	@Prop showOverlay: boolean = true
	/**
	 * 自定义蒙层颜色。默认值: 0x33000000 API10以上支持
	 */
	@Prop overlayColor: ResourceColor = '0x33000000'
	/**
	 * 某弹框需要显示在主窗口之外时，是否在子窗口显示此弹窗
	 */
	@Prop showInSubWindow: boolean = false
	/**
	 * 是否在点击遮罩层后关闭弹窗
	 */
	@Prop closeOnClickOverlay: boolean = false
	/**
	 * 是否允许返回键关闭
	 * @since 1.16.0
	 */
	@Prop closeOnBackPress: boolean = true
	/**
	 * 弹窗在竖直方向上的对齐方式 默认center
	 */
	@Prop alignment: 'center' | 'top' | 'bottom' = 'center'
	/**
	 * 弹窗相对alignment所在位置的横向偏移量
	 */
	@Prop offsetX: IBestStringNumber = 0
	/**
	 * 弹窗相对alignment所在位置的纵向偏移量。
	 */
	@Prop offsetY: IBestStringNumber = 0
	/**
	 * 弹窗避让键盘后，和键盘之间的距离
	 * @since 2.0.8
	 */
	@Prop keyboardAvoidDistance: LengthMetrics = LengthMetrics.vp(16)
	/**
	 * 弹窗显示层级
	 * @since 2.0.8
	 */
	@Prop levelMode: LevelMode = 0
	/**
	 * 页面级弹窗需要显示的层级下的节点 uniqueId, 仅当levelMode属性设置为LevelMode.EMBEDDED时生效
	 * @since 2.0.8
	 */
	@Prop levelUniqueId: number = 0
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
	 * 关闭前的回调函数，返回 false 可阻止关闭，支持返回 Promise
	 */
	beforeClose?: (action: 'cancel' | 'confirm') => Promise<boolean> | boolean
	/**
	 * 弹框打开回调
	 * @since 1.16.0
	 */
	onOpen: () => void = () => {}
	/**
	 * 弹框关闭回调
	 * @since 1.16.0
	 */
	onClose: () => void = () => {}
	/**
	 * 点击取消的回调
	 */
	onCancel: () => void = () => {}
	/**
	 * 点击确认的的回调
	 */
	onConfirm: () => void = () => {}

	private promptAction = this.getUIContext().getPromptAction()
	private dialogId: number = 0
	@Builder dialogBuilder(){
		IBestDialogView({
			dialogWidth: this.dialogWidth,
			dialogBorderRadius: this.dialogBorderRadius,
			bgColor: this.bgColor,
			bgImage: this.bgImage,
			title: this.title,
			titleColor: this.titleColor,
			titlePaddingTop: this.titlePaddingTop,
			titlePaddingX: this.titlePaddingX,
			titleLineHeight: this.titleLineHeight,
			titleFontSize: this.titleFontSize,
			titleTextAlign: this.titleTextAlign,
			message: this.message,
			messagePaddingX: this.messagePaddingX,
			messagePaddingTop: this.messagePaddingTop,
			messagePaddingBottom: this.messagePaddingBottom,
			messageFontColor: this.messageFontColor,
			messageFontSize: this.messageFontSize,
			messageLineHeight: this.messageLineHeight,
			messageTextAlign: this.messageTextAlign,
			messageMaxHeight: this.messageMaxHeight,
			theme: this.theme,
			showConfirmButton: this.showConfirmButton,
			showCancelButton: this.showCancelButton,
			confirmButtonText: this.confirmButtonText,
			cancelButtonText: this.cancelButtonText,
			buttonFontSize: this.buttonFontSize,
			confirmButtonColor: this.confirmButtonColor,
			confirmButtonFontWeight: this.confirmButtonFontWeight,
			confirmButtonBgColor: this.confirmButtonBgColor,
			cancelButtonColor: this.cancelButtonColor,
			cancelButtonBgColor: this.cancelButtonBgColor,
			confirmButtonDisabled: this.confirmButtonDisabled,
			cancelButtonDisabled: this.cancelButtonDisabled,
			confirmButtonLoading: this.confirmButtonLoading,
			cancelButtonLoading: this.cancelButtonLoading,
			titleBuilder: this.titleBuilder,
			defaultBuilder: this.defaultBuilder,
			footerBuilder: this.footerBuilder,
			onCancel: () => {
				this.handleCancel()
			},
			onConfirm: () => {
				this.handleConfirm()
			},
			onClickOverlay: () => {
				if (this.closeOnClickOverlay) {
					this.handleCancel()
				}
			}
		})
	}
	// visible 变化
	visibleChange() {
		if (this.visible) {
			this.open()
		} else {
			this.promptAction.closeCustomDialog(this.dialogId)
		}
	}
	getAlignment() {
		switch (this.alignment) {
			case 'center':
				return DialogAlignment.Center
			case 'top':
				return DialogAlignment.Top
			case 'bottom':
				return DialogAlignment.Bottom
			default:
				return DialogAlignment.Center
		}
	}
	// 结束前的动画
	async handleBeforeClose(action: 'cancel' | 'confirm') {
		let status = true
		try {
			if (this.beforeClose) {
				status = await this.beforeClose(action)
			}
		} catch (e) {
			status = false
		}
		return status
	}
	// 点击取消的回调
	async handleCancel() {
		if (this.cancelButtonDisabled || this.cancelButtonLoading) {
			return
		}
		if (this.beforeClose) {
			this.cancelButtonLoading = true
			const status = await this.handleBeforeClose('cancel');
			this.cancelButtonLoading = false
			if (!status) {
				return
			}
		}
		this.cancelButtonDisabled = true
		this.close()
		this.onCancel()
		// 等待动画结束
		await sleep()
		this.cancelButtonDisabled = false
	}
	// 点击确定的回调
	async handleConfirm() {
		if (this.confirmButtonDisabled || this.confirmButtonLoading) {
			return
		}
		if (this.beforeClose) {
			this.confirmButtonLoading = true
			const status = await this.handleBeforeClose('confirm');
			this.confirmButtonLoading = false
			if (!status) {
				return
			}
		}
		this.confirmButtonDisabled = true;
		this.close()
		this.onConfirm()
		// 等待动画结束
		await sleep()
		this.confirmButtonDisabled = false;
		this.confirmButtonLoading = false;
	}
	// 打开
	async open(){
		this.dialogId = await this.promptAction.openCustomDialog({
			builder: () => {
				this.dialogBuilder()
			},
			width: CONTAINER_SIZE.FULL,
			backgroundBlurStyle: BlurStyle.NONE,
			cornerRadius: 0,
			alignment: this.getAlignment(),
			offset: {
				dx: this.offsetX,
				dy: this.offsetY
			},
			isModal: this.showOverlay,
			maskColor: this.overlayColor,
			showInSubWindow: this.showInSubWindow,
			keyboardAvoidDistance: this.keyboardAvoidDistance,
			// immersiveMode: ImmersiveMode.EXTEND,
			levelMode: this.levelMode,
			levelUniqueId: this.levelUniqueId,
			onDidAppear: () => {
				this.onOpen()
			},
			onDidDisappear: () => {
				this.onClose()
			},
			onWillDismiss:(dismissDialogAction: DismissDialogAction)=> {
				// 1 点击遮罩返回  0 物理返回(左滑右滑、返回键)
				let reason = dismissDialogAction.reason
				if (reason == DismissReason.PRESS_BACK && this.closeOnBackPress || reason == DismissReason.TOUCH_OUTSIDE && this.closeOnClickOverlay) {
					this.handleCancel()
				}
			}
		})
	}
	// 关闭
	close() {
		this.visible = false
	}
	build() {}
}