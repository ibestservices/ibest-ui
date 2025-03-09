import { IBestStringNumber } from '../../model/Global.type'
import GlobalStore from '../../utils/GlobalStore'
import { base64ToPixelMap, getResourceStr } from '../../utils/utils'

interface DrawCanvasItemArgs {
	height: number,
	width: number,
	rotateDeg: number,
	callback: () => void
}
interface CountData {
	countX: number,
	countY: number
}
@Component
export struct WatermarkCanvas {
	@StorageProp("IBestColorMode") @Watch("drawWaterMark") colorMode: ColorMode = ColorMode.LIGHT
	settings: RenderingContextSettings = new RenderingContextSettings(true)
	context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
	/**
	 * 图片水印的宽度
	 */
	@Prop @Watch('drawWaterMark') waterMarkWidth: number = 100
	/**
	 * 图片水印的高度
	 */
	@Prop @Watch('drawWaterMark') waterMarkHeight: number = 100
	/**
	 * 水印透明度
	 */
	@Prop waterMarkOpacity: number = 0.3
	/**
	 * 旋转角度
	 */
	@Prop @Watch('drawWaterMark') rotateDeg: number = -22
	/**
	 * 水印区域的总高度
	 */
	@Prop @Watch('drawWaterMark') waterMarkContainHeight: number = 0
	/**
	 * 水印区域的总宽度
	 */
	@Prop @Watch('drawWaterMark') waterMarkContainWidth: number = 0
	/**
	 * 水印之间的水平间隔 默认0
	 */
	@Prop @Watch('drawWaterMark') gapX: number = 0
	/**
	 * 水印之间的垂直间隔 默认0
	 */
	@Prop @Watch('drawWaterMark') gapY: number = 0
	/**
	 * 图片水印的链接
	 */
	@Prop @Watch('drawWaterMark') imageUrl: ResourceStr = ''
	/**
	 * 文字水印的文案 文字水印优先级高于图片水印
	 */
	@Prop @Watch('drawWaterMark') text: ResourceStr = ''
	/**
	 * 文字的大小
	 */
	@Prop @Watch('drawWaterMark') fontSize: number = 14
	/**
	 * 文字字体
	 */
	@Prop @Watch('drawWaterMark') fontFamily: string = 'sans-serif'
	/**
	 * 文字颜色
	 */
	@Prop @Watch('drawWaterMark') fontColor: IBestStringNumber | CanvasGradient | CanvasPattern = ''
	/**
	 * 绘制完成回调
	 */
	onComplete: (url: string) => void = () => {}
	private resourceManager = GlobalStore.context.resourceManager
	getFontColor() {
		return this.fontColor || (this.colorMode == 0 ? "#f5f5f5" : "#323232")
	}
	getText(){
		return getResourceStr(this.text)
	}
	// 清除画布
	clearCanvas() {
		this.context?.clearRect(0, 0, this.waterMarkWidth, this.waterMarkHeight)
	}
	/**
	 * 获取x轴与y轴的绘制数量
	 * @param width
	 * @param height
	 * @returns
	 */
	getXYCount(width: number, height: number) {
		// 计算出水平数量
		let countX = Math.ceil(this.waterMarkContainWidth / (width + this.gapX))
		// 保证最少有一个
		if (countX <= 0) {
			countX = 1
		}
		// 计算出垂直数量
		let countY = Math.ceil(this.waterMarkContainHeight / (height + this.gapY))
		// 保证最少有一个
		if (countY <= 0) {
			countY = 1
		}
		// 避免因为旋转导致有部分留白 所以多渲染点
		countY = countY + 2
		countX = countX + 2
		const countData: CountData = {
			countX,
			countY
		}
		return countData
	}
	/**
	 * 创建矩阵绘制canvas
	 * @param {number} width 每个绘制块的宽度
	 * @param {number} height 每个绘制块的高度
	 * @param {number} rotateDeg 旋转的角度
	 * @param {()=>void} callback 每次绘制的内容
	 */
	drawCanvasItem(data: DrawCanvasItemArgs) {
		const width = data.width
		const height = data.height
		const rotateDeg = data.rotateDeg
		const callback = data.callback
		const countData = this.getXYCount(width, height)
		const countX = countData.countX
		const countY = countData.countY
		// 根据计算出的数量创建矩阵
		// i是Y轴
		for (let i = 0; i < countY; i++) {
			// j是X轴
			for (let j = 0; j < countX; j++) {
				const x = width * j + this.gapX * j
				const y = height * i + this.gapY * i
				this.context.save()
				this.context.translate(x, y)
				this.context.rotate(rotateDeg)
				callback()
				// 还原之前保存的状态
				this.context.restore()
			}
		}
		let url: string = this.context.toDataURL("png")
		if (url != "data:image/png") {
			this.onComplete(url)
		}
	}
	/**
	 * 绘制图片
	 */
	async handleLayoutImg(rotateDeg: number) {
		let imgModel: PixelMap | ImageBitmap
		if (typeof this.imageUrl == 'string') {
			if(this.imageUrl.startsWith("data:image")){ // base64
				imgModel = await base64ToPixelMap(this.imageUrl)
			} else { // 本地选择的图片 网络图片
				imgModel = new ImageBitmap(this.imageUrl)
			}
		} else {	// Resource
			imgModel = await base64ToPixelMap(this.resourceManager.getMediaContentBase64Sync(this.imageUrl))
		}
		this.drawCanvasItem({
			width: this.waterMarkWidth,
			height: this.waterMarkHeight,
			rotateDeg,
			callback: () => {
				this.context.drawImage(imgModel, 0, 0, this.waterMarkWidth, this.waterMarkHeight)
			}
		})
	}
	/**
	 * 绘制文字
	 */
	handleLayoutText(rotateDeg: number) {
		let text = this.getText()
		this.context.fillStyle = this.getFontColor()
		this.context.font = `${vp2px(this.fontSize)}px ${this.fontFamily}`
		const data = this.context.measureText(text)
		this.drawCanvasItem({
			width: data.width,
			height: data.height,
			rotateDeg,
			callback: () => {
				this.context.fillText(text, 0, 0)
			}
		})
	}
	/**
	 * 绘制水印
	 */
	drawWaterMark() {
		this.clearCanvas()
		this.context.textBaseline = 'top'
		const rotateDeg = this.rotateDeg * Math.PI / 180
		if(this.text){
			this.handleLayoutText(rotateDeg)
		}else if(this.imageUrl){
			this.handleLayoutImg(rotateDeg)
		}
	}
	build() {
		Canvas(this.context)
			.width(this.waterMarkContainWidth)
			.height(this.waterMarkContainHeight)
			.onReady(() => {
				this.drawWaterMark()
			})
			.opacity(0)
			.enabled(false)
	}
}

