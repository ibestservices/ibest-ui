import { ComponentContent, LengthMetrics, UIContext, window } from '@kit.ArkUI';
import { convertDimensionsWidthUnit, generateId, getLengthUnit, getSizeByUnit } from '../utils/utils';
import CustomContent from '../common/components/CustomContent';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../theme-chalk/src';
import { GRAY_COLOR } from '../theme-chalk/src/color';
import { CONTAINER_SIZE } from '../theme-chalk/src/container';
import { IBestUIBaseStyleObjType } from '../theme-chalk/src/index.type';
import { IBestActionSheetColor } from './color';
import { IBestIcon } from '../components/icon';
import { IBestStringNumber } from '../model/Global.type';

// 选项类型
export class IBestActionType {
	name: ResourceStr = ""
	value?: IBestStringNumber
	subName?: ResourceStr
	color?: ResourceColor
	icon?: ResourceStr
	isDisabled?: boolean
	readonly?: boolean
}

export class IBestActionMultiLine extends IBestActionType {
	icon: ResourceStr = ""
}

/**
 * ActionSheetOption 类型
 */
class IBestActionSheetOption {
	/**
	 * 宽度
	 */
	width?: Dimension
	/**
	 * 高度
	 */
	height?: SheetSize | Length
	/**
	 * 半模态页面的背板颜色
	 */
	backgroundColor?: ResourceColor
	/**
	 * 半模态页面的切换高度档位
	 */
	detents?: [(SheetSize | Length), ( SheetSize | Length)?, (SheetSize | Length)?]
	/**
	 * 半模态页面的样式
	 */
	preferType?: SheetType
	/**
	 * 设置半模态页面的显示层级
	 */
	mode?: SheetMode
	/**
	 * 是否显示控制条
	 */
	dragBar?: boolean
	/**
	 * 原生标题
	 */
	title?: SheetTitleOptions | CustomBuilder
	/**
	 * 是否显示原生关闭图标
	 */
	showClose?: boolean
	/**
	 * 选项列表
	 */
	actions?: (IBestActionType | string)[] | (IBestActionMultiLine)[][]
	/**
	 * 自定义标题
	 */
	customTitle?: ResourceStr
	/**
	 * 自定义标题背景色
	 */
	titleBgColor?: ResourceColor
	/**
	 * 描述
	 */
	description?: ResourceStr
	/**
	 * 是否显示关闭图标
	 */
	closeable?: boolean
	/**
	 * 自定义关闭图标
	 */
	closeIcon?: ResourceStr
	/**
	 * 底部按钮文字
	 */
	cancelText?: ResourceStr
	/**
	 * 是否开启底部安全距离适配
	 */
	safeAreaInsetBottom?: boolean
	/**
	 * 是否允许物理关闭
	 */
	closeOnBackPress?: boolean
	/**
	 * 是否允许点击遮罩关闭
	 */
	closeOnClickOverlay?: boolean
	/**
	 * 自定义内容
	 */
	customContent?: CustomBuilder
	/**
	 * 打开回调
	 */
	onOpen?: () => void
	/**
	 * 选择后回调
	 */
	onSelect?: (index1: number, index2?: IBestStringNumber, value?: IBestStringNumber) => void
	/**
	 * 点击取消回调
	 */
	onCancel?: () => void
	/**
	 * 关闭回调
	 */
	onClose?: () => void
	/**
	 * 取消按钮文字颜色
	 * @since 1.17.0
	 */
	cancelTextColor?: ResourceColor
	/**
	 * 关闭前的回调函数，返回 false 可阻止关闭，支持返回 Promise
	 * @since 1.17.0
	 */
	beforeClose?: () => Promise<boolean> | boolean
	/**
	 * 选项高度
	 * @since 2.0.0
     */
	itemHeight?: IBestStringNumber
	/**
	 * 圆角
	 * @since 2.0.8
     */
	radius?: number
}

