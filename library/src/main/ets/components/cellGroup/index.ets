import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
import { IBestCellGroupColor } from './color';
@Component
export struct IBestCellGroup {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 默认插槽
	 */
	@BuilderParam defaultBuilder?: CustomBuilder;
	/**
	 * 分组标题
	 */
	@Prop title: ResourceStr = '';
	/**
	 * 是否展示为圆角卡片风格
	 */
	@Prop inset: boolean = false;
	/**
	 * 是否显示外边框
	 */
	@Prop hasBorder: boolean = true;
	/**
	 * 圆角大小, 仅inset为true时有效
	 * @since 2.0.6
     */
	@Prop radius: number | string = this.baseStyle.borderRadiusLg as string
	/**
	 * 获取边框宽度
	 * @returns
	 */
	getBorderWidth() {
		return this.hasBorder && !this.inset ? 1 : 0
	}
	/**
	 * 获取margin
	 * @returns
	 */
	getMargin() {
		return this.inset ? { left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd } as Padding : 0
	}
	build() {
		Column() {
			if (this.title) {
				Text(this.title)
					.textAlign(TextAlign.Start)
					.width(CONTAINER_SIZE.FULL)
					.border({
						width: { bottom: this.getBorderWidth() },
						color: IBestCellGroupColor.borderColor
					})
					.padding(this.baseStyle.spaceMd)
					.lineHeight(convertDimensionsWidthUnit(16))
					.fontSize(this.baseStyle.fontSizeMd)
					.fontColor(IBestCellGroupColor.textColor)
			}
			if (typeof this.defaultBuilder === 'function') {
				this.defaultBuilder()
			}
		}
		.border({
			width: { bottom: this.getBorderWidth(), top: this.title ? 0 : this.getBorderWidth() },
			color: IBestCellGroupColor.borderColor
		})
		.margin(this.getMargin())
		.borderRadius(this.inset ? getSizeByUnit(this.radius) : 0)
		.clip(true)
	}
}