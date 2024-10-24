import { ComponentContent, PromptAction, window } from '@kit.ArkUI'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../theme-chalk/src'
import { CONTAINER_SIZE } from '../theme-chalk/src/container.type'
import { IBestUIBaseStyleObjType } from '../theme-chalk/src/index.type'
import CustomContent from '../common/components/CustomContent'
import GlobalStore from '../utils/GlobalStore'
class IBestNotifyOption{
	/**
	 * 展示类型
	 */
	type?: "primary" | "success" | "warning" | "danger"
	/**
	 * 展示文本
	 */
	message?: string = ""
	/**
	 * 显示时长
	 */
	duration?: number
	/**
	 * 字体颜色
	 */
	color?: ResourceColor
	/**
	 * 字体大小
	 */
	fontSize?: number
	/**
	 * 背景色
     */
	backgroundColor?: ResourceColor
	/**
	 * 自定义通知内容
  	 */
	customContent?: CustomBuilder
	/**
	 * 打开后回调
	 */
	onOpen?: () => void
	/**
	 * 关闭回调
     */
	onClose?: () => void
	/**
	 * 点击回调
	 */
	onClick?: () => void
}

class IBestNotifyParams extends IBestNotifyOption{
	constructor(value: IBestNotifyOption) {
		super()
		this.type = value.type || "danger"
		this.message = value.message || ""
		this.duration = typeof value.duration != "undefined" ? value.duration : 1500
		this.color = value.color || "#fff"
		this.fontSize = typeof value.fontSize != "undefined" ? value.fontSize : 28
		this.backgroundColor = value.backgroundColor || getDefaultBaseStyle()[this.type]
		this.customContent = value.customContent
		this.onOpen = value.onOpen
		this.onClose = value.onClose
		this.onClick = value.onClick
	}
}

@Component
struct defaultContent{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@State transY: string | number = "-100%"
	@Prop option: IBestNotifyParams

	aboutToReuse(): void {
		this.transY = "-100%"
	}

	build() {
		Column(){
			Column(){
				if(this.option.customContent){
					CustomContent({ customBuilder: this.option.customContent })
				}else{
					Row(){
						Text(this.option.message)
							.fontColor(this.option.color)
							.fontSize(this.option.fontSize + "lpx")
							.textAlign(TextAlign.Center)
							.wordBreak(WordBreak.BREAK_WORD)
					}
					.width(CONTAINER_SIZE.FULL)
					.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd, top: this.baseStyle.spaceXs, bottom: this.baseStyle.spaceXs })
					.backgroundColor(this.option.backgroundColor)
					.justifyContent(FlexAlign.Center)
					.alignItems(VerticalAlign.Center)
					.onClick(() => {
						this.option.onClick?.()
					})
				}
			}
			.translate({ y: this.transY })
			.animation({
				duration: 150
			})
			.onAppear(() => {
				setTimeout(() => {
					this.transY = 0
				}, 100)
			})
		}
		.margin({ top: GlobalStore.topAvoidHeight + 'lpx' })
		.clip(true)
	}
}

@Builder function defaultBuilder(option: IBestNotifyParams){
	defaultContent({ option })
}

class Notify{
	private static _instance: Notify = new Notify()
	private params: IBestNotifyParams | null = null
	private contentNode: ComponentContent<IBestNotifyParams> | null = null
	private promptAction: PromptAction | null = null
	private timer: number = 0

	constructor() {}

	private static getInstance(params: IBestNotifyParams, contentNode: ComponentContent<IBestNotifyParams>, promptAction: PromptAction): Notify{
		if(!Notify._instance){
			Notify._instance = new Notify()
		}
		Notify._instance.params = params
		Notify._instance.contentNode = contentNode
		Notify._instance.promptAction = promptAction
		return Notify._instance
	}
	/**
	 * 显示
	 */
	public async show(option: IBestNotifyOption){
		let params: IBestNotifyParams = new IBestNotifyParams(option)
		if(Notify._instance.contentNode){
			Notify._instance.params = params
			Notify._instance.contentNode.update(params)
			this.autoClose(params)
			return
		}
		let windowClass = await window.getLastWindow(getContext())
		let uiContext = windowClass.getUIContext()
		let promptAction = uiContext.getPromptAction()
		let contentNode = new ComponentContent(uiContext, wrapBuilder(defaultBuilder), params)
		Notify._instance = Notify.getInstance(params, contentNode, promptAction)
		promptAction.openCustomDialog(contentNode, {
			alignment: DialogAlignment.Top,
			isModal: false,
			autoCancel: false,
			onWillDismiss: ((DismissSheetAction: DismissSheetAction) => {
				// 0: 点击三键back、左滑/右滑、键盘ESC
				if (DismissSheetAction.reason == DismissReason.PRESS_BACK) {
					this.close()
					params.onClose?.()
				}
			})
		}).then(()=>{
			params.onOpen?.()
			this.autoClose(params)
		})
	}
	/**
	 * 开启自动关闭
	 */
	private autoClose(params: IBestNotifyParams){
		if(Notify._instance.timer){
			clearTimeout(Notify._instance.timer)
			Notify._instance.timer = 0
		}
		Notify._instance.timer = setTimeout(() => {
			this.close()
		}, params.duration)
	}
	/**
	 * 关闭
	 */
	public close(){
		if(Notify._instance.contentNode){
			Notify._instance.contentNode.reuse()
			if(Notify._instance.timer){
				clearTimeout(Notify._instance.timer)
				Notify._instance.timer = 0
			}
			setTimeout(() => {
				if(Notify._instance.contentNode){
					Notify._instance.promptAction?.closeCustomDialog(Notify._instance.contentNode)
					Notify._instance.contentNode.dispose()
					Notify._instance.contentNode = null
					Notify._instance.params?.onClose?.()
				}
			}, 220)
		}
	}
}
export default new Notify()