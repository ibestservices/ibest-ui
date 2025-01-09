import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from '../../utils/utils'
import { IBestIcon } from '../icon'
import { IBestNavbarColor } from './color'
@Component
export struct IBestNavBar{
	@State uniId: number = 0
	// 标题区域左右宽度
	@State leftWidth: number = 0
	@State rightWidth: number = 0
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@StorageProp("IBestTopAvoidHeight") topAvoidHeight: number = 0
	@StorageProp("IBestIsApp") isApp: boolean = false
	/**
	 * 导航栏高度
	 */
	@Prop navBarHeight: number | string = convertDimensionsWidthUnit(this.isApp ? 46 : 56)
	/**
	 * 导航栏背景色
     */
	@Prop @Watch("navBarBgColorChange") navBarBgColor: ResourceColor = IBestNavbarColor.bgColor
	/**
	 * 导航栏渐变色
     */
	@Prop bgLinearGradient: LinearGradient
	/**
	 * 导航栏左右内边距
     */
	@Prop leftRightPadding: number | string = convertDimensionsWidthUnit(16)
	/**
	 * 是否显示下边框
     */
	@Prop isShowBorder: boolean = true
	/**
	 * 标题内容
	 */
	@Prop title: ResourceStr = ''
	/**
	 * 标题文字颜色
     */
	@Prop titleColor: ResourceColor = IBestNavbarColor.textColor
	/**
	 * 标题文字大小
     */
	@Prop titleFontSize: number | string = convertDimensionsWidthUnit(16, true)
	/**
	 * 标题图标
	 * @deprecated 请使用titleIcon
	 */
	@Prop titleIconName: string = ""
	/**
	 * 标题图标
     */
	@Prop titleIcon: ResourceStr = ""
	/**
	 * 标题图标颜色
     */
	@Prop titleIconColor: ResourceColor = IBestNavbarColor.textColor
	/**
	 * 标题图标大小
     */
	@Prop titleIconSize: number | string = convertDimensionsWidthUnit(20)
	/**
	 * 标题图标圆角
	 */
	@Prop titleIconRadius: number | string = 0
	/**
	 * 标题是否加粗
	 */
	@Prop titleFontWeight: FontWeight = 600
	/**
	 * 二级标题
     */
	@Prop subTitle: ResourceStr = ''
	/**
	 * 二级标题颜色
     */
	@Prop subTitleColor: ResourceColor = IBestNavbarColor.subTitleColor
	/**
	 * 二级标题字体大小
     */
	@Prop subTitleFontSize: number | string = convertDimensionsWidthUnit(12, true)
	/**
	 * 是否显示左侧
     */
	@Prop isShowLeft: boolean = true
	/**
	 * 左侧图标名称
	 * @deprecated 请使用leftIcon
     */
	@Prop leftIconName: string = 'arrow-left'
	/**
	 * 左侧图标
     */
	@Prop leftIcon: ResourceStr = "arrow-left"
	/**
	 * 左侧图标颜色
     */
	@Prop leftIconColor: ResourceColor = IBestNavbarColor.textColor
	/**
	 * 左侧图标大小
     */
	@Prop leftIconSize: number | string = convertDimensionsWidthUnit(20)
	/**
	 * 左侧图标圆角
	 */
	@Prop leftIconRadius: number | string = 0
	/**
	 * 左侧文本内容
     */
	@Prop leftLabel: ResourceStr = ''
	/**
	 * 左侧文本颜色
     */
	@Prop leftLabelColor: ResourceColor = IBestNavbarColor.textColor
	/**
	 * 左侧文本大小
     */
	@Prop leftLabelFontSize: number | string = convertDimensionsWidthUnit(16, true)
	/**
	 * 是否显示右侧
     */
	@Prop isShowRight: boolean = false
	/**
	 * 右侧图标名称
	 * @deprecated 请使用rightIcon
     */
	@Prop rightIconName: string = ''
	/**
	 * 右侧图标
     */
	@Prop rightIcon: ResourceStr = ""
	/**
	 * 右侧图标颜色
     */
	@Prop rightIconColor: ResourceColor = IBestNavbarColor.textColor
	/**
	 * 右侧图标大小
     */
	@Prop rightIconSize: number | string = convertDimensionsWidthUnit(20)
	/**
	 * 右侧图标圆角
	 */
	@Prop rightIconRadius: number | string = 0
	/**
	 * 右侧文本内容
     */
	@Prop rightLabel: ResourceStr = ''
	/**
	 * 右侧文本颜色
     */
	@Prop rightLabelColor: ResourceColor = IBestNavbarColor.textColor
	/**
	 * 右侧文本大小
     */
	@Prop rightLabelFontSize: number | string = convertDimensionsWidthUnit(16, true)
	/**
	 * 是否显示状态栏
	 */
	@Prop isShowStatusBar: boolean = false
	/**
	 * 状态栏背景色
	 */
	@Prop statusBarBgColor: ResourceColor = this.navBarBgColor
	/**
	 * 是否保持状态栏背景色与标题栏背景色一致
	 */
	@Prop isKeepBgColorSame: boolean = true
	/**
	 * 标题对齐方式
	 * @since 2.0.4
	 */
	@Prop titleTextAlign: "left" | "center" = "center"
	/**
	 * 自定义左侧内容
     */
	@BuilderParam leftBuilder?: CustomBuilder
	/**
	 * 自定义右侧内容
     */
	@BuilderParam rightBuilder?: CustomBuilder
	/**
	 * 自定义标题内容
     */
	@BuilderParam titleBuilder?: CustomBuilder
	/**
	 * 左侧点击回调
     */
	onLeftClick: () => void = () => {}
	/**
	 * 右侧点击回调
     */
	onRightClick: () => void = () => {}
	/**
	 * 标题点击回调
     */
	onTitleClick: () => void = () => {}

