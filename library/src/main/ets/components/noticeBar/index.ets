import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from '../../utils/utils'
import { IBestIcon } from '../icon'
@Component
export struct IBestNoticeBar{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 通知栏模式
     */
	@Prop mode: 'closeable' | 'link'
	/**
	 * 通知栏高度
     */
	@Prop barHeight: number | string = convertDimensionsWidthUnit(40)
	/**
	 * 背景色
     */
	@Prop bgColor: ResourceColor = "#fffbe8"
	/**
	 * 左右内边距
     */
	@Prop leftRightPadding: number | string = convertDimensionsWidthUnit(16)
	/**
	 * 左侧图标名称
	 * @deprecated 请使用leftIcon
     */
	@Prop leftIconName: string = ''
	/**
	 * 自定义左侧图标
     */
	@Prop leftIcon: ResourceStr = ''
	/**
	 * 左侧图标尺寸
     */
	@Prop leftIconSize: number | string = convertDimensionsWidthUnit(16)
	/**
	 * 左侧图标颜色
     */
	@Prop leftIconColor: ResourceColor = "#ed6a0c"
	/**
	 * 通知文本
     */
	@Prop @Watch("reset") text: ResourceStr = ''
	/**
	 * 文本颜色
     */
	@Prop textColor: ResourceColor = "#ed6a0c"
	/**
	 * 文本大小
     */
	@Prop textFontSize: number | string = this.baseStyle.fontSizeMd as string
	/**
	 * 右侧图标名称
	 * @deprecated 请使用rightIcon
     */
	@Prop rightIconName: string = ''
	/**
	 * 自定义右侧图标
     */
	@Prop rightIcon: ResourceStr = ""
	/**
	 * 右侧图标大小
     */
	@Prop rightIconSize: number | string = convertDimensionsWidthUnit(16)
	/**
	 * 右侧图标颜色
     */
	@Prop rightIconColor: ResourceColor = "#ed6a0c"
	/**
	 * 是否开启滚动播放，内容长度溢出时默认开启
     */
	@Prop @Watch("reset") scrollable: boolean
	/**
	 * 动画延迟时间(s)
     */
	@Prop delay: number = 1
	/**
	 * 滚动速率(vp/s)
     */
	@Prop speed: number = 60
	/**
	 * 是否开启换行, 为true时滚动不生效
     */
	@Prop wrapable: boolean = false
	/**
	 * 垂直滚动
     */
	@Prop vertical: boolean = false
	/**
	 * 垂直滚动内容
     */
	@Prop verticalTextList: string[] = []
	/**
	 * 垂直滚动间隔 单位秒
     */
	@Prop verticalInterval: number = 3
	/**
	 * 点击通知栏回调
     */
	onBarClick: () => void = () => {}
	/**
	 * 关闭通知栏触发
     */
	onClose: () => void = () => {}
	/**
	 * 垂直滚动时,点击文字回调
     */
	onTextClick: (index: number) => void = () => {}

	@State uniId: number = 0
	@State isShow: boolean = true
	@State transX: number = 0
	@State duration: number = 0
	contentWidth: number = 0
	textWidth: number = 0
	startTimer: number = 0
	private uiContext = this.getUIContext()

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
	}

	reset(){
		if(this.scrollable === false || this.wrapable){
			return
		}
		this.transX = 0
		this.duration = 0
		clearTimeout(this.startTimer)
		this.startTimer = setTimeout(() => {
			let contentWidth = getComponentsInfo(this.uiContext, `ibest_noticeBar_${this.uniId}`).width
			let textWidth = getComponentsInfo(this.uiContext, `ibest_noticeBar_text_${this.uniId}`).width
			this.contentWidth = contentWidth
			this.textWidth = textWidth
			if (this.scrollable || textWidth > contentWidth) {
				if(this.scrollable === undefined){
					this.scrollable = true
				}
				this.duration = textWidth / +this.speed
				this.transX = -textWidth
			}
		}, +this.delay * 1000)
	}
	onFinish(){
		this.transX = this.contentWidth
		this.duration = 0
		setTimeout(() => {
			this.duration = (this.contentWidth + this.textWidth) / +this.speed
			this.transX = -this.textWidth
		}, 100)
	}

	build() {
		Row(){
			if(this.leftIcon || this.leftIconName){
				Row(){
					IBestIcon({
						name: this.leftIcon || this.leftIconName,
						iconSize: this.leftIconSize,
						color: this.leftIconColor
					})
				}
				.constraintSize({minWidth: convertDimensionsWidthUnit(24)})
			}
			if(this.vertical){
				Swiper() {
					ForEach(this.verticalTextList, (item: string, index: number) => {
						Text(item)
							.width(CONTAINER_SIZE.FULL)
							.fontColor(this.textColor)
							.fontSize(getSizeByUnit(this.textFontSize, true))
							.maxLines(1)
							.textOverflow({overflow: TextOverflow.Ellipsis})
							.onClick(() => {
								this.onTextClick(index)
							})
					}, (item: string) => item)
				}
				.layoutWeight(1)
				.height(CONTAINER_SIZE.FULL)
				.vertical(true)
				.interval(this.verticalInterval*1000)
				.autoPlay(true)
				.indicator(false)
				.disableSwipe(true)
			}else{
				Scroll(){
					Text(this.text)
						.width(this.scrollable === false || this.wrapable ? CONTAINER_SIZE.FULL : "auto")
						.fontColor(this.textColor)
						.fontSize(getSizeByUnit(this.textFontSize, true))
						.maxLines(this.wrapable || this.scrollable ? undefined : 1)
						.textOverflow(this.wrapable || this.scrollable ? undefined : {overflow: TextOverflow.Ellipsis})
						.id(`ibest_noticeBar_text_${this.uniId}`)
						.translate({x: this.transX})
						.animation({
							duration: this.duration * 1000,
							curve: Curve.Linear,
							onFinish: (): void => this.onFinish()
						})
						.onAppear(() => {
							this.reset()
						})
				}
				.layoutWeight(1)
				.scrollable(ScrollDirection.None)
				.align(Alignment.Start)
				.id(`ibest_noticeBar_${this.uniId}`)
			}
			if(this.rightIcon || this.rightIconName || this.mode){
				Row(){
					IBestIcon({
						name: this.rightIcon || this.rightIconName || (this.mode == "closeable" ? "cross" : "arrow"),
						iconSize: this.rightIconSize,
						color: this.rightIconColor
					})
				}
				.constraintSize({minWidth: convertDimensionsWidthUnit(24)})
				.justifyContent(FlexAlign.End)
				.onClick(() => {
					if(this.mode == "closeable"){
						this.isShow = false
						this.onClose()
					}
				})
			}
		}
		.height(this.wrapable ? "auto" : getSizeByUnit(this.barHeight))
		.constraintSize({minHeight: this.wrapable ? getSizeByUnit(this.barHeight) : ""})
		.backgroundColor(this.bgColor)
		.padding({
			left: getSizeByUnit(this.leftRightPadding),
			right: getSizeByUnit(this.leftRightPadding),
			top: this.wrapable ? convertDimensionsWidthUnit(8) : 0,
			bottom: this.wrapable ? convertDimensionsWidthUnit(8) : 0
		})
		.visibility(this.isShow ? Visibility.Visible : Visibility.None)
		.onClick(() => {
			this.onBarClick()
		})
	}
}