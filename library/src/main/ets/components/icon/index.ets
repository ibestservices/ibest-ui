import { IBestIconData } from './config'
import { IBestIconDataType } from './index.type'
import { convertDimensionsWidthUnit, getResourceStr, getSizeByUnit } from '../../utils/utils'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { IBestGlobalConfig } from '../../model/GlobalConfig'

@Component
export struct IBestIcon {
	@StorageProp(IBestStorageKey.GLOBAL_CONFIG) config: IBestGlobalConfig = AppStorage.get(IBestStorageKey.GLOBAL_CONFIG)!
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
	getFontFamily(){
		let arr = ["ibestFont", getResourceStr(this.fontName)].concat(this.config.fontNames.map(e => getResourceStr(e)))
		return Array.from<string>(new Set(arr.filter(e => e))).join(",")
	}
	build() {
		if (typeof this.name == "string" && !this.isOnlineImage()) {
			Text(Object(IBestIconData)[this.name as string] || this.name)
				.fontFamily(this.getFontFamily())
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