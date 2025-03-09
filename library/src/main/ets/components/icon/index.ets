import { IBestIconData } from './config';
import { IBestIconDataType } from './index.type';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
import { IBestIconColor } from './color';
import { IBestStringNumber } from '../../model/Global.type';

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
	@Prop iconSize: IBestStringNumber = convertDimensionsWidthUnit(16)
	/**
	 * 图标圆角
	 * @since 1.19.0
	 */
	@Prop iconRadius: IBestStringNumber = 0
	/**
	 * 点击回调
	 */
	onIconClick: (event: TouchEvent) => void = () => {}
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
				.onTouch(event => {
					event.type == TouchType.Up && this.onIconClick(event)
				})
		} else {
			Image(this.name)
				.width(getSizeByUnit(this.iconSize))
				.aspectRatio(1)
				.fillColor(this.color)
				.borderRadius(getSizeByUnit(this.iconRadius))
				.onTouch(event => {
					event.type == TouchType.Up && this.onIconClick(event)
				})
		}
	}
}