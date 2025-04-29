import {
	addNumber,
	clamp,
	convertDimensions,
	convertDimensionsWidthUnit,
	getComponentsInfo,
	getLengthUnit,
	getSizeByUnit
} from '../../utils/utils'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { LengthUnit } from '@kit.ArkUI'
import { IBestSliderValue } from './index.type'
import { IBestGlobalConfig, IBestStringNumber } from '../../model/Global.type'
import { IBestSliderColor } from './color'

@Component
export struct IBestSlider{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@State uniId: number = 0
	@State space: number = 2.5
	@State percentage: number = 0
	@State barOffset: number = 0
	@State buttonIndex: 0 | 1 = 0
	@Provide buttonWidth: number = 0
	@Provide buttonHeight: number = 0
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
	@Provide({allowOverride: "buttonSize"}) buttonSize: number = convertDimensions(24)
	/**
	 * 滑块背景色
	 * @since 2.0.1
     */
	@Provide({allowOverride: "buttonBgColor"}) buttonBgColor: ResourceColor = IBestSliderColor.buttonBg
	/**
	 * 进度条激活态颜色
	 */
	@Prop activeColor: ResourceColor = this.baseStyle.primary
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
	@Provide({allowOverride: "vertical"}) vertical: boolean = false
	/**
	 * 是否反转
	 */
	@Provide({allowOverride: "reverse"}) reverse: boolean = false
	/**
	 * 自定义滑块
	 */
	@BuilderParam customButton?: CustomBuilder
	/**
	 * 进度变化且拖动结束后触发
	 */
	onChange: (value: IBestSliderValue) => void = () => {}

	private uiContext = this.getUIContext()

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		this.updateValue(this.value)
		this.calcMainAxis()
		setTimeout(() => {
			this.getButtonSize()
		}, 50)
	}

	// 获取slider 内容容器尺寸
	getButtonSize(){
		let size = getComponentsInfo(this.uiContext, `buttonBox_${this.uniId}`)
		this.buttonWidth = size.width
		this.buttonHeight = size.height
	}
	getBarPosition(): LocalizedEdges{
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
		const diff = Math.round((value - min) / step) * step
		return addNumber(min, diff)
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
			value = (this.vertical ? Math.round((height - y) / height * scope) : Math.round((width - x) / width * scope)) + this.min
		}else{
			value = (this.vertical ? Math.round(y / height * scope) : Math.round(x / width * scope)) + this.min
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
					this.updateValue(current)
				}else {
					this.updateValue(value)
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
					this.updateValue(current)
				} else {
					this.updateValue(value)
				}
				break
			case TouchType.Up:
				this.onChange(this.value)
				break
		}
	}
	// 更新值
	updateValue(value: IBestSliderValue){
		if (Array.isArray(value)) {
			this.value = value.map(e => this.format(e)) as IBestSliderValue
		} else {
			this.value = this.format(value)
		}
	}

	build() {
		Row(){
			Stack(){
				Row(){
					// 底层背景
					Row()
						.width(this.vertical ? getSizeByUnit(this.barHeight) : CONTAINER_SIZE.FULL)
						.height(this.vertical ? CONTAINER_SIZE.FULL : getSizeByUnit(this.barHeight))
						.backgroundColor(this.barBgColor)
						.borderRadius(this.baseStyle.borderRadiusMax)
						.opacity(this.disabled ? 0.5 : 1)
					// 激活条
					Row(){
						Row()
							.width(this.vertical ? getSizeByUnit(this.barHeight) : `${this.percentage}%`)
							.height(this.vertical ? `${this.percentage}%` : getSizeByUnit(this.barHeight))
							.backgroundColor(this.activeColor)
							.borderRadius(this.baseStyle.borderRadiusMax)
							.opacity(this.disabled ? 0.5 : 1)
						// 拖动按钮1
						DragBar({
							value: this.value,
							uniId: this.uniId,
							buttonIndex: 0,
							customButton: this.customButton
						})
						// 拖动按钮2
						if(Array.isArray(this.value)){
							DragBar({
								value: this.value,
								buttonIndex: 1,
								customButton: this.customButton
							})
						}
					}
					.width(this.vertical ? convertDimensionsWidthUnit(this.buttonWidth || this.buttonSize) : "")
					.height(this.vertical ? "" : convertDimensionsWidthUnit(this.buttonHeight || this.buttonSize))
					.justifyContent(FlexAlign.Center)
					.position(this.getBarPosition())
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
			.width(this.vertical ? convertDimensionsWidthUnit(this.buttonWidth) : CONTAINER_SIZE.FULL)
			.height(this.vertical ? CONTAINER_SIZE.FULL : convertDimensionsWidthUnit(this.buttonHeight))
		}
		.padding({
			left: this.vertical ? 0 : convertDimensionsWidthUnit(this.buttonWidth/2 + this.space),
			right: this.vertical ? 0 : convertDimensionsWidthUnit(this.buttonWidth/2 + this.space),
			top: this.vertical ? convertDimensionsWidthUnit(this.buttonHeight/2 + this.space) : convertDimensionsWidthUnit(this.space),
			bottom: this.vertical ? convertDimensionsWidthUnit(this.buttonHeight/2 + this.space) : convertDimensionsWidthUnit(this.space)
		})
		.enabled(!this.disabled)
	}
}

@Component
struct DragBar{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@StorageProp("IBestGlobalConfig") config: IBestGlobalConfig = new IBestGlobalConfig()
	@Prop value: IBestSliderValue
	@Prop uniId: number
	@Consume buttonWidth: number
	@Consume buttonHeight: number
	@Consume buttonSize: IBestStringNumber
	@Consume buttonBgColor: ResourceColor
	@Consume vertical: boolean
	@Consume reverse: boolean
	@Prop buttonIndex: 0 | 1 = 0
	@BuilderParam customButton?: CustomBuilder

	getBarPosition(): LocalizedEdges{
		let value: LengthMetrics = {
			value: -convertDimensions(this.buttonWidth/2),
			unit: getLengthUnit()
		}
		if(Array.isArray(this.value)){
			if(this.vertical){
				return this.buttonIndex == 0 ? {
					top: value
				} : {
					bottom: value
				}
			}else{
				return this.buttonIndex == 0 ? {
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

	build() {
		Row(){
			if(this.customButton){
				this.customButton()
			}else{
				Row()
					.width(getSizeByUnit(this.buttonSize))
					.aspectRatio(1)
					.backgroundColor(this.buttonBgColor)
					.borderRadius(this.baseStyle.borderRadiusMax)
					.shadow({ radius: 2, color: "rgba(0,0,0,0.5)", offsetY: 1 })
			}
		}
		.id(`buttonBox_${this.uniId}`)
		.position(this.getBarPosition())
	}
}

