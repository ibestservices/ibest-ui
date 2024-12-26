import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
import { IBestEmptyColor } from './color';
@Component
export struct IBestEmpty {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 描述文字底部的builder
	 */
	@BuilderParam defaultBuilder?: CustomBuilder;
	/**
	 * 占位图的builder
	 */
	@BuilderParam emptyImgBuilder?: CustomBuilder;
	/**
	 * 描述文字的builder
	 */
	@BuilderParam descriptionBuilder?: CustomBuilder;
	/**
	 * 图片下方的描述文字 默认空字符串
	 */
	@Prop description: ResourceStr = '';
	/**
	 * 描述文字颜色 默认 "#969799"
	 */
	@Prop descriptionColor: ResourceColor = IBestEmptyColor.textColor
	/**
	 * 描述文字大小
	 */
	@Prop descriptionFontSize: string | number = convertDimensionsWidthUnit(14)
	/**
	 * 空占位图的高度
	 */
	@Prop imageSize: string | number = convertDimensionsWidthUnit(160)
	/**
	 * 图片类型，可选值为 error network search default 默认default
	 */
	@Prop emptyImage: 'error' | 'network' | 'search' | 'default' = 'default';
	/**
	 * 自定义占位图
	 * @since 1.18.0
	 */
	@Prop emptyImgUrl: ResourceStr = ''
	@Styles
	imgStyle(){
		.height(getSizeByUnit(this.imageSize))
	}
	@Builder
	EmptyImg() {
		if (this.emptyImgUrl) {
			Image(this.emptyImgUrl).imgStyle()
		} else if (this.emptyImage === 'default') {
			Image($r("app.media.ibest_empty")).imgStyle()
		} else if (this.emptyImage === 'network') {
			Image($r("app.media.ibest_empty_network_error")).imgStyle()
		} else if (this.emptyImage === 'search') {
			Image($r("app.media.ibest_empty_search_error")).imgStyle()
		} else if (this.emptyImage === 'error') {
			Image($r("app.media.ibest_empty_error")).imgStyle()
		}
	}
	build() {
		Column() {
			// 空占位图
			if (this.emptyImgBuilder) {
				this.emptyImgBuilder()
			} else {
				this.EmptyImg()
			}
			// 描述
			if (this.descriptionBuilder) {
				this.descriptionBuilder()
			} else {
				Text(this.description)
					.margin({
						top: this.description ?? false ? this.baseStyle.spaceMd : 0
					})
					.padding({
						left: this.baseStyle.spaceXl,
						right: this.baseStyle.spaceXl
					})
					.fontColor(this.descriptionColor)
					.fontSize(getSizeByUnit(this.descriptionFontSize, true))
			}
			// 底部插槽
			if (this.defaultBuilder) {
				this.defaultBuilder()
			}
		}.width(CONTAINER_SIZE.FULL)
	}
}