import { IBestIcon, IBestProgress, IBestStringNumber } from "../../../../../Index"
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { emitter } from "../../utils/EventEmitter"
import { convertDimensionsWidthUnit, getComponentsInfo, getEventName, getSizeByUnit } from "../../utils/utils"
import { IBestStepsColor } from "./color"
import { COMPONENT_NAME, IBestStepConfig, IBestStepMarkType, STEPS_EVENT_NAME } from "./index.type"

@Component
export struct IBestSteps{
	/**
	 * 分组id
     */
	@Prop @Require groupId: IBestStringNumber
	/**
	 * 当前激活的步骤索引
     */
	@Prop @Watch("activeChange") active: number = 0
	/**
	 * 步骤条方向
     */
	@Prop placeDirection: Axis = Axis.Horizontal
	/**
	 * 步骤标记类型
     */
	@Prop type: IBestStepMarkType = 'num'
	/**
	 * 点大小
     */
	@Prop dotSize: IBestStringNumber = convertDimensionsWidthUnit(6)
	/**
	 * 非激活底部图标, 仅type为 icon 时有效
     */
	@Prop inactiveIcon: ResourceStr = ""
	/**
	 * 激活底部图标, 仅type为 icon 时有效
     */
	@Prop activeIcon: ResourceStr = ""
	/**
	 * 图标大小
     */
	@Prop iconSize: IBestStringNumber = convertDimensionsWidthUnit(14)
	/**
	 * 未激活颜色
     */
	@Prop inactiveColor: ResourceColor = IBestStepsColor.inactiveColor
	/**
	 * 激活颜色
     */
	@Prop activeColor: ResourceColor = ""
	/**
	 * 自定义内容
     */
	@BuilderParam defaultBuilder: CustomBuilder

	@State uniId: number = 0
	@State allSteps: number[] = []
	@State percentContentSize: number = 0
	@State stepHeightArr: number[] = []
	@State percentContentHeight: number = 0
	@State percent: number = 0
	private uiContext = this.getUIContext()

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		emitter.on(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_ALL_STEPS, this.groupId), this.uniId, (uniId: number): void => this.saveSteps(uniId))
	}
	onDidBuild(): void {
		setTimeout(() => {
			if(this.allSteps.length){
				emitter.emit(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_CONFIG, this.groupId), this.allSteps, this.active, {
					placeDirection: this.placeDirection,
					type: this.type,
					dotSize: this.dotSize,
					inactiveIcon: this.inactiveIcon,
					activeIcon: this.activeIcon,
					iconSize: this.iconSize,
					activeColor: this.activeColor,
					inactiveColor: this.inactiveColor
				})
				this.percent = this.active / (this.allSteps.length - 1) * 100
				setTimeout(() => {
					let size = getComponentsInfo(this.uiContext, `ibest_steps_mark_${this.groupId}`)
					this.percentContentSize = this.placeDirection == Axis.Vertical ? size.width : size.height
					if(this.placeDirection == Axis.Vertical){
						for (let i = 0; i < this.allSteps.length - 1; i++) {
							this.stepHeightArr.push(getComponentsInfo(this.uiContext, `ibest_step_item_${this.groupId}_${i}`).height)
						}
						this.percentContentHeight = this.stepHeightArr.reduce((a, b) => a + b, 0)
					}
				}, 50)
			}
		}, 50)
	}
	// 保存步骤id
	saveSteps(uniId: number){
		if(!this.allSteps.includes(uniId)){
			this.allSteps.push(uniId)
		}
	}
	// 索引变化
	activeChange(){
		let percent = this.active / (this.allSteps.length - 1) * 100
		let oldPercent = this.percent
		this.percent = percent
		setTimeout(() => {
			emitter.emit(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.ACTIVE_CHANGE, this.groupId), this.active)
		}, percent > oldPercent ? 280 : 0)
	}
	// 获取激活颜色
	getActiveColor(){
		return this.activeColor || IBestStepsColor.activeColor
	}
	build() {
		if(this.placeDirection == Axis.Vertical){
			Stack({alignContent: Alignment.TopStart}){
				Column(){
					Column(){
						IBestProgress({
							value: $percent,
							lineWidth: 2,
							bgColor: IBestStepsColor.borderColor,
							color: this.getActiveColor(),
							showText: false
						})
					}
					.width(this.percentContentHeight)
					.position({x: this.percentContentSize / 2, y: 0})
					.rotate({z: 1, angle: 90, centerX: 0, centerY: 1})
				}
				.width(this.percentContentSize)
				.height(this.percentContentHeight)
				Column(){
					if(this.defaultBuilder){
						this.defaultBuilder()
					}
				}
				.width(CONTAINER_SIZE.FULL)
				.alignItems(HorizontalAlign.Start)
				.id(`ibest_steps_right_${this.groupId}`)
			}
			.width(CONTAINER_SIZE.FULL)
			.backgroundColor(IBestStepsColor.bgColor)
		}else {
			Stack({alignContent: Alignment.Top}){
				Row(){
					IBestProgress({
						value: $percent,
						lineWidth: 2,
						bgColor: IBestStepsColor.borderColor,
						color: this.getActiveColor(),
						showText: false
					})
				}
				.height(this.percentContentSize)
				Row(){
					if(this.defaultBuilder){
						this.defaultBuilder()
					}
				}
				.width(CONTAINER_SIZE.FULL)
				.justifyContent(FlexAlign.SpaceBetween)
			}
			.width(CONTAINER_SIZE.FULL)
			.backgroundColor(IBestStepsColor.bgColor)
			.opacity(this.percentContentSize ? 1 : 0)
		}
	}
}

