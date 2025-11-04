import { IBestAwaitable, IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getSizeByUnit, handleBeforeFunction } from '../../utils/utils'
import { IBestLoading } from '../loading'
import { IBestSwitchColor } from './color'
import { IBestIcon } from '../icon/index'

@Component
export struct IBestSwitch {
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 开关默认选中的状态
	 * @since 2.0.1
	 * @since 2.2.0 开始支持string number类型
	 */
	@Link value: boolean | IBestStringNumber
	/**
	 * 开关按钮的尺寸
	 */
	@Prop switchSize: IBestStringNumber = convertDimensionsWidthUnit(26)
	/**
	 * 打开时的背景色
	 */
	@Prop activeColor: ResourceColor = ""
	/**
	 * 关闭时的背景色
	 */
	@Prop inactiveColor: ResourceColor = IBestSwitchColor.bg
	/**
	 * 是否禁用 禁用状态下开关不可点击
	 */
	@Prop disabled: boolean = false
	/**
	 * 是否为加载状态 加载状态下开关不可点击
	 */
	@Prop loading: boolean = false
	/**
	 * 打开时的loading颜色
	 */
	@Prop loadingActiveColor: ResourceColor = ''
	/**
	 * 关闭时的loading颜色
	 */
	@Prop loadingInactiveColor: ResourceColor = ''
	/**
	 * 组件宽度
	 * @since 2.2.0
     */
	@Prop componentWidth: IBestStringNumber = ""
	/**
	 * 组件内边距
	 * @since 2.2.0
     */
	@Prop componentPadding: Length | Padding | LocalizedPadding = 2
	/**
	 * 打开时的文字
	 * @since 2.2.0
     */
	@Prop activeText: ResourceStr = ""
	/**
	 * 关闭时的文字
	 * @since 2.2.0
     */
	@Prop inactiveText: ResourceStr = ""
	/**
	 * 打开时的图标, 优先级高于activeText
	 * @since 2.2.0
	 */
	@Prop activeIcon: ResourceStr = ""
	/**
	 * 关闭时的图标, 优先级高于inactiveText
	 * @since 2.2.0
     */
	@Prop inactiveIcon: ResourceStr = ""
	/**
	 * 文字/图标大小
	 * @since 2.2.0
     */
	@Prop textFontSize: IBestStringNumber = convertDimensionsWidthUnit(14)
	/**
	 * 打开时文字/图标颜色
	 * @since 2.2.0
     */
	@Prop activeTextColor: ResourceColor = this.baseStyle.default
	/**
	 * 关闭时文字/图标颜色
	 * @since 2.2.0
     */
	@Prop inactiveTextColor: ResourceColor = this.baseStyle.default
	/**
	 * 打开时的值
	 * @since 2.2.0
     */
	@Prop activeValue: boolean | IBestStringNumber = true
	/**
	 * 关闭时的值
	 * @since 2.2.0
     */
	@Prop inactiveValue: boolean | IBestStringNumber = false
	/**
	 * 自定义按钮的内容
	 */
	@BuilderParam nodeBuilder: CustomBuilder
	/**
	 * 改变的回调
	 */
	onChange: (value: boolean | IBestStringNumber) => void = () => {}
	/**
	 * 改变前的回调
	 */
	onBeforeChange?: (value: boolean) => IBestAwaitable
	/**
	 * 点击的回调
	 * @deprecated since 2.0.8
	 * @useinstead onSwitchClick
	 */
	onClickSwitch: () => void = () => {}
	onSwitchClick: () => void = () => {}

	@State realWidth: number = 0
	@State switchBarSize: number = 0

	// 获取值
	getBooleanValue(){
		return this.value === this.activeValue
	}
	// 改变的回调
	async handleChange() {
		let value = this.value
		let booleanValue = this.getBooleanValue() ? value === this.inactiveValue : value === this.activeValue
		let status = await handleBeforeFunction(this.onBeforeChange, booleanValue)
		if(!status){
			return
		}
		let changedValue = this.getBooleanValue() ? this.inactiveValue : this.activeValue
		this.value = changedValue
		this.onChange(changedValue)
	}
	// 获取激活的颜色
	getActiveColor() {
		return this.activeColor || this.baseStyle.primary
	}
	// 获取移动距离
	getTransDistance(){
		return this.realWidth - this.switchBarSize
	}
	build() {
		Row(){
			Row(){
				Column() {
					if (this.nodeBuilder) {
						this.nodeBuilder()
					} else if (this.loading && this.switchBarSize) {
						IBestLoading({
							loadingSize: this.switchBarSize / 1.5,
							loadingColor: this.getBooleanValue() ? this.loadingActiveColor || this.getActiveColor() : this.loadingInactiveColor || this.getActiveColor()
						})
					}
				}
				.width(getSizeByUnit(this.switchSize))
				.height(getSizeByUnit(this.switchSize))
				.alignItems(HorizontalAlign.Center)
				.justifyContent(FlexAlign.Center)
				.borderRadius(this.baseStyle.borderRadiusMax)
				.shadow({
					color: 'rgba(0, 0, 0, 0.1)',
					offsetY: 1,
					radius: 1
				})
				.backgroundColor(IBestSwitchColor.white)
				.translate({
					x: this.getBooleanValue() ? this.getTransDistance() : 0
				})
				.animation({
					duration: this.baseStyle.animationDuration as number
				})
				.onAreaChange((_, newVal) => {
					this.switchBarSize = newVal.width as number
				})
				if(this.activeIcon || this.activeText){
					Row(){
						if(this.activeIcon){
							IBestIcon({
								name: this.getBooleanValue() ? this.activeIcon : this.inactiveIcon,
								color: this.getBooleanValue() ? this.activeTextColor : this.inactiveTextColor,
								iconSize: this.textFontSize
							})
						}else{
							Text(this.getBooleanValue() ? this.activeText : this.inactiveText)
								.fontSize(getSizeByUnit(this.textFontSize, true))
								.fontColor(this.getBooleanValue() ? this.activeTextColor : this.inactiveTextColor)
								.maxLines(1)
								.textOverflow({overflow: TextOverflow.Ellipsis})
						}
					}
					.layoutWeight(1)
					.padding({left: 2, right: 2})
					.justifyContent(FlexAlign.Center)
					.translate({
						x: this.getBooleanValue() ? -this.switchBarSize : 0
					})
					.animation({
						duration: this.baseStyle.animationDuration as number
					})
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.onAreaChange((_, newVal) => {
				this.realWidth = newVal.width as number
			})
		}
		.backgroundColor(this.getBooleanValue() ? this.getActiveColor() : this.inactiveColor)
		.animation({
			duration: this.baseStyle.animationDuration as number
		})
		.width(this.componentWidth ? getSizeByUnit(this.componentWidth) : this.switchBarSize * 2)
		.padding(getSizeByUnit(this.componentPadding))
		.borderRadius(this.baseStyle.borderRadiusMax)
		.enabled(!this.disabled && !this.loading)
		.opacity(this.disabled ? 0.6 : 1)
		.onClick(() => {
			this.handleChange()
			this.onClickSwitch()
			this.onSwitchClick()
		})
	}
}