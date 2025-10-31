import {
	addNumber,
	clamp,
	convertDimensionsWidthUnit,
	getComponentsInfo,
	getLengthUnit,
	getSizeByUnit
} from '../../utils/utils'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { LengthUnit } from '@kit.ArkUI'
import { IBestSliderTicks, IBestSliderValue } from './index.type'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { IBestSliderColor } from './color'

@Component
export struct IBestSlider{
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 当前进度值
	 */
	@Link @Watch("calcMainAxis") value: IBestSliderValue
	/**
	 * 最大值
	 */
	@Prop max: number = 100
	/**
	 * 最小值
	 */
	@Prop min: number = 0
	/**
	 * 步长
	 */
	@Prop step: number = 1
	/**
	 * 进度条高度
	 */
	@Prop barHeight: IBestStringNumber = convertDimensionsWidthUnit(2)
	/**
	 * 滑块大小
	 */
	@Prop buttonSize: IBestStringNumber = convertDimensionsWidthUnit(24)
	/**
	 * 滑块背景色
	 * @since 2.0.1
     */
	@Prop buttonBgColor: ResourceColor = IBestSliderColor.buttonBg
	/**
	 * 进度条激活态颜色
	 */
	@Prop activeColor: ResourceColor = ""
	/**
	 * 进度条背景颜色
	 */
	@Prop barBgColor: ResourceColor = IBestSliderColor.inactiveBg
	/**
	 * 是否禁用
	 */
	@Prop disabled: boolean = false
	/**
	 * 是否垂直展示
	 */
	@Prop vertical: boolean = false
	/**
	 * 是否反转
	 */
	@Prop reverse: boolean = false
	/**
	 * 是否显示刻度点
	 * @since 2.1.9
     */
	@Prop ticks: boolean = false
	/**
	 * 自定义滑块
	 */
	@BuilderParam customButton: CustomBuilder
	/**
	 * 自定义第二个滑块
	 * @since 2.1.2
     */
	@BuilderParam customSecondButton: CustomBuilder
	/**
	 * 触摸开始触发
	 */
	onTouchStart: (value: IBestSliderValue) => void = () => {}
	/**
	 * 触摸滑动中触发
	 */
	onTouchMove: (value: IBestSliderValue) => void = () => {}
	/**
	 * 触摸结束触发
	 */
	onTouchEnd: (value: IBestSliderValue) => void = () => {}
	/**
	 * 触摸结束触发
	 */
	onChange: (value: IBestSliderValue) => void = () => {}

	@State space: number = 2.5
	@State percentage: number = 0
	@State barOffset: number = 0
	@State realBarHeight: number = 0
	@State buttonIndex: 0 | 1 = 0
	@State buttonWidth: number = 0
	@State buttonHeight: number = 0

	@Builder dragBar(buttonIndex: 0 | 1){
		Row(){
			if(buttonIndex == 0 && this.customButton){
				this.customButton()
			}else if (buttonIndex == 1 && this.customSecondButton) {
				this.customSecondButton()
			}else{
				Row()
					.width(getSizeByUnit(this.buttonSize))
					.aspectRatio(1)
					.backgroundColor(this.buttonBgColor)
					.borderRadius(this.baseStyle.borderRadiusMax)
					.shadow({ radius: 2, color: "rgba(0,0,0,0.5)", offsetY: 1 })
			}
		}
		.position(this.getBarPosition(buttonIndex))
		.onAreaChange((_, newVal) => {
			this.buttonWidth = newVal.width as number
			this.buttonHeight = newVal.height as number
		})
	}

