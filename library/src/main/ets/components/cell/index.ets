import { IBestBorderSizeType, IBestStorageKey, IBestStringNumber } from '../../model/Global.type';
import { getDefaultBaseStyle } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { SIZE } from '../../theme-chalk/src/size.type';
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from '../../utils/utils';
import { IBestIcon } from '../icon';
import { IBestCellColor } from './color';
import { ARROW_DIRECTION, CellSizeData } from './index.type';
@Component
export struct IBestCell {
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 左侧标题
	 */
	@Prop title: ResourceStr = ''
	/**
	 * 标题的文字颜色 默认 #323233
	 */
	@Prop titleColor: ResourceColor = IBestCellColor.titleColor
	/**
	 * 标题文字大小
	 * @since 2.1.2
	 */
	@Prop titleFontSize: IBestStringNumber = ""
	/**
	 * 右侧内容
	 */
	@Prop value: ResourceStr = ''
	/**
	 * 内容的文字颜色 默认 #969799
	 */
	@Prop valueColor: ResourceColor = IBestCellColor.valueColor
	/**
	 * 内容的文字大小
	 * @since 2.2.6
     */
	@Prop valueFontSize: IBestStringNumber = ""
	/**
	 * 标题下方的描述信息
	 */
	@Prop label: ResourceStr = ''
	/**
	 * 描述的文字颜色 默认 #969799
	 */
	@Prop labelColor: ResourceColor = IBestCellColor.labelColor
	/**
	 * 标题下方的描述信息文字大小
	 * @since 2.1.2
	 */
	@Prop labelFontSize: IBestStringNumber = ""
	/**
	 * 是否显示底部边框
	 */
	@Prop hasBorder: boolean = true
	/**
	 * 单元格大小 默认 'normal'
	 */
	@Prop cellSize: `${SIZE.LARGE}` | `${SIZE.NORMAL}` = SIZE.NORMAL
	/**
	 * 是否开启点击反馈
	 */
	@Prop clickable: boolean = false
	/**
	 * 是否展示右侧箭头并开启点击反馈
	 */
	@Prop isLink: boolean = false
	/**
	 * 右侧箭头方向
	 */
	@Prop arrowDirection: `${ARROW_DIRECTION}` = ARROW_DIRECTION.RIGHT
	/**
	 * 右侧箭头大小
	 * @since 2.1.3
   	 */
	@Prop arrowSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
	/**
	 * 右侧箭头颜色
	 * @since 2.1.3
     */
	@Prop arrowColor: ResourceColor = GRAY_COLOR.GRAY_6
	/**
	 * 是否显示必填*号
	 */
	@Prop required: boolean = false
	/**
	 * 是否使内容垂直居中
	 */
	@Prop center: boolean = false
	/**
	 * 左侧图标
	 * @since 1.17.0
	 */
	@Prop leftIcon: ResourceStr = ""
	/**
	 * 左侧图标颜色
	 * @since 1.17.0
	 */
	@Prop leftIconColor: ResourceColor = ""
	/**
	 * 左侧图标大小
	 * @since 1.17.0
	 */
	@Prop leftIconSize: IBestStringNumber = this.baseStyle.fontSizeLg as string
	/**
	 * 左侧图标与title间距
	 * @since 1.18.0
	 */
	@Prop leftIconMarginRight: IBestStringNumber = this.baseStyle.spaceBase as string
	/**
	 * 右侧图标
	 * @since 1.17.0
	 */
	@Prop rightIcon: ResourceStr = ""
	/**
	 * 右侧图标颜色
	 * @since 1.17.0
	 */
	@Prop rightIconColor: ResourceColor = GRAY_COLOR.GRAY_6
	/**
	 * 右侧图标大小
	 * @since 1.17.0
	 */
	@Prop rightIconSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
	/**
	 * 右侧图标与内容间距
	 * @since 1.18.0
	 */
	@Prop rightIconMarginLeft: IBestStringNumber = this.baseStyle.spaceBase as string
	/**
	 * 左侧内容宽度
	 * @since 1.18.0
	 */
	@Prop leftContentWidth: IBestStringNumber = 0
	/**
	 * 左右padding
	 * @since 1.18.0
	 */
	@Prop leftRightPadding: IBestStringNumber = this.baseStyle.spaceMd as string
	/**
	 * 底部分割线尺寸类型
	 * @since 1.18.0
	 */
	@Provide borderSizeType: IBestBorderSizeType = "center"
	/**
	 * 底部分割线left值
	 * @since 1.18.0
	 */
	@Prop borderLeft: Dimension
	/**
	 * 底部分割线颜色
	 * @since 1.18.0
	 */
	@Provide bdColor: ResourceColor = IBestCellColor.borderColor
	/**
	 * 禁用
	 * @since 2.0.1
	 */
	@Prop disabled: boolean = false
	/**
	 * 单元格padding
	 * @since 2.1.3
     */
	@Prop cellPadding: Length | Padding | LocalizedPadding = 0
	/**
	 * title的插槽 优先级大于 title
	 */
	@BuilderParam titleBuilder: CustomBuilder
	/**
	 * value的插槽 优先级大于 value
	 */
	@BuilderParam valueBuilder: CustomBuilder
	/**
	 * value的插槽 优先级大于 label
	 */
	@BuilderParam labelBuilder: CustomBuilder
	/**
	 * 自定义title左侧icon的插槽
	 */
	@BuilderParam iconBuilder: CustomBuilder
	/**
	 * 自定义value右侧icon的插槽
	 */
	@BuilderParam rightIconBuilder: CustomBuilder
	/**
	 * 点击单元格的回调
	 * @deprecated since 2.0.8
	 * @useinstead onCellClick
	 */
	onClickCell: () => void = () => {}
	onCellClick: () => void = () => {}

