import { IBestStringNumber } from "../../model/Global.type"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { SPACE } from "../../theme-chalk/src/space"
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from "../../utils/utils"
@Component
export struct IBestColorPicker{
	/**
	 * 初始颜色值
     */
	@Prop color: ResourceColor = ""
	/**
	 * 面板高度
     */
	@Prop panelHeight: IBestStringNumber = convertDimensionsWidthUnit(180)
	/**
	 * 色彩滑块宽度
     */
	@Prop hueSliderWidth: IBestStringNumber = convertDimensionsWidthUnit(12)
	/**
	 * 透明度滑块高度
     */
	@Prop alphaSliderHeight: IBestStringNumber = convertDimensionsWidthUnit(12)

	@State uniId: number = 0
	@State panelWidth: number = 0
	private uiContext = this.getUIContext()

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		setTimeout(() => {
			this.panelWidth = getComponentsInfo(this.uiContext, `ibest_colorpicker_${this.uniId}`).width
		}, 50)
	}

	build() {
		Column({space: SPACE.XS}){
			Row({space: SPACE.XS}){
				Stack(){
					Row()
						.width(CONTAINER_SIZE.FULL)
						.height(CONTAINER_SIZE.FULL)
						.linearGradient({
							direction: GradientDirection.Right,
							colors: [['#ffffff', 0], ['#00ffffff', 1]]
						})
					Row()
						.width(CONTAINER_SIZE.FULL)
						.height(CONTAINER_SIZE.FULL)
						.linearGradient({
							direction: GradientDirection.Top,
							colors: [['#000', 0], ['#0000', 1]]
						})
				}
				.layoutWeight(1)
				.height(getSizeByUnit(this.panelHeight))
				.backgroundColor("rgb(0, 125, 255)")
				.id(`ibest_colorpicker_${this.uniId}`)
				Row(){
					Row()
						.width(CONTAINER_SIZE.FULL)
						.height(CONTAINER_SIZE.FULL)
						.linearGradient({
							direction: GradientDirection.Bottom,
							colors: [['red', 0], ['#ff0', 0.17], ['#0f0', 0.33], ['#0ff', 0.5], ['#00f', 0.67], ['#f0f', 0.83], ['red', 1]]
						})
					Row()
						.width(CONTAINER_SIZE.FULL)
						.height(4)
						.backgroundColor("#fff")
						.borderRadius(2)
						.border({width: 1, color: "#363637"})
						.shadow({
							radius: 2,
							color: "#0009"
						})
						.position({x: 0, y: 0})
				}
				.width(getSizeByUnit(this.hueSliderWidth))
				.height(getSizeByUnit(this.panelHeight))
				.padding({top: 4, bottom: 4})
				.backgroundColor(Color.Red)
			}
			Row()
				.width(this.panelWidth)
				.height(getSizeByUnit(this.alphaSliderHeight))
		}
		.width(CONTAINER_SIZE.FULL)
		.alignItems(HorizontalAlign.Start)
	}
}