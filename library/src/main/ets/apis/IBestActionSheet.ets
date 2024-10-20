import { ComponentContent, UIContext, window } from '@kit.ArkUI';
import { generateId } from '../assets/ets/utils';
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
}
class IBestActionSheetParams extends IBestActionSheetOption {
	id: string = ""
	close: (id: string) => void = () => {}
	constructor(option: IBestActionSheetOption) {
		// console.log("options", JSON.stringify(option))
		super()
		this.width = option.width || "100%"
		this.height = option.height || SheetSize.FIT_CONTENT
		this.backgroundColor = option.backgroundColor
		this.detents = option.detents
		this.preferType = option.preferType
		this.mode = option.mode
		this.dragBar = option.dragBar || false
		this.title = option.title
		this.showClose = option.showClose || option.title != undefined || false
		this.actions = option.actions || []
		this.customTitle = option.customTitle || ""
		this.titleBgColor = option.titleBgColor || "#fff"
		this.description = option.description || ""
		this.closeable = option.closeable || true
		this.closeIcon = option.closeIcon || $r("app.media.close")
		this.cancelText = option.cancelText || ""
		this.safeAreaInsetBottom = option.safeAreaInsetBottom || true
		this.closeOnBackPress = option.closeOnBackPress || true
		this.closeOnClickOverlay = option.closeOnClickOverlay || true
		this.customContent = option.customContent || undefined
		this.onOpen = option.onOpen || undefined
		this.onSelect = option.onSelect || undefined
		this.onCancel = option.onCancel || undefined
		this.onClose = option.onClose || undefined
	}
}

@Extend(Column) function actionSheetItemStyle(){
	.width("100%")
	.padding({ left: "32lpx", right: "32lpx", top: "28lpx", bottom: "28lpx" })
}
@Extend(Button) function actionSheetButtonStyle(bd: boolean = false){
	.type(ButtonType.Normal)
	.backgroundColor("#fff")
	.border({ width: { bottom: bd ? 1 : 0 }, color: "#ebedf0" })
}

@Component
struct customContent {
	@BuilderParam customBuilder: () => void
	build() {
		this.customBuilder()
	}
}

/**
 * 默认内容 Builder
 */
