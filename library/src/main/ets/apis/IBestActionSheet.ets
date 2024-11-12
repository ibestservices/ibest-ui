import { ComponentContent, UIContext, window } from '@kit.ArkUI';
import { generateId } from '../assets/ets/utils';
import CustomContent from '../common/components/CustomContent';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../theme-chalk/src';
import { GRAY_COLOR } from '../theme-chalk/src/color.type';
import { CONTAINER_SIZE } from '../theme-chalk/src/container.type';
import { IBestUIBaseStyleObjType } from '../theme-chalk/src/index.type';
import GlobalStore from '../utils/GlobalStore';
// 选项类型
class IBestActionType {
	name: string = ""
	value?: string
	subName?: string
	color?: ResourceColor
	icon?: ResourceStr
	isDisabled?: boolean
}

class IBestActionMultiLine extends IBestActionType {
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
	customTitle?: string
	/**
	 * 自定义标题背景色
	 */
	titleBgColor?: ResourceColor
	/**
	 * 描述
	 */
	description?: string
	/**
	 * 是否显示关闭图标
	 */
	closeable?: boolean
	/**
	 * 自定义关闭图标
	 */
	closeIcon?: string | Resource
	/**
	 * 底部按钮文字
	 */
	cancelText?: string
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
	onSelect?: (index1: number, index2?: number | string, value?: string) => void
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
}

class IBestActionSheetParams extends IBestActionSheetOption {
	id: string = ""
	close: (id: string) => void = () => {}
	constructor(option: IBestActionSheetOption) {
		// console.log("options", JSON.stringify(option))
		super()
		this.width = option.width || CONTAINER_SIZE.FULL
		this.height = option.height || SheetSize.FIT_CONTENT
		this.backgroundColor = option.backgroundColor
		this.detents = option.detents
		this.preferType = option.preferType || SheetType.BOTTOM
		this.mode = option.mode
		this.dragBar = option.dragBar != undefined ? option.dragBar : false
		this.title = option.title
		this.showClose = option.showClose || option.title != undefined || false
		this.actions = option.actions || []
		this.customTitle = option.customTitle || ""
		this.titleBgColor = option.titleBgColor || "#fff"
		this.description = option.description || ""
		this.closeable = option.closeable != undefined ? option.closeable : true
		this.closeIcon = option.closeIcon || $r("app.media.close")
		this.cancelText = option.cancelText || ""
		this.safeAreaInsetBottom = option.safeAreaInsetBottom != undefined ? option.safeAreaInsetBottom : true
		this.closeOnBackPress = option.closeOnBackPress != undefined ? option.closeOnBackPress : true
		this.closeOnClickOverlay = option.closeOnClickOverlay != undefined ? option.closeOnClickOverlay : true
		this.customContent = option.customContent || undefined
		this.onOpen = option.onOpen || undefined
		this.onSelect = option.onSelect || undefined
		this.onCancel = option.onCancel || undefined
		this.onClose = option.onClose || undefined
		this.cancelTextColor = option.cancelTextColor || GRAY_COLOR.GRAY_7
		this.beforeClose = option.beforeClose || undefined
	}
}

@Extend(Button) function actionSheetButtonStyle(bd: boolean = false){
	.type(ButtonType.Normal)
	.backgroundColor("#fff")
	.border({ width: { bottom: bd ? 1 : 0 }, color: "#ebedf0" })
}

