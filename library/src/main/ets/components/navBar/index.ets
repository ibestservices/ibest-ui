import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from '../../utils/utils'
import { IBestIcon } from '../icon'

@Component
export struct IBestNavBar{
	@State uniId: number = 0
	// 标题区域左右内边距
	@State leftWidth: number = 0
	@State rightWidth: number = 0
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@StorageProp("iBestTopAvoidHeight") topAvoidHeight: number = 0
	/**
	 * 标题栏背景色
     */
	@Prop @Watch("navBarBgColorChange") navBarBgColor: ResourceColor = this.baseStyle.default
	/**
	 * 标题栏渐变色
     */
	@Prop bgLinearGradient: LinearGradient
	/**
	 * 标题栏左右内边距
     */
	@Prop leftRightPadding: number | string = convertDimensionsWidthUnit(16)
	/**
	 * 是否显示下边框
     */
	@Prop isShowBorder: boolean = true
	/**
	 * 标题内容
	 */
	@Prop title: string = ''
	/**
	 * 标题文字颜色
     */
	@Prop titleColor: ResourceColor = GRAY_COLOR.GRAY_8
	/**
	 * 标题文字大小
     */
	@Prop titleFontSize: number | string = convertDimensionsWidthUnit(16, true)
	/**
	 * 标题图标
     */
	@Prop titleIcon: ResourceStr = ""
	/**
	 * 标题图标颜色
     */
	@Prop titleIconColor: ResourceColor = GRAY_COLOR.GRAY_8
	/**
	 * 标题图标大小
     */
	@Prop titleIconSize: number | string = convertDimensionsWidthUnit(20)
	/**
	 * 标题是否加粗
	 */
	@Prop isTitleBold: boolean = false
	/**
	 * 二级标题
     */
	@Prop subTitle: string = ''
	/**
	 * 二级标题颜色
     */
	@Prop subTitleColor: ResourceColor = GRAY_COLOR.GRAY_6
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
     */
	@Prop leftIconName: string = 'arrow-left'
	/**
	 * 自定义左侧图标 优先级大于name
     */
	@Prop leftIcon: ResourceStr = ""
	/**
	 * 左侧图标颜色
     */
	@Prop leftIconColor: ResourceColor = GRAY_COLOR.GRAY_8
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
	@Prop leftLabel: string = ''
	/**
	 * 左侧文本颜色
     */
	@Prop leftLabelColor: ResourceColor = GRAY_COLOR.GRAY_8
	/**
	 * 左侧文本大小
     */
	@Prop leftLabelSize: number | string = convertDimensionsWidthUnit(16, true)
	/**
	 * 是否显示右侧
     */
	@Prop isShowRight: boolean = false
	/**
	 * 右侧图标名称
     */
	@Prop rightIconName: string = ''
	/**
	 * 自定义右侧图标 优先级大于name
     */
	@Prop rightIcon: ResourceStr = ""
	/**
	 * 右侧图标颜色
     */
	@Prop rightIconColor: ResourceColor = GRAY_COLOR.GRAY_8
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
	@Prop rightLabel: string = ''
	/**
	 * 右侧文本颜色
     */
	@Prop rightLabelColor: ResourceColor = GRAY_COLOR.GRAY_8
	/**
	 * 右侧文本大小
     */
	@Prop rightLabelSize: number | string = convertDimensionsWidthUnit(16, true)
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
	 * 是否显示状态栏
	 */
	@Prop isShowStatusBar: boolean = false
	/**
	 * 状态栏背景色
	 */
	@Prop statusBarBgColor: ResourceColor = this.navBarBgColor
	/**
	 * 标题栏高度
	 */
	@Prop navBarHeight: number | string = convertDimensionsWidthUnit(46)
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
		this.getMaxWidth()
	}
	navBarBgColorChange(){
		this.statusBarBgColor = this.navBarBgColor
	}
	getMaxWidth(){
		setTimeout(() => {
			let leftWidth = 0
			let rightWidth = 0
			if(this.isShowLeft){
				leftWidth = getComponentsInfo(this.uiContext, `ibest_navbar_left_${this.uniId}`).width
			}
			if(this.isShowRight){
				rightWidth = getComponentsInfo(this.uiContext, `ibest_navbar_right_${this.uniId}`).width
			}
			this.leftWidth = leftWidth
			this.rightWidth = rightWidth
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
					Row({space: this.baseStyle.spaceBase}){
						if(this.leftBuilder){
							this.leftBuilder()
						}else {
							if(this.leftIcon){
								Image(this.leftIcon)
									.width(getSizeByUnit(this.leftIconSize))
									.fillColor(this.leftIconColor)
									.borderRadius(getSizeByUnit(this.leftIconRadius))
							}else{
								IBestIcon({
									name: this.leftIconName,
									color: this.leftIconColor,
									iconSize: this.leftIconSize,
									iconRadius: this.leftIconRadius,
									onIconClick: () => {
										this.onLeftClick()
									}
								})
							}
							if(this.leftLabel){
								Text(this.leftLabel)
									.fontSize(getSizeByUnit(this.leftLabelSize))
									.fontColor(this.leftLabelColor)
									.lineHeight(this.baseStyle.lineHeightMd)
							}
						}
					}
					.height(CONTAINER_SIZE.FULL)
					.position({left: 0})
					.padding({left: getSizeByUnit(this.leftRightPadding), right: this.baseStyle.spaceXs})
					.id(`ibest_navbar_left_${this.uniId}`)
					.onClick(() => {
						this.onLeftClick()
					})
				}
				Column({space: this.baseStyle.spaceMini}){
					if(this.titleBuilder){
						this.titleBuilder()
					}else{
						Row({space: this.baseStyle.spaceXs}){
							if(this.titleIcon){
								Image(this.titleIcon)
									.height(getSizeByUnit(this.titleIconSize))
									.fillColor(this.titleIconColor)
							}
							if(this.title){
								Text(this.title)
									.fontColor(this.titleColor)
									.fontSize(getSizeByUnit(this.titleFontSize))
									.textAlign(TextAlign.Center)
									.maxLines(1)
									.textOverflow({overflow: TextOverflow.Ellipsis})
									.fontWeight(this.isTitleBold ? FontWeight.Bold : FontWeight.Normal)
									.onClick(() => {
										this.onTitleClick()
									})
							}
						}
						if(this.subTitle){
							Text(this.subTitle)
								.fontSize(getSizeByUnit(this.subTitleFontSize))
								.fontColor(this.subTitleColor)
								.textAlign(TextAlign.Center)
								.maxLines(1)
								.textOverflow({overflow: TextOverflow.Ellipsis})
						}
					}
				}
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
				.constraintSize({maxWidth: this.titleBuilder ? "100%" : "60%"})
				.justifyContent(FlexAlign.Center)
				.alignItems(this.titleBuilder ? HorizontalAlign.Start : HorizontalAlign.Center)
				.padding(this.titleBuilder ? {left: this.leftWidth, right: this.rightWidth} : 0)
				if(this.isShowRight){
					Row({space: this.baseStyle.spaceBase}){
						if(this.rightBuilder){
							this.rightBuilder()
						}else{
							if(this.rightLabel){
								Text(this.rightLabel)
									.fontSize(getSizeByUnit(this.rightLabelSize))
									.fontColor(this.rightLabelColor)
									.lineHeight(this.baseStyle.lineHeightMd)
							}
							if(this.rightIcon){
								Image(this.rightIcon)
									.width(getSizeByUnit(this.rightIconSize))
									.fillColor(this.rightIconColor)
							}else if(this.rightIconName){
								IBestIcon({
									name: this.rightIconName,
									color: this.rightIconColor,
									iconSize: this.rightIconSize,
									onIconClick: () => {
										this.onRightClick()
									}
								})
							}
						}
					}
					.height(CONTAINER_SIZE.FULL)
					.position({right: 0})
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
			.border({width:{bottom: this.isShowBorder ? 1 : 0}, color: GRAY_COLOR.GRAY_3})
		}
	}
}