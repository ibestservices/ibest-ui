import { IBestEdges, IBestShape, IBestStringNumber } from '../../model/Global.type'
/**
 * 组件名称
 */
export const COMPONENT_NAME = 'FLOATBUBBLE';
/**
 * FloatBubble事件名称
 */
export enum FLOAT_BUBBLE_EVENT_NAME {
	/**
	 * 配置更新
	 */
	CONFIG_UPDATE = 'CONFIG_UPDATE'
}
/**
 * 可拖拽方向
 */
export type IBestFloatBubbleDragAxis = 'x' | 'y' | 'xy' | 'lock'

export class IBestFloatBubbleOption{
	groupId: number = 0
	bubbleSize: IBestStringNumber = ""
	shape: IBestShape = "circle"
	icon: ResourceStr = ""
	iconSize: IBestStringNumber = ""
	iconColor: ResourceColor = ""
	bgColor: ResourceColor = ""
	radius: IBestStringNumber = ""
	pos: IBestEdges = {}
    dragAxis: IBestFloatBubbleDragAxis = "y"
	isMagnetic: boolean = true
	gap: number = 0
	bubbleShadow: ShadowOptions | ShadowStyle = {radius: 0}
	autoHide: boolean = false
	hideDelay: number = 0
	remainSize: number = 0
    defaultBuilder: CustomBuilder = () => {}
	onBubbleClick: () => void = () => {}
}

export class IBestFloatBubbleParams extends IBestFloatBubbleOption{
	constructor(option: IBestFloatBubbleOption) {
		super()
		this.groupId = option.groupId
		this.bubbleSize = option.bubbleSize
		this.shape = option.shape
		this.icon = option.icon
		this.iconSize = option.iconSize
		this.iconColor = option.iconColor
		this.bgColor = option.bgColor
		this.radius = option.radius
		this.pos = option.pos
        this.dragAxis = option.dragAxis
		this.isMagnetic = option.isMagnetic
		this.gap = option.gap
		this.bubbleShadow = option.bubbleShadow
		this.autoHide = option.autoHide
		this.hideDelay = option.hideDelay
		this.remainSize = option.remainSize
        this.defaultBuilder = option.defaultBuilder
		this.onBubbleClick = option.onBubbleClick
	}
}