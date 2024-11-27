import { IBestRefreshContentParams, PullRefreshStatus } from './index.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { IBestLoading } from '../loading'
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from '../../utils/utils'
@Component
export struct IBestPullRefresh {
	/**
	 * 是否处于加载状态
  	 */
	@Link @Watch("loadingChange") loading: boolean
	/**
	 * 下拉过程提示文案
	 */
	@Provide({allowOverride: 'pullingText'}) pullingText: ResourceStr = "下拉即可刷新..."
	/**
	 * 释放过程提示文案
     */
	@Provide({allowOverride: 'loosingText'}) loosingText: ResourceStr = "释放即可刷新..."
	/**
	 * 加载过程提示文案
	 */
	@Provide({allowOverride: 'loadingText'}) loadingText: ResourceStr = "加载中..."
	/**
	 * 刷新成功提示文案
	 */
	@Provide({allowOverride: 'successText'}) successText: ResourceStr = ""
	/**
	 * 刷新成功提示展示时长(ms)
	 */
	@Prop successDuration: number = 500
	/**
	 * 动画时长
	 */
	@Prop duration: number = 300
	/**
	 * 顶部内容高度
	 */
	@Prop headHeight: number | string = convertDimensionsWidthUnit(50)
	/**
	 * 默认内容
     */
	@BuilderParam defaultContent?: CustomBuilder
	/**
	 * 自定义下拉过程顶部内容
  	 */
	@BuilderParam pullingContent?: ($$: IBestRefreshContentParams) => void
	/**
	 * 自定义释放过程顶部内容
  	 */
	@BuilderParam loosingContent?: ($$: IBestRefreshContentParams) => void
	/**
	 * 自定义加载过程顶部内容
  	 */
	@BuilderParam loadingContent?: CustomBuilder
	/**
	 * 自定义刷新成功提示内容
	 */
	@BuilderParam successContent?: CustomBuilder
	/**
	 * 触发下拉刷新时的回调
	 */
	onRefresh: () => void = () => {}
	/**
	 * 当自定义内容包含List Grid Scroll组件时必传
  	 */
	scroller: Scroller = new Scroller()

