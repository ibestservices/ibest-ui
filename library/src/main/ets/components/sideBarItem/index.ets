import { IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { emitter } from '../../utils/EventEmitter'
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit } from '../../utils/utils'
import { COMPONENT_NAME, SIDEBAR_EVENT_NAME, SideBarConfig } from '../sideBar/index.type'
@Component
export struct IBestSideBarItem{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 分组id
	 */
	@Prop @Require groupId: IBestStringNumber
	/**
	 * 索引
     */
	@Prop index: number = 0
	/**
	 * 选项文字
     */
	@Prop title: ResourceStr = ""
	/**
	 * 是否禁用该项
     */
	@Prop disabled: boolean = false
	/**
	 * 自定义内容
     */
	@BuilderParam defaultBuilder: CustomBuilder
	/**
	 * 点击事件
     */
	onItemClick: (index: number) => void = () => {}

	@State uniId: number = 0
	@State config: SideBarConfig = {} as SideBarConfig
	@State isActive: boolean = false

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		if(this.groupId){
			emitter.on(getEventName(COMPONENT_NAME, SIDEBAR_EVENT_NAME.INIT_ITEM, this.groupId), this.uniId, (active: number, config?: SideBarConfig): void => this.init(active, config))
		}
	}

	aboutToDisappear(): void {
		if(this.groupId) {
			emitter.off(getEventName(COMPONENT_NAME, SIDEBAR_EVENT_NAME.INIT_ITEM, this.groupId), this.uniId)
		}
	}

	init(active: number, config?: SideBarConfig){
		this.isActive = active == this.index
		if(config){
			this.config = config
		}
	}
	changeActive(){
		emitter.emit(getEventName(COMPONENT_NAME, SIDEBAR_EVENT_NAME.CHANGE_ACTIVE, this.groupId), this.index)
		this.onItemClick(this.index)
	}
	build() {
		Row(){
			if(this.defaultBuilder){
				this.defaultBuilder
			}else{
				if(this.config.showLeftBar){
					Divider()
						.vertical(true)
						.width(getSizeByUnit(this.config.leftBarSize.width))
						.height(getSizeByUnit(this.config.leftBarSize.height))
						.backgroundColor(this.config.leftBarColor)
						.margin({right: 12})
						.visibility(this.isActive ? Visibility.Visible : Visibility.Hidden)
				}
				Text(this.title)
					.fontColor(this.isActive ? this.config.activeFontColor : this.config.titleColor)
					.fontSize(getSizeByUnit(this.config.titleFontSize))
					.wordBreak(WordBreak.BREAK_ALL)
					.fontWeight(this.isActive ? this.config.activeFontWeight : FontWeight.Normal)
					.lineHeight(convertDimensionsWidthUnit(20))
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.padding({
			top: convertDimensionsWidthUnit(20),
			bottom: convertDimensionsWidthUnit(20),
			right: this.baseStyle.spaceSm
		})
		.justifyContent(FlexAlign.Start)
		.alignItems(VerticalAlign.Center)
		.backgroundColor(this.isActive ? this.config.activeBgColor : "")
		.enabled(!this.disabled)
		.opacity(this.disabled ? 0.5 : 1)
		.onClick(() => {
			this.changeActive()
		})
	}
}