	aboutToAppear(): void {
		this.updateValue(this.value)
		this.calcMainAxis()
	}
	// 获取刻度值
	getScalesList(){
		let list = Array.from({length: (this.max - this.min) / this.step + 1}, (_: undefined, index: number) => this.min + index * this.step).map((item: number) => {
			let obj: IBestSliderTicks = {
				value: item,
				percent: (item - this.min) * 100 / (this.max - this.min)
			}
			return obj
		})
		return list
	}
	// 获取刻度大小
	getScaleSize(){
		return this.realBarHeight + 4
	}
	getActiveLinePosition(): LocalizedEdges{
		if(this.reverse){
			return this.vertical ? {
				bottom: { value: this.barOffset, unit: LengthUnit.PERCENT }
			} : {
				end: { value: this.barOffset, unit: LengthUnit.PERCENT }
			}
		}else{
			return this.vertical ? {
				top: { value: this.barOffset, unit: LengthUnit.PERCENT }
			} : {
				start: { value: this.barOffset, unit: LengthUnit.PERCENT }
			}
		}
	}
	getBarPosition(buttonIndex: 0 | 1): LocalizedEdges{
		let value: LengthMetrics = {
			value: -this.buttonWidth/2,
			unit: getLengthUnit()
		}
		if(Array.isArray(this.value)){
			if(this.vertical){
				return buttonIndex == 0 ? {
					top: value
				} : {
					bottom: value
				}
			}else{
				return buttonIndex == 0 ? {
					start: value
				} : {
					end: value
				}
			}
		}else{
			if(this.reverse){
				return this.vertical ? {
					top: value
				} : {
					start: value
				}
			}else{
				return this.vertical ? {
					bottom: value
				} : {
					end: value
				}
			}
		}
	}
	// 获取活动最大值
	getScopeValue(){
		return this.max - this.min
	}
	// 根据步数格式化值
	format(value: number): number{
		const min = +this.min
		const max = +this.max
		const step = +this.step
		value = clamp(value, min, max)
		return addNumber(min, Math.round((value - min) / step) * step)
	}
	// 计算选中条的长度百分比
	calcMainAxis(){
		let scope = this.getScopeValue()
		if (Array.isArray(this.value)) {
			this.barOffset = (this.value[0] - this.min) / scope
			this.percentage = ((this.value[1] - this.value[0]) * 100) / scope
		}else{
			this.barOffset = 0
			this.percentage = ((this.value - this.min) * 100) / scope
		}
	}
	// 背景触摸事件
	onBgTouch(event: TouchEvent){
		let touch = event.touches[0]
		if(!touch){
			return
		}
		const scope = this.getScopeValue()
		let value: number
		const width = event.target.area.width as number
		const height = event.target.area.height as number
		const x = touch.x
		const y = touch.y
		if(this.reverse){
			value = (this.vertical ? (height - y) / height * scope : (width - x) / width * scope) + this.min
		}else{
			value = (this.vertical ? y / height * scope : x / width * scope) + this.min
		}
		switch (event.type){
			case TouchType.Down:
				if (Array.isArray(this.value)) {
					let current = this.value
					const left = current[0]
					const right = current[1]
					const middle = (left + right) / 2
					if (value <= middle) {
						current = [value, right]
						this.buttonIndex = 0
					} else {
						current = [left, value]
						this.buttonIndex = 1
					}
					this.updateValue(current, "start")
				}else {
					this.updateValue(value, "start")
				}
				break
			case TouchType.Move:
				if (Array.isArray(this.value)) {
					let current = this.value
					const left = current[0]
					const right = current[1]
					const index = this.buttonIndex
					if(index == 0 && value >= right){
						current = [right, value]
						this.buttonIndex = 1
					}else if(index == 1 && value <= left) {
						current = [value, left]
						this.buttonIndex = 0
					}else{
						current[index] = value
					}
					this.updateValue(current, 'move')
				} else {
					this.updateValue(value, 'move')
				}
				break
			case TouchType.Up:
				this.onTouchEnd(this.value)
				this.onChange(this.value)
				break
		}
	}
	// 更新值
	updateValue(value: IBestSliderValue, type?: "start" | "move"){
		let val = Array.isArray(value) ? value.map(e => this.format(e)) as IBestSliderValue : this.format(value)
		this.value = val
		if(type == "start"){
			this.onTouchStart(val)
		}else if(type == "move"){
			this.onTouchMove(val)
		}
	}