@Builder
function defaultContentBuilder(option: IBestActionSheetParams) {
	Column() {
		if(option.customTitle){
			Stack({ alignContent: Alignment.End }) {
				Text(option.customTitle)
					.width("100%")
					.height("100%")
					.textAlign(TextAlign.Center)
					.fontSize("32lpx")
					.fontWeight(600)
				if(option.closeable){
					Row(){
						Image(option.closeIcon)
							.width("44lpx")
							.aspectRatio(1)
					}
					.height("100%")
					.padding({ left: "32lpx", right: "32lpx"})
					.onClick(() => {
						option.close(option.id)
					})
				}
			}
			.height("96lpx").backgroundColor(option.titleBgColor).border({ width: { bottom: 1 }, color: "#ebedf0" })
		}
		if(option.description){
			Text(option.description)
				.width("100%")
				.lineHeight("40lpx")
				.textAlign(TextAlign.Center)
				.padding({ top: "40lpx", bottom: "40lpx", left: "32lpx", right: "32lpx" })
				.fontSize("28lpx")
				.fontColor("#969799")
				.backgroundColor("#fff")
				.border({ width: { bottom: 1 }, color: "#ebedf0" })
		}
		if(option.customContent){
			customContent({ customBuilder: option.customContent })
		}else if(option.actions){
			if(Array.isArray(option.actions[0])){
				ForEach(option.actions, (actionList: IBestActionMultiLine[], listIndex) => {
					Scroll(){
						Row(){
							ForEach(actionList, (action: IBestActionMultiLine, index) => {
								Button(){
									Column() {
										Image(action.icon)
											.width("96lpx")
											.fillColor("#323232")
											.borderRadius(1000)
											.aspectRatio(1)
											.margin({ left: "32lpx", right: "32lpx", bottom: "16lpx" })
											.draggable(false)
										Text(action.name)
											.padding({ left: "8lpx", right: "8lpx" })
											.fontSize("24lpx")
											.fontColor(action.color || "#323232")
										if(action.subName){
											Text(action.subName)
												.fontSize("24lpx")
												.fontColor("#c8c9cc")
												.margin({ top: "12lpx" })
												.padding({ left: "8lpx", right: "8lpx" })
										}
									}.alignItems(HorizontalAlign.Center)
								}
								.type(ButtonType.Normal)
								.borderRadius(0)
								.backgroundColor("#fff")
								.stateEffect(!action.isDisabled)
								.opacity(action.isDisabled ? 0.5 : 1)
								.onClick(() => {
									if(!action.isDisabled){
										if(action.value){
											option.onSelect?.(listIndex, index, action.value)
										}else{
											option.onSelect?.(listIndex, index)
										}
										option.close(option.id)
									}
								})
							})
						}.alignItems(VerticalAlign.Top)
					}
					.width("100%")
					.scrollable(ScrollDirection.Horizontal)
					.scrollBar(BarState.Off)
					.align(Alignment.Start)
					.backgroundColor("#fff")
					.padding({ top: "32lpx", bottom: "32lpx", left: "16lpx" })
					.border({ width: { top: listIndex > 0 ? 1 :0 }, color: "#ebedf0" })
				})
			}else{
				ForEach(option.actions, (action: IBestActionType | string, index) => {
					Button({ type: ButtonType.Normal }){
						Column() {
							Row(){
								if(typeof action == "object" && action.icon){
									Image(action.icon)
										.width("36lpx")
										.aspectRatio(1)
										.fillColor(typeof action == "object" && action.isDisabled ? "#c8c9cc" : "#323232")
										.margin({ right: "16lpx" })
										.draggable(false)
								}
								Text(typeof action == "object" ? action.name : action).fontColor(typeof action == "object" && action.isDisabled ? "#c8c9cc" : (typeof action == "object" && action.color || "#323232"))
							}.justifyContent(FlexAlign.Center)
							if(typeof action == "object" && action.subName){
								Text(action.subName)
									.width("100%")
									.textAlign(TextAlign.Center)
									.fontSize("24lpx")
									.fontColor("#969799")
									.margin({ top: "16lpx" })
							}
						}.actionSheetItemStyle()
					}
					.actionSheetButtonStyle(option.actions && index < option.actions.length - 1)
					.stateEffect(typeof action == "string" || !action.isDisabled)
					.onClick(() => {
						if(typeof action == "string" || !action.isDisabled){
							if(typeof action == "object" && action.value){
								option.onSelect?.(index, action.value)
							}else{
								option.onSelect?.(index)
							}
							option.close(option.id)
						}
					})
				})
			}
		}
		if(option.cancelText){
			Divider()
				.width("100%")
				.strokeWidth("16lpx")
				.color("#f7f8fa")
			Button({ type: ButtonType.Normal }){
				Column(){
					Text(option.cancelText).fontColor("#646566")
				}.actionSheetItemStyle()
			}
			.actionSheetButtonStyle()
			.onClick(() => {
				option.onCancel?.()
				option.close(option.id)
			})
		}
	}
	.width("100%")
	.padding({ bottom: option.safeAreaInsetBottom ? `${GlobalStore.bottomBarHeight}lpx` : 0 })
}

class ActionSheet{
	private uiContext: UIContext | null = null
	private contentNodeMap: Map<string, ComponentContent<IBestActionSheetParams>> = new Map()
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
		params.close = (id: string): void => this.close(id)
		let contentNode = new ComponentContent(this.uiContext, wrapBuilder(defaultContentBuilder), params)
		let sheetOption: SheetOptions = {
			width: params.width,
			height: params.height,
			dragBar: params.dragBar,
			showClose: params.showClose,
			onWillDismiss: ((DismissSheetAction: DismissSheetAction) => {
				// console.log("onWillDismiss", DismissSheetAction.reason)
				// 0: 点击三键back、左滑/右滑、键盘ESC 1 点击蒙层  3: 跟手拖拽
				if (DismissSheetAction.reason == DismissReason.PRESS_BACK && params.closeOnBackPress) {
					DismissSheetAction.dismiss()
					params?.onClose?.()
				}
				if(DismissSheetAction.reason == DismissReason.TOUCH_OUTSIDE && params.closeOnClickOverlay){
					DismissSheetAction.dismiss()
					params?.onClose?.()
				}
				DismissSheetAction.dismiss()
				params?.onClose?.()
			})
		}
		if(params.backgroundColor){
			sheetOption.backgroundColor = params.backgroundColor
		}
		if(params.detents){
			sheetOption.detents = params.detents
		}
		if(params.preferType){
			sheetOption.preferType = params.preferType
		}
		if(params.mode){
			sheetOption.mode = params.mode
		}
		if(params.title){
			sheetOption.title = params.title
		}
		this.contentNodeMap.set(key, contentNode)
		await this.uiContext.openBindSheet(contentNode, sheetOption)
		params.onOpen?.()
		return key
	}
	/**
	 * 关闭actionSheet
	 */
	public close(id?: string){
		let key = id || this.getLastKey()
		if(this.contentNodeMap.has(key)){
			this.uiContext?.closeBindSheet(this.contentNodeMap.get(key)).then(() => {
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