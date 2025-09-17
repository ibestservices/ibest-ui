import { clamp, getComponentsInfo, getSizeByUnit } from '../../utils/utils'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { IBestRateOption } from './index.type'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { IBestIcon } from '../../../../../Index'

@Component
export struct IBestRate {
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	// 唯一id
	@Provide uniId: number = 0
	// 选项列表
	@State optionsList: IBestRateOption[] = []
	// 容器宽度
	@State containerWidth: number = 0
	// 单个图标宽度
	@State iconWidth: number = 0
	// 图标间距
	@State iconSpace: number = 0
	// 手势初始位置
	@State startX: number = 0
	/**
	 * 值
	 */
	@Link @Watch("refreshList") value: number
	/**
	 * 图标总数
	 */
	@Prop count: number = 5
	/**
	 * 图标大小
	 */
	@Provide({allowOverride: "iconSize"}) iconSize: IBestStringNumber = 20
	/**
	 * 间距
	 */
	@Prop space: IBestStringNumber = 4
	/**
	 * 选中图标
	 */
	@Provide({allowOverride: "activeIcon"}) activeIcon: ResourceStr = $r("app.media.ibest_icon_star_o")
	/**
	 * 未选中图标
	 */
	@Provide({allowOverride: "inactiveIcon"}) inactiveIcon: ResourceStr = $r("app.media.ibest_icon_star")
	/**
	 * 选中颜色
	 */
	@Provide({allowOverride: "activeColor"}) activeColor: ResourceColor = this.baseStyle.danger as string
	/**
	 * 未选中颜色
	 */
	@Provide({allowOverride: "inactiveColor"}) inactiveColor: ResourceColor = GRAY_COLOR.GRAY_5
	/**
	 * 是否允许半选
	 */
	@Prop allowHalf: boolean = false
	/**
	 * 禁用
	 */
	@Provide({allowOverride: "disabled"}) disabled: boolean = false
	/**
	 * 只读
	 */
	@Prop readOnly: boolean = false
	/**
	 * 禁用时颜色
	 */
	@Provide({allowOverride: "disabledColor"}) disabledColor: ResourceColor = GRAY_COLOR.GRAY_5
	/**
	 * 是否可清空
	 */
	@Prop clearable: boolean = false
	/**
	 * 是否可通过滑动手势选择评分
	 */
	@Prop isTouchable: boolean = true
	/**
	 * 分值变化回调
	 */
	onChange: (value: number) => void = () => {}
	private context = this.getUIContext()

	private panOption: PanGestureOptions = new PanGestureOptions({
		fingers: 1,
		distance: 1
	})

	aboutToAppear(): void {
		this.init()
	}
	// 初始化
	init(){
		let value = clamp(this.value, 0, this.count)
		this.uniId = this.getUniqueId()
		if(value.toString().indexOf(".") > -1 && !this.allowHalf){
			value = Math.ceil(value)
		}
		this.optionsList = Array(this.count).fill(0).map((_: number, i: number) => {
			let val = value - i
			return new IBestRateOption(val > 1 ? 1 : val > 0 ? val : 0)
		})
	}
	// 获取组件容器宽度
	getContentWidth(){
		this.containerWidth = getComponentsInfo(this.context, `ibest_rate_${this.uniId}`).width
		this.iconWidth = getComponentsInfo(this.context, `ibest_rate_${this.uniId}_0`).width
		this.iconSpace = (this.containerWidth - this.iconWidth*this.count)/(this.count - 1)
	}
	// 点击
	rateClick(event: ClickEvent, index: number){
		let x = event.x
		let value = 0
		if(this.allowHalf){
			value = index + (x <= this.iconWidth/2 ? 0.5 : 1)
		}else{
			value = index + 1
		}
		this.value = value == this.value && this.clearable ? 0 : value
		this.onChange(this.value)
	}
	// 刷新optionsList
	refreshList(){
		let value = this.value
		this.optionsList.forEach((item: IBestRateOption, i: number) => {
			let val = value - i
			item.value = val > 1 ? 1 : val > 0 ? val : 0
		})
	}
	// 手指移动
	onFingerMove(event: GestureEvent){
		let offsetX = this.startX + event.offsetX
		this.value = clamp(Math.ceil(offsetX/(this.iconWidth + this.iconSpace)), 0, this.count)
	}
	build() {
		Row({ space: getSizeByUnit(this.space) }){
			ForEach(this.optionsList, (item: IBestRateOption, index: number) => {
				RateItem({ item: item, index })
				.onClick((event: ClickEvent) => {
					this.rateClick(event, index)
				})
			}, (_: IBestRateOption, index) => index + "")
		}
		.id(`ibest_rate_${this.uniId}`)
		.enabled(!(this.disabled || this.readOnly))
		.onAppear(() => {
			setTimeout(() => {
				this.getContentWidth()
			}, 10)
		})
		.onVisibleAreaChange([0,1], (isExpanding: boolean) => {
			if(isExpanding && !this.containerWidth){
				this.getContentWidth()
			}
		})
		.gesture(
			PanGesture(this.panOption)
				.onActionStart((event: GestureEvent) => {
					this.startX = event.fingerList[0].localX
				})
				.onActionUpdate((event: GestureEvent) => {
					this.isTouchable && this.onFingerMove(event)
				})
				.onActionEnd(() => {
					this.startX = 0
					this.onChange(this.value)
				})
		)
	}
}

@Component
struct RateItem {
	@ObjectLink item: IBestRateOption
	@Prop index: number
	@Consume uniId: number
	@Consume inactiveIcon: ResourceStr
	@Consume activeIcon: ResourceStr
	@Consume activeColor: ResourceColor
	@Consume inactiveColor: ResourceColor
	@Consume iconSize: IBestStringNumber
	@Consume disabled: boolean
	@Consume disabledColor: ResourceColor
	build() {
		Stack({ alignContent: Alignment.Start }) {
			IBestIcon({
				name: this.inactiveIcon,
				iconSize: CONTAINER_SIZE.FULL,
				color: this.inactiveColor
			})
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
				.visibility(this.item.value == 1 ? Visibility.None : Visibility.Visible)
			Row() {
				IBestIcon({
					name: this.activeIcon,
					iconSize: CONTAINER_SIZE.FULL,
					color: this.disabled ? this.disabledColor : this.activeColor
				})
					.width(getSizeByUnit(this.iconSize))
					.height(getSizeByUnit(this.iconSize))
			}
			.width(this.item.value*100 + "%")
			.height(CONTAINER_SIZE.FULL)
			.clip(true)
		}
		.width(getSizeByUnit(this.iconSize))
		.aspectRatio(1)
		.id(`ibest_rate_${this.uniId}_${this.index}`)
	}
}