	build() {
		Row(){
			Stack(){
				Row(){
					// 底层背景
					Row(){
						// 刻度
						if(this.ticks){
							ForEach(this.getScalesList(), (item: IBestSliderTicks) => {
								Row()
									.width(this.vertical ? '' : this.getScaleSize())
									.height(this.vertical ? this.getScaleSize() : '')
									.aspectRatio(1)
									.borderRadius(this.baseStyle.borderRadiusMax)
									.backgroundColor((Array.isArray(this.value) ? item.value >= this.value[0] && item.value <= this.value[1] : this.value >= item.value) ? this.activeColor || this.baseStyle.primary : this.barBgColor)
									.margin(this.vertical ? this.reverse ? { bottom: -this.getScaleSize()/2 } : { top: -this.getScaleSize()/2 } : this.reverse ? { left: -this.getScaleSize()/2 } : { right: -this.getScaleSize()/2 })
									.position(this.vertical ? this.reverse ? { bottom: `${item.percent}%`, left: this.realBarHeight/2 } : { top: `${item.percent}%`, left: this.realBarHeight/2 } : this.reverse ? { right: `${item.percent}%`, top: this.realBarHeight/2 } : { left: `${item.percent}%`, top: this.realBarHeight/2 })
									.translate(this.vertical ? { x: "-50%", y: this.reverse ? "50%" : "-50%" } : { x: this.reverse ? "50%" : "-50%", y: "-50%" })
							})
						}
					}
					.width(this.vertical ? getSizeByUnit(this.barHeight) : CONTAINER_SIZE.FULL)
					.height(this.vertical ? CONTAINER_SIZE.FULL : getSizeByUnit(this.barHeight))
					.backgroundColor(this.barBgColor)
					.borderRadius(this.baseStyle.borderRadiusMax)
					.justifyContent(FlexAlign.SpaceBetween)
					.opacity(this.disabled ? 0.5 : 1)
					.onAreaChange((_, newVal) => {
						this.realBarHeight = this.vertical ? newVal.width as number : newVal.height as number
					})
					// 激活条
					Row(){
						Row()
							.width(this.vertical ? getSizeByUnit(this.barHeight) : `${this.percentage}%`)
							.height(this.vertical ? `${this.percentage}%` : getSizeByUnit(this.barHeight))
							.backgroundColor(this.activeColor || this.baseStyle.primary)
							.borderRadius(this.baseStyle.borderRadiusMax)
							.opacity(this.disabled ? 0.5 : 1)
						// 拖动按钮1
						this.dragBar(0)
						// 拖动按钮2
						if(Array.isArray(this.value)){
							this.dragBar(1)
						}
					}
					.width(this.vertical ? this.buttonWidth || getSizeByUnit(this.buttonSize) : "")
					.height(this.vertical ? "" : this.buttonHeight || getSizeByUnit(this.buttonSize))
					.justifyContent(FlexAlign.Center)
					.position(this.getActiveLinePosition())
				}
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
				.justifyContent(FlexAlign.Center)
				.alignItems(VerticalAlign.Center)
				Row()
					.width(CONTAINER_SIZE.FULL)
					.height(CONTAINER_SIZE.FULL)
					.monopolizeEvents(true)
					.onTouch((event: TouchEvent) => {
						this.onBgTouch(event)
					})
			}
			.width(this.vertical ? this.buttonWidth : CONTAINER_SIZE.FULL)
			.height(this.vertical ? CONTAINER_SIZE.FULL : this.buttonHeight)
			.opacity(this.buttonHeight ? 1 : 0)
		}
		.padding({
			left: this.vertical ? 0 : this.buttonWidth/2 + this.space,
			right: this.vertical ? 0 : this.buttonWidth/2 + this.space,
			top: this.vertical ? this.buttonHeight/2 + this.space : this.space,
			bottom: this.vertical ? this.buttonHeight/2 + this.space : this.space
		})
		.enabled(!this.disabled)
	}
}