	@State borderRight: number = 0
	private arrowDirection2RotateDegMap: Record<string, number> = {
		[ARROW_DIRECTION.RIGHT]: 0,
		[ARROW_DIRECTION.TOP]: -90,
		[ARROW_DIRECTION.BOTTOM]: 90,
		[ARROW_DIRECTION.LEFT]: 180,
	}
	private uiContext = this.getUIContext()
	private uniId: number = 0

	@Builder cellDividerBuilder(){
		Divider()
			.width(this.borderSizeType == 'center' ? `calc(100% - ${this.borderLeft}vp - ${this.borderRight}vp)` : CONTAINER_SIZE.FULL)
			.height(1)
			.color(this.bdColor)
			.position({ left: this.borderSizeType == "full" ? 0 : this.borderLeft, bottom: 0 })
	}

	aboutToAppear(){
		this.uniId = this.getUniqueId()
	}
	init(){
		if(this.borderLeft === undefined){
			this.borderLeft = getComponentsInfo(this.uiContext, `ibest_cell_left_${this.uniId}`).localLeft
		}
		let fullWidth = getComponentsInfo(this.uiContext, `ibest_cell_${this.uniId}`).width
		let rightInfo = getComponentsInfo(this.uiContext, `ibest_cell_right_${this.uniId}`)
		this.borderRight = fullWidth - rightInfo.width - rightInfo.localLeft
	}
	getCellSize() {
		const cellSize = this.cellSize;
		switch (cellSize) {
			case SIZE.LARGE:
				return new CellSizeData(convertDimensionsWidthUnit(14), this.titleFontSize || this.baseStyle.fontSizeLg as string, this.labelFontSize || this.baseStyle.fontSizeMd as string, this.valueFontSize || this.baseStyle.fontSizeLg as string)
			default:
				return new CellSizeData(this.baseStyle.spaceSm as string, this.titleFontSize || this.baseStyle.fontSizeMd as string, this.labelFontSize || this.baseStyle.fontSizeSm as string, this.valueFontSize || this.baseStyle.fontSizeMd as string)
		}
	}
	getArrowRotateAngle() {
		return this.arrowDirection2RotateDegMap[this.arrowDirection] || this.arrowDirection2RotateDegMap[ARROW_DIRECTION.RIGHT]
	}
	getAlignItems() {
		return this.center ? VerticalAlign.Center : VerticalAlign.Top
	}
	build() {
		Column() {
			Row() {
				if (this.required) {
					Text('*')
						.margin({
							right: this.baseStyle.spaceMini
						})
						.fontSize(this.baseStyle.fontSizeSm)
						.fontColor(this.baseStyle.danger)
				}
				Column() {
					Row() {
						if (this.iconBuilder) {
							Row() {
								this.iconBuilder()
							}.margin({ right: getSizeByUnit(this.leftIconMarginRight) })
						} else if (this.leftIcon) {
							IBestIcon({
								name: this.leftIcon,
								iconSize: this.leftIconSize,
								color: this.leftIconColor
							}).margin({ right: getSizeByUnit(this.leftIconMarginRight) })
						}
						if (this.titleBuilder) {
							this.titleBuilder()
						} else {
							Text(this.title)
								.layoutWeight(1)
								.fontSize(getSizeByUnit(this.getCellSize().fontSize, true))
								.fontColor(this.titleColor)
						}
					}.width(CONTAINER_SIZE.FULL)
					.alignItems(this.getAlignItems())
					if (this.labelBuilder) {
						this.labelBuilder()
					} else if (this.label) {
						Text(this.label)
							.width(CONTAINER_SIZE.FULL)
							.fontSize(getSizeByUnit(this.getCellSize().labelFontSize, true))
							.margin({
								top: this.baseStyle.spaceBase
							})
							.fontColor(this.labelColor)
					}
				}
				.layoutWeight(this.leftContentWidth ? 0 : 1)
				.width(getSizeByUnit(this.leftContentWidth))
				.alignItems(this.center ? HorizontalAlign.Center : HorizontalAlign.Start)
				.id(`ibest_cell_left_${this.uniId}`)
				Row() {
					Row() {
						if (this.valueBuilder) {
							this.valueBuilder()
						} else {
							Text(this.value)
								.textAlign(TextAlign.Start)
								.fontSize(getSizeByUnit(this.getCellSize().valueFontSize, true))
								.fontColor(this.valueColor)
						}
					}.justifyContent(FlexAlign.End).layoutWeight(1)
					if (this.rightIconBuilder) {
						Row() {
							this.rightIconBuilder()
						}
						.margin({ left: getSizeByUnit(this.rightIconMarginLeft) })
					} else if (this.rightIcon) {
						IBestIcon({
							name: this.rightIcon,
							iconSize: this.rightIconSize,
							color: this.rightIconColor
						}).margin({ left: getSizeByUnit(this.rightIconMarginLeft) })
					}
					if (this.isLink) {
						Row() {
							IBestIcon({
								name: "arrow",
								iconSize: this.arrowSize,
								color: this.arrowColor
							})
								.margin({
									left: getSizeByUnit(this.rightIconMarginLeft)
								})
								.rotate({ angle: this.getArrowRotateAngle() })
								.animation({
									duration: this.baseStyle.animationDuration as number
								})
						}.height(convertDimensionsWidthUnit(16))
					}
				}
				.layoutWeight(1)
				.alignItems(this.getAlignItems())
				.id(`ibest_cell_right_${this.uniId}`)
			}
			.alignItems(this.getAlignItems())
			.width(CONTAINER_SIZE.FULL)
			.padding(this.cellPadding ? getSizeByUnit(this.cellPadding) : {
				top: getSizeByUnit(this.getCellSize().padding),
				bottom: getSizeByUnit(this.getCellSize().padding),
				left: getSizeByUnit(this.leftRightPadding),
				right: getSizeByUnit(this.leftRightPadding)
			})
			if (this.hasBorder) {
				this.cellDividerBuilder()
			}
		}
		.stateStyles({
			normal: {
				.backgroundColor(IBestCellColor.bgColor)
			},
			pressed: {
				.backgroundColor(this.isLink || this.clickable ? IBestCellColor.activeBgColor : IBestCellColor.bgColor)
			}
		})
		.animation({
			duration: this.baseStyle.animationDuration as number
		})
		.enabled(!this.disabled)
		.opacity(this.disabled ? 0.7 : 1)
		.clip(true)
		.id(`ibest_cell_${this.uniId}`)
		.onClick(() => {
			this.onClickCell()
			this.onCellClick()
		})
		.onAppear(() => {
			setTimeout(() => {
				this.init()
			}, 100)
		})
		.onVisibleAreaChange([0,1], (isExpanding: boolean) => {
			if(isExpanding && this.borderLeft === undefined){
				this.init()
			}
		})
	}
}