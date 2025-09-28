import { IBestIconData } from './config'
import { IBestIconDataType } from './index.type'
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils'
import { IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestIcon {
	/**
	 * 图标名称、unicode 编码、图片链接
	 */
	@Prop @Require name: keyof IBestIconDataType | ResourceStr
	/**
	 * 图标颜色
	 */
	@Prop color: ResourceColor
	/**
	 * 图标大小
	 */
	@Prop iconSize: IBestStringNumber = convertDimensionsWidthUnit(16)
	/**
	 * 图标圆角
	 * @since 1.19.0
	 */
	@Prop iconRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0
	/**
	 * 字体名称
	 * @since 2.1.8
     */
	@Prop fontName: ResourceStr = ""
	/**
	 * 动画
	 * @since 2.1.9
     */
	@Prop iconAnimation: AnimateParam
	/**
	 * 点击回调
	 */
	onIconClick: (event: TouchEvent) => void = () => {}
	isOnlineImage(): boolean {
		return (this.name as string).startsWith("http")
	}
	build() {
		if (typeof this.name == "string" && !this.isOnlineImage()) {
			Text(this.fontName ? this.name : Object(IBestIconData)[this.name as string])
				.fontFamily(this.fontName || "ibestFont")
				.fontColor(this.color)
				.fontSize(getSizeByUnit(this.iconSize, true))
				.borderRadius(getSizeByUnit(this.iconRadius))
				.animation(this.iconAnimation)
				.onTouch(event => {
					event.type == TouchType.Up && this.onIconClick(event)
				})
		} else {
			Image(this.name)
				.width(getSizeByUnit(this.iconSize))
				.fillColor(this.color)
				.borderRadius(getSizeByUnit(this.iconRadius))
				.draggable(false)
				.animation(this.iconAnimation)
				.onTouch(event => {
					event.type == TouchType.Up && this.onIconClick(event)
				})
		}
	}
}