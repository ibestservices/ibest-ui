import { emitter } from "../../utils/EventEmitter"
import { getComponentsInfo, clamp } from "../../utils/utils"

type SwipeCellSide = 'left' | 'right'

@Component
export struct IBestSwipeCell{
	uniId: number = 0
	/**
	 * 自定义左侧滑动区域的内容
  	 */
	@BuilderParam leftContent?: CustomBuilder
	/**
	 * 自定义右侧滑动区域的内容
  	 */
	@BuilderParam rightContent?: CustomBuilder
	/**
	 * 中间内容
  	 */
	@BuilderParam defaultContent?: CustomBuilder
	/**
	 * 中间内容点击回调
  	 */
	onContentClick: () => void = () => {}

	private uiContext = this.getUIContext()

	private leftWidth: number = 0
	private rightWidth: number = 0
	@State centerHeight: number = 0
	@State transX: number = 0
	private startX: number = 0
	private startTransX: number = 0
	@State isOpen: boolean = false

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		setTimeout(() => {
			this.getContentWidth()
		}, 0)
		emitter.on("onSwipeCellTouch", (uniId: number): void => this.onSwipeCellTouch(uniId))
	}
	aboutToDisappear(): void {
		emitter.off("onSwipeCellTouch", (uniId: number): void => this.onSwipeCellTouch(uniId))
	}
	onSwipeCellTouch(uniId: number){
		if(uniId != this.uniId && this.isOpen){
			this.close()
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
	onFingerTouch(event: TouchEvent){
		switch (event.type){
			case TouchType.Down:
				this.startTransX = this.transX
				this.startX = event.touches[0].x
				break
			case TouchType.Move:
				let newOffset = px2lpx(vp2px(event.touches[0].x - this.startX))
				this.transX = clamp(newOffset + this.startTransX, -this.rightWidth, this.leftWidth)
				break
			case TouchType.Up:
				const offset = Math.abs(this.transX)
				const THRESHOLD = 0.15
				const threshold = this.isOpen ? 1 - THRESHOLD : THRESHOLD
				let side: SwipeCellSide = this.transX > 0 ? 'left' : 'right'
				const width = side === 'left' ? this.leftWidth : this.rightWidth
				if (width && offset > width * threshold) {
					this.open(side)
				} else {
					this.close()
				}
				break
		}
	}
	open (side: SwipeCellSide) {
		this.transX = side === 'left' ? this.leftWidth : -this.rightWidth
		if (!this.isOpen) {
			this.isOpen = true
			emitter.emit("onSwipeCellTouch", this.uniId)
		}
	}
	close (){
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
					.height(`${this.centerHeight}lpx`)
					.id("ibest_swipe_left_" + this.uniId)
					.position({ left: 0 })
					.translate({ x: "-100%" })
				}
				if(this.defaultContent){
					Row(){
						this.defaultContent()
					}
					.id("ibest_swipe_center_" + this.uniId)
					.onTouch((event: TouchEvent) => {
						if(event.type == TouchType.Up){
							if(this.isOpen){
								this.close()
							}else if(Math.abs(this.transX) == 0){
								this.onContentClick()
								emitter.emit("onSwipeCellTouch", this.uniId)
							}
						}
					})
				}
				if(this.rightContent){
					Row(){
						this.rightContent()
					}
					.height(`${this.centerHeight}lpx`)
					.id("ibest_swipe_right_" + this.uniId)
					.position({ right: 0 })
					.translate({ x: "100%" })
				}
			}
			.translate({ x: this.transX + "lpx" })
			.animation({
				duration: 200
			})
			.onTouch((event: TouchEvent) => {
				this.onFingerTouch(event)
			})
		}
		.clip(true)
	}
}