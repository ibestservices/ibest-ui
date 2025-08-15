import { convertDimensionsWidthUnit, getSizeByUnit, sleep } from '../../utils/utils'
import { PopupAlign, PopupBaseController } from './index.type'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { IBestPopupColor } from './color'
import { IBestIcon } from '../icon'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import GlobalStore from '../../utils/GlobalStore'
import { ImmersiveMode, LengthMetrics } from '@kit.ArkUI'

const popupDuration = 200
const hideDuration = 220

interface PopupSize{
	width: IBestStringNumber
	height: IBestStringNumber
}

@Component
struct IBestPopupBaseContent {
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@StorageProp(IBestStorageKey.IS_LANDSCAPE) @Watch("initSize") isLandscape: boolean = false
	@StorageProp(IBestStorageKey.TOP_AVOID_HEIGHT) topAvoidHeight: number = 0
	@StorageProp(IBestStorageKey.BOTTOM_BAR_HEIGHT) bottomBarHeight: number = 0
	/**
	 * 弹框显示位置
	 */
	@Consume popupAlign: PopupAlign
	/**
	 * 弹框宽度
	 */
	@Link popupWidth: IBestStringNumber
	/**
	 * 弹框高度
	 */
	@Link popupHeight: IBestStringNumber
	/**
	 * 背景图片
	 */
	@Consume bgColor: ResourceColor
	/**
	 * 背景图片
     */
	@Consume bgImage: ResourceStr
	/**
	 * 是否显示头部
	 */
	@Consume isShowHeader: boolean
	@Consume title: ResourceStr
	@Consume titleColor: ResourceColor
	@Consume isShowClose: boolean
	@Consume closeIcon: ResourceStr
	@Consume closeIconColor: ResourceColor
	/**
	 * 背板的圆角半径
	 */
	@Consume cornerRadius: Length | BorderRadiuses | LocalizedBorderRadiuses
	/**
	 * 底部偏移
	 */
	@Consume offsetY: number
	/**
	 * 是否开启顶部安全区适配
	 */
	@Consume safeAreaInsetTop: boolean
	/**
	 * 是否开启底部安全区适配
	 */
	@Consume safeAreaInsetBottom: boolean
	/**
	 * 自定义头部
	 * @since 1.18.0
     */
	@BuilderParam headerBuilder: CustomBuilder
	/**
	 * 自定义内容
	 */
	@BuilderParam contentBuilder: CustomBuilder
	/**
	 * 点击遮罩
	 */
	onClickOverlay: () => void = () => {}
	close: () => void = () => {}

	@State transX: IBestStringNumber = ""
	@State transY: IBestStringNumber = ""
	baseController: PopupBaseController = new PopupBaseController()

	@Builder popupTitle(){
		Row(){
			Text(this.title)
				.fontSize(this.baseStyle.fontSizeLg)
				.fontColor(this.titleColor)
			IBestIcon({
				name: this.closeIcon,
				iconSize: convertDimensionsWidthUnit(20),
				color: this.closeIconColor
			})
				.onClick(() => {
					this.close()
				})
				.visibility(this.isShowClose ? Visibility.Visible : Visibility.None)
		}
		.width(CONTAINER_SIZE.FULL)
		.height(convertDimensionsWidthUnit(40))
		.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
		.justifyContent(FlexAlign.SpaceBetween)
		.alignItems(VerticalAlign.Center)
	}
	@Builder placeRow(){
		Blank()
			.onClick(() => {
				this.onClickOverlay()
			})
	}

