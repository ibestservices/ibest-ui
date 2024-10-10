import { ComponentContent, PromptAction, window } from '@kit.ArkUI'
import { CONTAINER_SIZE } from '../theme-chalk/src/container.type'
import { clamp, getComponentsInfo } from '../assets/ets/utils'
import { getDefaultBaseStyle } from '../theme-chalk/src'

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
	/*
	 * 遮罩背景色
	 */
	maskColor?: ResourceColor = 'rgba(24,24,25,0.95)'
	/*
	 * 指定初始显示的图片索引
	 */
	startIndex?: number = 0
	/*
	 * 动画时长
	 */
	swipeDuration?: number = 200
	/*
	 * 是否显示页码
	 */
	showIndex?: boolean = true
	/*
	 * 页码位置
	 */
	indexPosition?: 'top' | 'bottom' = 'bottom'
	/*
	 * 页码距离顶部或底部距离
	 */
	indexOffset?: number = 104
	/*
	 * 页码字体颜色
	 */
	indexFontColor?: ResourceColor
	/*
	 * 页码字体大小
	 */
	indexFontSize?: number = 28
	/*
	 * 是否循环
	 */
	loop?: boolean = true
	/*
	 * 是否启用双击缩放手势，禁用后，点击时会立即关闭图片预览
	 */
	doubleScale?: boolean = true
	/*
	 * 是否在点击遮罩层后关闭图片预览
	 */
	closeOnClickOverlay?: boolean = true
	/*
	 * 是否在点击图片后关闭图片预览
	 */
	closeOnClickImage?: boolean = true
	/*
	 * 最大缩放比例
	 */
	maxScale?: number = 3
	/*
	 * 最小缩放比例
	 */
	minScale?: number = 1
	/*
	 * 图片点击事件
	 */
	onImgClick?: (index: number) => void
	/*
	 * 图片长按事件
	 */
	onImgLongPress?: (index: number) => void
}

class IBestImagePreviewParams extends IBestImagePreviewOption {
	list: IBestPreviewImgType[] = []
	// 关闭
	hide: () => void = () => {}
	constructor(list: IBestPreviewImgType[], params?: IBestImagePreviewOption) {
		let baseStyle = getDefaultBaseStyle()
		super()
		this.list = list
		this.maskColor = params?.maskColor || 'rgba(24,24,25,0.95)'
		this.startIndex = params?.startIndex || 0
		this.swipeDuration = params?.swipeDuration || 200
		this.showIndex = params?.showIndex != undefined ? params.showIndex : true
		this.indexPosition = params?.indexPosition || 'bottom'
		this.indexOffset = params?.indexOffset || 104
		this.indexFontColor = params?.indexFontColor != undefined ? params.indexFontColor : baseStyle.default as string
		this.indexFontSize = params?.indexFontSize != undefined ? params.indexFontSize : 28
		this.loop = params?.loop != undefined ? params.loop : true
		this.doubleScale = params?.doubleScale != undefined ? params.doubleScale : true
		this.closeOnClickOverlay = params?.closeOnClickOverlay != undefined ? params.closeOnClickOverlay : true
		this.closeOnClickImage = params?.closeOnClickImage != undefined ? params.closeOnClickImage : true
		this.maxScale = params?.maxScale || 3
		this.minScale = params?.minScale || 1
		this.onImgClick = params?.onImgClick
		this.onImgLongPress = params?.onImgLongPress
	}
}

class MyDataSource implements IDataSource {
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

	registerDataChangeListener(listener: DataChangeListener): void {
	}

	unregisterDataChangeListener() {
	}
}

@Component
struct PreviewContent{
	params: IBestImagePreviewParams = new IBestImagePreviewParams([])
	private data: MyDataSource = new MyDataSource([])
	@State active: number = 0
	@State isMoving: boolean = false

