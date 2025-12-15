import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { emitter } from '../../utils/eventEmitter'
import { convertDimensionsWidthUnit, getComponentsInfo, getEventName, getSizeByUnit } from '../../utils/utils'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { IBestIcon } from '../icon'
import { IBestProgress } from '../progress'
import { IBestStepsColor } from './color'
import { COMPONENT_NAME, IBestStepConfig, IBestStepMarkType, STEPS_EVENT_NAME } from './index.type'

@Component
export struct IBestSteps{
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 分组id
     */
	@Prop @Require groupId: IBestStringNumber
	/**
	 * 当前激活的步骤索引
     */
	@Prop @Watch("activeChange") active: number = 0
	/**
	 * 背景色
	 * @since 2.1.3
	 */
	@Prop bgColor: ResourceColor = IBestStepsColor.bgColor
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
	 * 图标大小, 仅type为 icon 时有效
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
	@State percentContentSize: number = 0
	@State percentContentHeight: number = 0
	@State percent: number = 0
	allSteps: number[] = []
	private uiContext = this.getUIContext()
	private timer: number = 0

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		emitter.on(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.INIT_STEPS, this.groupId), this.uniId, (type: string, uniId: number): void => this.initSteps(type, uniId))
	}
	aboutToDisappear(): void {
		emitter.off(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.INIT_STEPS, this.groupId), this.uniId)
	}
	onDidBuild() {
		if(this.allSteps.length){
			emitter.emit(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_CONFIG, this.groupId), this.active, {
				placeDirection: this.placeDirection,
				type: this.type,
				dotSize: this.dotSize,
				inactiveIcon: this.inactiveIcon,
				activeIcon: this.activeIcon,
				iconSize: this.iconSize,
				activeColor: this.activeColor,
				inactiveColor: this.inactiveColor,
				bgColor: this.bgColor
			})
			this.percent = this.active / (this.allSteps.length - 1) * 100
			setTimeout(() => {
				let arr: number[] = []
				this.allSteps.forEach((_, index) => {
					arr.push(getComponentsInfo(this.uiContext, `ibest_steps_mark_${this.groupId}_${index}`).width)
				})
				this.percentContentSize = Math.max(...arr)
				emitter.emit(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_MAX_MARK_SIZE, this.groupId), this.percentContentSize)
				if(this.placeDirection == Axis.Vertical){
					let stepHeightArr: number[] = []
					for (let i = 0; i < this.allSteps.length - 1; i++) {
						stepHeightArr.push(getComponentsInfo(this.uiContext, `ibest_step_item_${this.groupId}_${i}`).height)
					}
					this.percentContentHeight = stepHeightArr.reduce((a, b) => a + b, 0)
				}else {
					let width = getComponentsInfo(this.uiContext, `ibest_steps_content_${this.uniId}`).width / (this.allSteps.length - 1)
					emitter.emit(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_STEP_ITEM_WIDTH, this.groupId), width)
				}
			}, 20)
		}
	}
	// 保存步骤id
	initSteps(type: string, uniId: number){
		if(type == 'add'){
			this.allSteps.push(uniId)
		}else if(type == 'del'){
			this.allSteps = this.allSteps.filter(item => item != uniId)
		}
		emitter.emit(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.SAVE_STEPS, this.groupId), this.allSteps)
		clearTimeout(this.timer)
		this.timer = setTimeout(() => {
			this.onDidBuild()
		}, 0)
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
	build() {
		if(this.placeDirection == Axis.Vertical){
			Stack({alignContent: Alignment.TopStart}){
				Column(){
					IBestProgress({
						value: $percent,
						lineWidth: 2,
						bgColor: IBestStepsColor.borderColor,
						color: this.activeColor,
						showText: false
					})
				}
				.width(this.percentContentHeight)
				.position({x: this.percentContentSize / 2, y: 0})
				.rotate({z: 1, angle: 90, centerX: 0, centerY: 1})
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
			.backgroundColor(this.bgColor)
		}else {
			Stack({alignContent: Alignment.Top}){
				Row(){
					IBestProgress({
						value: $percent,
						lineWidth: 2,
						bgColor: IBestStepsColor.borderColor,
						color: this.activeColor,
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
				.alignItems(VerticalAlign.Top)
			}
			.width(CONTAINER_SIZE.FULL)
			.backgroundColor(this.bgColor)
			.opacity(this.percentContentSize ? 1 : 0)
			.id(`ibest_steps_content_${this.uniId}`)
		}
	}
}

@Component
export struct IBestStep{
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
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
	 * 步骤标记类型
	 */
	@Prop type: IBestStepMarkType
	/**
	 * 点大小
	 */
	@Prop dotSize: IBestStringNumber
	/**
	 * 非激活底部图标, 仅type为 icon 时有效
	 */
	@Prop inactiveIcon: ResourceStr
	/**
	 * 激活底部图标, 仅type为 icon 时有效
	 */
	@Prop activeIcon: ResourceStr
	/**
	 * 图标大小, 仅type为 icon 时有效
	 */
	@Prop iconSize: IBestStringNumber
	/**
	 * 未激活颜色
	 */
	@Prop inactiveColor: ResourceColor
	/**
	 * 激活颜色
	 */
	@Prop activeColor: ResourceColor
	/**
	 * 自定义内容
	 */
	@BuilderParam defaultBuilder: CustomBuilder

	@State uniId: number = 0
	@State allSteps: number[] = []
	@State index: number = 0
	@State active: number = 0
	@State config: IBestStepConfig = {} as IBestStepConfig
	@State maxMarkWidth: number = 0
	@State stepItemWidth: number = 0

	@Builder stepContent(){
		Row(){
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
				.backgroundColor(this.config.bgColor)
				.id(this.getMarkId())
			}else if(this.config.type == 'num') {
				Row(){
					Text((this.index+1).toString())
						.fontSize(this.baseStyle.fontSizeSm)
						.fontColor(this.getActiveColor())
				}
				.padding({left: 4, right: 4})
				.aspectRatio(1)
				.borderRadius(this.baseStyle.borderRadiusMax)
				.border({width: 2, color: this.isActive() ? this.getActiveColor() : IBestStepsColor.borderColor})
				.justifyContent(FlexAlign.Center)
				.backgroundColor(this.config.bgColor)
				.id(this.getMarkId())
			}
		}
		.width(this.maxMarkWidth || "auto")
		.aspectRatio(1)
		.justifyContent(FlexAlign.Center)
		.alignItems(VerticalAlign.Top)
		if(this.defaultBuilder){
			this.defaultBuilder()
		}else {
			if(this.title){
				Text(this.title)
					.fontSize(this.baseStyle.fontSizeSm)
					.fontColor(this.getActiveColor())
					.textAlign(this.isVertical() ? TextAlign.Start : this.isLastStep() ? TextAlign.End : this.isFirstStep() ? TextAlign.Start : TextAlign.Center)
			}
			if(this.description){
				Text(this.description)
					.fontSize(this.baseStyle.fontSizeXs)
					.fontColor(this.getActiveColor())
					.textAlign(this.isVertical() ? TextAlign.Start : this.isLastStep() ? TextAlign.End : this.isFirstStep() ? TextAlign.Start : TextAlign.Center)
			}
		}
	}

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		emitter.on(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.SAVE_STEPS, this.groupId), this.uniId, (steps: number[]): void => this.saveSteps(steps))
		emitter.on(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_CONFIG, this.groupId), this.uniId, (active: number, data: IBestStepConfig): void => this.saveConfig(active, data))
		emitter.on(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.ACTIVE_CHANGE, this.groupId), this.uniId, (active: number): void => {
			this.active = active
		})
		emitter.on(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_MAX_MARK_SIZE, this.groupId), this.uniId, (size: number): void => {
			this.maxMarkWidth = size
		})
		emitter.on(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_STEP_ITEM_WIDTH, this.groupId), this.uniId, (width: number): void => {
			this.stepItemWidth = width
		})
	}
	aboutToDisappear(): void {
		emitter.off(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.SAVE_STEPS, this.groupId), this.uniId)
		emitter.off(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_CONFIG, this.groupId), this.uniId)
		emitter.off(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.ACTIVE_CHANGE, this.groupId), this.uniId)
		emitter.off(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_MAX_MARK_SIZE, this.groupId), this.uniId)
		emitter.off(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.GET_STEP_ITEM_WIDTH, this.groupId), this.uniId)
		emitter.emit(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.INIT_STEPS, this.groupId), 'del', this.uniId)
	}
	onDidBuild(): void {
		emitter.emit(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.INIT_STEPS, this.groupId), 'add', this.uniId)
	}

	saveSteps(steps: number[]){
		this.allSteps = steps
	}
	// 保存配置信息
	saveConfig(active: number, data: IBestStepConfig){
		this.active = active
		this.index = this.allSteps.indexOf(this.uniId)
		this.config = {
			placeDirection: data.placeDirection,
			type: this.type || data.type,
			dotSize: this.dotSize || data.dotSize,
			inactiveIcon: this.inactiveIcon || data.inactiveIcon,
			activeIcon: this.activeIcon || data.activeIcon,
			iconSize: this.iconSize || data.iconSize,
			inactiveColor: this.inactiveColor || data.inactiveColor,
			activeColor: this.activeColor || data.activeColor,
			bgColor: data.bgColor
		}
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
		return this.isActive() ? this.config.activeColor || this.baseStyle.primary : this.config.inactiveColor
	}
	// 生成id
	getMarkId(){
		return `ibest_steps_mark_${this.groupId}_${this.index}`
	}
	build() {
		if(this.isVertical()){
			Row({space: this.baseStyle.spaceXs}){
				this.stepContent()
			}
			.width(CONTAINER_SIZE.FULL)
			.alignItems(VerticalAlign.Top)
			.padding({bottom: this.baseStyle.spaceSm})
			.id(`ibest_step_item_${this.groupId}_${this.index}`)
		}else {
			Column({space: this.baseStyle.spaceXs}){
				this.stepContent()
			}
			.width(this.isFirstStep() || this.isLastStep() ? 'auto' : this.stepItemWidth)
			.layoutWeight(this.isFirstStep() || this.isLastStep() ? 1 : undefined)
			.alignItems(this.isFirstStep() ? HorizontalAlign.Start : this.isLastStep() ? HorizontalAlign.End : HorizontalAlign.Center)
			.animation({duration: this.isFirstStep() || this.isLastStep() ? 0 : 100})
		}
	}
}