class IBestActionSheetParams extends IBestActionSheetOption {
	id: string = ""
	close: (id: string) => void = () => {}
	constructor(option: IBestActionSheetOption) {
		super()
		this.width = option.width || CONTAINER_SIZE.FULL
		this.height = option.height || SheetSize.FIT_CONTENT
		this.backgroundColor = option.backgroundColor || IBestActionSheetColor.contentBg
		this.detents = option.detents
		this.preferType = option.preferType || SheetType.BOTTOM
		this.mode = option.mode
		this.dragBar = option.dragBar ?? false
		this.title = option.title
		this.showClose = option.showClose ?? false
		this.actions = option.actions || []
		this.customTitle = option.customTitle || ""
		this.titleBgColor = option.titleBgColor || IBestActionSheetColor.buttonBg
		this.description = option.description || ""
		this.closeable = option.closeable ?? true
		this.closeIcon = option.closeIcon || "cross"
		this.cancelText = option.cancelText || ""
		this.safeAreaInsetBottom = option.safeAreaInsetBottom ?? true
		this.closeOnBackPress = option.closeOnBackPress ?? true
		this.closeOnClickOverlay = option.closeOnClickOverlay ?? true
		this.customContent = option.customContent || undefined
		this.onOpen = option.onOpen || undefined
		this.onSelect = option.onSelect || undefined
		this.onCancel = option.onCancel || undefined
		this.onClose = option.onClose || undefined
		this.cancelTextColor = option.cancelTextColor || GRAY_COLOR.GRAY_7
		this.beforeClose = option.beforeClose || undefined
		this.itemHeight = option.itemHeight || convertDimensionsWidthUnit(50)
		this.radius = option.radius ?? 16
	}
}

@Component
struct defaultContent{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@StorageProp("IBestColorMode") @Watch("colorModeChange") colorMode: ColorMode = ColorMode.LIGHT
	@StorageProp("IBestBottomBarHeight") bottomBarHeight: number = 0
	@Prop option: IBestActionSheetParams

	@State bgColor: ResourceColor = IBestActionSheetColor.contentBg
	@State buttonColor: ResourceColor = IBestActionSheetColor.buttonBg
	@State textColor: ResourceColor = IBestActionSheetColor.textColor
	@State descriptionColor: ResourceColor = IBestActionSheetColor.descriptionColor
	@State disabledTextColor: ResourceColor = IBestActionSheetColor.disabledTextColor
	@State bdColor: ResourceColor = IBestActionSheetColor.borderColor
	@State activeBg: ResourceColor = IBestActionSheetColor.activeBg

