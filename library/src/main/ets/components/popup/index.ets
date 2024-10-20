import { FONT_SIZE } from '../../theme-chalk/src/font.type'
import { spaceData } from '../../theme-chalk/src/space'
import { getIsLandscape, getWindowAvoidSize } from '../../assets/ets/utils'
import { common } from '@kit.AbilityKit'
import { PopupAlign } from './index.type'

@CustomDialog
@Component
struct IBestPopupBaseContent {
	/**
	 * 弹框显示位置
	 */
	@Prop popupAlign: PopupAlign = 'center'
	/**
	 * 弹框宽度
	 */
	@Prop popupWidth: string | number = ""
	/**
	 * 弹框高度
	 */
	@Prop popupHeight: string | number = ""
	/**
	 * 是否显示头部
	 */
	@Consume isShowHeader: boolean
	/**
	 * 背板的圆角半径
	 */
	@Prop cornerRadius: number = 0
	/**
	 * 是否开启顶部安全区适配
	 */
	@Consume safeAreaInsetTop: boolean
	/**
	 * 是否开启底部安全区适配
	 */
	@Consume safeAreaInsetBottom: boolean
	/**
	 * 顶部规避尺寸
	 */
	@Prop topAvoidSize: number
	/**
	 * 底部规避尺寸
	 */
	@Prop bottomAvoidSize: number
	/**
	 * 自定义内容
	 */
	@BuilderParam contentBuilder: CustomBuilder
	close: () => void = () => {}
	controller?: CustomDialogController

	build() {
		Column(){
			PopupTitle({
				close: this.close
			})
				.visibility(this.isShowHeader ? Visibility.Visible : Visibility.None)
			if(this.contentBuilder){
				this.contentBuilder()
			}
		}
		.width(this.popupWidth)
		.height(this.popupHeight)
		.backgroundColor("#fff")
		.padding({
			top: this.safeAreaInsetTop && (this.popupAlign == "left" || this.popupAlign == "right" || this.popupAlign
				== "top") ? this.topAvoidSize + "lpx" : 0,
			bottom: this.safeAreaInsetBottom && (this.popupAlign == "left" || this.popupAlign == "right" || this.popupAlign
				== "bottom") ? this.bottomAvoidSize + "lpx" : 0
		})
		.alignItems(HorizontalAlign.Start)
		.borderRadius(this.cornerRadius + "lpx")
		.clip(true)
		.transition(
			 this.popupAlign == "center" ? undefined : TransitionEffect.move(this.popupAlign == "top" ?
			 TransitionEdge.TOP : this.popupAlign == 'bottom' ? TransitionEdge.BOTTOM : this.popupAlign == "left" ?
				 TransitionEdge.START : TransitionEdge.END).animation({duration: 300, curve: Curve.FastOutSlowIn})
		)
	}
}

