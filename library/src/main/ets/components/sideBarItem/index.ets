import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import ibestEmitter from '../../utils/eventEmitter'
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit } from '../../utils/utils'
import { COMPONENT_NAME, SIDEBAR_EVENT_NAME, SideBarConfig } from '../sideBar/index.type'
@Component
export struct IBestSideBarItem{
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
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
	 * 内边距
	 * @since 2.2.0
     */
	@Prop contentPadding: Length | Padding | LocalizedPadding = {
		top: convertDimensionsWidthUnit(20),
		bottom: convertDimensionsWidthUnit(20),
		right: this.baseStyle.spaceSm
	}
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
			ibestEmitter.on(getEventName(COMPONENT_NAME, SIDEBAR_EVENT_NAME.INIT_ITEM, this.groupId), this.uniId, (active: number, config?: SideBarConfig): void => this.init(active, config))
		}
	}

	aboutToDisappear(): void {
		if(this.groupId) {
			ibestEmitter.off(getEventName(COMPONENT_NAME, SIDEBAR_EVENT_NAME.INIT_ITEM, this.groupId), this.uniId)
		}
	}

	init(active: number, config?: SideBarConfig){
		this.isActive = active == this.index
		if(config){
			this.config = config
		}
	}
	changeActive(){
		ibestEmitter.emit(getEventName(COMPONENT_NAME, SIDEBAR_EVENT_NAME.CHANGE_ACTIVE, this.groupId), this.index)
		this.onItemClick(this.index)
	}
	build() {
		Row(){
			if(this.defaultBuilder){
				this.defaultBuilder()
			}else{
				if(this.config.showLeftBar){
					Divider()
						.vertical(true)
						.width(getSizeByUnit(this.config.leftBarSize.width))
						.height(getSizeByUnit(this.config.leftBarSize.height))
						.backgroundColor(this.config.leftBarColor || this.baseStyle.primary)
						.margin({right: this.baseStyle.spaceSm})
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
		.padding(getSizeByUnit(this.contentPadding))
		.justifyContent(FlexAlign.Start)
		.alignItems(VerticalAlign.Center)
		.backgroundColor(this.isActive ? this.config.activeBgColor : "")
		.enabled(!this.disabled)
		.opacity(this.disabled ? 0.6 : 1)
		.onClick(() => {
			this.changeActive()
		})
	}
}