import { IBestSize, IBestStringNumber } from "../../model/Global.type"
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { convertDimensionsWidthUnit, getSizeByUnit } from "../../utils/utils"
import { IBestIcon } from "../icon"
import { IBestSkeletonType } from "./index.type"

@Component
export struct IBestSkeleton{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 段落占位图行数
     */
	@Prop rows: number = 3
	/**
	 * 是否显示头像占位图
     */
	@Prop avatar: boolean = false
	/**
	 * 是否使用动画
     */
	@Prop animated: boolean = true
	/**
	 * 圆角, circle类型无效
	 */
	@Prop radius: IBestStringNumber = 0
	/**
	 * 加载
     */
	@Prop loading: boolean = true
	/**
	 * 自定义内容
     */
	@BuilderParam defaultBuilder: CustomBuilder

    build() {
		if(this.loading){
			Row({space: this.baseStyle.spaceSm as string}){
				if(this.avatar){
					IBestSkeletonParagraph({type: "circle"})
				}
				Column(){
					ForEach(Array.from({length: this.rows+1}), (_: number, index: number) => {
						IBestSkeletonParagraph({
							radius: this.radius,
							animated: this.animated,
							rowWidth: index == 0 ? "40%" : index == this.rows ? "60%" : CONTAINER_SIZE.FULL
						})
							.margin({top: index > 0 ? this.baseStyle.spaceSm : 0})
					})
				}
				.layoutWeight(1)
				.alignItems(HorizontalAlign.Start)
			}
			.width(CONTAINER_SIZE.FULL)
			.alignItems(VerticalAlign.Top)
		}else if(this.defaultBuilder){
			this.defaultBuilder()
		}
    }
}

// 段落占位图
@Component
export struct IBestSkeletonParagraph{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@StorageProp("IBestColorMode") colorMode: ColorMode = ColorMode.LIGHT
	/**
	 * 占位图类型
	 */
	@Prop type: IBestSkeletonType = 'text'
	/**
	 * 占位图宽度
     */
	@Prop rowWidth: IBestStringNumber
	/**
	 * 占位图高度, 仅type为text时有效
     */
	@Prop rowHeight: IBestStringNumber
	/**
	 * 圆角, type为circle时无效
     */
	@Prop radius: IBestStringNumber = 0
	/**
	 * 是否使用动画
	 */
	@Prop animated: boolean = true

	@State positionX: string = "0"

	getSize(): IBestSize{
		switch (this.type){
			case 'image':
				return {
					width: this.rowWidth || convertDimensionsWidthUnit(96),
					height: this.rowWidth || convertDimensionsWidthUnit(96)
				}
			case 'circle':
			case 'avatar':
				return {
					width: this.rowWidth || convertDimensionsWidthUnit(32),
					height: this.rowWidth || convertDimensionsWidthUnit(32)
				}
			default:
				return {
					width: this.rowWidth || CONTAINER_SIZE.FULL,
					height: this.rowHeight || convertDimensionsWidthUnit(16)
				}
		}
	}

	build() {
		Row(){
			if(this.type == 'image'){
				IBestIcon({
					name: "photo",
					iconSize: 48,
					color: $r("app.color.ibest_gray_5")
				})
					.position({x: 0, y: 0})
					.translate({x: "50%", y: "50%"})
					.zIndex(1)
			}
			if(this.animated){
				Row()
					.width(CONTAINER_SIZE.FULL)
					.height(CONTAINER_SIZE.FULL)
					.linearGradient({
						angle: 90,
						colors: this.colorMode == 0 ? [['#303030', 0], ['#424243', 0.5], ['#303030', 1]] : [['#f0f2f5', 0], ['#e6e8eb', 0.5], ['#f0f2f5', 1]]
					})
					.translate({x: this.positionX})
					.animation({
						duration: 1400,
						iterations: -1,
						curve: Curve.Ease,
						onFinish: () => {
							this.positionX = "-100%"
						}
					})
					.onAppear(() => {
						this.positionX = "100%"
					})
			}
		}
		.width(getSizeByUnit(this.getSize().width))
		.height(getSizeByUnit(this.getSize().height))
		.clip(true)
		.borderRadius(this.type == 'circle' ? this.baseStyle.borderRadiusMax : getSizeByUnit(this.radius))
		.backgroundColor(this.colorMode == 0 ? "#303030" : "#f0f2f5")
	}
}