@Component
export struct IBestStep{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 分组id
	 */
	@Prop @Require groupId: IBestStringNumber
	/**
	 * 标题
     */
	@Prop title: ResourceStr
	/**
	 * 描述
     */
	@Prop description: ResourceStr
	/**
	 * 自定义内容
	 */
	@BuilderParam defaultBuilder: CustomBuilder

	@State uniId: number = 0
	@State allSteps: number[] = []
	@State index: number = 0
	@State active: number = 0
	@State config: IBestStepConfig = {} as IBestStepConfig

	@Builder stepContent(){
		if(this.config.type == 'dot'){
			Row()
				.width(getSizeByUnit(this.config.dotSize))
				.aspectRatio(1)
				.borderRadius(this.baseStyle.borderRadiusMax)
				.backgroundColor(this.getActiveColor())
				.id(this.getMarkId())
		}else if(this.config.type == 'icon'){
			Row(){
				IBestIcon({
					name: this.isActive() ? this.config.activeIcon : this.config.inactiveIcon,
					iconSize: this.config.iconSize,
					color: this.getActiveColor()
				})
			}
			.backgroundColor(IBestStepsColor.bgColor)
			.id(this.getMarkId())
		}else if(this.config.type == 'num') {
			Row(){
				Text((this.index+1).toString())
					.fontSize(this.baseStyle.fontSizeSm)
					.fontColor(this.getActiveColor())
			}
			.padding(4)
			.aspectRatio(1)
			.borderRadius(this.baseStyle.borderRadiusMax)
			.border({width: 2, color: this.isActive() ? this.baseStyle.primary : IBestStepsColor.borderColor})
			.justifyContent(FlexAlign.Center)
			.backgroundColor(IBestStepsColor.bgColor)
			.id(this.getMarkId())
		}
		if(this.defaultBuilder){
			this.defaultBuilder()
		}else {
			if(this.title){
				Text(this.title)
					.fontSize(this.baseStyle.fontSizeSm)
					.fontColor(this.getActiveColor())
			}
			if(this.description){
				Text(this.description)
					.fontSize(this.baseStyle.fontSizeXs)
					.fontColor(this.getActiveColor())
			}
		}
	}

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		emitter.on(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_CONFIG, this.groupId), this.uniId, (steps: number[], active: number, data: IBestStepConfig): void => this.saveConfig(steps, active, data))
		emitter.on(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.ACTIVE_CHANGE, this.groupId), this.uniId, (active: number): void => {
			this.active = active
		})
		emitter.emit(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_ALL_STEPS, this.groupId), this.uniId)
	}
	aboutToDisappear(): void {
		emitter.off(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_CONFIG, this.groupId), this.uniId)
		emitter.off(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.ACTIVE_CHANGE, this.groupId), this.uniId)
	}
	// 保存配置信息
	saveConfig(steps: number[], active: number, data: IBestStepConfig){
		this.allSteps = steps
		this.active = active
		this.index = steps.indexOf(this.uniId)
		this.config = data
	}
	// 获取是否是第一个
	isFirstStep(): boolean{
		return this.uniId == this.allSteps[0]
	}
	// 获取是否是最后一个步骤
	isLastStep(): boolean{
		return this.uniId == this.allSteps[this.allSteps.length - 1]
	}
	// 当前是否激活
	isActive(): boolean{
		return this.active >= this.index
	}
	// 是否是竖向排列
	isVertical(): boolean{
		return this.config.placeDirection == Axis.Vertical
	}
	// 获取激活颜色
	getActiveColor(){
		return this.isActive() ? (this.config.activeColor || IBestStepsColor.activeColor) : this.config.inactiveColor
	}
	// 生成id
	getMarkId(){
		return `ibest_steps_mark_${this.groupId}`
	}
	build() {
		if(this.isVertical()){
			Row({space: this.baseStyle.spaceXs as string}){
				this.stepContent()
			}
			.width(CONTAINER_SIZE.FULL)
			.alignItems(VerticalAlign.Top)
			.padding({bottom: this.baseStyle.spaceSm as string})
			.id(`ibest_step_item_${this.groupId}_${this.index}`)
		}else {
			Column({space: this.baseStyle.spaceXs as string}){
				this.stepContent()
			}
			.layoutWeight(1)
			.alignItems(this.isFirstStep() ? HorizontalAlign.Start : this.isLastStep() ? HorizontalAlign.End : HorizontalAlign.Center)
		}
	}
}