@Component
struct defaultContent{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@Prop option: IBestActionSheetParams
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
					if(this.option.closeable){
						Row(){
							Image(this.option.closeIcon)
								.width("44lpx")
								.aspectRatio(1)
						}
						.height(CONTAINER_SIZE.FULL)
						.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd})
						.onClick(() => {
							this.option.close(this.option.id)
						})
					}
				}
				.height("96lpx")
				.backgroundColor(this.option.titleBgColor)
				.border({ width: { bottom: 1 }, color: GRAY_COLOR.GRAY_3 })
			}
			if(this.option.description){
				Text(this.option.description)
					.width(CONTAINER_SIZE.FULL)
					.textAlign(TextAlign.Center)
					.padding(this.baseStyle.spaceMd)
					.fontSize(this.baseStyle.fontSizeMd)
					.fontColor(GRAY_COLOR.GRAY_6)
					.backgroundColor(this.baseStyle.default)
					.border({ width: { bottom: 1 }, color: GRAY_COLOR.GRAY_3 })
			}
			if(this.option.customContent){
				CustomContent({ customBuilder: this.option.customContent })
			}else if(this.option.actions){
				if(Array.isArray(this.option.actions[0])){
					ForEach(this.option.actions, (actionList: IBestActionMultiLine[], listIndex) => {
						Scroll(){
							Row(){
								ForEach(actionList, (action: IBestActionMultiLine, index) => {
									Button(){
										Column() {
											Image(action.icon)
												.width("96lpx")
												.fillColor(GRAY_COLOR.GRAY_8)
												.borderRadius(999)
												.aspectRatio(1)
												.margin({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd, bottom: this.baseStyle.spaceXs })
												.draggable(false)
											Text(action.name)
												.padding({ left: this.baseStyle.spaceBase, right: this.baseStyle.spaceBase })
												.fontSize(this.baseStyle.fontSizeSm)
												.fontColor(action.color || GRAY_COLOR.GRAY_8)
											if(action.subName){
												Text(action.subName)
													.fontSize(this.baseStyle.fontSizeSm)
													.fontColor(GRAY_COLOR.GRAY_5)
													.margin({ top: "12lpx" })
													.padding({ left: this.baseStyle.spaceBase, right: this.baseStyle.spaceBase })
											}
										}.alignItems(HorizontalAlign.Center)
									}
									.type(ButtonType.Normal)
									.borderRadius(0)
									.backgroundColor(this.baseStyle.default)
									.stateEffect(!action.isDisabled)
									.opacity(action.isDisabled ? 0.5 : 1)
									.onClick(() => {
										if(!action.isDisabled){
											if(action.value){
												this.option.onSelect?.(listIndex, index, action.value)
											}else{
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
						.backgroundColor(this.baseStyle.default)
						.padding({ top: this.baseStyle.spaceMd, bottom: this.baseStyle.spaceMd, left: this.baseStyle.spaceXs })
						.border({ width: { top: listIndex > 0 ? 1 :0 }, color: GRAY_COLOR.GRAY_3 })
					})
				}else{
					ForEach(this.option.actions, (action: IBestActionType | string, index) => {
						Button({ type: ButtonType.Normal }){
							Column() {
								Row(){
									if(typeof action == "object" && action.icon){
										Image(action.icon)
											.width("36lpx")
											.aspectRatio(1)
											.fillColor(typeof action == "object" && action.isDisabled ? GRAY_COLOR.GRAY_5 : GRAY_COLOR.GRAY_8)
											.margin({ right: this.baseStyle.spaceXs })
											.draggable(false)
									}
									Text(typeof action == "object" ? action.name : action)
										.fontColor(typeof action == "object" && action.isDisabled ? GRAY_COLOR.GRAY_5 : (typeof action == "object" && action.color || GRAY_COLOR.GRAY_8))
								}.justifyContent(FlexAlign.Center)
								if(typeof action == "object" && action.subName){
									Text(action.subName)
										.width(CONTAINER_SIZE.FULL)
										.textAlign(TextAlign.Center)
										.fontSize(this.baseStyle.fontSizeSm)
										.fontColor(GRAY_COLOR.GRAY_6)
										.margin({ top: this.baseStyle.spaceXs })
								}
							}
							.width(CONTAINER_SIZE.FULL)
							.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd, top: this.baseStyle.spaceSm, bottom: this.baseStyle.spaceSm })
						}
						.actionSheetButtonStyle(this.option.actions && index < this.option.actions.length - 1)
						.stateEffect(typeof action == "string" || !action.isDisabled)
						.onClick(() => {
							if(typeof action == "string" || !action.isDisabled){
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
			if(this.option.cancelText){
				Divider()
					.width(CONTAINER_SIZE.FULL)
					.strokeWidth("16lpx")
					.color(GRAY_COLOR.GRAY_1)
				Button({ type: ButtonType.Normal }){
					Column(){
						Text(this.option.cancelText).fontColor(this.option.cancelTextColor)
					}
					.width(CONTAINER_SIZE.FULL)
					.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd, top: this.baseStyle.spaceSm, bottom: this.baseStyle.spaceSm })
				}
				.actionSheetButtonStyle()
				.onClick(() => {
					this.option.onCancel?.()
					this.option.close(this.option.id)
				})
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.padding({ bottom: this.option.safeAreaInsetBottom ? `${GlobalStore.bottomBarHeight}lpx` : 0 })
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

class ActionSheet{
	private uiContext: UIContext | null = null
	private contentNodeMap: Map<string, contentNodeMapVal> = new Map()
	/**
	 * 展示actionSheet
  	 */
	public async show(option: IBestActionSheetOption): Promise<string> {
		let key = this.getUniKey()
		if(this.uiContext == null){
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
			dragBar: params.dragBar,
			preferType: params.preferType,
			showClose: params.showClose,
			onWillDismiss: async (DismissSheetAction: DismissSheetAction) => {
				// console.log("onWillDismiss", DismissSheetAction.reason)
				// 0: 点击三键back、左滑/右滑、键盘ESC 1 点击蒙层  3: 跟手拖拽
				if (DismissSheetAction.reason == DismissReason.PRESS_BACK && !params.closeOnBackPress || DismissSheetAction.reason == DismissReason.TOUCH_OUTSIDE && !params.closeOnClickOverlay) {
					return
				}
				if(params.beforeClose){
					let status = await params.beforeClose?.()
					if(!status){
						return
					}
				}
				DismissSheetAction.dismiss()
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
		params.onOpen?.()
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