@Component
export struct IBestPopup{
	// 是否横屏
	@State isLandscape: boolean = getIsLandscape(getContext(this))
	/**
	 * 弹框展示状态
	 */
	@Link @Watch("visibleChange") visible: boolean
	/**
	 * 弹框显示位置
	 */
	@Prop popupAlign: PopupAlign = 'center'
	/**
	 * 弹框宽度
	 */
	@Prop popupWidth: string | number = ""
	/**
	 * 弹框高度
	 */
	@Prop popupHeight: string | number = ""
	/**
	 * 是否显示头部标题栏
	 */
	@Provide isShowHeader: boolean = false
	/**
	 * 标题
	 */
	@Provide title: string = ""
	/**
	 * 底部偏移
	 */
	@Prop offsetY: number = 0
	/**
	 * 蒙层颜色
	 * @since 1.15.0
	 */
	@Prop maskColor: ResourceColor = "0x33000000"
	/**
	 * 背板的圆角半径
	 */
	@Prop cornerRadius: number = 0
	/**
	 * 是否允许点击遮罩关闭
	 */
	@Prop closeOnClickOverlay: boolean = true
	/**
	 * 是否允许返回键关闭
	 */
	@Prop closeOnBackPress: boolean = false
	/**
	 * 是否显示关闭图标
	 */
	@Provide isShowClose: boolean = true
	/**
	 * 自定义关闭图标
	 */
	@Provide closeIcon: string | Resource = ""
	/**
	 * 是否开启顶部安全区适配
	 */
	@Provide safeAreaInsetTop: boolean = false
	/**
	 * 是否开启底部安全区适配
	 */
	@Provide safeAreaInsetBottom: boolean = false
	/**
	 * 顶部规避尺寸
	 */
	@State topAvoidSize: number = 0
	/**
	 * 底部规避尺寸
	 */
	@State bottomAvoidSize: number = 0
	/**
	 * 自定义内容
	 */
	@BuilderParam contentBuilder?: CustomBuilder
	/**
	 * 弹框打开回调
	 */
	onOpen: () => void = () => {}
	/**
	 * 弹框关闭回调
	 */
	onClose: () => void = () => {}
	private context = getContext(this) as common.BaseContext
	dialogController: CustomDialogController = new CustomDialogController({
		builder: IBestPopupBaseContent({
			contentBuilder: this.contentBuilder,
			popupAlign: this.popupAlign,
			popupWidth: this.popupWidth,
			popupHeight: this.popupHeight,
			topAvoidSize: this.topAvoidSize,
			bottomAvoidSize: this.bottomAvoidSize,
			cornerRadius: this.cornerRadius,
			close: (): void => this.close()
		}),
		alignment: this.popupAlign == "left" ? DialogAlignment.TopStart : this.popupAlign == "right" ?
		DialogAlignment.TopEnd : this.popupAlign == "top" ? DialogAlignment.Top : this.popupAlign == "bottom" ?
			DialogAlignment.Bottom : DialogAlignment.Center,
		offset: { dx: 0, dy: -this.offsetY },
		isModal: true,
		maskColor: this.maskColor,
		customStyle: true,
		onWillDismiss:(dismissDialogAction: DismissDialogAction)=> {
			// 1 点击遮罩返回  0 物理返回(左滑右滑、返回键)
			let reason = dismissDialogAction.reason
			if (reason == DismissReason.PRESS_BACK && this.closeOnBackPress) {
				dismissDialogAction.dismiss()
			}
			if (reason == DismissReason.TOUCH_OUTSIDE && this.closeOnClickOverlay) {
				dismissDialogAction.dismiss()
			}
		},
		cancel: this.close
	})

	aboutToAppear(){
		this.initSize()
	}
	// 初始化尺寸
	async initSize(){
		let res = await getWindowAvoidSize(this.context)
		switch (this.popupAlign){
			case "left":
			case "right":
				if(this.isLandscape){
					this.popupWidth = this.popupWidth === "" ? "70%" : typeof this.popupWidth == "string" ? this.popupWidth : (this.popupWidth + "lpx")
				}else{
					this.popupWidth = this.popupWidth === "" ? "60%" : typeof this.popupWidth == "string" ? this.popupWidth : (this.popupWidth + "lpx")
				}
				this.popupHeight = this.popupHeight || "100%"
				break
			case "top":
			case "bottom":
				this.popupWidth = this.popupWidth || "100%"
				if(this.isLandscape){
					this.popupHeight = this.popupHeight === "" ? "70%" : typeof this.popupHeight == "string" ? this.popupHeight : (this.popupHeight + "lpx")
				}else{
					this.popupHeight = this.popupHeight === "" ? "40%" : typeof this.popupHeight == "string" ? this.popupHeight : (this.popupHeight + "lpx")
				}
				break
			case "center":
				this.popupWidth = this.popupWidth ? typeof this.popupWidth == "string" ? this.popupWidth : this.popupWidth + "lpx" : ""
				this.popupHeight = ""
				break
		}
		this.topAvoidSize = res.topSize
		this.bottomAvoidSize = res.navigationSize
	}
	visibleChange(){
		if(this.visible){
			this.dialogController.open()
			this.onOpen()
		}else{
			this.dialogController.close()
			this.onClose()
		}
	}
	// 关闭弹框
	close() {
		this.visible = false
	}
	build() {}
}

@Component
struct PopupTitle {
	@Consume title: string
	@Consume isShowClose: boolean
	/**
	 * 自定义关闭图标
	 */
	@Consume closeIcon: string | Resource
	close: () => void = () => {}
	build() {
		Row(){
			Text(this.title)
				.fontSize(FONT_SIZE.LG)
			Image(this.closeIcon || $r("app.media.close"))
				.width(spaceData.spaceMd)
				.aspectRatio(1)
				.fillColor("#ccc")
				.visibility(this.isShowClose ? Visibility.Visible : Visibility.None)
				.onClick(() => {
					this.close()
				})
		}
		.width("100%")
		.height("80lpx")
		.padding({ left: spaceData.spaceMd, right: spaceData.spaceMd })
		.justifyContent(FlexAlign.SpaceBetween)
		.alignItems(VerticalAlign.Center)
	}
}