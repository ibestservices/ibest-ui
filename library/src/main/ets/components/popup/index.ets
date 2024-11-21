import { convertDimensionsWidthUnit, getIsLandscape, getSizeByUnit, getWindowAvoidSize } from '../../utils/utils'
import { common } from '@kit.AbilityKit'
import { PopupAlign, PopupBaseController } from './index.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
const popupDuration = 200
const hideDuration = 220

@CustomDialog
@Component
struct IBestPopupBaseContent {
	@State transX: string | number = ""
	@State transY: string | number = ""
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
	@BuilderParam contentBuilder?: CustomBuilder
	close: () => void = () => {}
	controller?: CustomDialogController

	baseController: PopupBaseController = new PopupBaseController()

	aboutToAppear(): void {
		this.baseController.hide = (): void => this.init()
		this.init()
	}
	// 初始化
	init(){
		switch (this.popupAlign){
			case "left":
				this.transX = "-100%"
				break
			case "right":
				this.transX = "100%"
				break
			case "top":
				this.transY = "-100%"
				break
			case "bottom":
				this.transY = "100%"
				break
		}
	}
	// 变换显示
	trans(){
		switch (this.popupAlign){
			case "left":
			case "right":
				this.transX = 0
				break
			case "top":
			case "bottom":
				this.transY = 0
				break
		}
	}

	build() {
		Column(){
			Column(){
				if(this.isShowHeader){
					PopupTitle({
						close: this.close
					})
				}
				if(this.contentBuilder){
					this.contentBuilder()
				}
			}
			.width(this.popupWidth)
			.height(this.popupHeight)
			.backgroundColor("#fff")
			.padding({
				top: this.safeAreaInsetTop && (this.popupAlign == "left" || this.popupAlign == "right" || this.popupAlign
					== "top") ? convertDimensionsWidthUnit(this.topAvoidSize) : 0,
				bottom: this.safeAreaInsetBottom && (this.popupAlign == "left" || this.popupAlign == "right" || this.popupAlign
					== "bottom") ? convertDimensionsWidthUnit(this.bottomAvoidSize) : 0
			})
			.alignItems(HorizontalAlign.Start)
			.borderRadius(getSizeByUnit(this.cornerRadius))
			.translate({
				x: (this.popupAlign == "left" || this.popupAlign == "right") ? this.transX : "",
				y: (this.popupAlign == "top" || this.popupAlign == 'bottom') ? this.transY : "" })
			.animation({
				duration: popupDuration,
				curve: Curve.EaseInOut
			})
			.onAppear(() => {
				setTimeout(() => {
					this.trans()
				}, 100)
			})
		}
		.clip(true)
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
	@Provide({allowOverride: "isShowHeader"}) isShowHeader: boolean = false
	/**
	 * 标题
	 */
	@Provide({allowOverride: "title"}) title: string = ""
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
	@Provide({allowOverride: "isShowClose"}) isShowClose: boolean = true
	/**
	 * 自定义关闭图标
	 */
	@Provide({allowOverride: "closeIcon"}) closeIcon: string | Resource = ""
	/**
	 * 是否开启顶部安全区适配
	 */
	@Provide({allowOverride: "safeAreaInsetTop"}) safeAreaInsetTop: boolean = false
	/**
	 * 是否开启底部安全区适配
	 */
	@Provide({allowOverride: "safeAreaInsetBottom"}) safeAreaInsetBottom: boolean = false
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
	private baseController: PopupBaseController = new PopupBaseController()
	dialogController: CustomDialogController = new CustomDialogController({
		builder: IBestPopupBaseContent({
			baseController: this.baseController,
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
			if (reason == DismissReason.PRESS_BACK && this.closeOnBackPress || reason == DismissReason.TOUCH_OUTSIDE && this.closeOnClickOverlay) {
				this.close()
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
					this.popupWidth = getSizeByUnit(this.popupWidth || "70%")
				}else{
					this.popupWidth = getSizeByUnit(this.popupWidth || "60%")
				}
				this.popupHeight = getSizeByUnit(this.popupHeight || "100%")
				break
			case "top":
			case "bottom":
				this.popupWidth = getSizeByUnit(this.popupWidth || "100%")
				if(this.isLandscape){
					this.popupHeight = getSizeByUnit(this.popupHeight || "70%")
				}else{
					this.popupHeight = getSizeByUnit(this.popupHeight || "40%")
				}
				break
			case "center":
				this.popupWidth = getSizeByUnit(this.popupWidth || "")
				this.popupHeight = getSizeByUnit(this.popupHeight || "")
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
			this.baseController.hide()
			setTimeout(() => {
				this.dialogController.close()
				this.onClose()
			}, hideDuration)
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
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
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
				.fontSize(this.baseStyle.fontSizeLg)
			Image(this.closeIcon || $r("app.media.close"))
				.width(this.baseStyle.spaceMd)
				.aspectRatio(1)
				.fillColor("#ccc")
				.visibility(this.isShowClose ? Visibility.Visible : Visibility.None)
				.onClick(() => {
					this.close()
				})
		}
		.width("100%")
		.height(convertDimensionsWidthUnit(40))
		.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
		.justifyContent(FlexAlign.SpaceBetween)
		.alignItems(VerticalAlign.Center)
	}
}