	aboutToAppear(): void {
		this.baseController.hide = (): void => this.init()
		this.init()
	}
	// 初始化尺寸
	initSize(): PopupSize{
		switch (this.popupAlign){
			case "left":
			case "right":
				return {
					width: this.popupWidth || (this.isLandscape ? "70%" : "60%"),
					height: this.popupHeight || "100%"
				}
			case "top":
			case "bottom":
				return {
					width: this.popupWidth || "100%",
					height: this.popupHeight || (this.isLandscape ? "70%" : "40%")
				}
			case "center":
				return {
					width: this.popupWidth || "",
					height: this.popupHeight || ""
				}
		}
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
			if(this.popupAlign == 'center' || this.popupAlign == 'bottom'){
				this.placeRow()
			}
			Row(){
				if(this.popupAlign == 'center' || this.popupAlign == 'right'){
					this.placeRow()
				}
				Column(){
					if(this.isShowHeader){
						if(this.headerBuilder){
							this.headerBuilder()
						}else{
							this.popupTitle()
						}
					}
					if(this.contentBuilder){
						this.contentBuilder()
					}
				}
				.width(getSizeByUnit(this.initSize().width))
				.height(getSizeByUnit(this.initSize().height))
				.backgroundColor(this.bgColor)
				.backgroundImage(this.bgImage)
				.backgroundImageSize(ImageSize.FILL)
				.padding({
					top: this.safeAreaInsetTop && (this.popupAlign == "left" || this.popupAlign == "right" || this.popupAlign
						== "top") ? convertDimensionsWidthUnit(this.topAvoidHeight) : 0,
					bottom: this.safeAreaInsetBottom && (this.popupAlign == "left" || this.popupAlign == "right" || this.popupAlign
						== "bottom") ? convertDimensionsWidthUnit(this.bottomBarHeight) : 0
				})
				.alignItems(HorizontalAlign.Start)
				.borderRadius(getSizeByUnit(this.cornerRadius))
				.translate({
					x: (this.popupAlign == "left" || this.popupAlign == "right") ? this.transX : "",
					y: (this.popupAlign == "top" || this.popupAlign == 'bottom') ? this.transY : ""
				})
				.animation({ duration: popupDuration, curve: Curve.EaseInOut })
				.onAppear(() => {
					setTimeout(() => {
						this.trans()
					}, 100)
				})
				if(this.popupAlign == 'center' || this.popupAlign == 'left'){
					this.placeRow()
				}
			}
			.width(['left', 'center', 'right'].includes(this.popupAlign) ? CONTAINER_SIZE.FULL : "")
			if(this.popupAlign == 'center' || this.popupAlign == 'top'){
				this.placeRow()
			}
		}
		.height(CONTAINER_SIZE.FULL)
		.offset({x: 0, y: this.offsetY})
		.clip(true)
	}
}

@Component
export struct IBestPopup{
	@StorageProp(IBestStorageKey.IS_LANDSCAPE) @Watch("landScapeChange") isLandscape: boolean = false
	@StorageProp(IBestStorageKey.TOP_AVOID_HEIGHT) topAvoidHeight: number = 0
	/**
	 * 弹框展示状态
	 */
	@Link @Watch("visibleChange") visible: boolean
	/**
	 * 弹框显示位置
	 */
	@Provide({allowOverride: "popupAlign"}) popupAlign: PopupAlign = 'center'
	/**
	 * 弹框宽度
	 */
	@Prop popupWidth: IBestStringNumber = ""
	/**
	 * 弹框高度
	 */
	@Prop popupHeight: IBestStringNumber = ""
	/**
	 * 背景颜色
	 * @since 2.0.8
	 */
	@Provide({allowOverride: "bgColor"}) bgColor: ResourceColor = IBestPopupColor.bgColor
	/**
	 * 背景图片
	 * @since 2.0.7
	 */
	@Provide({allowOverride: "bgImage"}) bgImage: ResourceStr = ""
	/**
	 * 是否显示头部标题栏
	 */
	@Provide({allowOverride: "isShowHeader"}) isShowHeader: boolean = false
	/**
	 * 标题
	 */
	@Provide({allowOverride: "title"}) title: ResourceStr = ""
	/**
	 * 标题字体颜色
	 * @since 2.0.1
     */
	@Provide({allowOverride: "titleColor"}) titleColor: ResourceColor = IBestPopupColor.titleColor
	/**
	 * 底部偏移
	 */
	@Provide({allowOverride: "offsetY"}) offsetY: number = 0
	/**
	 * 是否为模态窗口
	 */
	@Prop isModal: boolean = true
	/**
	 * 蒙层颜色
	 * @since 1.15.0
	 */
	@Prop maskColor: ResourceColor = "0x33000000"
	/**
	 * 背板的圆角半径
	 */
	@Provide({allowOverride: "cornerRadius"}) cornerRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0
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
	@Provide({allowOverride: "closeIcon"}) closeIcon: ResourceStr = "cross"
	/**
	 * 关闭图标颜色
	 * @since 2.0.1
     */
	@Provide({allowOverride: "closeIconColor"}) closeIconColor: ResourceColor = IBestPopupColor.closeIconColor
	/**
	 * 是否开启顶部安全区适配
	 */
	@Provide({allowOverride: "safeAreaInsetTop"}) safeAreaInsetTop: boolean = false
	/**
	 * 是否开启底部安全区适配
	 */
	@Provide({allowOverride: "safeAreaInsetBottom"}) safeAreaInsetBottom: boolean = false
	/**
	 * 设置弹窗是否在拉起软键盘时进行自动避让
	 * @since 2.1.0
	 */
	@Prop keyboardAvoidMode: KeyboardAvoidMode = KeyboardAvoidMode.DEFAULT
	/**
	 * 弹窗避让键盘后，和键盘之间的距离
	 * @since 2.1.0
	 */
	@Prop keyboardAvoidDistance: LengthMetrics = LengthMetrics.vp(16)
	/**
	 * 弹窗显示层级
	 * @since 2.1.0
	 */
	@Prop levelMode: LevelMode = 0
	/**
	 * 页面级弹窗需要显示的层级下的节点 uniqueId, 仅当levelMode属性设置为LevelMode.EMBEDDED时生效
	 * @since 2.1.0
	 */
	@Prop levelUniqueId: number = 0
	/**
	 * 自定义头部 优先级大于title
	 * @since 1.18.0
	 */
	@BuilderParam headerBuilder: CustomBuilder
	/**
	 * 自定义内容
	 */
	@BuilderParam contentBuilder: CustomBuilder
	/**
	 * 弹框打开回调
	 */
	onOpen: () => void = () => {}
	/**
	 * 弹框关闭回调
	 */
	onClose: () => void = () => {}

