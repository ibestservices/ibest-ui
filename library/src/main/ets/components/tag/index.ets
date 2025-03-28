import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { COLOR_TYPE, ColorType } from '../../theme-chalk/src/color.type';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { SIZE } from '../../theme-chalk/src/size.type';
import { TagSizeData } from './index.type';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
import { IBestTagColor } from './color';
import { IBestIcon } from '../icon';
import { IBestStringNumber } from '../../model/Global.type';

@Extend(Row) function ibestTagSizeStyle(data: TagSizeData) {
	.padding({
		top: 0,
		right: data.padding,
		bottom: 0,
		left: data.padding
	})
	.height(data.height)
	.borderRadius(data.borderRadius)
}
@Component
export struct IBestTag {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
	/**
	 * 类型，可选值为 primary success warning danger 默认值为default
	 */
	@Prop type: ColorType = COLOR_TYPE.DEFAULT;
	/**
	 * 大小，可选值为 large normal small mini
	 * size是保留字所以没使用size
	 */
	@Prop tagSize: `${SIZE.LARGE}` | `medium` | `${SIZE.SMALL}` = SIZE.SMALL;
	/**
	 * 标签内容
	 */
	@Prop text: ResourceStr = '';
	/**
	 * 标签颜色
	 */
	@Prop color: ResourceColor = '';
	/**
	 * 文本颜色，优先级高于 color 属性
	 */
	@Prop textColor: ResourceColor = ''
	/**
	 * 是否为空心样式
	 */
	@Prop plain: boolean = false;
	/**
	 * 是否为圆角样式
	 */
	@Prop round: boolean = false;
	/**
	 * 是否为标记样式
	 */
	@Prop mark: boolean = false;
	/**
	 * 是否为可关闭标签 关闭标签时会触发 close 事件，在 close 事件中可以执行隐藏标签的逻辑
	 */
	@Prop closeable: boolean = false;
	/**
	 * 是否展示标签
	 */
	@Prop show: boolean = true;
	/**
	 * 点击关闭按钮触发的回调
	 */
	onClose: () => void = () => {}
	/**
	 * 点击标签触发的回调
	 * @deprecated since 2.0.8
	 * @useinstead onTagClick
	 */
	onClickTag: () => void = () => {}
	onTagClick: () => void = () => {}
	// 获取按钮边框的颜色
	getBorderColor() {
		return this.color ? this.color : this.type === COLOR_TYPE.DEFAULT ? GRAY_COLOR.GRAY_4 : this.baseStyle[this.type]
	}
	// 获取按钮文字的颜色
	getTextColor() {
		if (this.textColor) {
			return this.textColor
		}
		if (this.plain) {
			return this.color ? this.color : this.type === COLOR_TYPE.DEFAULT ? IBestTagColor.textColor : this.baseStyle[this.type]
		}
		return this.type === COLOR_TYPE.DEFAULT ? IBestTagColor.textColor : IBestTagColor.whiteColor
	}
	// 根据颜色type获取背景色
	getBackgroundColor() {
		return this.plain ? "transparent" : this.color ? this.color : this.type == "default" ? IBestTagColor.defaultBg : this.baseStyle[this.type]
	}
	// 根据size获取tag的尺寸
	getTagSize() {
		const tagSize = this.tagSize;
		switch (tagSize) {
			case 'medium':
				return new TagSizeData(convertDimensionsWidthUnit(6), convertDimensionsWidthUnit(20),
					this.baseStyle.fontSizeSm, this.getBorderRadius(convertDimensionsWidthUnit(2)));
			case SIZE.LARGE:
				return new TagSizeData(this.baseStyle.spaceXs, convertDimensionsWidthUnit(24),
					this.baseStyle.fontSizeMd, this.getBorderRadius(convertDimensionsWidthUnit(4)));
			default:
				return new TagSizeData(this.baseStyle.spaceBase, convertDimensionsWidthUnit(17),
					this.baseStyle.fontSizeSm, this.getBorderRadius(convertDimensionsWidthUnit(2)));
		}
	}
	// 获取边框radius
	getBorderRadius(borderRadius: IBestStringNumber): BorderRadiuses | Length {
		if (this.round) {
			return this.baseStyle.borderRadiusMax
		} else if (this.mark) {
			return {
				topLeft: 0,
				topRight: this.baseStyle.borderRadiusMax,
				bottomLeft: 0,
				bottomRight: this.baseStyle.borderRadiusMax
			}
		} else {
			return getSizeByUnit(borderRadius)
		}
	}
	build() {
		if (this.show) {
			Row() {
				Text(this.text)
					.fontSize(this.getTagSize()?.fontSize)
					.fontColor(this.getTextColor())
				if (this.closeable) {
					IBestIcon({
						name: "cross",
						iconSize: convertDimensionsWidthUnit(12),
						color: this.getTextColor()
					})
						.onClick(() => {
							animateTo({ duration: this.baseStyle.animationDuration as number }, () => {
								this.onClose()
							})
						})
						.margin({ left: this.baseStyle.spaceMini })
				}
			}
			.ibestTagSizeStyle(this.getTagSize())
			.alignItems(VerticalAlign.Center)
			.justifyContent(FlexAlign.Center)
			.borderWidth(1)
			.backgroundColor(this.getBackgroundColor())
			.borderColor(this.getBorderColor())
			.transition({ type: TransitionType.Insert, opacity: 1 })
			.transition({ type: TransitionType.Delete, opacity: 0 })
			.onTouch(event => {
				if(event.type == TouchType.Up){
					this.onClickTag()
					this.onTagClick()
				}
			})
		}
	}
}