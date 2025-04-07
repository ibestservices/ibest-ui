import { IBestStringNumber } from "../../model/Global.type"
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { SPACE } from "../../theme-chalk/src/space"
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from "../../utils/utils"
import { IBestHsva, IBestColorFormat } from "./index.type"
import { color2Hsva, hsva2HexColor, hsva2RgbColor, hue2Rgb } from "./util"

@Component
export struct IBestColorPicker{
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 初始颜色值, 仅支持HEX 或 rgb格式
     */
	@Link @Watch("update") value: string
	/**
	 *  颜色格式
     */
	@Prop colorFormat: IBestColorFormat = "hex"
	/**
	 * 面板高度
     */
	@Prop panelHeight: IBestStringNumber = convertDimensionsWidthUnit(180)
	/**
	 * 颜色选取块宽度
     */
	@Prop cursorWidth: IBestStringNumber = convertDimensionsWidthUnit(12)
	/**
	 * 色彩滑块宽度
     */
	@Prop hueSliderWidth: IBestStringNumber = convertDimensionsWidthUnit(16)
	/**
	 * 色彩滑块高度
     */
	@Prop hueSliderHeight: IBestStringNumber = convertDimensionsWidthUnit(8)
	/**
	 * 透明度滑块宽度
     */
	@Prop alphaSliderWidth: IBestStringNumber = convertDimensionsWidthUnit(8)
	/**
	 * 透明度滑块高度
     */
	@Prop alphaSliderHeight: IBestStringNumber = convertDimensionsWidthUnit(16)
	/**
	 * 是否支持透明度选择
     */
	@Prop enableAlpha: boolean = false

