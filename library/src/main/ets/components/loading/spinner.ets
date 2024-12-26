import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { curves } from '@kit.ArkUI';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
@Component
export struct IBestLoadingSpinner {
	/**
	 * 菊花图尺寸
	 */
	@Prop spinnerSize: number | string = convertDimensionsWidthUnit(30)
	/**
	 * 菊花图线的宽度
	 */
	@Prop strokeWidth: Length = 3
	/**
	 * 滚动的角度
	 */
	@State rotateAngle: number = 0
	/**
	 * 当前菊花图的每条线的长度
	 */
	@Prop strokeHeight: string | number = convertDimensionsWidthUnit(8)
	/**
	 * loading的颜色
	 */
	@Prop color: ResourceColor = GRAY_COLOR.GRAY_5
	/**
	 * 循环渲染的数据
	 */
	private list: number[] = new Array(12).fill(1)
	build() {
		Column() {
			ForEach(this.list, (item: number, index) => {
				Column() {
					Column()
						.width(this.strokeWidth)
						.height(getSizeByUnit(this.strokeHeight))
						.borderRadius(1)
						.backgroundColor(this.color)
				}
				.position({ top: 0, left: 0 })
				.width(getSizeByUnit(this.spinnerSize))
				.height(getSizeByUnit(this.spinnerSize))
				.rotate({
					angle: (index + 1) * 30 + 'deg'
				})
				.opacity(1 - index * 0.083)
				.align(Alignment.Top)
			})
		}
		.width(getSizeByUnit(this.spinnerSize))
		.height(getSizeByUnit(this.spinnerSize))
		.rotate({ angle: this.rotateAngle })
		.animation({
			duration: 800,
			iterations: -1,
			curve: curves.stepsCurve(12, true)
		})
		.onAppear(() => {
			this.rotateAngle = 360
		})
	}
}