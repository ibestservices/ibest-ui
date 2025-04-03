import { emitter } from '../../utils/EventEmitter'
import { clamp, getComponentsInfo, getEventName } from '../../utils/utils'
import { COMPONENT_NAME, IBestSwipeCellSide, SWIPECELL_EVENT_NAME } from './index.type'

@Component
export struct IBestSwipeCell{
	/**
	 * 自定义左侧滑动区域的内容
  	 */
	@BuilderParam leftContent: CustomBuilder
	/**
	 * 自定义右侧滑动区域的内容
  	 */
	@BuilderParam rightContent: CustomBuilder
	/**
	 * 中间内容
  	 */
	@BuilderParam defaultContent: CustomBuilder
	/**
	 * 关闭前回调
     */
	beforeClose?: (position: IBestSwipeCellSide) => boolean | Promise<boolean>
	/**
	 * 中间内容点击回调
  	 */
	onContentClick: () => void = () => {}

	@State uniId: number = 0
	@State centerHeight: number = 0
	@State transX: number = 0
	@State isOpen: boolean = false
	private leftWidth: number = 0
	private rightWidth: number = 0
	private startTransX: number = 0
	private uiContext = this.getUIContext()

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		setTimeout(() => {
			this.getContentWidth()
		}, 0)
		emitter.on(getEventName(COMPONENT_NAME, SWIPECELL_EVENT_NAME.SWIPECELL_TOUCH,), this.uniId, (uniId: number): void => this.onSwipeCellTouch(uniId))
	}
	aboutToDisappear(): void {
		emitter.off(getEventName(COMPONENT_NAME, SWIPECELL_EVENT_NAME.SWIPECELL_TOUCH), this.uniId)
	}
	emitTouch(){
		emitter.emit(getEventName(COMPONENT_NAME, SWIPECELL_EVENT_NAME.SWIPECELL_TOUCH), this.uniId)
	}
	onSwipeCellTouch(uniId: number){
		if(uniId != this.uniId && this.isOpen){
			this.close("center")
		}
	}
	getContentWidth(){
		let leftInfo = getComponentsInfo(this.uiContext, "ibest_swipe_left_" + this.uniId)
		let rightInfo = getComponentsInfo(this.uiContext, "ibest_swipe_right_" + this.uniId)
		let centerInfo = getComponentsInfo(this.uiContext, "ibest_swipe_center_" + this.uniId)
		this.leftWidth = leftInfo.width
		this.rightWidth = rightInfo.width
		this.centerHeight = centerInfo.height
	}
	onTouchStart(){
		this.startTransX = this.transX
	}
	// 手指移动
	onTouchMove(event: GestureEvent): void {
		let bl = event.offsetX
		this.transX = clamp(bl + this.startTransX, -this.rightWidth, this.leftWidth)
	}
	// 手指离开
	onTouchEnd(): void {
		const offset = Math.abs(this.transX)
		const THRESHOLD = 0.15
		const threshold = this.isOpen ? 1 - THRESHOLD : THRESHOLD
		let side: IBestSwipeCellSide = this.transX > 0 ? 'left' : 'right'
		const width = side === 'left' ? this.leftWidth : this.rightWidth
		if (width && offset > width * threshold) {
			this.open(side)
		} else {
			this.close("center")
		}
	}
	async handleBeforeClose(position: IBestSwipeCellSide) {
		let status = true
		try {
			if (this.beforeClose) {
				status = await this.beforeClose(position)
			}
		} catch (e) {
			status = false
		}
		return status
	}
	open (side: IBestSwipeCellSide) {
		this.transX = side === 'left' ? this.leftWidth : -this.rightWidth
		if (!this.isOpen) {
			this.isOpen = true
			this.emitTouch()
		}
	}
	async close (position: IBestSwipeCellSide){
		if (this.beforeClose) {
			const status = await this.handleBeforeClose(position)
			if (!status) {
				return
			}
		}
		this.transX = 0
		if (this.isOpen) {
			this.isOpen = false
		}
	}

	build() {
		Row(){
			Row(){
				if(this.leftContent){
					Row(){
						this.leftContent()
					}
					.height(this.centerHeight)
					.id("ibest_swipe_left_" + this.uniId)
					.position({ left: 0 })
					.translate({ x: "-100%" })
					.parallelGesture(
						TapGesture({fingers: 1})
							.onAction(() => {
								this.close("left")
							})
					)
				}
				if(this.defaultContent){
					Row(){
						this.defaultContent()
					}
					.id("ibest_swipe_center_" + this.uniId)
					.parallelGesture(
						TapGesture({fingers: 1})
							.onAction(() => {
								if(this.isOpen){
									this.close("center")
								}else if(Math.abs(this.transX) == 0){
									this.onContentClick()
									this.emitTouch()
								}
							})
					)
				}
				if(this.rightContent){
					Row(){
						this.rightContent()
					}
					.height(this.centerHeight)
					.id("ibest_swipe_right_" + this.uniId)
					.position({ right: 0 })
					.translate({ x: "100%" })
					.parallelGesture(
						TapGesture({fingers: 1})
							.onAction(() => {
								this.close("right")
							})
					)
				}
			}
			.translate({ x: this.transX })
			.animation({
				duration: 200
			})
			.parallelGesture(
				PanGesture({fingers: 1, direction: PanDirection.Horizontal, distance: 1})
					.onActionStart(() => {
						this.onTouchStart()
					})
					.onActionUpdate((event: GestureEvent) => {
						this.onTouchMove(event)
					})
					.onActionEnd(() => {
						this.onTouchEnd()
					})
			)
		}
		.clip(true)
	}
}