	@State uniId: number = 0
	@State realPanelWidth: number = 0
	@State realPanelHeight: number = 0
	@State realHueSliderHeight: number = 0
	@State realAlphaSliderWidth: number = 0
	@State realCursorWidth: number = 0
	@State cursorX: number = 0
	@State cursorY: number = 0
	@State cursorPositionX: number = 0
	@State cursorPositionY: number = 0
	@State hueSliderY: number = 0
	@State hueSliderPositionY: number = 0
	@State alphaSliderX: number = 0
	@State alphaSliderPositionX: number = 0
	@State hsva: IBestHsva = {} as IBestHsva
	@State isLock: boolean = false
	private uiContext = this.getUIContext()

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		setTimeout(() => {
			let panelInfo = getComponentsInfo(this.uiContext, `ibest_colorpicker_panel_${this.uniId}`)
			this.realPanelWidth = panelInfo.width
			this.realPanelHeight = panelInfo.height
			this.realCursorWidth = getComponentsInfo(this.uiContext, `ibest_colorpicker_cursor_${this.uniId}`).width
			this.realHueSliderHeight = getComponentsInfo(this.uiContext, `ibest_colorpicker_hueslider_${this.uniId}`).height
			this.realAlphaSliderWidth = getComponentsInfo(this.uiContext, `ibest_colorpicker_alphaslider_${this.uniId}`).width
			this.hsva = new IBestHsva()
			if(this.value){
				this.setHsva()
			}else{
				this.setValue()
			}
		}, 50)
	}
	// 记录hsv
	setHsva(){
		let hsva = color2Hsva(this.value)
		this.hsva.h = hsva.h
		this.hsva.s = hsva.s
		this.hsva.v = hsva.v
		this.hsva.a = hsva.a
		this.setValue()
	}
	// 根据色相滑块位置获取面板背景颜色
	getPanelBgColor(): string{
		let rgb = hue2Rgb(this.hueSliderY / (this.realPanelHeight - this.realHueSliderHeight / 2))
		return `rgb(${rgb.r}, ${rgb.g}, ${rgb.b})`
	}
	// 当前颜色转rgb颜色
	getAlphaLinearGradient(): [string, number][]{
		let rgb = hue2Rgb(this.hueSliderY / (this.realPanelHeight - this.realHueSliderHeight / 2))
		return [[`rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, 0)`, 0], [`rgb(${rgb.r}, ${rgb.g}, ${rgb.b})`, 1]]
	}
	setH(y: number){
		this.hsva.h = y / this.realPanelHeight
		this.setValue()
	}
	setSv(x: number, y: number){
		this.hsva.s = x / this.realPanelWidth
		this.hsva.v = 1 - (y / this.realPanelHeight)
		this.setValue()
	}
	setAlpha(x: number){
		let a = 0
		if(x == this.realPanelWidth - this.realAlphaSliderWidth/2){
			a = 1
		}else if(x != this.realAlphaSliderWidth/2){
			a = x / this.realPanelWidth
		}
		this.hsva.a = a
		this.setValue()
	}
	// 根据颜色获取选取块、色相滑块位置
	update(){
		let sliderY = this.hsva.h * this.realPanelHeight
		let cursorX = this.hsva.s * this.realPanelWidth
		let cursorY = (1 - this.hsva.v) * this.realPanelHeight
		let alphaX = this.hsva.a == 0 ? this.realAlphaSliderWidth / 2 : this.hsva.a == 1 ? this.realPanelWidth - this.realAlphaSliderWidth / 2 : this.hsva.a * this.realPanelWidth
		this.hueSliderY = sliderY
		this.cursorX = cursorX
		this.cursorY = cursorY
		this.alphaSliderX = alphaX
		if(!this.isLock){
			this.hueSliderPositionY = sliderY
			this.cursorPositionX = cursorX
			this.cursorPositionY = cursorY
			this.alphaSliderPositionX = alphaX
		}
	}
	setValue(){
		let value = ''
		if (this.colorFormat == 'rgb') {
			value = hsva2RgbColor(this.hsva, this.enableAlpha)
		} else {
			value = hsva2HexColor(this.hsva, this.enableAlpha)
		}
		console.log("setValue", value)
		if(value === this.value){
			this.update()
		}else {
			this.value = value
		}
	}

	build() {
		Column({space: SPACE.XS}){
			Row({space: SPACE.XS}){
				Stack(){
					Row()
						.width(CONTAINER_SIZE.FULL)
						.height(CONTAINER_SIZE.FULL)
						.linearGradient({ direction: GradientDirection.Right, colors: [['#ffffff', 0], ['#00ffffff', 1]] })
					Row()
						.width(CONTAINER_SIZE.FULL)
						.height(CONTAINER_SIZE.FULL)
						.linearGradient({ direction: GradientDirection.Top, colors: [['#000', 0], ['#0000', 1]] })
					Row(){
						Row()
							.width(getSizeByUnit(this.cursorWidth))
							.aspectRatio(1)
							.borderRadius(this.baseStyle.borderRadiusMax)
							.border({width: 2, color: "#fff"})
							.shadow({ radius: 2, color: "#0006" })
							.id(`ibest_colorpicker_cursor_${this.uniId}`)
							.translate({x: "-50%", y: "-50%"})
					}
					.position({x: this.cursorX, y: this.cursorY})
					.zIndex(1)
				}
				.layoutWeight(1)
				.height(getSizeByUnit(this.panelHeight))
				.backgroundColor(this.getPanelBgColor())
				.clip(false)
				.id(`ibest_colorpicker_panel_${this.uniId}`)
				.onTouch((e) => {
					if(e.type == TouchType.Down){
						this.setSv(e.touches[0].x, e.touches[0].y)
					}
				})
                .gesture(
					PanGesture({distance: 1})
						.onActionStart(() => {
							this.isLock = true
						})
						.onActionUpdate((event: PanGestureEvent) => {
							let x = this.cursorPositionX + event.offsetX
							let y = this.cursorPositionY + event.offsetY
							x = x < 0 ? 0 : x > this.realPanelWidth ? this.realPanelWidth : x
							y = y < 0 ? 0 : y > this.realPanelHeight ? this.realPanelHeight : y
							this.setSv(x, y)
						})
						.onActionEnd(() => {
							this.isLock = false
							this.cursorPositionX = this.cursorX
							this.cursorPositionY = this.cursorY
						})
				)
				Row(){
					Row()
						.width(CONTAINER_SIZE.FULL)
						.height(`calc(100% - ${this.realHueSliderHeight}vp)`)
						.linearGradient({
							direction: GradientDirection.Bottom,
							colors: [['red', 0], ['#ff0', 0.17], ['#0f0', 0.33], ['#0ff', 0.5], ['#00f', 0.67], ['#f0f', 0.83], ['red', 1]]
						})
					Row()
						.width(CONTAINER_SIZE.FULL)
						.height(getSizeByUnit(this.hueSliderHeight))
						.backgroundColor("#fff")
						.borderRadius(1)
						.border({width: 1, color: "#363637"})
						.shadow({ radius: 2, color: "#0009" })
						.position({x: 0, y: this.hueSliderY})
						.id(`ibest_colorpicker_hueslider_${this.uniId}`)
						.translate({x: 0, y: "-50%"})
				}
				.width(getSizeByUnit(this.hueSliderWidth))
				.height(this.realPanelHeight)
				.backgroundColor(Color.Red)
				.onTouch((e) => {
					if(e.type == TouchType.Down){
						let y = e.touches[0].y
						y = y < this.realHueSliderHeight/2 ? this.realHueSliderHeight/2 : y > this.realPanelHeight - this.realHueSliderHeight/2 ? this.realPanelHeight - this.realHueSliderHeight/2 : y
						this.setH(y)
					}
				})
				.gesture(
					PanGesture({direction: PanDirection.Vertical, distance: 1})
						.onActionStart(() => {
							this.isLock = true
						})
						.onActionUpdate((event: PanGestureEvent) => {
							let y = this.hueSliderPositionY + event.offsetY
							y = y < this.realHueSliderHeight/2 ? this.realHueSliderHeight/2 : y > this.realPanelHeight - this.realHueSliderHeight/2 ? this.realPanelHeight - this.realHueSliderHeight/2 : y
							this.setH(y)
						})
						.onActionEnd(() => {
							this.isLock = false
							this.hueSliderPositionY = this.hueSliderY
						})
				)
			}
			if(this.enableAlpha){
				Stack(){
					Row()
						.width(CONTAINER_SIZE.FULL)
						.height(CONTAINER_SIZE.FULL)
						.linearGradient({ direction: GradientDirection.Right, colors: this.getAlphaLinearGradient() })
					Row()
						.width(getSizeByUnit(this.alphaSliderWidth))
						.height(CONTAINER_SIZE.FULL)
						.backgroundColor("#fff")
						.borderRadius(1)
						.border({width: 1, color: "#363637"})
						.shadow({ radius: 2, color: "#0009" })
						.position({x: this.alphaSliderX, y: 0})
						.id(`ibest_colorpicker_alphaslider_${this.uniId}`)
						.translate({x: "-50%", y: 0})
				}
				.width(this.realPanelWidth)
				.height(getSizeByUnit(this.alphaSliderHeight))
				.backgroundImage($r("app.media.ibest_alpha"), ImageRepeat.X)
				.backgroundImageSize(ImageSize.Contain)
				.onTouch((e) => {
					if(e.type == TouchType.Down){
						let x = e.touches[0].x
						x = x < this.realAlphaSliderWidth/2 ? this.realAlphaSliderWidth/2 : x > this.realPanelWidth - this.realAlphaSliderWidth/2 ? this.realPanelWidth - this.realAlphaSliderWidth/2 : x
						this.setAlpha(x)
					}
				})
				.gesture(
					PanGesture({direction: PanDirection.Horizontal, distance: 1})
						.onActionStart(() => {
							this.isLock = true
						})
						.onActionUpdate((event: PanGestureEvent) => {
							let x = this.alphaSliderPositionX + event.offsetX
							x = x < this.realAlphaSliderWidth/2 ? this.realAlphaSliderWidth/2 : x > this.realPanelWidth - this.realAlphaSliderWidth/2 ? this.realPanelWidth - this.realAlphaSliderWidth/2 : x
							this.setAlpha(x)
						})
						.onActionEnd(() => {
							this.isLock = false
							this.alphaSliderPositionX = this.alphaSliderX
						})
				)
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.alignItems(HorizontalAlign.Start)
	}
}