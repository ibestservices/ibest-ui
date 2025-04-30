import { IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from '../../utils/utils'
import { IBestLoading } from '../loading'
import { IBestSwitchColor } from './color'
@Component
export struct IBestSwitch {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 开关默认选中的状态
	 * @since 2.0.1
	 */
	@Link value: boolean
	/**
	 * 开关按钮的尺寸
	 */
	@Prop switchSize: IBestStringNumber = convertDimensionsWidthUnit(26)
	/**
	 * 打开时的背景色
	 */
	@Prop activeColor: ResourceColor = ''
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
	 * 自定义按钮的内容
	 */
	@BuilderParam nodeBuilder: CustomBuilder
	/**
	 * 改变的回调
	 */
	onChange: (value: boolean) => void = () => {}
	/**
	 * 改变前的回调
	 */
	onBeforeChange?: (value: boolean) => Promise<boolean> | boolean
	/**
	 * 点击的回调
	 * @deprecated since 2.0.8
	 * @useinstead onSwitchClick
	 */
	onClickSwitch: () => void = () => {}
	onSwitchClick: () => void = () => {}


	@State uniId: number = 0
	@State switchBarSize: number = 0
	private uiContext = this.getUIContext()

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		setTimeout(() => {
			this.switchBarSize = getComponentsInfo(this.uiContext, `ibest_switch_${this.uniId}`).width
		}, 20)
	}
	// 结束前的动画
	async handleBeforeClose(value: boolean) {
		let status = true
		try {
			if (this.onBeforeChange) {
				status = await this.onBeforeChange(value)
			}
		} catch (e) {
			status = false
		}
		return status
	}
	// 改变的回调
	async handleChange() {
		const nextValue = !this.value
		let status = await this.handleBeforeClose(nextValue)
		if(!status){
			return
		}
		this.value = nextValue
		this.onChange(nextValue)
	}
	// 获取激活的颜色
	getActiveColor() {
		return this.activeColor || this.baseStyle.primary as string
	}
	build() {
		Column() {
			Column() {
				if (this.nodeBuilder) {
					this.nodeBuilder()
				} else if (this.loading && this.switchBarSize) {
					IBestLoading({
						loadingSize: this.switchBarSize / 1.5,
						loadingColor: this.value ? this.loadingActiveColor || this.getActiveColor() : this.loadingInactiveColor || this.activeColor
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
				offsetY: px2vp(3),
				radius: px2vp(1)
			})
			.backgroundColor(IBestSwitchColor.white)
			.translate({
				x: this.value ? this.switchBarSize - 4 : 0
			})
			.id(`ibest_switch_${this.uniId}`)
			.animation({
				duration: this.baseStyle.animationDuration as number,
			})
		}
		.alignItems(HorizontalAlign.Start)
		.justifyContent(FlexAlign.Center)
		.width(this.switchBarSize * 2)
		.padding(2)
		.backgroundColor(this.value ? this.getActiveColor() : this.inactiveColor)
		.borderRadius(this.baseStyle.borderRadiusMax)
		.enabled(!this.disabled && !this.loading)
		.opacity(this.disabled ? 0.5 : 1)
		.animation({
			duration: this.baseStyle.animationDuration as number
		})
		.onClick(() => {
			this.handleChange()
			this.onClickSwitch()
			this.onSwitchClick()
		})
	}
}