	private uiContext = this.getUIContext()

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		this.getLeftRightWidth()
	}
	navBarBgColorChange(){
		if(this.isKeepBgColorSame){
			this.statusBarBgColor = this.navBarBgColor
		}
	}
	getLeftRightWidth(){
		setTimeout(() => {
			let leftWidth = 0
			let rightWidth = 0
			if(this.isShowLeft){
				leftWidth = getComponentsInfo(this.uiContext, `ibest_navbar_left_${this.uniId}`).width
			}
			if(this.isShowRight){
				rightWidth = getComponentsInfo(this.uiContext, `ibest_navbar_right_${this.uniId}`).width
			}
			let maxWidth = Math.max(leftWidth, rightWidth)
			if(this.isApp){
				this.leftWidth = this.titleBuilder ? leftWidth : maxWidth
				this.rightWidth = this.titleBuilder ? rightWidth : maxWidth
			}else{
				let maxPadding = Math.max(maxWidth, 100)
				this.leftWidth = this.titleBuilder || this.titleTextAlign == "left" ? leftWidth : maxPadding
				this.rightWidth = maxPadding
			}
		}, 0)
	}

	build() {
		Column(){
			if(this.isShowStatusBar){
				Row()
					.width(CONTAINER_SIZE.FULL)
					.height(this.topAvoidHeight)
					.backgroundColor(this.statusBarBgColor)
			}
			Row(){
				if(this.isShowLeft){
					Row({space: this.baseStyle.spaceBase as string}){
						if(this.leftBuilder){
							this.leftBuilder()
						}else {
							if(this.leftIcon || this.leftIconName){
								IBestIcon({
									name: this.leftIcon || this.leftIconName,
									color: this.leftIconColor,
									iconSize: this.leftIconSize,
									iconRadius: this.leftIconRadius
								})
							}
							if(this.leftLabel){
								Text(this.leftLabel)
									.fontSize(getSizeByUnit(this.leftLabelFontSize, true))
									.fontColor(this.leftLabelColor)
									.lineHeight(this.baseStyle.lineHeightMd)
							}
						}
					}
					.height(CONTAINER_SIZE.FULL)
					.position({left: 0})
					.zIndex(10)
					.padding({left: getSizeByUnit(this.leftRightPadding), right: this.baseStyle.spaceXs})
					.id(`ibest_navbar_left_${this.uniId}`)
					.onClick(() => {
						this.onLeftClick()
					})
				}
				Column(){
					if(this.titleBuilder){
						this.titleBuilder()
					}else{
						Column({space: this.baseStyle.spaceMini as string}){
							Row({space: this.baseStyle.spaceXs as string}){
								if(this.titleIcon || this.titleIconName){
									IBestIcon({
										name: this.titleIcon || this.titleIconName,
										color: this.titleIconColor,
										iconSize: this.titleIconSize,
										iconRadius: this.titleIconRadius
									})
								}
								if(this.title){
									Text(this.title)
										.fontColor(this.titleColor)
										.fontSize(getSizeByUnit(this.titleFontSize, true))
										.textAlign(TextAlign.Center)
										.maxLines(1)
										.textOverflow({overflow: TextOverflow.Ellipsis})
										.fontWeight(this.titleFontWeight)
								}
							}
							.onClick(() => {
								this.onTitleClick()
							})
							if(this.subTitle){
								Text(this.subTitle)
									.fontSize(getSizeByUnit(this.subTitleFontSize, true))
									.fontColor(this.subTitleColor)
									.textAlign(TextAlign.Center)
									.maxLines(1)
									.textOverflow({overflow: TextOverflow.Ellipsis})
							}
						}
						.width(CONTAINER_SIZE.FULL)
						.height(CONTAINER_SIZE.FULL)
						.justifyContent(FlexAlign.Center)
						.alignItems(this.titleTextAlign == "center" ? HorizontalAlign.Center : HorizontalAlign.Start)
					}
				}
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
				.justifyContent(FlexAlign.Center)
				.alignItems(this.titleBuilder ? HorizontalAlign.Start : HorizontalAlign.Center)
				.padding({left: this.leftWidth, right: this.rightWidth})
				if(this.isShowRight){
					Row({space: this.baseStyle.spaceBase as string}){
						if(this.rightBuilder){
							this.rightBuilder()
						}else{
							if(this.rightLabel){
								Text(this.rightLabel)
									.fontSize(getSizeByUnit(this.rightLabelFontSize, true))
									.fontColor(this.rightLabelColor)
									.lineHeight(this.baseStyle.lineHeightMd)
							}
							if(this.rightIcon || this.rightIconName){
								IBestIcon({
									name: this.rightIcon || this.rightIconName,
									color: this.rightIconColor,
									iconSize: this.rightIconSize
								})
							}
						}
					}
					.height(CONTAINER_SIZE.FULL)
					.position({right: 0})
					.zIndex(10)
					.padding({left: this.baseStyle.spaceXs, right: getSizeByUnit(this.leftRightPadding)})
					.id(`ibest_navbar_right_${this.uniId}`)
					.onClick(() => {
						this.onRightClick()
					})
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.height(getSizeByUnit(this.navBarHeight))
			.justifyContent(FlexAlign.Center)
			.backgroundColor(this.navBarBgColor)
			.linearGradient(this.bgLinearGradient)
			.border({width:{bottom: this.isShowBorder ? 1 : 0}, color: IBestNavbarColor.borderColor})
		}
	}
}