	aboutToAppear(): void {
		this.data = new MyDataSource(this.params.list)
		this.active = this.params.startIndex as number
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
						isMoving: $isMoving
					})
				}, (item: IBestPreviewImgType, index: number) => index + "")
			}
			.width(CONTAINER_SIZE.FULL)
			.height(CONTAINER_SIZE.FULL)
			.index($$this.active)
			.indicator(false)
			.loop(this.params.loop)
			.duration(this.params.swipeDuration)
			.disableSwipe(this.isMoving)
			if(this.params.showIndex){
				Text(`${this.active + 1} / ${this.data.totalCount()}`)
					.fontColor(this.params.indexFontColor)
					.fontSize(this.params.indexFontSize + "lpx")
					.offset({ y: `${this.params.indexPosition == "top" ? "" : "-"}${this.params.indexOffset}lpx` })
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
	@Link isMoving: boolean
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

	private isImageMoved: boolean = false
	private longImageRatio: number = 2.6
	private lastCenter: CenterLocation = { x: 0, y: 0 }

	// 初始化
	init(width: number, height: number){
		let comInfo = getComponentsInfo(this.getUIContext(), "ibestPreviewImgContent")
		let rootRatio = comInfo.height / comInfo.width
		this.imgWidth = px2vp(width)
		this.imgHeight = px2vp(height)
		this.imageRatio = height / width
		this.rootWidth = px2vp(lpx2px(comInfo.width))
		this.rootHeight = px2vp(lpx2px(comInfo.height))

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
	// 双击
	doubleClick(fingers: FingerInfo[]){
		let scale = this.curScale == 1 ? 2 : 1
		this.setParams(scale, scale == 2 || this.isLongImage ? { x: fingers[0].localX, y: fingers[0].localY } : undefined)
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
				break
			case TouchType.Move:
				if(this.isMoving){
					let x = event.touches[0].x - this.startX
					let y = event.touches[0].y - this.startY
					let offsetX = this.curX + x
					let offsetY = this.curY + y
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
			this.pinchValue = scale
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
				.animation({
					duration: 200
				})
				.onComplete((event) => {
					if(event){
						this.init(event.contentWidth, event.contentHeight)
					}
				})
				.gesture(
					GestureGroup(GestureMode.Exclusive,
						// 双击
						TapGesture({ fingers: 1, count: 2 }).onAction((event) => {
							if(this.params.doubleScale){
								this.doubleClick(event.fingerList)
							}else{
								this.params.closeOnClickImage && this.params.hide()
							}
						}),
						// 单击
						TapGesture({ fingers: 1, count: 1 }).onAction(() => {
							!this.params.closeOnClickImage && this.params.onImgClick && this.params.onImgClick(this.index)
							this.params.closeOnClickImage && !this.isImageMoved && this.params.hide()
						}),
						// 长按
						LongPressGesture({ fingers: 1 }).onAction(() => {
							this.params.onImgLongPress && this.params.onImgLongPress(this.index)
						})
					)
				)
				.gesture(
					// 缩放
					PinchGesture({ fingers: 2 })
						.onActionUpdate((event: GestureEvent) => {
							let scale = Number((this.pinchValue * event.scale).toFixed(1))
							let lastCenter = this.getCenter(event.fingerList)
							this.lastCenter = lastCenter
							this.isMoving = false
							this.setParams(scale, lastCenter)
						})
						.onActionEnd(() => {
							const maxZoom = +(this.params.maxScale as number)
							if (this.curScale > maxZoom) {
								this.setParams(maxZoom, this.lastCenter)
							}
							this.pinchValue = this.curScale
						})
				)
		}
		.justifyContent(FlexAlign.Center)
		.id("ibestPreviewImgContent")
		.onTouch((event) => {
			this.onFingerMove(event)
		})
		.gesture(
			GestureGroup(GestureMode.Exclusive,
				// 双击
				TapGesture({ fingers: 1, count: 2 }).onAction((event) => {
					if(this.params.doubleScale){
						this.doubleClick(event.fingerList)
					}else{
						this.params.closeOnClickImage && this.params.hide()
					}
				}),
				// 单击
				TapGesture({ fingers: 1, count: 1 }).onAction(() => {
					this.params.closeOnClickOverlay && !this.isImageMoved && this.params.hide()
				})
			)
		)
	}
}

@Builder function previewBuilder(params: IBestImagePreviewParams){
	PreviewContent({ params })
}

class ImagePreview{
	private static _instance: ImagePreview | null = null
	private contentNode: ComponentContent<IBestImagePreviewParams> | null = null
	private promptAction: PromptAction | null = null

	private static getInstance(contentNode: ComponentContent<IBestImagePreviewParams>, promptAction: PromptAction): ImagePreview{
		if(!ImagePreview._instance){
			ImagePreview._instance = new ImagePreview()
		}
		ImagePreview._instance.contentNode = contentNode
		ImagePreview._instance.promptAction = promptAction
		return ImagePreview._instance
	}
	/*
	 * 显示
	 */
	public static async show(list: IBestPreviewImgType[], option?: IBestImagePreviewOption){
		let opt: IBestImagePreviewParams = new IBestImagePreviewParams(list, option)
		opt.hide = (): void => ImagePreview.hide()
		if(ImagePreview._instance?.contentNode){
			ImagePreview.hide()
		}
		let windowClass = await window.getLastWindow(getContext())
		let uiContext = windowClass.getUIContext()
		let contentNode = new ComponentContent(uiContext, wrapBuilder(previewBuilder), opt)
		let promptAction = uiContext.getPromptAction()
		ImagePreview._instance = ImagePreview.getInstance(contentNode, promptAction)
		promptAction.openCustomDialog(contentNode, {
			alignment: DialogAlignment.Center,
			isModal: true,
			maskColor: opt.maskColor,
			autoCancel: false
		})
	}

	/*
	 * 关闭
	 */
	static hide(){
		if(ImagePreview._instance){
			ImagePreview._instance.promptAction?.closeCustomDialog(ImagePreview._instance.contentNode)
			ImagePreview._instance.contentNode?.dispose()
			ImagePreview._instance.contentNode = null
		}
	}
}
export default ImagePreview