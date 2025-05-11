import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from '../../utils/utils';
import { ComponentContent, OverlayManager } from '@kit.ArkUI';
import { IBestFloatBubbleDragAxis, IBestFloatBubbleParams } from './index.type';
import { IBestEdges, IBestStringNumber } from '../../model/Global.type';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { IBestIcon } from '../icon';
import { IBestFloatBubbleColor } from './color';
@Builder
function bubbleDefaultBuilder(option: IBestFloatBubbleParams) {
	Column(){
		FloatBubbleComponent({option})
	}
	.width(CONTAINER_SIZE.FULL)
	.height(CONTAINER_SIZE.FULL)
	.hitTestBehavior(HitTestMode.Transparent)
}

@Component
struct FloatBubbleComponent{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@Prop option: IBestFloatBubbleParams
    @BuilderParam defaultBuilder: CustomBuilder
	@State uniId: number = 0
    @State isReady: boolean = false
	@State offsetX: number = 0
	@State offsetY: number = 0
    private enableAnimation: boolean = true
    private isHide: boolean = false
    private isDragging: boolean = false
    private positionX: number = 0
    private positionY: number = 0
    private boxWidth: number = 0
    private bubbleSize: number = 0
	private uiContext: UIContext = this.getUIContext()
	private panOption: PanGestureOptions = new PanGestureOptions({ distance: 1 })
	private minX: number = 0
	private maxX: number = 0
	private minY: number = 0
	private maxY: number = 0
	private timer: number = 0
	private preX: number = 0

	aboutToAppear(): void {
		this.init()
	}
	// 初始化位置
	init(){
        this.defaultBuilder = this.option.defaultBuilder
        this.setDirection()
		setTimeout(() => {
			let boxSize = getComponentsInfo(this.uiContext, `ibest_float_bubble_box_${this.uniId}`)
			this.bubbleSize = getComponentsInfo(this.uiContext, `ibest_float_bubble_${this.uniId}`).width
            this.boxWidth = boxSize.width
			this.minX = this.option.gap ?? 0
			this.maxX = boxSize.width - this.bubbleSize - this.option.gap
			this.minY = this.option.gap ?? 0
			this.maxY = boxSize.height - this.bubbleSize - this.option.gap
            if(this.option.pos){
                if(this.option.pos.right != undefined){
                    this.offsetX = boxSize.width - this.bubbleSize - Math.max(this.option.pos.right, this.option.gap)
                }else if(this.option.pos.left != undefined){
                    this.offsetX = Math.max(this.option.pos.left, this.option.gap)
                }
                if(this.option.pos.bottom != undefined){
                    this.offsetY = boxSize.height - this.bubbleSize - Math.max(this.option.pos.bottom, this.option.gap)
                }else if(this.option.pos.top != undefined){
                    this.offsetY = Math.max(this.option.pos.top, this.option.gap)
                }
            }else{
                this.offsetX = this.maxX
                this.offsetY = this.maxY
            }
            this.positionX = this.offsetX
            this.positionY = this.offsetY
            setTimeout(() => {
                this.isReady = true
                this.autoHide()
            }, 300)
		}, 50)
	}
    // 设置拖动方向
    setDirection(){
        switch (this.option.dragAxis){
            case 'x':
                this.panOption.setDirection(PanDirection.Horizontal)
                break;
            case 'y':
                this.panOption.setDirection(PanDirection.Vertical)
                break;
            case 'xy':
                this.panOption.setDirection(PanDirection.All)
                break
            default:
                this.panOption.setDirection(PanDirection.None)
                break
        }
    }
	// 拖动中
	onActionUpdate(event: GestureEvent){
		let offsetX = this.positionX + event.offsetX
		let offsetY = this.positionY + event.offsetY
		this.offsetX = offsetX < this.minX ? this.minX : offsetX > this.maxX ? this.maxX : offsetX
		this.offsetY = offsetY < this.minY ? this.minY : offsetY > this.maxY ? this.maxY : offsetY
	}
	// 拖动结束
	onActionEnd(){
        this.enableAnimation = true
		if(this.option.isMagnetic){
			if(this.offsetX < this.maxX/2){
				this.offsetX = this.minX
			}else if(this.offsetX > this.maxX/2){
				this.offsetX = this.maxX
			}
			this.autoHide()
		}
		this.positionX = this.offsetX
		this.positionY = this.offsetY
        this.isDragging = false
	}
	// 自动隐藏
	autoHide(){
        if(this.option.autoHide){
            clearTimeout(this.timer)
            this.timer = setTimeout(() => {
                this.preX = this.offsetX
                this.offsetX = this.offsetX < this.maxX/2 ? -this.bubbleSize + this.option.remainSize : this.boxWidth - this.option.remainSize
                this.isHide = true
                this.panOption.setDirection(PanDirection.None)
            }, this.option.hideDelay)
        }
	}
	// 气泡点击
	onBubbleClick(){
		if(this.isHide){
            this.isHide = false
			this.offsetX = this.preX
            this.setDirection()
            this.autoHide()
		}else {
			this.option.onBubbleClick()
		}
	}

