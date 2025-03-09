import { IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { emitter } from '../../utils/EventEmitter'
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit } from '../../utils/utils'
import { IBestSidebarColor } from './color'
import { COMPONENT_NAME, LeftBarSize, SIDEBAR_EVENT_NAME } from './index.type'
@Component
export struct IBestSideBar{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 分组id
     */
	@Prop groupId: string = ""
	/**
	 * 当前导航项的索引
	 */
	@Link @Watch("initItems") active: number
	/**
	 * 宽度
     */
	@Prop sideWidth: IBestStringNumber = convertDimensionsWidthUnit(80)
	/**
	 * 最大高度
     */
	@Prop maxHeight: IBestStringNumber = 0
	/**
	 * 背景色
     */
	@Prop bgColor: ResourceColor = IBestSidebarColor.bgColor
	/**
	 * 文字颜色
	 */
	@Prop titleColor: ResourceColor = IBestSidebarColor.textColor
	/**
	 * 文字大小
	 */
	@Prop titleFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
	/**
	 * 激活背景色
     */
	@Prop activeBgColor: ResourceColor = IBestSidebarColor.activeBg
	/**
	 * 是否显示左侧颜色条
     */
	@Prop showLeftBar: boolean = true
	/**
	 * 左侧颜色条尺寸
     */
	@Prop leftBarSize: LeftBarSize = { width: convertDimensionsWidthUnit(4), height: convertDimensionsWidthUnit(16) }
	/**
	 * 左侧颜色条颜色
     */
	@Prop leftBarColor: ResourceColor = this.baseStyle.primary
	/**
	 * 激活态文字颜色
     */
	@Prop activeFontColor: ResourceColor = IBestSidebarColor.textColor
	/**
	 * 激活态字重
	 */
	@Prop activeFontWeight: FontWeight = FontWeight.Medium
	/**
	 * 默认内容
     */
	@BuilderParam defaultBuilder?: CustomBuilder
	/**
	 * 切换事件回调
     */
	onChange: (index: number) => void = () => {}

	@State uniId: number = 0

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		if(this.groupId){
			emitter.on(getEventName(COMPONENT_NAME, SIDEBAR_EVENT_NAME.CHANGE_ACTIVE, this.groupId), this.uniId, (active: number): void => this.changeActive(active))
			setTimeout(() => {
				this.initItems()
			}, 0)
		}
	}
	aboutToDisappear(): void {
		if(this.groupId){
			emitter.off(getEventName(COMPONENT_NAME, SIDEBAR_EVENT_NAME.CHANGE_ACTIVE, this.groupId), this.uniId)
		}
	}
	initItems(){
		emitter.emit(getEventName(COMPONENT_NAME, SIDEBAR_EVENT_NAME.INIT_ITEM, this.groupId), this.active, {
			titleColor: this.titleColor,
			titleFontSize: this.titleFontSize,
			activeBgColor: this.activeBgColor,
			showLeftBar: this.showLeftBar,
			leftBarSize: this.leftBarSize,
			leftBarColor: this.leftBarColor,
			activeFontColor: this.activeFontColor,
			activeFontWeight: this.activeFontWeight
		})
	}
	changeActive(active: number){
		this.active = active
		this.initItems()
		this.onChange(active)
	}
	build() {
		Scroll(){
			Column(){
				if(this.defaultBuilder){
					this.defaultBuilder()
				}
			}
			.backgroundColor(this.bgColor)
		}
		.width(getSizeByUnit(this.sideWidth))
		.scrollBar(BarState.Off)
		.edgeEffect(EdgeEffect.None)
		.align(Alignment.Start)
	}
}