import { IBestCanvasContent } from './index.type';
import { base64ToPixelMap, getComponentSnapshot, getSizeByUnit, sleep } from '../../utils/utils';
import { IBestStringNumber } from '../../model/Global.type';

@Component
export struct IBestCanvasDrawer{
	/**
	 * 画板宽度
     */
	@Prop canvasWidth: IBestStringNumber = 0
	/**
	 * 画板高度
     */
	@Prop canvasHeight: IBestStringNumber = 0
	/**
	 * 画板背景色
     */
	@Prop canvasBgColor: ResourceColor = "#fff"
	/**
	 * 画板渐变背景色
     */
	@Prop linerGradient: LinearGradient
	/**
	 * 画板背景图片
     */
	@Prop canvasBgImg: ResourceStr | PixelMap = ""
	/**
	 * 圆角
	 */
	@Prop radius: IBestStringNumber = 0
	/**
	 * 内容列表
     */
	@Prop @Watch("contentChange") contentList: IBestCanvasContent[] = []
	/**
	 * 绘制完毕回调
     */
	onDrawFinish: (pixelMap: PixelMap) => void = () => {}

	@State uniId: number = 0
	private uiContext = this.getUIContext()
	private context = this.uiContext.getHostContext()!
	private settings: RenderingContextSettings = new RenderingContextSettings(true)
	private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
	private resourceManager = this.context.resourceManager

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
	}
	contentChange(){
		if(this.contentList.length){
			this.startPainting()
		}
	}
	// 开始绘画
	async startPainting() {
		this.ctx.clearRect(0, 0, this.ctx.width, this.ctx.height)
		if(this.contentList.length){
			for (let item of this.contentList) {
				switch (item.type) {
					case "image":
						await this.drawImage(item)
						break
					case "text":
						this.drawText(item)
						break
				}
			}
		}
		this.createUrl()
	}
	// 绘制图片
	async drawImage(params: IBestCanvasContent) {
		this.ctx.save()
		let url = params.url
		let width = params.width || 0
		let height = params.height || 0
		let top = params.bottom != undefined ? this.ctx.height - height - params.bottom : (params.top || 0)
		let left = params.right != undefined ? this.ctx.width - width - params.right : (params.left || 0)
		let borderRadius = params.borderRadius || 0
		let deg = params.deg || 0
		let imgModel: PixelMap | ImageBitmap
		if (typeof url == 'string') {
			if(url.startsWith("data:image")){ // base64
				imgModel = await base64ToPixelMap(url)
			} else { // 本地选择的图片/网络图片
				imgModel = new ImageBitmap(url)
			}
		} else {	// Resource
			imgModel = await base64ToPixelMap(this.resourceManager.getMediaContentBase64Sync(url?.id))
		}
		if (deg) {
			this.ctx.translate(left + width / 2, top + height / 2)
			this.ctx.rotate(deg * Math.PI / 180)
		}
		if (borderRadius) {
			this.ctx.beginPath()
			if(deg){
				let transLeft = width/2,
				    transTop = height/2
				this.ctx.moveTo(-transLeft, -transTop + borderRadius)
				this.ctx.arcTo(-transLeft, -transTop, -transLeft + borderRadius, -transTop, borderRadius)
				this.ctx.lineTo(transLeft - borderRadius, -transTop)
				this.ctx.arcTo(transLeft, -transTop, transLeft, -transTop + borderRadius, borderRadius)
				this.ctx.lineTo(transLeft, transTop - borderRadius)
				this.ctx.arcTo(transLeft, transTop, transLeft - borderRadius, transTop, borderRadius)
				this.ctx.lineTo(-transLeft + borderRadius, transTop)
				this.ctx.arcTo(-transLeft, transTop, -transLeft, transTop - borderRadius, borderRadius)
			}else{
				this.ctx.moveTo(left, top + borderRadius)
				this.ctx.arcTo(left, top, left + borderRadius, top, borderRadius)
				this.ctx.lineTo(left + width - borderRadius, top)
				this.ctx.arcTo(left + width, top, left + width, top + borderRadius, borderRadius)
				this.ctx.lineTo(left + width, top + height - borderRadius)
				this.ctx.arcTo(left + width, top + height, left + width - borderRadius, top + height, borderRadius)
				this.ctx.lineTo(left + borderRadius, top + height)
				this.ctx.arcTo(left, top + height, left, top + height - borderRadius, borderRadius)
			}
			this.ctx.closePath()
			this.ctx.clip()
		}
		if (deg) {
			this.ctx.drawImage(imgModel, -width / 2, -height / 2, width, height)
			this.ctx.resetTransform()
		} else {
			this.ctx.drawImage(imgModel, left, top, width, height)
		}
		this.ctx.restore()
	}
	// 画文字
	drawText(params: IBestCanvasContent) {
		this.ctx.save()
		let textAlign = params.textAlign || 'left',
			fontColor = params.fontColor || '#000',
			fontSize = params.fontSize || 16,
			fontWeight = params.fontWeight || "normal"
		this.ctx.textBaseline = 'top'
		this.ctx.textAlign = textAlign
		this.ctx.fillStyle = fontColor
		this.ctx.font = `normal ${fontWeight} ${fontSize}vp sans-serif`
		let text = typeof params.text == "string" ? params.text : this.resourceManager.getStringSync(params.text?.id)
		let result = this.ctx.measureText(text)
		let maxLineNumber = params.maxLineNumber || 1,
			top = params.top || 0,
			left = params.left || 0,
			right = params.right || 0,
			lineHeight = params.lineHeight || result.height,
			width = params.width || (this.ctx.width - (right || left)),
			textDecoration = params.textDecoration || ''
		let textLeft = textAlign == "center" ? width / 2 + (right || left) : textAlign == "right" ? right ? this.ctx.width - right : (left+width) : left
		if (maxLineNumber == 1) {
			text = this.getLimitStr(text, text, width)
			let textSize = this.ctx.measureText(text)
			this.ctx.fillText(text, textLeft, top)
			if(textDecoration){
				let lineLeft = right ? this.ctx.width - width - right : left
				this.drawTextLine(lineLeft, top + textSize.height, textDecoration, textSize, fontColor)
			}
		} else {
			let fillText = ''
			let fillTop = top
			let lineNum = 1
			for (let i = 0; i < text.length; i++) {
				fillText += text[i]
				let fillTextSize = this.ctx.measureText(fillText)
				if (fillTextSize.width > width) {
					if (lineNum === maxLineNumber) {
						if (i !== text.length - 1) {
							fillText = fillText.substring(0, fillText.length - 1) + '…'
							this.ctx.fillText(fillText, textLeft, fillTop)
							if(textDecoration) {
								let lineLeft = right ? this.ctx.width - width - right : left
								this.drawTextLine(lineLeft, fillTop + fillTextSize.height, textDecoration, fillTextSize, fontColor)
							}
							break
						}
					}
					this.ctx.fillText(fillText, textLeft, fillTop)
					if(textDecoration){
						let lineLeft = right ? this.ctx.width - width - right : left
						this.drawTextLine(lineLeft, fillTop + fillTextSize.height, textDecoration, fillTextSize, fontColor)
					}
					fillText = ''
					fillTop += lineHeight
					lineNum++
				}else if (i === text.length - 1) {
					this.ctx.fillText(fillText, textLeft, fillTop)
					if(textDecoration){
						let offsetLeft = textAlign == "center" ? (width - fillTextSize.width) / 2 : textAlign == "right" ? width - fillTextSize.width : 0
						let lineLeft = (right ? this.ctx.width - width - right : left) + offsetLeft
						this.drawTextLine(lineLeft, fillTop + fillTextSize.height, textDecoration, fillTextSize, fontColor)
					}
				}
			}
		}
		this.ctx.restore()
	}
	getLimitStr(originStr: string, str: string, maxWidth: number): string{
		let originWidth = this.ctx.measureText(originStr).width
		let omitContent = originWidth > maxWidth ? '…' : ''
		let strWidth = this.ctx.measureText(str + omitContent).width
		if (originWidth > maxWidth && strWidth > maxWidth) {
			return this.getLimitStr(originStr, str.slice(0, str.length - 1), maxWidth)
		}
		return str + omitContent
	}
	// 划线
	drawTextLine(left: number, top: number, textDecoration: string, size: TextMetrics, color: IBestStringNumber |CanvasGradient | CanvasPattern) {
		this.ctx.save()
		this.ctx.beginPath()
		this.ctx.strokeStyle = color
		if (textDecoration === 'underline') {
			this.ctx.moveTo(left, top)
			this.ctx.lineTo(left + size.width, top)
			this.ctx.stroke()
		} else {
			let lineTop = top - size.height / 2
			this.ctx.moveTo(left, lineTop)
			this.ctx.lineTo(left + size.width, lineTop)
			this.ctx.stroke()
		}
		this.ctx.restore()
	}
	async createUrl(){
		await sleep(500)
		let pixelMap = getComponentSnapshot(this.uiContext, `ibest_poster_${this.uniId}`)
		this.onDrawFinish(pixelMap)
	}

	build() {
		Canvas(this.ctx)
			.width(getSizeByUnit(this.canvasWidth))
			.height(getSizeByUnit(this.canvasHeight))
			.borderRadius(getSizeByUnit(this.radius))
			.backgroundColor(this.canvasBgColor)
			.linearGradient(this.linerGradient)
			.backgroundImage(this.canvasBgImg)
			.backgroundImageSize({width: "100%", height: "100%"})
			.clip(true)
			.position({ x: -2000, y: -2000})
			.id(`ibest_poster_${this.uniId}`)
			.onReady(() => {
				this.startPainting()
			})
	}
}