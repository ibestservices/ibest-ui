import { IBestStringNumber } from "../../model/Global.type"
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from "../../utils/utils"
import { IBestHsva, IBestColorFormat, IBestFormatPredefineColor } from "./index.type"
import { color2Hsva, getRgbaStr, hsva2HexColor, hsva2RgbColor } from "./util"
import { LengthMetrics } from "@kit.ArkUI"
@Component
export struct IBestColorPicker{
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 初始颜色值, 仅支持HEX 或 rgb格式
     */
	@Link @Watch("valueChange") value: string
	/**
	 *  颜色格式
     */
	@Prop colorFormat: IBestColorFormat = "hex"
	/**
	 * 是否支持透明度选择
	 */
	@Prop enableAlpha: boolean = false
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
	 * 颜色面板与色相滑块之间的距离
     */
	@Prop panelHueSpace: IBestStringNumber = this.baseStyle.spaceSm as string
	/**
	 * 颜色面板与透明度滑块之间的距离
     */
	@Prop panelAlphaSpace: IBestStringNumber = this.baseStyle.spaceSm as string
	/**
	 * 预定颜色
     */
	@Prop predefineColors: string[] = []
	/**
	 * 预定颜色块宽度
	 */
	@Prop predefineBlockWidth: IBestStringNumber = convertDimensionsWidthUnit(20)
	/**
	 * 颜色值变化时触发
     */
	onChange: (value: string) => void = () => {}

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
	@State formatPredefineColor: IBestFormatPredefineColor[] = []
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
			this.initColorFormat()
			if(this.value){
				this.setHsva()
			}else{
				this.update()
			}
			if(this.predefineColors.length){
				this.getFormatPredefineColor()
			}
		}, 50)
	}
	// 初始化 colorFormat
	initColorFormat(){
		if(this.value.startsWith("#") && this.colorFormat != 'hex'){
			this.colorFormat = "hex"
		}else if(this.value.startsWith("rgb") && this.colorFormat != 'rgb'){
			this.colorFormat = "rgb"
		}
	}
	// 格式化 预设颜色
	getFormatPredefineColor(){
		let colors = this.predefineColors.filter(e => e.startsWith("#") || e.startsWith("rgb"))
		this.formatPredefineColor = colors.map((e) => {
			let obj: IBestFormatPredefineColor = {
				origin: e,
				format: ""
			}
			if(this.colorFormat == 'hex'){
				obj.format = hsva2HexColor(color2Hsva(e, this.enableAlpha), this.enableAlpha)
			}else {
				let rgb = hsva2RgbColor(color2Hsva(e, this.enableAlpha))
				obj.format = getRgbaStr(rgb, this.enableAlpha)
			}
			return obj
		})
	}
	valueChange(){
		if(this.value){
			this.setHsva()
		}
	}
	// 记录hsv
	setHsva(value?: string){
		let hsva = color2Hsva(value || this.value, this.enableAlpha)
		this.hsva.h = hsva.h
		this.hsva.s = hsva.s
		this.hsva.v = hsva.v
		this.hsva.a = hsva.a
		this.setValue()
	}
	// 获取面板背景颜色
	getPanelBgColor(): string{
		let h = this.hueSliderY / (this.realPanelHeight - this.realHueSliderHeight / 2)
		return getRgbaStr(hsva2RgbColor({h, s: 1, v: 1, a: 1}), false)
	}
	// 获取透明度面板渐变色
	getAlphaLinearGradient(): [string, number][]{
		let h = this.hueSliderY / (this.realPanelHeight - this.realHueSliderHeight / 2)
		let rgb = hsva2RgbColor({h, s: 1, v: 1, a: 1})
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
	// 更新坐标
	update(){
		let sliderY = this.hsva.h == 0 ? this.realHueSliderHeight / 2 : this.hsva.h == 1 ? this.realPanelHeight - this.realHueSliderHeight / 2 :  this.hsva.h * this.realPanelHeight
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
			value = getRgbaStr(hsva2RgbColor(this.hsva), this.enableAlpha)
		} else {
			value = hsva2HexColor(this.hsva, this.enableAlpha)
		}
		if(value === this.value){
			this.update()
		}else {
			this.value = value
			this.onChange(value)
		}
	}
	// 选择预设颜色
	choosePredefineColor(item: IBestFormatPredefineColor){
		if(this.value != item.format){
			this.setHsva(item.format)
		}
	}

	build() {
		Column({space: getSizeByUnit(this.panelAlphaSpace)}){
			Row({space: getSizeByUnit(this.panelHueSpace)}){
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
						.borderRadius(2)
						.border({width: 2, color: "#363637"})
						.shadow({ radius: 10, color: "#0009" })
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
						.borderRadius(2)
						.border({width: 2, color: "#363637"})
						.shadow({ radius: 10, color: "#0009" })
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
			if(this.formatPredefineColor.length){
				Flex({space: {main: LengthMetrics.vp(8), cross: LengthMetrics.vp(8) }, wrap: FlexWrap.Wrap}){
					ForEach(this.formatPredefineColor, (item: IBestFormatPredefineColor) => {
						Row()
							.width(getSizeByUnit(this.predefineBlockWidth))
							.aspectRatio(1)
							.borderRadius(this.baseStyle.borderRadiusMd)
							.backgroundColor(item.format)
							.shadow({radius: this.value == item.format ? 12 : 0, color: this.baseStyle.primary as string})
							.onClick(() => {
								this.choosePredefineColor(item)
							})
					}, (_: string, index: number) => index.toString())
				}
				.width(this.realPanelWidth)
				.padding({left: this.baseStyle.spaceBase})
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.alignItems(HorizontalAlign.Start)
	}
}