import { IBestEdges, IBestStringNumber } from "../../model/Global.type"

export class IBestFloatBubbleOption{
	bubbleSize: IBestStringNumber = ""
	shape: "rect" | "circle" = "rect"
	icon: ResourceStr = ""
	iconSize: IBestStringNumber = ""
	iconColor: ResourceColor = ""
	bgColor: ResourceColor = ""
	radius: IBestStringNumber = ""
	pos: IBestEdges = {}
	isMagnetic: boolean = true
	gap: number = 0
	bubbleShadow: ShadowOptions | ShadowStyle = {radius: 0}
	autoHide: boolean = false
	hideDelay: number = 0
	remainSize: number = 0
	onBubbleClick: () => void = () => {}
}

export class IBestFloatBubbleParams extends IBestFloatBubbleOption{
	constructor(option: IBestFloatBubbleOption) {
		super()
		this.bubbleSize = option.bubbleSize
		this.shape = option.shape
		this.icon = option.icon
		this.iconSize = option.iconSize
		this.iconColor = option.iconColor
		this.bgColor = option.bgColor
		this.radius = option.radius
		this.pos = option.pos
		this.isMagnetic = option.isMagnetic
		this.gap = option.gap
		this.bubbleShadow = option.bubbleShadow
		this.autoHide = option.autoHide
		this.hideDelay = option.hideDelay
		this.remainSize = option.remainSize
		this.onBubbleClick = option.onBubbleClick
	}
}