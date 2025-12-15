import { ComponentContent, PromptAction } from '@kit.ArkUI'
import { CONTAINER_SIZE } from '../theme-chalk/src/container'
import { clamp, convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from '../utils/utils'
import { IBestActionSheetColor } from './color'
import { IBestStringNumber } from '../model/Global.type'
import GlobalStore from '../utils/globalStore'
type IBestPreviewImgType = PixelMap | ResourceStr | DrawableDescriptor

interface CenterLocation {
	x: number;
	y: number;
}
interface ScaleImageInfo{
	width: number
	height: number
	localLeft: number
	localTop: number
}

class IBestImagePreviewOption{
	/**
	 * 遮罩背景色
	 */
	maskColor?: ResourceColor = 'rgba(24,24,25,0.95)'
	/**
	 * 指定初始显示的图片索引
	 */
	startIndex?: number = 0
	/**
	 * 动画时长
	 */
	swipeDuration?: number = 200
	/**
	 * 是否显示页码
	 */
	showIndex?: boolean = true
	/**
	 * 页码位置
	 */
	indexPosition?: 'top' | 'bottom' = 'bottom'
	/**
	 * 页码距离顶部或底部距离
	 */
	indexOffset?: IBestStringNumber = 52
	/**
	 * 页码字体颜色
	 */
	indexFontColor?: ResourceColor
	/**
	 * 页码字体大小
	 */
	indexFontSize?: IBestStringNumber = 14
	/**
	 * 是否循环
	 */
	loop?: boolean = true
	/**
	 * 是否启用双击缩放手势，禁用后，点击时会立即关闭图片预览
	 */
	doubleScale?: boolean = true
	/**
	 * 是否在点击遮罩层后关闭图片预览
	 */
	closeOnClickOverlay?: boolean = true
	/**
	 * 是否在点击图片后关闭图片预览
	 */
	closeOnClickImage?: boolean = true
	/**
	 * 最大缩放比例
	 */
	maxScale?: number = 3
	/**
	 * 最小缩放比例
	 */
	minScale?: number = 1
	/**
	 * 图片点击事件
	 */
	onImgClick?: (index: number) => void
	/**
	 * 图片长按事件
	 */
	onImgLongPress?: (index: number) => void
}

class IBestImagePreviewParams extends IBestImagePreviewOption {
	list: IBestPreviewImgType[] = []
	// 关闭
	hide: () => void = () => {}
	constructor(list: IBestPreviewImgType[], params?: IBestImagePreviewOption) {
		super()
		this.list = list
		this.maskColor = params?.maskColor || 'rgba(24,24,25,0.95)'
		this.startIndex = params?.startIndex || 0
		this.swipeDuration = params?.swipeDuration || 200
		this.showIndex = params?.showIndex ?? list.length > 1
		this.indexPosition = params?.indexPosition || 'bottom'
		this.indexOffset = params?.indexOffset || convertDimensionsWidthUnit(52)
		this.indexFontColor = params?.indexFontColor || IBestActionSheetColor.whiteColor
		this.indexFontSize = params?.indexFontSize || convertDimensionsWidthUnit(14, true)
		this.loop = params?.loop ?? true
		this.doubleScale = params?.doubleScale ?? true
		this.closeOnClickOverlay = params?.closeOnClickOverlay ?? true
		this.closeOnClickImage = params?.closeOnClickImage ?? true
		this.maxScale = params?.maxScale || 3
		this.minScale = params?.minScale || 1
		this.onImgClick = params?.onImgClick
		this.onImgLongPress = params?.onImgLongPress
	}
}

class IBestImagePreviewDataSource implements IDataSource {
	private list: IBestPreviewImgType[] = []

	constructor(list: IBestPreviewImgType[]) {
		this.list = list
	}

	totalCount(): number {
		return this.list.length
	}

	getData(index: number): IBestPreviewImgType {
		return this.list[index]
	}

	registerDataChangeListener(listener: DataChangeListener): void {}

	unregisterDataChangeListener() {}
}

@Component
struct PreviewContent{
	@Prop params: IBestImagePreviewParams = new IBestImagePreviewParams([])
	@State active: number = 0
	@State isDisabledSwiper: boolean = false
	private data: IBestImagePreviewDataSource = new IBestImagePreviewDataSource([])

	aboutToAppear(): void {
		this.active = this.params.startIndex as number
		this.data = new IBestImagePreviewDataSource(this.params.list)
	}
	build() {
		Stack({ alignContent: this.params.indexPosition === 'top' ? Alignment.Top : Alignment.Bottom }){
			Swiper() {
				LazyForEach(this.data, (item: IBestPreviewImgType, index: number) => {
					SwiperItem({
						url: item,
						index: index,
						active: this.active,
						params: this.params,
						isDisabledSwiper: $isDisabledSwiper
					})
				}, (_: IBestPreviewImgType, index: number) => index.toString())
			}
			.width(CONTAINER_SIZE.FULL)
			.height(CONTAINER_SIZE.FULL)
			.index($$this.active)
			.indicator(false)
			.loop(this.params.loop)
			.duration(this.params.swipeDuration)
			.disableSwipe(this.isDisabledSwiper)
			.cachedCount(3)
			if(this.params.showIndex){
				Text(`${this.active + 1} / ${this.params.list.length}`)
					.fontColor(this.params.indexFontColor)
					.fontSize(this.params.indexFontSize ? getSizeByUnit(this.params.indexFontSize, true) : "")
					.offset({ y: `${this.params.indexPosition == "top" ? "" : "-"}${getSizeByUnit(this.params.indexOffset)}` })
			}
		}
	}
}

@Component
struct SwiperItem{
	params: IBestImagePreviewParams = new IBestImagePreviewParams([])
	@Prop url: IBestPreviewImgType
	@Prop index: number
	@Prop @Watch("reset") active: number
	@Link isDisabledSwiper: boolean

	@State uniId: number = 0
	@State rootWidth: number = 0
	@State rootHeight: number = 0
	@State imgWidth: number = 0
	@State imgHeight: number = 0
	@State curScale: number = 1
	@State pinchValue: number = 1
	@State offsetX: number = 0
	@State offsetY: number = 0
	@State startX: number = 0
	@State startY: number = 0
	@State curX: number = 0
	@State curY: number = 0
	@State offsetMaxX: number = 0
	@State offsetMaxY: number = 0
	@State imageRatio: number = 0
	@State isLongImage: boolean = false
	@State imgDraggable: boolean = true

	@State isMoving: boolean = false
	private isImageMoved: boolean = false
	private isFingerMove: boolean = false
	private longImageRatio: number = 2.6
	private lastCenter: CenterLocation = { x: 0, y: 0 }

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
	}
	// 初始化
	init(width: number, height: number){
		let comInfo = getComponentsInfo(this.getUIContext(), `ibest_preview_img_content_${this.uniId}`)
		let rootRatio = comInfo.height / comInfo.width
		this.imgWidth = GlobalStore.px2vp(width)
		this.imgHeight = GlobalStore.px2vp(height)
		this.imageRatio = height / width
		this.rootWidth = comInfo.width
		this.rootHeight = comInfo.height

		this.isLongImage = this.imageRatio > rootRatio && this.imageRatio >= this.longImageRatio
		this.imgDraggable = !this.params.onImgLongPress

		this.setParams(1)
	}
	getCenter(fingers: FingerInfo[]): CenterLocation {
		return {
			x: (fingers[0].localX + fingers[1].localX) / 2,
			y: (fingers[0].localY + fingers[1].localY) / 2,
		}
	}
	getMaxMoveX(){
		if (this.imageRatio) {
			const displayWidth = this.isLongImage ? this.imgWidth : this.rootWidth
			return Math.max(0, (this.curScale * displayWidth - this.rootWidth) / 2)
		}
		return 0
	}
	getMaxMoveY(){
		if (this.imageRatio) {
			const displayHeight = this.isLongImage ? this.rootHeight : this.imgHeight
			return Math.max(0, (this.curScale * displayHeight - this.rootHeight) / 2)
		}
		return 0
	}
	// 获取缩放后图片信息
	getScaleImageInfo(): ScaleImageInfo {
		let scaleWidth = this.imgWidth * this.curScale
		let scaleHeight = this.imgHeight * this.curScale
		return {
			width: scaleWidth,
			height: scaleHeight,
			localLeft: (this.rootWidth - scaleWidth) / 2,
			localTop: (this.rootHeight - scaleHeight) / 2
		}
	}
	// 单击
	singleClick(type: "img" | "mask"){
		if(this.isFingerMove){
			return
		}
		if(type == "img"){
			!this.params.closeOnClickImage && this.params.onImgClick && this.params.onImgClick(this.index)
			this.params.closeOnClickImage && this.params.hide()
		}else{
			this.params.closeOnClickOverlay && this.params.hide()
		}
	}
	// 双击
	doubleClick(fingers: FingerInfo[]){
		if(this.isFingerMove){
			return
		}
		if(this.params.doubleScale){
			let scale = this.curScale == 1 ? 2 : 1
			this.setParams(scale, scale == 2 || this.isLongImage ? { x: fingers[0].localX, y: fingers[0].localY } : undefined)
		}else{
			this.params.closeOnClickImage && this.params.hide()
		}
	}
	// 手指移动
	onFingerMove(event: TouchEvent) {
		switch (event.type){
			case TouchType.Down:
				this.isMoving = this.curScale !== 1 || this.isLongImage
				this.startX = event.touches[0].x
				this.startY = event.touches[0].y
				this.curX = this.offsetX
				this.curY = this.offsetY
				this.isImageMoved = false
				this.isFingerMove = false
				break
			case TouchType.Move:
				let x = event.touches[0].x - this.startX
				let y = event.touches[0].y - this.startY
				this.isFingerMove = x != 0 || y != 0
				let offsetX = this.curX + x
				let offsetY = this.curY + y
				this.isDisabledSwiper = Math.abs(offsetX) <= this.offsetMaxX
				if(this.isMoving){
					if(Math.abs(offsetX) > this.offsetMaxX && !this.isImageMoved){
						this.isMoving = false
						return
					}
					this.isImageMoved = true
					this.offsetX = clamp(offsetX, -this.offsetMaxX, this.offsetMaxX)
					this.offsetY = clamp(offsetY, -this.offsetMaxY, this.offsetMaxY)
				}
				break
			case TouchType.Up:
				this.isMoving = false
				break
		}
	}
	// 设置参数
	setParams(scale: number, lastCenter?: CenterLocation) {
		scale = clamp(scale, +(this.params.minScale as number), +(this.params.maxScale as number) + 1)
		if(scale != this.curScale){
			const ratio = scale / this.curScale
			this.curScale = scale
			this.offsetMaxX = this.getMaxMoveX()
			this.offsetMaxY = this.getMaxMoveY()
			if(lastCenter){
				const imgInfo = this.getScaleImageInfo()
				const moveX = this.offsetX - (lastCenter.x - imgInfo.localLeft - imgInfo.width/2) * (ratio - 1)
				const moveY = this.offsetY - (lastCenter.y - imgInfo.localTop - imgInfo.height/2) * (ratio - 1)

				this.offsetX = clamp(moveX, -this.offsetMaxX, this.offsetMaxX)
				this.offsetY = clamp(moveY, -this.offsetMaxY, this.offsetMaxY)
			} else {
				this.offsetX = 0
				this.offsetY = 0
			}
		}
	}
	// 重置
	reset(){
		this.setParams(1)
	}
	build() {
		Row(){
			Image(this.url)
				.width(this.isLongImage ? "" : CONTAINER_SIZE.FULL)
				.height(this.isLongImage ? CONTAINER_SIZE.FULL : "")
				.objectFit(ImageFit.Contain)
				.scale({ x: this.curScale, y: this.curScale, z: 1 })
				.translate({ x: this.offsetX, y: this.offsetY, z: 0 })
				.draggable(this.imgDraggable)
				.animation({ duration: 100 })
				.onComplete((event) => {
					if(event){
						this.init(event.contentWidth, event.contentHeight)
					}
				})
				.gesture(
					GestureGroup(GestureMode.Exclusive,
						// 双击
						TapGesture({ count: 2 }).onAction((event) => {
							this.doubleClick(event.fingerList)
						}),
						// 单击
						TapGesture().onAction(() => {
							this.singleClick("img")
						})
					)
				)
		}
		.justifyContent(FlexAlign.Center)
		.id(`ibest_preview_img_content_${this.uniId}`)
		.onTouch((event) => {
			this.onFingerMove(event)
		})
		.gesture(
			GestureGroup(GestureMode.Exclusive,
				// 双击
				TapGesture({ count: 2 }).onAction((event) => {
					this.doubleClick(event.fingerList)
				}),
				// 单击
				TapGesture().onAction(() => {
					this.singleClick("mask")
				}),
				// 长按
				LongPressGesture().onAction(() => {
					this.params.onImgLongPress && this.params.onImgLongPress(this.index)
				}),
				// 缩放
				PinchGesture({ fingers: 2 })
					.onActionStart(() => {
						this.pinchValue = this.curScale
					})
					.onActionUpdate((event: GestureEvent) => {
						let scale = Number((this.pinchValue * event.scale).toFixed(1))
						let lastCenter = this.getCenter(event.fingerList)
						this.lastCenter = lastCenter
						this.isMoving = false
						this.isDisabledSwiper = true
						this.setParams(scale, lastCenter)
					})
					.onActionEnd(() => {
						const maxZoom = +(this.params.maxScale as number)
						if (this.curScale > maxZoom) {
							this.setParams(maxZoom, this.lastCenter)
						}
						this.pinchValue = Math.min(this.curScale, maxZoom)
					})
			)
		)
	}
}

