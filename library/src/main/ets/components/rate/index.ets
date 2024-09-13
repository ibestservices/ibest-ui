import { clamp, getComponentsInfo } from '../../assets/ets/utils'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type'
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
	@State uniId: number = 0
	// 选项列表
	@State optionsList: RateOption[] = []
	// 容器宽度
	@State containerWidth: number = 0
	// 手势左侧实时距离
	@State offsetX: number = 0
	@State offsetY: number = 0
	// 手势初始位置
	@State startX: number = 0
	@State startY: number = 0
	/*
	 * 值
	 */
	@Link @Watch("refreshList") value: number
	/*
	 * 图标总数
	 */
	@Prop count: number = 5
	/*
	 * 图标大小
	 */
	@Provide iconSize: number = 40
	/*
	 * 间距
	 */
	@Prop space: number = 8
	/*
	 * 选中图标
	 */
	@Provide activeIcon: Resource = $r("app.media.icon_star_o")
	/*
	 * 未选中图标
	 */
	@Provide inactiveIcon: Resource = $r("app.media.icon_star")
	/*
	 * 选中颜色
	 */
	@Provide activeColor: string = this.baseStyle.danger as string
	/*
	 * 未选中颜色
	 */
	@Provide inactiveColor: string = GRAY_COLOR.GRAY_5
	/*
	 * 是否允许半选
	 */
	@Prop allowHalf: boolean = false
	/*
	 * 禁用
	 */
	@Provide disabled: boolean = false
	/*
	 * 只读
	 */
	@Prop readOnly: boolean = false
	/*
	 * 禁用时颜色
	 */
	@Provide disabledColor: string = GRAY_COLOR.GRAY_5
	/*
	 * 是否可清空
	 */
	@Prop clearable: boolean = false
	/*
	 * 是否可通过滑动手势选择评分
	 */
	@Prop isTouchable: boolean = true
	/*
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
		// setTimeout(() => {
		// 	this.getContentWidth()
		// }, 10)
	}
	// TODO 获取组件容器宽度 暂时没有flex宽度自适应的方法
	getContentWidth(){
		this.containerWidth = getComponentsInfo(this.context, `IBestRate_${this.uniId}`).width
		console.log("containerWidth", this.containerWidth)
	}
	// 点击
	rateClick(event: ClickEvent, index: number){
		let x = px2lpx(vp2px(event.x))
		let value = 0
		if(this.allowHalf){
			value = index + (x <= this.iconSize/2 ? 0.5 : 1)
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
	// TODO 手指移动  实时计算当前手指之前的选项数量
	onFingerMove(event: GestureEvent){
		this.offsetX = px2lpx(vp2px(this.startX + event.offsetX))
		// this.offsetY = px2lpx(vp2px(this.startY + event.offsetY))
		this.value = clamp(Math.ceil(this.offsetX/(this.iconSize + this.space)), 0, this.count)
	}
	build() {
		// Row({ space: `${this.space}lpx` }){
		Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, space: { main: new LengthMetrics(this.space, LengthUnit.LPX) } }) {
			ForEach(this.optionsList, (item: RateOption, index: number) => {
				RateItem({ item: item })
				.onClick((event: ClickEvent) => {
					this.rateClick(event, index)
				})
			}, (item: RateOption, index) => index + "")
		}
		.width("auto")
		.id(`IBestRate_${this.uniId}`)
		.enabled(!(this.disabled || this.readOnly))
		.gesture(
			PanGesture(this.panOption)
				.onActionStart((event: GestureEvent) => {
					this.startX = this.offsetX = event.fingerList[0].localX
					this.startY = this.offsetY = event.fingerList[0].localY
				})
				.onActionUpdate((event: GestureEvent) => {
					this.isTouchable && this.onFingerMove(event)
				})
				.onActionEnd(() => {
					this.offsetX = 0
					this.offsetY = 0
					this.startX = 0
					this.startY = 0
					this.onChange(this.value)
				})
		)
	}
}

@Component
struct RateItem {
	@ObjectLink item: RateOption
	@Consume inactiveIcon: string | Resource
	@Consume activeIcon: string | Resource
	@Consume activeColor: string
	@Consume inactiveColor: string
	@Consume iconSize: number
	@Consume disabled: boolean
	@Consume disabledColor: string
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
					.width(`${this.iconSize}lpx`)
					.height(`${this.iconSize}lpx`)
					.draggable(false)
					.fillColor(this.disabled ? this.disabledColor : this.activeColor)
			}
			.width(this.item.value*100 + "%")
			.height(CONTAINER_SIZE.FULL)
			.clip(true)
		}
		.width(`${this.iconSize}lpx`)
		.aspectRatio(1)
	}
}