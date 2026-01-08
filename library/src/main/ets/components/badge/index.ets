import { IBestIcon } from '../icon'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit } from '../../utils/utils'
import { IBestBadgeColor } from './color'
import { IBestBadgePosition } from './index.type'
@Component
export struct IBestBadge {
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 徽标内容
	 */
	@Prop content: IBestStringNumber = ''
	/**
	 * 徽标背景色
	 */
	@Prop color: ResourceColor = IBestBadgeColor.badgeBgColor
	/**
	 * 是否展示为小红点
	 */
	@Prop dot: boolean = false
	/**
	 * 最大值,超过最大值会显示 {max}+,仅当 content 为数字时有效
	 */
	@Prop max: number = -1
	/**
	 * 值为0时是否显示徽标
	 */
	@Prop showZero: boolean = true
	/**
	 * 徽标位置
	 */
	@Prop badgePosition: IBestBadgePosition = 'top-right'
	/**
	 * 徽标图标, 优先级高于 content dot
	 * @since 2.1.5
     */
	@Prop icon: ResourceStr = ''
	/**
	 * 徽标图标大小
	 * @since 2.1.5
     */
	@Prop iconSize: IBestStringNumber = this.baseStyle.fontSizeSm as string
	/**
	 * 徽标图标颜色
	 * @since 2.1.5
     */
	@Prop iconColor: ResourceColor
	/**
	 * 自定义内容
	 */
	@BuilderParam defaultBuilder: CustomBuilder

	isShow(){
		return !(typeof this.content == "number" && this.content == 0 && !this.showZero)
	}
	getContent(){
		if(typeof this.content == 'number' && this.max > 0 && this.content > this.max){
			return this.max + '+'
		}
		return this.content.toString()
	}
	getPosition(): Edges{
		switch (this.badgePosition){
			case 'top-left':
				return {
					left: 0,
					top: 0
				}
			case 'top-right':
				return {
					right: 0,
					top: 0
				}
			case 'bottom-left':
				return {
					left: 0,
					bottom: 0
				}
			case 'bottom-right':
				return {
					right: 0,
					bottom: 0
				}
		}
	}
	getTranslate(): TranslateOptions{
		switch (this.badgePosition){
			case 'top-left':
				return {
					x: "-50%",
					y: "-50%"
				}
			case 'top-right':
				return {
					x: "50%",
					y: "-50%"
				}
			case 'bottom-left':
				return {
					x: "-50%",
					y: "50%"
				}
			case 'bottom-right':
				return {
					x: "50%",
					y: "50%"
				}
		}
	}
	build() {
		Row() {
			if (this.defaultBuilder) {
				this.defaultBuilder()
			}
			if(this.icon){
				IBestIcon({
					name: this.icon,
					iconSize: this.iconSize,
					color: this.iconColor
				})
					.position(this.getPosition())
					.translate(this.getTranslate())
			} else if (this.dot) {
				Text()
					.width(convertDimensionsWidthUnit(8))
					.aspectRatio(1)
					.borderRadius(this.baseStyle.borderRadiusMax)
					.backgroundColor(this.color)
					.position(this.getPosition())
					.translate(this.getTranslate())
			} else if(this.isShow()) {
				Text(this.getContent())
					.constraintSize({ minWidth: convertDimensionsWidthUnit(16) })
					.fontColor(IBestBadgeColor.textColor)
					.fontSize(this.baseStyle.fontSizeMd)
					.padding({ left: convertDimensionsWidthUnit(3), right: convertDimensionsWidthUnit(3) })
					.backgroundColor(this.color)
					.borderRadius(this.baseStyle.borderRadiusMax)
					.position(this.getPosition())
					.translate(this.getTranslate())
					.textAlign(TextAlign.Center)
			}
		}
	}
}