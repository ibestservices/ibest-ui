import { clamp,
	convertDimensions,
	convertDimensionsWidthUnit, getComponentsInfo, getLengthUnit, getSizeByUnit } from '../../utils/utils'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { RateOption } from './index.type'
import { LengthMetrics, LengthUnit } from '@kit.ArkUI'

@Component
export struct IBestRate {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	// 唯一id
	@Provide uniId: number = 0
	// 选项列表
	@State optionsList: RateOption[] = []
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
	@Provide({allowOverride: "iconSize"}) iconSize: number | string = convertDimensions(20)
	/**
	 * 间距
	 */
	@Prop space: number | string = convertDimensions(4)
	/**
	 * 选中图标
	 */
	@Provide({allowOverride: "activeIcon"}) activeIcon: Resource = $r("app.media.icon_star_o")
	/**
	 * 未选中图标
	 */
	@Provide({allowOverride: "inactiveIcon"}) inactiveIcon: Resource = $r("app.media.icon_star")
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
			return new RateOption(val > 1 ? 1 : val > 0 ? val : 0)
		})
		setTimeout(() => {
			this.getContentWidth()
		}, 10)
	}
	// 获取组件容器宽度
	getContentWidth(){
		this.containerWidth = getComponentsInfo(this.context, `iBestRate_${this.uniId}`).width
		this.iconWidth = getComponentsInfo(this.context, `iBestRate_${this.uniId}_0`).width
		this.iconSpace = (this.containerWidth - this.iconWidth*this.count)/(this.count - 1)
		console.log("containerWidth", this.containerWidth, this.iconWidth)
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
		this.optionsList.forEach((item: RateOption, i: number) => {
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
			ForEach(this.optionsList, (item: RateOption, index: number) => {
				RateItem({ item: item, index })
				.onClick((event: ClickEvent) => {
					this.rateClick(event, index)
				})
			}, (item: RateOption, index) => index + "")
		}
		.id(`iBestRate_${this.uniId}`)
		.enabled(!(this.disabled || this.readOnly))
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
	@ObjectLink item: RateOption
	@Prop index: number
	@Consume uniId: number
	@Consume inactiveIcon: string | Resource
	@Consume activeIcon: string | Resource
	@Consume activeColor: ResourceColor
	@Consume inactiveColor: ResourceColor
	@Consume iconSize: number | string
	@Consume disabled: boolean
	@Consume disabledColor: ResourceColor
	build() {
		Stack({ alignContent: Alignment.Start }) {
			Image(this.inactiveIcon)
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
				.fillColor(this.inactiveColor)
				.draggable(false)
				.visibility(this.item.value == 1 ? Visibility.None : Visibility.Visible)
			Row() {
				Image(this.activeIcon)
					.width(getSizeByUnit(this.iconSize))
					.height(getSizeByUnit(this.iconSize))
					.draggable(false)
					.fillColor(this.disabled ? this.disabledColor : this.activeColor)
			}
			.width(this.item.value*100 + "%")
			.height(CONTAINER_SIZE.FULL)
			.clip(true)
		}
		.width(getSizeByUnit(this.iconSize))
		.aspectRatio(1)
		.id(`iBestRate_${this.uniId}_${this.index}`)
	}
}