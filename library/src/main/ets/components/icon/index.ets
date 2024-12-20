import { IBestIconData } from './config';
import { IBestIconDataType } from './index.type';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
import { IBestIconColor } from './color';

@Component
export struct IBestIcon {
	/**
	 * 图标名称或图片链接
	 */
	@Prop name: keyof IBestIconDataType | ResourceStr = 'arrow'
	/**
	 * 图标颜色
	 */
	@Prop color: ResourceColor = IBestIconColor.iconColor
	/**
	 * 图标大小
	 */
	@Prop iconSize: number | string = convertDimensionsWidthUnit(16)
	/**
	 * 图标圆角
	 * @since 1.19.0
	 */
	@Prop iconRadius: number | string = 0
	/**
	 * 点击回调
	 * @deprecated since 2.0.1
	 */
	onIconClick: (event: ClickEvent) => void = () => {}
	isOnlineImage(): boolean {
		return (this.name as string).startsWith("http")
	}
	build() {
		if (typeof this.name == "string" && !this.isOnlineImage()) {
			Text(Object(IBestIconData)[this.name])
				.fontFamily('ibestFont')
				.fontColor(this.color)
				.fontSize(getSizeByUnit(this.iconSize))
				.borderRadius(getSizeByUnit(this.iconRadius))
		} else {
			Image(this.name)
				.width(getSizeByUnit(this.iconSize))
				.aspectRatio(1)
				.fillColor(this.color)
				.borderRadius(getSizeByUnit(this.iconRadius))
		}
	}
}