	colorModeChange(){
		this.bgColor = IBestActionSheetColor.contentBg
		this.buttonColor = IBestActionSheetColor.buttonBg
		this.textColor = IBestActionSheetColor.textColor
		this.descriptionColor = IBestActionSheetColor.descriptionColor
		this.disabledTextColor = IBestActionSheetColor.disabledTextColor
		this.bdColor = IBestActionSheetColor.borderColor
		this.activeBg = IBestActionSheetColor.activeBg
	}
	build() {
		Column() {
			if(this.option.customTitle){
				Stack({ alignContent: Alignment.End }) {
					Text(this.option.customTitle)
						.width(CONTAINER_SIZE.FULL)
						.height(CONTAINER_SIZE.FULL)
						.textAlign(TextAlign.Center)
						.fontSize(this.baseStyle.fontSizeLg)
						.fontWeight(600)
						.fontColor(this.textColor)
					if(this.option.closeable){
						Row(){
							IBestIcon({
								name: this.option.closeIcon,
								iconSize: convertDimensionsWidthUnit(18),
								color: this.textColor
							})
						}
						.height(CONTAINER_SIZE.FULL)
						.padding({left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd})
						.onClick(() => {
							this.option.close(this.option.id)
						})
					}
				}
				.height(convertDimensionsWidthUnit(48))
				.backgroundColor(this.option.titleBgColor)
				.border({ width: { bottom: 1 }, color: this.bdColor })
			}
			if(this.option.description){
				Text(this.option.description)
					.width(CONTAINER_SIZE.FULL)
					.textAlign(TextAlign.Center)
					.padding(this.baseStyle.spaceMd)
					.fontSize(this.baseStyle.fontSizeMd)
					.fontColor(this.descriptionColor)
					.backgroundColor(IBestActionSheetColor.buttonBg)
					.border({ width: { bottom: 1 }, color: this.bdColor })
			}
			if(this.option.customContent){
				CustomContent({ customBuilder: this.option.customContent })
			}else if(this.option.actions){
				Column(){
					if(Array.isArray(this.option.actions[0])){
						ForEach(this.option.actions, (actionList: IBestActionMultiLine[], listIndex) => {
							Scroll(){
								Row() {
									ForEach(actionList, (action: IBestActionMultiLine, index) => {
										Button({ type: ButtonType.Normal }) {
											Column() {
												Image(action.icon)
													.width(convertDimensionsWidthUnit(48))
													.fillColor(this.textColor)
													.borderRadius(this.baseStyle.borderRadiusMax)
													.aspectRatio(1)
													.margin({
														left: this.baseStyle.spaceMd,
														right: this.baseStyle.spaceMd,
														bottom: this.baseStyle.spaceXs
													})
													.draggable(false)
												Text(action.name)
													.padding({
														left: this.baseStyle.spaceBase,
														right: this.baseStyle.spaceBase
													})
													.fontSize(this.baseStyle.fontSizeSm)
													.fontColor(action.color || this.textColor)
												if (action.subName) {
													Text(action.subName)
														.fontSize(this.baseStyle.fontSizeSm)
														.fontColor(this.descriptionColor)
														.margin({ top: convertDimensionsWidthUnit(6) })
														.padding({
															left: this.baseStyle.spaceBase,
															right: this.baseStyle.spaceBase
														})
												}
											}
											.alignItems(HorizontalAlign.Center)
										}
										.borderRadius(0)
										.backgroundColor(this.buttonColor)
										.stateEffect(!(action.isDisabled || action.readonly))
										.opacity(action.isDisabled ? 0.5 : 1)
										.onClick(() => {
											if (!(action.isDisabled || action.readonly)) {
												if (action.value) {
													this.option.onSelect?.(listIndex, index, action.value)
												} else {
													this.option.onSelect?.(listIndex, index)
												}
												this.option.close(this.option.id)
											}
										})
									})
								}.alignItems(VerticalAlign.Top)
							}
							.width(CONTAINER_SIZE.FULL)
							.scrollable(ScrollDirection.Horizontal)
							.scrollBar(BarState.Off)
							.align(Alignment.Start)
							.padding({ top: this.baseStyle.spaceMd, bottom: this.baseStyle.spaceMd, left: this.baseStyle.spaceXs })
							.border({ width: { top: listIndex > 0 ? 1 :0 }, color: this.bdColor })
						})
					}else{
						ForEach(this.option.actions, (action: IBestActionType | string, index) => {
							Button({ type: ButtonType.Normal }){
								Column() {
									Row(){
										if(typeof action == "object" && action.icon){
											Image(action.icon)
												.width(convertDimensionsWidthUnit(18))
												.aspectRatio(1)
												.fillColor(typeof action == "object" && action.isDisabled ? this.disabledTextColor : this.textColor)
												.margin({ right: this.baseStyle.spaceXs })
												.draggable(false)
										}
										Text(typeof action == "object" ? action.name : action)
											.fontColor(typeof action == "object" && action.isDisabled ? this.disabledTextColor : (typeof action == "object" && action.color || this.textColor))
									}.justifyContent(FlexAlign.Center)
									if(typeof action == "object" && action.subName){
										Text(action.subName)
											.width(CONTAINER_SIZE.FULL)
											.textAlign(TextAlign.Center)
											.fontSize(this.baseStyle.fontSizeSm)
											.fontColor(this.descriptionColor)
											.margin({ top: this.baseStyle.spaceXs })
									}
								}
								.width(CONTAINER_SIZE.FULL)
								.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
							}
							.height(getSizeByUnit(this.option.itemHeight || 'auto'))
							.backgroundColor(this.buttonColor)
							.type(ButtonType.Normal)
							.border({
								width: { bottom: this.option.actions && index < this.option.actions.length - 1 ? 1 : 0 },
								color: this.bdColor
							})
							.stateEffect(typeof action == "string" || !(action.isDisabled || action.readonly))
							.onClick(() => {
								if(typeof action == "string" || !(action.isDisabled || action.readonly)){
									if(typeof action == "object" && action.value){
										this.option.onSelect?.(index, action.value)
									}else{
										this.option.onSelect?.(index)
									}
									this.option.close(this.option.id)
								}
							})
						})
					}
				}
				.backgroundColor(this.buttonColor)
			}
			if(this.option.cancelText){
				Divider()
					.width(CONTAINER_SIZE.FULL)
					.strokeWidth(convertDimensionsWidthUnit(8))
					.color(this.bgColor)
				Button({ type: ButtonType.Normal }){
					Column(){
						Text(this.option.cancelText).fontColor(this.option.cancelTextColor)
					}
					.width(CONTAINER_SIZE.FULL)
					.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd, top: this.baseStyle.spaceSm, bottom: this.baseStyle.spaceSm })
				}
				.backgroundColor(this.buttonColor)
				.type(ButtonType.Normal)
				.onClick(() => {
					this.option.onCancel?.()
					this.option.close(this.option.id)
				})
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.padding({ bottom: this.option.safeAreaInsetBottom ? convertDimensionsWidthUnit(this.bottomBarHeight) : 0 })
	}
}