	build() {
		Column(){
			Row(){
                if(this.defaultBuilder){
                    this.defaultBuilder()
                }else {
                    IBestIcon({
                        name: this.option.icon,
                        iconSize: this.option.iconSize,
                        color: this.option.iconColor
                    })
                }
			}
				.width(getSizeByUnit(this.option.bubbleSize))
				.aspectRatio(1)
                .justifyContent(FlexAlign.Center)
				.backgroundColor(this.option.bgColor)
				.position({x: this.offsetX, y: this.offsetY})
				.borderRadius(this.baseStyle.borderRadiusMax)
                .shadow(this.option.bubbleShadow)
                .visibility(this.isReady ? Visibility.Visible : Visibility.Hidden)
				.id(`ibest_float_bubble_${this.uniId}`)
				.animation({
					duration: this.enableAnimation ? 300 : 0
				})
				.gesture(PanGesture(this.panOption)
                    .onActionStart(() => {
                        this.isDragging = true
                        this.enableAnimation = false
                        clearTimeout(this.timer)
                    })
					.onActionUpdate((event: GestureEvent) => this.onActionUpdate(event))
					.onActionEnd(() => this.onActionEnd()))
				.onTouch(event => {
					if(event.type == TouchType.Up && !this.isDragging){
						this.onBubbleClick()
					}
				})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.clip(true)
		.id(`ibest_float_bubble_box_${this.uniId}`)
	}
}

@Component
export struct IBestFloatBubble{
	/**
	 * 是否展示
	 */
	@Prop @Require @Watch("showChange") show: boolean = false
	/**
	 * 气泡尺寸
	 */
	@Prop bubbleSize: IBestStringNumber = convertDimensionsWidthUnit(48)
	/**
	 * 气泡样式类型
	 */
	@Prop shape: "rect" | "circle" = "circle"
	/**
	 * 气泡图标
	 */
	@Prop icon: ResourceStr = ""
	/**
	 * 图标大小
     */
	@Prop iconSize: IBestStringNumber = convertDimensionsWidthUnit(24)
	/**
	 * 图标颜色
     */
	@Prop iconColor: ResourceColor = IBestFloatBubbleColor.iconColor
	/**
	 * 气泡背景色
	 */
	@Prop bgColor: ResourceColor = IBestFloatBubbleColor.bgColor
	/**
	 * 圆角, 仅shape为rect时有效
	 */
	@Prop radius: IBestStringNumber = 6
	/**
	 * 气泡初始位置
	 */
	@Prop pos: IBestEdges
    /**
     * 可拖拽方向
     */
    @Prop dragAxis: IBestFloatBubbleDragAxis = "y"
	/**
	 * 是否开启磁吸
	 */
	@Prop isMagnetic: boolean = true
	/**
	 * 气泡与窗口最小间距
	 */
	@Prop gap: number = 24
	/**
	 * 气泡阴影
	 */
	@Prop bubbleShadow: ShadowOptions | ShadowStyle = {radius: 0}
	/**
	 * 贴边后是否自动延时隐藏, 仅isMagnetic为true时有效
     */
	@Prop autoHide: boolean = false
	/**
	 * 延时隐藏时间, 单位ms, 仅autoHide为true时有效
     */
	@Prop hideDelay: number = 2000
	/**
	 * 隐藏时预留尺寸, 仅autoHide为true时有效
     */
	@Prop remainSize: number = 20
    /**
     * 自定义内容
     */
    @BuilderParam defaultBuilder: CustomBuilder
	/**
	 * 按钮点击
     */
	onBubbleClick: () => void = () => {}

	private uiContext: UIContext = this.getUIContext()
	private overlayManager: OverlayManager = this.uiContext.getOverlayManager()
	private overlayContent: ComponentContent<IBestFloatBubbleParams> | null = null

	aboutToDisappear(): void {
		this.unmountBubble()
	}
	showChange(){
		if(this.show){
			this.mountBubble()
		}else {
			this.hideBubble()
		}
	}
	mountBubble(){
		if(this.overlayContent){
			this.overlayManager.showComponentContent(this.overlayContent)
		}else {
			let params = new IBestFloatBubbleParams({
				bubbleSize: this.bubbleSize,
				shape: this.shape,
				icon: this.icon,
				iconSize: this.iconSize,
				iconColor: this.iconColor,
				bgColor: this.bgColor,
				radius: this.radius,
				pos: this.pos,
                dragAxis: this.dragAxis,
				isMagnetic: this.isMagnetic,
				gap: this.gap,
				bubbleShadow: this.bubbleShadow,
				autoHide: this.autoHide,
				hideDelay: this.hideDelay,
				remainSize: this.remainSize,
                defaultBuilder: this.defaultBuilder,
				onBubbleClick: this.onBubbleClick
			})
			let componentContent = new ComponentContent(this.uiContext, wrapBuilder(bubbleDefaultBuilder), params)
			this.overlayContent = componentContent
			this.overlayManager.addComponentContent(componentContent, 0)
		}
	}
	unmountBubble(){
		this.overlayManager.removeComponentContent(this.overlayContent)
	}
	hideBubble(){
		this.overlayManager.hideComponentContent(this.overlayContent)
	}
	build() {}
}