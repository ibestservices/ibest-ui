import { image } from '@kit.ImageKit'
import common from '@ohos.app.ability.common'
import { dealUrlToSandbox, getComponentsInfo, getComponentSnapshot, getSizeByUnit } from '../../utils/utils'
import { IBestImageCropperController } from './index.type'
import { IBestImageCropperColor } from './color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestImageCropper {
	/**
	 * 组件宽度
     */
	@Prop componentWidth: IBestStringNumber = "100%"
	/**
	 * 组件高度
     */
	@Prop componentHeight: IBestStringNumber = "100%"
	/**
	 * 背景色
     */
	@Prop bgColor: ResourceColor = "#000"
	/**
	 * 需要裁剪的图片地址
     */
	@Prop @Watch("init") url: ResourceStr = ""
	/*
	 * 裁剪形状
	 */
	@Prop shape: 'rect' | 'circle' = "rect"
	/**
	 * 蒙层颜色
     */
	@Provide({allowOverride: "maskColor"}) maskColor: ResourceColor = "rgba(0,0,0,0.6)"
	/**
	 * 裁剪区域宽度或直径
     */
	@Prop centerWidth: IBestStringNumber = "60%"
	/**
	 * 裁剪区域高度, 仅当shape为rect时有效
     */
	@Prop centerHeight: IBestStringNumber = "60%"
	/**
	 * 是否显示裁剪区域边框
     */
	@Prop showBorder: boolean = true
	/**
	 * 边框颜色
     */
	@Prop bdColor: ResourceColor = IBestImageCropperColor.borderColor
	/**
	 * 最大缩放比例
	 */
	@Prop maxScale: number = 2
	/**
	 * 是否开启旋转, 开启后不可移动
	 * @since 2.1.8
     */
	@Prop @Watch("enableRotateChange") enableRotate: boolean = false
	/**
	 * 最大旋转角度, 默认180°, 即顺时针最大180°, 逆时针最大180°
	 * @since 2.1.8
     */
	@Prop maxAngle: number = 180
	/**
	 * 控制器实例
     */
	controller: IBestImageCropperController = new IBestImageCropperController()

	@State uniId: number = 0
	@State scaleValue: number = 1
	private pinchScaleValue: number = 1
	@State offsetX: number = 0
	@State offsetY: number = 0
	private positionX: number = 0
	private positionY: number = 0
	@State angle: number = 0
	private pinchAngle: number = 0
	@State imgInitWidth: number = 0
	@State imgInitHeight: number = 0
	@State imgWidth: number = 0
	@State imgHeight: number = 0
	@State offsetMaxX: number = 0
	@State offsetMaxY: number = 0
	@State realCenterWidth: number = 0
	@State realCenterHeight: number = 0
	private imgModel: PixelMap | null = null
	private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left | PanDirection.Right
	| PanDirection.Up | PanDirection.Down })
	private settings: RenderingContextSettings = new RenderingContextSettings(true)
	private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
	private uiContext = this.getUIContext()
	private pageContext = this.uiContext.getHostContext() as common.UIAbilityContext

	@Builder corner(angle: number = 0){
		Path()
			.width(this.realCenterWidth/2)
			.aspectRatio(1)
			.fill(this.maskColor)
			.commands(this.getCommands())
			.stroke(Color.Transparent)
			.rotate({z: 1, angle})
	}

	aboutToAppear() {
		this.uniId = this.getUniqueId()
		this.controller.setScale = (scale: number): void => this.setScale(scale)
		this.controller.setAngle = (angle: number): void => this.setAngle(angle)
		this.controller.reset = (): void => this.reset()
		this.controller.getResult = (callBack?: (result: PixelMap) => void): Promise<PixelMap> => this.getResult(callBack)
		this.getCenterSize()
	}
	enableRotateChange(){
		this.pinchAngle = this.angle = 0
		this.positionX = this.positionY = this.offsetX = this.offsetY = 0
	}
	// 获取透镜尺寸
	getCenterSize(){
		setTimeout(() => {
			let size = getComponentsInfo(this.uiContext, this.getId())
			this.realCenterWidth = size.width
			this.realCenterHeight = this.shape == 'circle' ? size.width : size.height
			if (this.url) {
				this.init()
			}
		}, 50)
	}
	// 根据图片信息初始化参数
	async init() {
		if(!this.url){
			this.imgModel = null
			return
		}
		this.resetParams()
		let path = `${this.pageContext.cacheDir}/ibestImageCropper_${this.uniId}.jpg`
		await dealUrlToSandbox(this.pageContext, this.url, path, () => {
			this.getImageInfo(path)
		})
		this.getImageInfo(path)
	}
	// 获取图片信息
	async getImageInfo(path: string) {
		let imageSource = image.createImageSource(path)
		this.imgModel = await imageSource.createPixelMap()
		let imageInfo = await imageSource.getImageInfo()
		let width = this.uiContext.px2vp(imageInfo.size.width)
		let height = this.uiContext.px2vp(imageInfo.size.height)
		let aspect = width / height
		if (width > height) { // 横向图片
			this.imgInitHeight = this.realCenterHeight
			this.imgInitWidth = this.imgInitHeight * aspect
		} else { // 纵向图片
			this.imgInitWidth = this.realCenterWidth
			this.imgInitHeight = this.imgInitWidth / aspect
		}
		this.setParams()
	}
	// 设置参数
	setParams() {
		this.setImgSize()
		this.offsetMaxX = Math.abs(Number(((this.imgWidth - this.realCenterWidth) / 2).toFixed()))
		this.offsetMaxY = Math.abs(Number(((this.imgHeight - this.realCenterHeight) / 2).toFixed()))
		this.offsetX = this.offsetX >= this.offsetMaxX ? this.offsetMaxX : this.offsetX <= -this.offsetMaxX ? -this.offsetMaxX : this.offsetX
		this.offsetY = this.offsetY >= this.offsetMaxY ? this.offsetMaxY : this.offsetY <= -this.offsetMaxY ? -this.offsetMaxY : this.offsetY
		this.positionX = this.offsetX
		this.positionY = this.offsetY
	}
	// 设置图片动态尺寸
	setImgSize() {
		this.imgWidth = Number((this.imgInitWidth * this.scaleValue).toFixed())
		this.imgHeight = Number((this.imgInitHeight * this.scaleValue).toFixed())
	}
	// 重置参数
	resetParams(){
		this.scaleValue = 1
		this.pinchScaleValue = 1
		this.offsetX = 0
		this.offsetY = 0
		this.positionX = 0
		this.positionY = 0
		this.offsetMaxX = 0
		this.offsetMaxY = 0
		this.angle = 0
		this.pinchAngle = 0
	}
	getCommands(){
		let width = this.uiContext.vp2px(this.realCenterWidth/2)
		return `M0 ${width} V0 0 L${width} 0 A${width} ${width} 0 0 0 0 ${width}`
	}
	getId(){
		return `ibest_imagecrop_${this.uniId}`
	}
	// 绘制
	drawImg(){
		this.context.clearRect(0, 0, this.realCenterWidth, this.realCenterHeight)
		this.context.reset()
		this.context.translate(this.realCenterWidth / 2, this.realCenterHeight / 2)
		this.context.rotate(this.angle * Math.PI / 180)
		this.context.drawImage(this.imgModel, this.offsetX - this.imgWidth / 2, this.offsetY - this.imgHeight / 2, this.imgWidth, this.imgHeight)
	}
	// 设置比例
	setScale(scale: number){
		scale = scale < 1 ? 1 : scale > this.maxScale ? this.maxScale : scale
		this.pinchScaleValue = this.scaleValue = scale
		this.setParams()
	}
	// 设置角度
	setAngle(angle: number){
		if(this.enableRotate){
			angle = angle < -this.maxAngle ? -this.maxAngle : angle > this.maxAngle ? this.maxAngle : angle
			this.pinchAngle = this.angle = angle
		}else {
			console.warn('旋转功能未启用')
		}
	}
	// 重置
	reset(){
		this.resetParams()
		this.setParams()
	}
	// 获取最终截取结果
	getResult(callBack?: (result: PixelMap) => void): Promise<PixelMap> {
		return new Promise((resolve, reject) => {
			this.drawImg()
			setTimeout(() => {
				let res = getComponentSnapshot(this.uiContext, this.getId())
				if(callBack){
					callBack(res)
				}else{
					resolve(res)
				}
			}, 100)
		})
	}
	build() {
		Stack({ alignContent: Alignment.Center }) {
			Image(this.imgModel)
				.width(this.imgInitWidth)
				.height(this.imgInitHeight)
				.objectFit(ImageFit.Contain)
				.scale({ x: this.scaleValue, y: this.scaleValue, z: 1 })
				.translate({ x: this.offsetX, y: this.offsetY, z: 0 })
				.rotate({z: 1, angle: this.angle})
				.animation({
					duration: 100
				})
				.visibility(this.url ? Visibility.Visible : Visibility.Hidden)
			Canvas(this.context)
				.width(getSizeByUnit(this.centerWidth))
				.height(getSizeByUnit(this.centerHeight))
				.aspectRatio(this.shape == 'circle' ? 1 : undefined)
				.borderRadius(this.shape == 'circle' ? this.realCenterWidth / 2 : 0)
				.position({left: -9999, top: -9999})
				.clip(true)
				.id(this.getId())
			Column(){
				Row()
					.width(CONTAINER_SIZE.FULL)
					.layoutWeight(1)
					.backgroundColor(this.maskColor)
				Row(){
					Row()
						.layoutWeight(1)
						.height(CONTAINER_SIZE.FULL)
						.backgroundColor(this.maskColor)
					Stack({alignContent: Alignment.Center}){
						if(this.shape == 'circle'){
							Flex({wrap: FlexWrap.Wrap}){
								this.corner()
								this.corner(90)
								this.corner(-90)
								this.corner(180)
							}
							if(this.showBorder){
								Circle()
									.width(this.realCenterWidth-1)
									.aspectRatio(1)
									.fillOpacity(0)
									.stroke(this.bdColor)
							}
						}
					}
					.width(getSizeByUnit(this.centerWidth))
					.height(CONTAINER_SIZE.FULL)
					.border({width: this.shape == 'rect' && this.showBorder ? 1 : 0, color: this.bdColor})
					.clip(true)
					Row()
						.layoutWeight(1)
						.height(CONTAINER_SIZE.FULL)
						.backgroundColor(this.maskColor)
				}
				.width(CONTAINER_SIZE.FULL)
				.height(this.realCenterHeight)
				Row()
					.width(CONTAINER_SIZE.FULL)
					.layoutWeight(1)
					.backgroundColor(this.maskColor)
			}
			.width(CONTAINER_SIZE.FULL)
			.height(CONTAINER_SIZE.FULL)
		}
		.width(getSizeByUnit(this.componentWidth))
		.height(getSizeByUnit(this.componentHeight))
		.backgroundColor(this.bgColor)
		.clip(true)
		.gesture(
			// 移动
			PanGesture(this.panOption)
				.onActionUpdate((event: GestureEvent) => {
					let x = Number((this.positionX + event.offsetX).toFixed())
					let y = Number((this.positionY + event.offsetY).toFixed())
					this.offsetX = x >= this.offsetMaxX ? this.offsetMaxX : x <= -this.offsetMaxX ? -this.offsetMaxX : x
					this.offsetY = y >= this.offsetMaxY ? this.offsetMaxY : y <= -this.offsetMaxY ? -this.offsetMaxY : y
				})
				.onActionEnd(() => {
					this.positionX = this.offsetX
					this.positionY = this.offsetY
				})
		)
		.gesture(
			GestureGroup(GestureMode.Parallel,
				// 缩放
				PinchGesture({ fingers: 2 })
					.onActionUpdate((event: GestureEvent) => {
						let scale = Number((this.pinchScaleValue * event.scale).toFixed(1))
						this.scaleValue = scale
						this.setImgSize()
					})
					.onActionEnd(() => {
						this.scaleValue = this.scaleValue < 1 ? 1 : this.scaleValue > this.maxScale ? this.maxScale : this.scaleValue
						this.pinchScaleValue = this.scaleValue
						this.setParams()
					}),
				// 旋转
				RotationGesture({ fingers: 2 })
					.onActionUpdate((event: GestureEvent) => {
						let angle = this.pinchAngle + event.angle
						angle = angle < -this.maxAngle ? -this.maxAngle : angle > this.maxAngle ? this.maxAngle : angle
						this.angle = angle
					})
					.onActionEnd(() => {
						this.pinchAngle = this.angle
					})
			)
		)
		.onGestureJudgeBegin((gestureInfo: GestureInfo) => {
			if (gestureInfo.type == GestureControl.GestureType.PAN_GESTURE && this.enableRotate || gestureInfo.type == GestureControl.GestureType.ROTATION_GESTURE && !this.enableRotate) {
				return GestureJudgeResult.REJECT
			}
			return GestureJudgeResult.CONTINUE
		})
	}
}