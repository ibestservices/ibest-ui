import { IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils'
import { IBestProgressColor } from './color'
@Component
export struct IBestProgress{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 进度值
     */
	@Prop @Watch("valueChange") value: number = 0
	/**
	 * 进度条粗细
     */
	@Prop lineWidth: IBestStringNumber = convertDimensionsWidthUnit(4)
	/**
	 * 进度条颜色
     */
	@Prop color: ResourceColor = ""
	/**
	 * 进度条渐变色
     */
	@Prop linearGradientColor: LinearGradient
	/**
	 * 进度条背景色
     */
	@Prop bgColor: ResourceColor = IBestProgressColor.bgColor
	/**
	 * 是否显示进度条文字
     */
	@Prop showText: boolean = true
	/**
	 * 文字显示在进度条内
     */
	@Prop textInside: boolean = false
	/**
	 * 文字颜色
     */
	@Prop textColor: ResourceColor = IBestProgressColor.textColor
	/**
	 * 文字大小
     */
	@Prop textFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
	/**
	 * 是否置灰
     */
	@Prop inactive: boolean = false
	/**
	 * 不确定进度
     */
	@Prop indeterminate: boolean = false
	/**
	 * 不确定进度时动画时长 单位s
     */
	@Prop duration: number = 3
	/**
	 * 格式化文本函数
     */
	format?: (value: number) => string

	@State positionX: string = `-${this.value}%`

	valueChange(){
		this.value = this.value > 100 ? 100 : this.value < 0 ? 0 : this.value
	}
	getColor(){
		return this.inactive ? GRAY_COLOR.GRAY_5 : (this.color || this.baseStyle.primary)
	}
	getTextColor(){
		return this.inactive ? GRAY_COLOR.GRAY_5 : this.textColor
	}

	build() {
		Row(){
			Stack({alignContent: Alignment.Start}){
				Row()
					.width(CONTAINER_SIZE.FULL)
					.height(CONTAINER_SIZE.FULL)
					.backgroundColor(this.bgColor)
				Row(){
					if(this.showText && this.textInside && this.value){
						Text(this.format ? this.format(this.value) : this.value + "%")
							.fontSize(getSizeByUnit(this.textFontSize, true))
							.fontColor(IBestProgressColor.whiteColor)
							.margin({right: this.baseStyle.spaceXs})
					}
				}
				.width(this.value + "%")
				.height(CONTAINER_SIZE.FULL)
				.backgroundColor(this.getColor())
				.borderRadius(this.baseStyle.borderRadiusMax)
				.linearGradient(this.linearGradientColor)
				.justifyContent(FlexAlign.End)
				.position(this.indeterminate ? {x: this.positionX} : undefined)
				.animation({
					duration: this.indeterminate ? this.duration*1000 : 300,
					iterations: this.indeterminate ? -1 : 1,
					curve: Curve.EaseOut,
					onFinish: () => {
						if(this.indeterminate){
							this.positionX = `-${this.value}%`
						}
					}
				})
				.onAppear(() => {
					if(this.indeterminate){
						this.positionX = "100%"
					}
				})
			}
			.layoutWeight(1)
			.height(getSizeByUnit(this.lineWidth))
			.borderRadius(this.baseStyle.borderRadiusMax)
			.clip(true)
			if(this.showText && !this.textInside){
				Text(this.format ? this.format(this.value) : this.value + "%")
					.fontSize(getSizeByUnit(this.textFontSize, true))
					.fontColor(this.getTextColor())
					.margin({left: this.baseStyle.spaceXs})
					.constraintSize({minWidth: convertDimensionsWidthUnit(40)})
			}
		}
	}
}