import { IBestAwaitable } from '../../model/Global.type'
import { clamp, handleBeforeFunction } from '../../utils/utils'
import { IBestSwipeCellSide } from './index.type'
import ibestSwipeCellEmitter from './swiperTouchEmitter'

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
	beforeClose?: (position: IBestSwipeCellSide) => IBestAwaitable
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
	private hasRegistered: boolean = false
	private uiContext = this.getUIContext()

	aboutToAppear() {
		this.uniId = this.getUniqueId()
	}
	onDidBuild() {
		ibestSwipeCellEmitter.ensureInstalled(this.uiContext)
		if (!this.hasRegistered) {
			ibestSwipeCellEmitter.add(this.uiContext, this.uniId, (event: TouchEvent) => {
				this.handleRootTouch(event)
			})
			this.hasRegistered = true
		}
	}
	aboutToDisappear() {
		if (this.hasRegistered) {
			ibestSwipeCellEmitter.remove(this.uiContext, this.uniId)
			this.hasRegistered = false
		}
	}
	handleRootTouch(event: TouchEvent): void {
		if (event.type !== TouchType.Down) {
			return
		}
		if (!event.touches || event.touches.length === 0) {
			return
		}
		const isInside = this.isTouchInsideSelf(event)
		if (!isInside && this.isOpen) {
			this.close("out")
		}
	}
	isTouchInsideSelf(event: TouchEvent): boolean {
		const frameNode = this.uiContext.getFrameNodeById(`ibest_swipe_cell_${this.uniId}`)
		if (!frameNode) {
			return false
		}
		if (!event.touches || event.touches.length === 0) {
			return false
		}
		const touch = event.touches[0]
		const position = frameNode.getPositionToWindow()
		const size = frameNode.getMeasuredSize()
		const widthVp = this.uiContext.px2vp(size.width)
		const heightVp = this.uiContext.px2vp(size.height)
		const left = position.x
		const right = position.x + widthVp
		const top = position.y
		const bottom = position.y + heightVp
		const x = touch.windowX
		const y = touch.windowY
		return x >= left && x <= right && y >= top && y <= bottom
	}
	onSwipeCellTouch(uniId: number){
		if(uniId != this.uniId && this.isOpen){
			this.close("center")
		}
	}
	onTouchStart(){
		this.startTransX = this.transX
	}
	onTouchMove(event: GestureEvent): void {
		const bl = event.offsetX
		this.transX = clamp(bl + this.startTransX, -this.rightWidth, this.leftWidth)
	}
	onTouchEnd(): void {
		const offset = Math.abs(this.transX)
		const THRESHOLD = 0.15
		const threshold = this.isOpen ? 1 - THRESHOLD : THRESHOLD
		const side: IBestSwipeCellSide = this.transX > 0 ? 'left' : 'right'
		const width = side === 'left' ? this.leftWidth : this.rightWidth
		if (width && offset > width * threshold) {
			this.open(side)
		} else {
			this.close("center")
		}
	}
	open(side: IBestSwipeCellSide) {
		this.transX = side === 'left' ? this.leftWidth : -this.rightWidth
		if (!this.isOpen) {
			this.isOpen = true
		}
	}
	async close(position: IBestSwipeCellSide){
		if (this.beforeClose) {
			const status = await handleBeforeFunction(this.beforeClose, position)
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
					.height(this.centerHeight || "auto")
					.position({ left: 0 })
					.translate({ x: "-100%" })
					.onAreaChange((_: Area, newVal: Area) => {
						this.leftWidth = newVal.width as number
					})
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
					.onAreaChange((_: Area, newVal: Area) => {
						this.centerHeight = newVal.height as number
					})
					.parallelGesture(
						TapGesture({fingers: 1})
							.onAction(() => {
								if(this.isOpen){
									this.close("center")
								}else if(Math.abs(this.transX) == 0){
									this.onContentClick()
								}
							})
					)
				}
				if(this.rightContent){
					Row(){
						this.rightContent()
					}
					.height(this.centerHeight || "auto")
					.position({ right: 0 })
					.translate({ x: "100%" })
					.onAreaChange((_: Area, newVal: Area) => {
						this.rightWidth = newVal.width as number
					})
					.parallelGesture(
						TapGesture({fingers: 1})
							.onAction(() => {
								this.close("right")
							})
					)
				}
			}
			.translate({ x: this.transX })
			.animation({ duration: 200 })
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
		.id(`ibest_swipe_cell_${this.uniId}`)
		.clip(true)
	}
}