	@State uniId: number = 0
	@State transY: number = 0
	@State startY: number = 0
	@Provide refreshStatus: PullRefreshStatus = "normal"
	@State scrollTop: number = 0
	@State headSize: number = 0
	private uiContext = this.getUIContext()

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		setTimeout(() => {
			this.headSize = getComponentsInfo(this.uiContext, `ibest_pull_${this.uniId}`).height
		}, 10)
	}

	isTouchable(){
		return this.refreshStatus != "loading" && this.refreshStatus != "success"
	}
	ease(distance: number) {
		const pullDistance = this.headSize
		if (distance > pullDistance) {
			if (distance < pullDistance * 2) {
				distance = pullDistance + (distance - pullDistance) / 2;
			} else {
				distance = pullDistance * 1.5 + (distance - pullDistance * 2) / 4;
			}
		}
		return Math.round(distance)
	}
	// 设置刷新状态
	setRefreshStatus(distance: number, isLoading?: boolean){
		this.transY = distance
		if(isLoading){
			this.refreshStatus = "loading"
		}else if(distance == 0){
			this.refreshStatus = "normal"
		}else if(distance < this.headSize){
			this.refreshStatus = "pulling"
		} else {
			this.refreshStatus = 'loosing'
		}
	}
	onFingerMove(event: TouchEvent){
		this.scrollTop = this.scroller.currentOffset()?.yOffset || 0
		if(this.isTouchable() && this.scrollTop == 0){
			switch (event.type){
				case TouchType.Down:
					this.startY = event.touches[0].y
					break
				case TouchType.Move:
					let newOffset = event.touches[0].y - this.startY
					if(newOffset >= 0){
						this.setRefreshStatus(this.ease(newOffset))
					}
					break
				case TouchType.Up:
					if(this.refreshStatus == "loosing"){
						this.setRefreshStatus(this.headSize, true)
						this.loading = true
						this.onRefresh()
					}else{
						this.setRefreshStatus(0)
					}
					break
			}
		}
	}
	onPanGestureChange(type: string, event: GestureEvent){
		let scrollTop = this.scroller.currentOffset()?.yOffset
		this.scrollTop = scrollTop == undefined || scrollTop < 0 ? 0 : scrollTop
		// console.log("scrollTop", scrollTop)
		if(this.isTouchable() && this.scrollTop < 1) {
			switch (type) {
				case "move":
					let newOffset = event.offsetY
					if(newOffset >= 0){
						this.setRefreshStatus(this.ease(newOffset))
					}
					break
				case "end":
					if(this.transY > 0){
						if(this.refreshStatus == "loosing"){
							this.setRefreshStatus(this.headSize, true)
							this.loading = true
							this.onRefresh()
						}else{
							this.setRefreshStatus(0)
						}
					}
					break
			}
		}
	}
	loadingChange(){
		if(this.loading){
			this.setRefreshStatus(this.headSize, true)
		}else if(this.successContent || this.successText){
			this.refreshStatus = "success"
			setTimeout(() => {
				this.setRefreshStatus(0)
			}, this.successDuration)
		} else {
			this.setRefreshStatus(0)
		}
	}

	build() {
		Column(){
			Column(){
				Row({ space: 10 }){
					Row(){
						if(this.pullingContent){
							this.pullingContent({ distance: this.transY })
						}else{
							TextTip()
						}
					}.visibility(this.refreshStatus == "pulling" ? Visibility.Visible : Visibility.None)
					Row(){
						if(this.loosingContent){
							this.loosingContent({ distance: this.transY })
						}else{
							TextTip()
						}
					}.visibility(this.refreshStatus == "loosing" ? Visibility.Visible : Visibility.None)
					Row(){
						if(this.loadingContent){
							this.loadingContent()
						}else{
							TextTip()
						}
					}.visibility(this.refreshStatus == "loading" ? Visibility.Visible : Visibility.None)
					Row(){
						if(this.successContent){
							this.successContent()
						}else{
							TextTip()
						}
					}.visibility(this.refreshStatus == "success" ? Visibility.Visible : Visibility.None)
				}
				.width(CONTAINER_SIZE.FULL)
				.height(getSizeByUnit(this.headHeight))
				.justifyContent(FlexAlign.Center)
				.position({ x: 0, y: 0 })
				.translate({ y: "-100%" })
				.id(`ibest_pull_${this.uniId}`)
				if(this.defaultContent){
					this.defaultContent()
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.translate({ y: this.transY })
			.animation({
				duration: this.duration
			})
			// .onTouch((event) => {
			// 	this.onFingerMove(event)
			// })
			.parallelGesture(
			  	PanGesture({ fingers: 1, direction: PanDirection.Vertical })
					.onActionUpdate((event: GestureEvent) => {
						this.onPanGestureChange("move", event)
					})
					.onActionEnd((event) => {
						this.onPanGestureChange("end", event)
					})
			)
		}
		.width(CONTAINER_SIZE.FULL)
		.clip(true)
	}
}

@Component
struct TextTip{
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@Consume refreshStatus: PullRefreshStatus
	@Consume pullingText: string
	@Consume loosingText: string
	@Consume loadingText: string
	@Consume successText: string
	getStatusText(): string{
		switch(this.refreshStatus){
			case "normal":
				return ""
			case "pulling":
				return this.pullingText
			case "loosing":
				return this.loosingText
			case "loading":
				return this.loadingText
			case "success":
				return this.successText
		}
	}
	build() {
		Row({space: convertDimensionsWidthUnit(5)}){
			if(this.refreshStatus == "loading") {
				IBestLoading({
					loadingSize: this.baseStyle.fontSizeMd
				})
			}
			Text(this.getStatusText())
				.fontColor(GRAY_COLOR.GRAY_6)
				.fontSize(this.baseStyle.fontSizeMd)
		}
	}
}