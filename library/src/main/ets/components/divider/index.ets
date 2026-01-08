import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils'
import { IBestDividerColor } from './color'

@Component
export struct IBestDivider{
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 线宽, 仅hairline为false时生效
     */
	@Prop lineWidth: IBestStringNumber = convertDimensionsWidthUnit(1)
	/**
	 * 是否使用虚线
	 */
	@Prop @Watch("dashedChange") dashed: boolean = false
	/**
	 * 是否使用细线
     */
	@Prop hairline: boolean = true
	/**
	 * 是否垂直
     */
	@Prop vertical: boolean = false
	/**
	 * 分割线高度, 仅垂直时生效
     */
	@Prop lineHeight: IBestStringNumber = this.baseStyle.lineHeightXs as string
	/**
	 * 线颜色
     */
	@Prop @Watch("lineColorChange") lineColor: ResourceColor = IBestDividerColor.borderColor
	/**
	 * 文本内容, 仅水平时生效
     */
	@Prop text: ResourceStr = ""
	/**
	 * 文字颜色, 仅水平时生效
     */
	@Prop color: ResourceColor = IBestDividerColor.textColor
	/**
	 * 文本大小, 仅水平时生效
     */
	@Prop texFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
	/**
	 * 文本与线段间距, 仅水平时生效
     */
	@Prop textLineSpace: IBestStringNumber = this.baseStyle.spaceMd as string
	/**
	 * 左侧线段宽度, 仅水平时生效
     */
	@Prop leftLineWidth: IBestStringNumber = ""
	/**
	 * 右侧线段宽度, 仅水平时生效
     */
	@Prop rightLineWidth: IBestStringNumber = ""
	/**
	 * 左右内边距, 仅水平时生效
     */
	@Prop leftRightPadding: IBestStringNumber = 0
	/**
	 * 左右外边距, 仅垂直时生效
     */
	@Prop leftRightMargin: IBestStringNumber = this.baseStyle.spaceXs as string
	/**
	 * 虚线间距, 仅在dashed为true时生效
	 * @since 2.1.5
     */
	@Prop dashGap: LengthMetrics
	/**
	 * 虚线线段长度, 仅在dashed为true时生效
	 * @since 2.1.5
     */
	@Prop dashWidth: LengthMetrics
	/**
	 * 右侧线颜色, 默认与lineColor一致
	 * @since 2.1.5
     */
	@Prop rightLineColor: ResourceColor
	/**
	 * 右侧线是否使用虚线, 默认与dashed一致
	 * @since 2.1.5
     */
	@Prop rightDashed: boolean
	/**
	 * 自定义文本内容
     */
	@BuilderParam textBuilder: CustomBuilder

	lineColorChange(){
		if(!this.rightLineColor){
			this.rightLineColor = this.lineColor
		}
	}
	dashedChange(){
		if(this.rightDashed === undefined){
			this.rightDashed = this.dashed
		}
	}

	build() {
		if(this.vertical){
			Row()
				.width(1)
				.height(getSizeByUnit(this.lineHeight))
				.scale({x: this.hairline ? 0.5 : 1})
				.border({
					width: { left: this.hairline ? 1 : getSizeByUnit(this.lineWidth) },
					color: this.lineColor,
					style: this.dashed ? BorderStyle.Dashed : BorderStyle.Solid,
					dashGap: this.dashGap,
					dashWidth: this.dashWidth
				})
				.margin({left: getSizeByUnit(this.leftRightMargin), right: getSizeByUnit(this.leftRightMargin)})
		}else{
			Row({space: getSizeByUnit(this.textLineSpace)}){
				Row()
					.width(this.leftLineWidth)
					.height(1)
					.layoutWeight(this.leftLineWidth ? "" : 1)
					.scale({y: this.hairline ? 0.5 : 1})
					.border({
						width: { top: this.hairline ? 1 : getSizeByUnit(this.lineWidth) },
						color: this.lineColor,
						style: this.dashed ? BorderStyle.Dashed : BorderStyle.Solid,
						dashGap: this.dashGap,
						dashWidth: this.dashWidth
					})
				if(this.textBuilder || this.text){
					Row(){
						if(this.textBuilder){
							this.textBuilder()
						}else{
							Text(this.text)
								.fontColor(this.color)
								.fontSize(getSizeByUnit(this.texFontSize, true))
						}
					}
					Row()
						.width(this.rightLineWidth)
						.height(1)
						.layoutWeight(this.rightLineWidth ? "" : 1)
						.scale({y: this.hairline ? 0.5 : 1})
						.border({
							width: { top: this.hairline ? 1 : getSizeByUnit(this.lineWidth) },
							color: this.rightLineColor || this.lineColor,
							style: (this.rightDashed ?? this.dashed) ? BorderStyle.Dashed : BorderStyle.Solid,
							dashGap: this.dashGap,
							dashWidth: this.dashWidth
						})
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.padding({left: getSizeByUnit(this.leftRightPadding), right: getSizeByUnit(this.leftRightPadding)})
			.alignItems(VerticalAlign.Center)
		}
	}
}