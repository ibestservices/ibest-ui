import { UIContext } from '@ohos.arkui.UIContext';
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type';
import { IBestGlobalConfig } from '../../model/GlobalConfig';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from '../../utils/utils';
class Point {
	x: number
	y: number
	constructor(x: number, y: number) {
		this.x = x
		this.y = y
	}
	plus(rhs: Point): Point {
		return new Point(this.x + rhs.x, this.y + rhs.y)
	}
	subtract(rhs: Point): Point {
		return new Point(this.x - rhs.x, this.y - rhs.y)
	}
	multiply(scale: number): Point {
		return new Point(this.x * scale, this.y * scale)
	}
	equals(rhs: Point): boolean {
		return this.x === rhs.x && this.y === rhs.y
	}
}
@AnimatableExtend(Circle)
function animatableDashArray(point: Point) {
	.strokeDashArray([point.x, point.y])
}
@AnimatableExtend(Circle)
function animatableDashOffset(strokeDashOffset: number) {
	.strokeDashOffset(strokeDashOffset)
}
@Component
export struct IBestLoadingCircular {
	/**
	 * loading的尺寸
	 */
	@Prop circularSize: IBestStringNumber = convertDimensionsWidthUnit(30)
	/**
	 * loading的颜色
	 */
	@Prop color: ResourceColor = GRAY_COLOR.GRAY_5;
	/**
	 * 圆的边框粗细
	 */
	@Prop strokeWidth: Length = 2

	@State uniId: number = 0
	@State rotateAngle: number = 0
	@State maxPerimeter: number = 0
	@State strokeDashArray: Point = new Point(0, 0)
	@State strokeDashOffset: number = 0
	@StorageProp(IBestStorageKey.GLOBAL_CONFIG) globalConfig: IBestGlobalConfig = new IBestGlobalConfig()
	private uiContext: UIContext = this.getUIContext()
	aboutToAppear() {
		this.uniId = this.getUniqueId()
		setTimeout(() => {
			let width = getComponentsInfo(this.uiContext, `ibest_circle_${this.uniId}`).width
			this.maxPerimeter = Math.floor(Math.PI * (width + (this.globalConfig.unit == "vp" ? 20 : 0)))
			this.strokeDashArray = new Point(0, this.maxPerimeter)
		}, 50)
	}
	keyframeAnimateTo() {
		this.uiContext?.keyframeAnimateTo({ iterations: -1 }, [
			{
				// 第一段关键帧动画时长为100ms
				duration: 100,
				curve: Curve.EaseInOut,
				event: () => {
					this.strokeDashOffset = 0
					this.strokeDashArray = new Point(0, this.maxPerimeter)
				}
			},
			{
				// 第一段关键帧动画时长为700ms
				duration: 700,
				curve: Curve.EaseInOut,
				event: () => {
					this.strokeDashOffset = -this.maxPerimeter * 0.3
					this.strokeDashArray = new Point(this.maxPerimeter * 0.6, this.maxPerimeter)
				}
			},
			{
				// 第二段关键帧动画时长为700ms
				duration: 700,
				curve: Curve.EaseInOut,
				event: () => {
					this.strokeDashOffset = -this.maxPerimeter * 0.5
					this.strokeDashArray = new Point(this.maxPerimeter * 0.6, this.maxPerimeter)
				}
			}
		])
	}
	build() {
		Row() {
			if(this.maxPerimeter){
				Circle({ width: CONTAINER_SIZE.FULL, height: CONTAINER_SIZE.FULL })
					.fill("transparent")
					.strokeWidth(this.strokeWidth)
					.stroke(this.color)
					.strokeLineCap(LineCapStyle.Round)
					.animatableDashArray(this.strokeDashArray)
					.animatableDashOffset(this.strokeDashOffset)
					.rotate({ angle: this.rotateAngle })
					.animation({
						duration: 2000,
						iterations: -1,
						curve: Curve.Linear,
						playMode: PlayMode.Normal
					})
					.onAppear(() => {
						this.rotateAngle = 360
						this.keyframeAnimateTo()
					})
			}
		}
		.width(getSizeByUnit(this.circularSize))
		.aspectRatio(1)
		.padding(1)
		.id(`ibest_circle_${this.uniId}`)
	}
}