	private baseController: PopupBaseController = new PopupBaseController()
	private uiContext = this.getUIContext()
	private promptAction = this.uiContext.getPromptAction()
	private dialogId: number = 0
	@Builder defaultContentBuilder() {
		IBestPopupBaseContent({
			popupWidth: $popupWidth,
			popupHeight: $popupHeight,
			headerBuilder: this.headerBuilder,
			contentBuilder: this.contentBuilder,
			baseController: this.baseController,
			onClickOverlay: () => {
				if(this.closeOnClickOverlay){
					this.close()
				}
			},
			close: (): void => this.close()
		})
	}

	async visibleChange(){
		if(this.visible){
			this.open()
		}else{
			if(this.popupAlign != 'center'){
				this.baseController.hide()
				await sleep(hideDuration)
			}
			this.promptAction.closeCustomDialog(this.dialogId)
		}
	}
	// 弹框打开时, 屏幕转向, 内容会错位, 暂时这样处理, 后续在再优化
	landScapeChange(){
		if(this.visible){
			this.visible = false
			setTimeout(() => {
				this.visible = true
			}, hideDuration * 2)
		}
	}
	getAlignment() {
		switch (this.popupAlign) {
			case 'left':
				return DialogAlignment.TopStart
			case 'right':
				return DialogAlignment.TopEnd
			case 'top':
				return DialogAlignment.Top
			case 'bottom':
				return DialogAlignment.Bottom
			default:
				return DialogAlignment.Center
		}
	}
	async open() {
		this.dialogId = await this.promptAction.openCustomDialog({
			builder: () => {
				this.defaultContentBuilder()
			},
			width: CONTAINER_SIZE.FULL,
			height: this.uiContext.px2vp(GlobalStore.screenHeight),
			backgroundBlurStyle: BlurStyle.NONE,
			cornerRadius: 0,
			alignment: this.getAlignment(),
			offset: { dx: 0, dy: -this.topAvoidHeight },
			isModal: this.isModal,
			maskColor: this.maskColor,
			keyboardAvoidMode: this.keyboardAvoidMode,
			keyboardAvoidDistance: this.keyboardAvoidDistance,
			levelMode: this.levelMode,
			levelUniqueId: this.levelUniqueId,
			immersiveMode: ImmersiveMode.EXTEND,
			onDidAppear: () => {
				this.onOpen()
			},
			onDidDisappear: () => {
				this.onClose()
			},
			onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
				// 1 点击遮罩返回  0 物理返回(左滑右滑、返回键)
				let reason = dismissDialogAction.reason
				if (reason == DismissReason.PRESS_BACK && this.closeOnBackPress || reason == DismissReason.TOUCH_OUTSIDE && this.closeOnClickOverlay) {
					this.close()
				}
			}
		})
	}
	// 关闭弹框
	close() {
		this.visible = false
	}
	build() {}
}