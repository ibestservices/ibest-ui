import { FONT_SIZE } from '../../theme-chalk/src/font.type'
import { spaceData } from '../../theme-chalk/src/space'
import { emitter } from '../../assets/ets/EventEmitter'
import { getWindowAvoidSize } from '../../assets/ets/utils'
import { common } from '@kit.AbilityKit'
import { PopupAlign } from './index.type'


@CustomDialog
@Component
struct IBestPopupBaseContent {
	/*
	 * 弹框显示位置
	 */
	@Prop popupAlign: PopupAlign = 'center'
	/*
	 * 弹框宽度
	 */
	@Prop PopupWidth: string | number = ""
	/*
	 * 弹框高度
	 */
	@Prop PopupHeight: string | number = ""
	/*
	 * 是否显示头部
	 */
	@Consume isShowHeader: boolean
	/*
	 * 背板的圆角半径
	 */
	@Prop cornerRadius: number = 0
	/*
	 * 是否开启顶部安全区适配
	 */
	@Consume safeAreaInsetTop: boolean
	/*
	 * 是否开启底部安全区适配
	 */
	@Consume safeAreaInsetBottom: boolean
	/*
	 * 顶部规避尺寸
	 */
	@Prop topAvoidSize: number
	/*
	 * 底部规避尺寸
	 */
	@Prop bottomAvoidSize: number

	@BuilderParam contentBuilder: () => void
	controller: CustomDialogController

	build() {
		Column(){
			PopupTitle()
				.visibility(this.isShowHeader ? Visibility.Visible : Visibility.None)
			this.contentBuilder()
		}
		.width(this.PopupWidth)
		.height(this.PopupHeight)
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
	@Provide uniId: number = 0
	/*
	 * 弹框展示状态
	 */
	@Link @Watch("visibleChange") visible: boolean
	/*
	 * 弹框显示位置
	 */
	@Prop popupAlign: PopupAlign = 'center'
	/*
	 * 弹框宽度
	 */
	@Prop PopupWidth: string | number = ""
	/*
	 * 弹框高度
	 */
	@Prop PopupHeight: string | number = ""
	/*
	 * 是否显示头部标题栏
	 */
	@Provide isShowHeader: boolean = false
	/*
	 * 标题
	 */
	@Provide title: string = ""
	/*
	 * 底部偏移
	 */
	@Prop offsetY: number = 0
	/*
	 * 背板的圆角半径
	 */
	@Prop cornerRadius: number = 0
	/*
	 * 是否允许点击遮罩关闭
	 */
	@Prop closeOnClickOverlay: boolean = true
	/*
	 * 是否允许返回键关闭
	 */
	@Prop closeOnBackPress: boolean = false
	/*
	 * 是否显示关闭图标
	 */
	@Provide isShowClose: boolean = true
	/*
	 * 自定义关闭图标
	 */
	@Provide closeIcon: string | Resource = ""
	/*
	 * 是否开启顶部安全区适配
	 */
	@Provide safeAreaInsetTop: boolean = false
	/*
	 * 是否开启底部安全区适配
	 */
	@Provide safeAreaInsetBottom: boolean = false
	/*
	 * 顶部规避尺寸
	 */
	@State topAvoidSize: number = 0
	/*
	 * 底部规避尺寸 暂时写死
	 */
	@State bottomAvoidSize: number = 0
	/*
	 * 默认弹框内容
	 */
	@Builder defaultBuilder() {
		if (this.popupAlign == "center") {
			Row() {
				Text("内容")
			}
			.width("100%")
			.aspectRatio(1)
			.justifyContent(FlexAlign.Center)
		}
	}
	/*
	 * 自定义内容
	 */
	@BuilderParam contentBuilder: () => void = this.defaultBuilder
	/*
	 * 弹框打开回调
	 */
	onOpen: () => void = () => {}
	/*
	 * 弹框关闭回调
	 */
	onClose: () => void = () => {}
	private context = getContext(this) as common.BaseContext
	dialogController: CustomDialogController | null = new CustomDialogController({
		builder: IBestPopupBaseContent({
			contentBuilder: this.contentBuilder,
			popupAlign: this.popupAlign,
			PopupWidth: this.PopupWidth,
			PopupHeight: this.PopupHeight,
			topAvoidSize: this.topAvoidSize,
			bottomAvoidSize: this.bottomAvoidSize,
			cornerRadius: this.cornerRadius
		}),
		alignment: this.popupAlign == "left" ? DialogAlignment.TopStart : this.popupAlign == "right" ?
		DialogAlignment.TopEnd : this.popupAlign == "top" ? DialogAlignment.Top : this.popupAlign == "bottom" ?
			DialogAlignment.Bottom : DialogAlignment.Center,
		offset: { dx: 0, dy: this.offsetY },
		isModal: true,
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

	async aboutToAppear(){
		this.uniId = this.getUniqueId()
		await this.initSize()
		emitter.on(`IBestPopupClose_${this.uniId}`, () => {
			this.close()
		})
	}
	aboutToDisappear(){
		emitter.off(`IBestPopupClose_${this.uniId}`, () => {})
	}
	// 初始化尺寸
	async initSize(){
		let res = await getWindowAvoidSize(this.context)
		switch (this.popupAlign){
			case "left":
			case "right":
				this.PopupWidth = this.PopupWidth === "" ? "60%" : typeof this.PopupWidth == "string" ? this
					.PopupWidth : (this.PopupWidth + "lpx")
				this.PopupHeight = "100%"
				break
			case "top":
			case "bottom":
				this.PopupWidth = "100%"
				this.PopupHeight = this.PopupHeight === "" ? "40%" : typeof this.PopupHeight == "string" ? this.PopupHeight : (this.PopupHeight + "lpx")
				break
			case "center":
				this.PopupWidth = this.PopupWidth ? typeof this.PopupWidth == "string" ? this.PopupWidth : this
					.PopupWidth + "lpx" : "320lpx"
				this.PopupHeight = ""
				break
		}
		this.topAvoidSize = res.topSize
		this.bottomAvoidSize = res.bottomSize
	}
	visibleChange(){
		if(this.visible){
			this.dialogController?.open()
			this.onOpen()
		}else{
			this.dialogController?.close()
			this.close()
		}
	}
	// 关闭弹框
	close() {
		this.visible = false
		this.onClose()
	}
	build() {}
}

@Component
struct PopupTitle {
	@Consume uniId: number
	@Consume title: string
	@Consume isShowClose: boolean
	/*
	 * 自定义关闭图标
	 */
	@Consume closeIcon: string | Resource
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
					emitter.emit(`IBestPopupClose_${this.uniId}`)
				})
		}
		.width("100%")
		.height("80lpx")
		.padding({ left: spaceData.spaceMd, right: spaceData.spaceMd})
		.justifyContent(FlexAlign.SpaceBetween)
		.alignItems(VerticalAlign.Center)
	}
}