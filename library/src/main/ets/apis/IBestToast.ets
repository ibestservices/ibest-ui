import { ComponentContent, PromptAction, UIObserver, window } from '@kit.ArkUI'
import { IBestLoading } from '../components/loading'
import { LoadingIconType, WordBreakType } from '../model/Global.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../theme-chalk/src/index'
import { IBestUIBaseStyleObjType } from '../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getSizeByUnit } from '../utils/utils'
class LoadingOption{
    /**
     * 展示文本
     */
    message?: string
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
    iconWidth?: number | string
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
    offsetY?: number | string
    /**
     * toast打开后回调
     */
    onOpened?: () => void
}

class ToastParams extends ToastOption{
    constructor(value?: ToastOption) {
        super()
        this.type = value?.type
        this.message = value?.message || "加载中"
        this.duration = typeof value?.duration != "undefined" ? value.duration : 1500
        this.wordBreak = value?.wordBreak || "normal"
        this.icon = value?.icon
        this.iconWidth = value?.iconWidth
        this.isShowMask = value?.isShowMask || false
        this.loadingType = value?.loadingType || "circular"
        this.position = value?.position || "center"
        this.offsetY = value?.offsetY || 0
        this.onOpened = value?.onOpened
    }
}

@Extend(Image) function imageStyle(width: number | string | undefined){
    .width(width ? getSizeByUnit(width) : convertDimensionsWidthUnit(36))
    .aspectRatio(1)
    .margin({bottom: convertDimensionsWidthUnit(10)})
}

@Component
struct defaultContent{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @Prop option: ToastParams
    build() {
        Column(){
            if(this.option.icon){
                Image(this.option.icon).imageStyle(this.option.iconWidth)
            }else if(this.option.type){
                if(this.option.type == "loading"){
                    IBestLoading({
                        loadingIconType: this.option.loadingType,
                        loadingSize: convertDimensionsWidthUnit(20),
                        loadingStrokeWidth: 2
                    }).margin({bottom: convertDimensionsWidthUnit(10)})
                }else{
                    Image(this.option.type == "success" ? $r("app.media.success") : this.option.type ==
                        "warning" ? $r("app.media.icon_warn") :$r("app.media.icon_cuo"))
                        .imageStyle(this.option.iconWidth)
                        .fillColor("#fff")
                }
            }
            Text(this.option.message)
                .fontColor($r("app.color.ibest_white"))
                .fontSize(this.baseStyle.fontSizeMd)
                .wordBreak(this.option.wordBreak == "normal" ? WordBreak.NORMAL : this.option.wordBreak == "break-all" ? WordBreak.BREAK_ALL : WordBreak.BREAK_WORD)
        }
        .constraintSize({minWidth: convertDimensionsWidthUnit(96), maxWidth: "60%", minHeight: !this.option.type && !this.option.icon ? 0 :
            convertDimensionsWidthUnit(98)})
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
    private static _instance: Toast = new Toast()
    private toastOption: ToastParams | null = null
    private uiObserver: UIObserver | null = null
    private loadingDialog: ComponentContent<ToastParams> | null = null
    private promptAction: PromptAction | null = null
    private timer: number = 0
    private isLock: boolean = false

    set message(msg: string){
        if(Toast._instance && Toast._instance.toastOption){
            Toast._instance.toastOption.message = msg
            Toast._instance?.loadingDialog?.update(new ToastParams(Toast._instance.toastOption))
        }
    }

    constructor() {}

    private static getInstance(option: ToastParams, uiObserver: UIObserver, loadingDialog: ComponentContent<ToastOption>, promptAction: PromptAction): Toast{
        if(!Toast._instance){
            Toast._instance = new Toast()
        }
        Toast._instance.toastOption = option
        Toast._instance.uiObserver = uiObserver
        Toast._instance.loadingDialog = loadingDialog
        Toast._instance.promptAction = promptAction
        return Toast._instance
    }
    /**
     * 根据参数打开弹框
     */
    private async open(option?: string | ToastOption) {
        if(Toast._instance.isLock){
            return
        }
        Toast._instance.isLock = true
        let params: ToastParams = typeof option == "string" ? new ToastParams({ message: option }) : new ToastParams(option)
        if(Toast._instance.loadingDialog){
            this.autoHide()
        }
        let windowClass = await window.getLastWindow(getContext())
        let uiContext = windowClass.getUIContext()
        let uiObserver = uiContext.getUIObserver()
        let loadingDialog = new ComponentContent(uiContext, wrapBuilder(defaultBuilder), params)
        let promptAction = uiContext.getPromptAction()
        Toast._instance = Toast.getInstance(params, uiObserver, loadingDialog, promptAction)
        await promptAction.openCustomDialog(loadingDialog, {
            alignment: params.position == "top" ? DialogAlignment.Top : params.position == "bottom" ? DialogAlignment.Bottom : DialogAlignment.Center,
            offset: {dx: 0, dy: params.offsetY},
            isModal: params.isShowMask || params.type == "loading",
            maskColor: params.type == "loading" ? "transparent" : "0x33000000",
            autoCancel: false,
            transition: TransitionEffect.IDENTITY,
            onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
                // console.log("原因", JSON.stringify(dismissDialogAction.reason))
            }
        })
        params.onOpened?.()
        if(params.type!="loading"){
            Toast._instance.isLock = false
        }
        // 监听路由变化，关闭toast
        Toast._instance?.uiObserver?.on("routerPageUpdate", ()=>{
            this.autoHide()
        })
        // 非loading自动关闭
        if(params.type!="loading" && params.duration){
            Toast._instance.timer = setTimeout(()=>{
                this.autoHide()
            }, params.duration)
        }
    }
    /**
     * 显示toast
     */
    public show(option?: string | ToastOption){
        this.open(option)
        return Toast._instance
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
    private autoHide(){
        if(Toast._instance === null || Toast._instance.loadingDialog === null){
            return
        }
        Toast._instance.promptAction?.closeCustomDialog(Toast._instance.loadingDialog)
        Toast._instance.loadingDialog?.dispose()
        Toast._instance.uiObserver?.off("routerPageUpdate")
        clearTimeout(Toast._instance.timer)
        Toast._instance.loadingDialog = null
        Toast._instance.isLock = false
    }
    /**
     * 关闭toast
     */
    public hide(){
        setTimeout(() => {
            this.autoHide()
        }, 1)
    }
}

const IBestToast = new Toast()

export default IBestToast