@Builder function previewBuilder(params: IBestImagePreviewParams){
	PreviewContent({ params })
}

class ImagePreview{
	private promptAction: PromptAction | null = null
	private contentNode: ComponentContent<IBestImagePreviewParams> | null = null
	/**
	 * 显示预览
	 */
	public async show(list: IBestPreviewImgType[], option?: IBestImagePreviewOption){
		if(this.contentNode){
			return
		}
		let windowClass = GlobalStore.getMainWindow()
		let uiContext = windowClass.getUIContext()
		this.promptAction = uiContext.getPromptAction()
		let opt: IBestImagePreviewParams = new IBestImagePreviewParams(list, option)
		opt.hide = (): void => this.hide()
		let contentNode = new ComponentContent(uiContext, wrapBuilder(previewBuilder), opt)
		this.contentNode = contentNode
		this.promptAction.openCustomDialog(contentNode, {
			alignment: DialogAlignment.Center,
			isModal: true,
			maskColor: opt.maskColor,
			autoCancel: false,
			onDidDisappear: () => {
				this.contentNode?.dispose()
				this.contentNode = null
			}
		})
	}
	/**
	 * 关闭预览
	 */
	public hide(){
		if(this.contentNode && this.promptAction){
			this.promptAction.closeCustomDialog(this.contentNode)
		}
	}
}
export default new ImagePreview()