@Builder
function defaultBuilder(option: IBestActionSheetParams) {
	defaultContent({ option })
}

interface contentNodeMapVal{
	content: ComponentContent<IBestActionSheetParams>
	params: IBestActionSheetParams
}
async function handleBeforeClose(params: IBestActionSheetParams) {
	let status = true
	try {
		if (params.beforeClose) {
			status = await params.beforeClose()
		}
	} catch (e) {
		status = false
	}
	return status
}

class ActionSheet{
	private uiContext: UIContext | null = null
	private contentNodeMap: Map<string, contentNodeMapVal> = new Map()
	/**
	 * 展示actionSheet
  	 */
	public async show(option: IBestActionSheetOption): Promise<string> {
		let key = this.getUniKey()
		if(!this.uiContext){
			let windowClass: window.Window = await window.getLastWindow(getContext())
			this.uiContext = windowClass.getUIContext()
		}
		let params = new IBestActionSheetParams(option)
		params.id = key
		params.close = (id: string): Promise<void> => this.close(id)
		let contentNode = new ComponentContent(this.uiContext, wrapBuilder(defaultBuilder), params)
		let sheetOption: SheetOptions = {
			width: params.width,
			height: params.height,
			radius: new LengthMetrics(params.radius as number, getLengthUnit()),
			dragBar: params.dragBar,
			preferType: params.preferType,
			showClose: params.showClose,
			onAppear: () => {
				params.onOpen?.()
			},
			onWillDismiss: async (DismissSheetAction: DismissSheetAction) => {
				// 0: 点击三键back、左滑/右滑、键盘ESC 1 点击蒙层  3: 跟手拖拽
				if (DismissSheetAction.reason == DismissReason.PRESS_BACK && !params.closeOnBackPress || DismissSheetAction.reason == DismissReason.TOUCH_OUTSIDE && !params.closeOnClickOverlay) {
					return
				}
				let state = await handleBeforeClose(params)
				if(!state){
					return
				}
				DismissSheetAction.dismiss()
			},
			onDisappear: () => {
				params.onClose?.()
			}
		}
		if(params.backgroundColor){
			sheetOption.backgroundColor = params.backgroundColor
		}
		if(params.detents){
			sheetOption.detents = params.detents
		}
		if(params.mode){
			sheetOption.mode = params.mode
		}
		if(params.title){
			sheetOption.title = params.title
		}
		this.contentNodeMap.set(key, {
			content: contentNode,
			params: params
		})
		await this.uiContext.openBindSheet(contentNode, sheetOption)
		return key
	}
	/**
	 * 关闭actionSheet
	 */
	public async close(id?: string){
		let key = id || this.getLastKey()
		if(this.contentNodeMap.has(key)){
			let val = this.contentNodeMap.get(key) as contentNodeMapVal
			if(val.params.beforeClose){
				let status = await val.params.beforeClose?.()
				if(!status){
					return
				}
			}
			this.uiContext?.closeBindSheet(val?.content).then(() => {
				val?.params.onClose?.()
				this.contentNodeMap.delete(key)
				if(this.contentNodeMap.size == 0){
					this.uiContext = null
				}
			})
		}
	}
	private getUniKey(): string{
		let key = generateId()
		if(this.contentNodeMap.has(key)){
			return this.getUniKey()
		}
		return key
	}
	private getLastKey(): string{
		return Array.from(this.contentNodeMap.keys()).pop() || ""
	}
}

export default new ActionSheet()