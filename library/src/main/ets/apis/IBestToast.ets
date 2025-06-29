import { ComponentContent, PromptAction, window } from '@kit.ArkUI'
import { IBestIcon } from '../components/icon'
import { IBestLoading } from '../components/loading'
import { IBestStringNumber, LoadingIconType, WordBreakType } from '../model/Global.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../theme-chalk/src/index'
import { IBestUIBaseStyleObjType } from '../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getSizeByUnit } from '../utils/utils'
class LoadingOption{
    /**
     * 展示文本
     */
    message?: ResourceStr
    /**
     * 显示时长
     */
    duration?: number
    /**
     * 加载类型  type为loading时有效
     */
    loadingType?: LoadingIconType
}

class ToastOption extends LoadingOption {
    /**
     * 展示类型
     */
    type?: "success" | "warning" | "fail" | "loading"
    /**
     * 换行方式
     */
    wordBreak?: WordBreakType
    /**
     * 自定义图标
     */
    icon?: ResourceStr
    /**
     * 自定义图标宽度
     * @since 1.18.0
     */
    iconWidth?: IBestStringNumber
    /**
     * 是否显示背景遮罩层
     */
    isShowMask?: boolean
    /**
     * 位置
     */
    position?: "top" | "center" | "bottom"
    /**
     * 偏移量
     */
    offsetY?: IBestStringNumber
    /**
     * toast打开后回调
     */
    onOpened?: () => void
    /**
     * toast关闭后回调
     * @since 2.1.2
     */
    onClosed?: () => void
}

class ToastParams extends ToastOption{
    constructor(value?: ToastOption) {
        super()
        this.type = value?.type
        this.message = value?.message || "加载中"
        this.duration = typeof value?.duration != "undefined" ? value.duration : 1500
        this.wordBreak = value?.wordBreak || "normal"
        this.icon = value?.icon
        this.iconWidth = value?.iconWidth || convertDimensionsWidthUnit(36)
        this.isShowMask = value?.isShowMask || false
        this.loadingType = value?.loadingType || "circular"
        this.position = value?.position || "center"
        this.offsetY = value?.offsetY || 0
        this.onOpened = value?.onOpened
        this.onClosed = value?.onClosed
    }
}

@Component
struct defaultContent{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @Prop option: ToastParams
    build() {
        Column({space: this.baseStyle.spaceXs as string}){
            if(this.option.icon){
                IBestIcon({
                    name: this.option.icon,
                    iconSize: getSizeByUnit(this.option.iconWidth!)
                })
            }else if(this.option.type){
                if(this.option.type == "loading"){
                    IBestLoading({
                        loadingIconType: this.option.loadingType,
                        loadingSize: convertDimensionsWidthUnit(20),
                        loadingStrokeWidth: 2
                    })
                }else{
                    IBestIcon({
                        name: this.option.type == "success" ? "success" : this.option.type == "warning" ? "fail" : "cross",
                        iconSize: this.option.iconWidth,
                        color: $r("app.color.ibest_white")
                    })
                }
            }
            Text(this.option.message)
                .fontColor($r("app.color.ibest_white"))
                .fontSize(this.baseStyle.fontSizeMd)
                .wordBreak(this.option.wordBreak == "normal" ? WordBreak.NORMAL : this.option.wordBreak == "break-all" ? WordBreak.BREAK_ALL : WordBreak.BREAK_WORD)
        }
        .constraintSize({minWidth: convertDimensionsWidthUnit(96), maxWidth: "60%", minHeight: !this.option.type && !this.option.icon ? 0 : convertDimensionsWidthUnit(98)})
        .backgroundColor("rgba(0,0,0,0.7)")
        .borderRadius(convertDimensionsWidthUnit(6))
        .padding({left: this.baseStyle.spaceSm, right: this.baseStyle.spaceSm, top: this.baseStyle.spaceXs, bottom: this.baseStyle.spaceXs})
        .justifyContent(FlexAlign.Center)
    }
}
@Builder function defaultBuilder(option: ToastParams){
    defaultContent({ option })
}

class Toast{
	private promptAction: PromptAction | null = null
	private toastOption: ToastParams | null = null
	private toastContent: ComponentContent<ToastParams> | null = null
	private timer: number = 0
	private isLock: boolean = false

    set message(msg: string){
        if(this.toastContent && this.toastOption){
			this.toastOption.message = msg
			this.toastContent.update(new ToastParams(this.toastOption))
        }
    }
    /**
     * 根据参数打开弹框
     */
    private async open(option: string | ToastOption) {
        if(this.isLock){
            return
        }
		if(this.toastContent){
			await this.hide()
		}
		this.isLock = true
		let windowClass = await window.getLastWindow(getContext())
		let uiContext = windowClass.getUIContext()
		this.promptAction = uiContext.getPromptAction()
		let params: ToastParams = typeof option == "string" ? new ToastParams({ message: option }) : new ToastParams(option)
		let toastContent = new ComponentContent(uiContext, wrapBuilder(defaultBuilder), params)
		this.toastContent = toastContent
		this.toastOption = params
        await this.promptAction.openCustomDialog(toastContent, {
            alignment: params.position == "top" ? DialogAlignment.Top : params.position == "bottom" ? DialogAlignment.Bottom : DialogAlignment.Center,
            offset: {dx: 0, dy: params.offsetY},
            isModal: params.isShowMask || params.type == "loading",
            maskColor: params.type == "loading" ? "transparent" : "0x33000000",
            autoCancel: false,
            transition: TransitionEffect.IDENTITY,
			onDidAppear: () => {
				params.onOpened?.()
			},
            onDidDisappear: () => {
				params.onClosed?.()
			},
            onWillDismiss: () => {}
        })
		if(params.type!="loading"){
			this.isLock = false
			if(params.duration){
				this.timer = setTimeout(()=>{
					this.hide()
				}, params.duration)
			}
		}
    }
    /**
     * 显示toast
     */
    public show(option: string | ToastOption){
        this.open(option)
        return this
    }
    /**
     * 显示loading
     */
    public showLoading(option?: LoadingOption) {
        let opt: ToastOption = {
            type: "loading",
            message: option?.message,
            loadingType: option?.loadingType,
            duration: option?.duration
        }
        this.open(opt)
    }
	/**
	 * 关闭toast
	 */
	public async hide(){
		if(this.toastContent === null || this.promptAction === null){
			return
		}
		clearTimeout(this.timer)
		this.timer = 0
		await this.promptAction.closeCustomDialog(this.toastContent)
		this.toastContent.dispose()
		this.toastContent = null
		this.toastOption = null
		this.isLock = false
    }
}

const IBestToast = new Toast()

export default IBestToast