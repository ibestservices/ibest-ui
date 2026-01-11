import { ComponentContent, PromptAction } from '@kit.ArkUI'
import { getDefaultBaseStyle } from '../theme-chalk/src'
import { CONTAINER_SIZE } from '../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../theme-chalk/src/index.type'
import CustomContent from '../common/components/CustomContent'
import { convertDimensionsWidthUnit, getSizeByUnit, sleep } from '../utils/utils'
import { IBestStorageKey, IBestStringNumber } from '../model/Global.type'
import GlobalStore from '../utils/globalStore'
class IBestNotifyOption{
	/**
	 * 展示类型
	 */
	type?: "primary" | "success" | "warning" | "danger"
	/**
	 * 展示文本
	 */
	message?: ResourceStr = ""
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
	fontSize?: IBestStringNumber
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
		this.message = value.message
		this.duration = value.duration || 1500
		this.color = value.color
		this.fontSize = value.fontSize
		this.backgroundColor = value.backgroundColor
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
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@StorageProp(IBestStorageKey.TOP_AVOID_HEIGHT) topAvoidHeight: number = 0
	@State transY: IBestStringNumber = "-100%"
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
							.fontColor(this.option.color ?? "#fff")
							.fontSize(getSizeByUnit(this.option.fontSize ?? this.baseStyle.fontSizeMd as string))
							.textAlign(TextAlign.Center)
							.wordBreak(WordBreak.BREAK_WORD)
					}
					.width(CONTAINER_SIZE.FULL)
					.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd, top: this.baseStyle.spaceXs, bottom: this.baseStyle.spaceXs })
					.backgroundColor(this.option.backgroundColor ?? this.baseStyle[this.option.type as string])
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
		.margin({ top: convertDimensionsWidthUnit(this.topAvoidHeight) })
		.clip(true)
	}
}

@Builder function defaultBuilder(option: IBestNotifyParams){
	defaultContent({ option })
}

class Notify{
	private promptAction: PromptAction | null = null
	private contentNode: ComponentContent<IBestNotifyParams> | null = null
	private timer: number = -1
	private isLock: boolean = false
	/**
	 * 显示
	 */
	public async show(option: IBestNotifyOption){
		if(this.isLock){
			return
		}
		if(this.contentNode){
			await this.close()
		}
		let windowClass = GlobalStore.getMainWindow()
		let uiContext = windowClass.getUIContext()
		let params: IBestNotifyParams = new IBestNotifyParams(option)
		this.promptAction = uiContext.getPromptAction()
		this.contentNode = new ComponentContent(uiContext, wrapBuilder(defaultBuilder), params)
		await this.promptAction.openCustomDialog(this.contentNode, {
			alignment: DialogAlignment.Top,
			isModal: false,
			autoCancel: false,
			onDidAppear: () => {
				params.onOpen?.()
			},
			onDidDisappear: () => {
				params.onClose?.()
			},
			onWillDismiss: ((DismissSheetAction: DismissSheetAction) => {
				// 0: 点击三键back、左滑/右滑、键盘ESC
				if (DismissSheetAction.reason == DismissReason.PRESS_BACK) {
					this.close()
				}
			})
		})
		this.autoClose(params)
	}
	/**
	 * 开启自动关闭
	 */
	private autoClose(params: IBestNotifyParams){
		if(this.timer > -1){
			clearTimeout(this.timer)
			this.timer = -1
		}
		this.timer = setTimeout(() => {
			this.close()
		}, params.duration)
	}
	/**
	 * 关闭
	 */
	public async close(){
		if(this.contentNode && this.promptAction){
			if(this.timer > -1){
				clearTimeout(this.timer)
				this.timer = -1
			}
			this.contentNode.reuse()
			await sleep(220)
			await this.promptAction.closeCustomDialog(this.contentNode)
			this.contentNode.dispose()
			this.contentNode = null
			this.isLock = false
		}
	}
}
export default new Notify()