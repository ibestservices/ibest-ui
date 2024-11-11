import { ComponentContent, PromptAction, UIObserver, window } from '@kit.ArkUI'
import { IBestLoading } from '../components/loading'
import { LoadingIconType, WordBreakType } from '../utils/Global.type'
import { fontSizeData } from '../theme-chalk/src/font'
import { spaceData } from '../theme-chalk/src/space'

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
    type?: "success" | "warning" | "fail" | "loading" | ""
    /**
     * 换行方式
     */
    wordBreak?: WordBreakType
    /**
     * 自定义图标
     */
    icon?: string | Resource
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
        this.type = value?.type || ""
        this.message = value?.message || "加载中"
        this.duration = typeof value?.duration != "undefined" ? value.duration : 1500
        this.wordBreak = value?.wordBreak || "normal"
        this.icon = value?.icon || ""
        this.isShowMask = value?.isShowMask || false
        this.loadingType = value?.loadingType || "circular"
        this.position = value?.position || "center"
        this.offsetY = value?.offsetY || 0
        this.onOpened = value?.onOpened
    }
}

@Extend(Image) function imageStyle(){
    .width('72lpx')
    .aspectRatio(1)
    .margin({bottom: '20lpx'})
}

@Builder function toastBuilder(option: ToastParams){
    Column(){
        if(option.icon){
            Image(option.icon).imageStyle()
        }else if(option.type){
            if(option.type == "loading"){
                IBestLoading({
                    loadingIconType: option.loadingType,
                    loadingSize: "38lpx",
                    loadingStrokeWidth: "3lpx"
                }).margin({bottom: '20lpx'})
            }else{
                Image(option.type == "success" ? $r("app.media.success") : option.type ==
                    "warning" ? $r("app.media.icon_warn") :$r("app.media.icon_cuo"))
                    .imageStyle()
                    .fillColor("#fff")
            }
        }
        Text(option.message)
            .fontColor('#fff')
            .fontSize(fontSizeData.fontSizeMd)
            .wordBreak(option.wordBreak == "normal" ? WordBreak.NORMAL : option.wordBreak == "break-all" ? WordBreak.BREAK_ALL : WordBreak.BREAK_WORD)
    }
    .constraintSize({minWidth: "192lpx", maxWidth: "60%", minHeight: option.type == "" && option.icon == "" ? 0 :
        "196lpx"})
    .backgroundColor("rgba(0,0,0,0.7)")
    .borderRadius("12lpx")
    .padding({left: spaceData.spaceSm, right: spaceData.spaceSm, top: spaceData.spaceXs, bottom: spaceData.spaceXs})
    .justifyContent(FlexAlign.Center)
}

class Toast{
    private static _instance: Toast = new Toast()
    private toastOption: ToastParams | null = null
    private uiObserver: UIObserver | null = null
    private loadingDialog: ComponentContent<ToastParams> | null = null
    private promptAction: PromptAction | null = null
    private timer: number = 0

    set message(msg: string){
        // console.log("message改变为", msg)
        if(Toast._instance && Toast._instance.toastOption){
            Toast._instance.toastOption.message = msg
            Toast._instance?.loadingDialog?.update(new ToastParams(Toast._instance.toastOption))
        }
    }

    constructor() {}

    private static getInstance(option: ToastParams, uiObserver: UIObserver, loadingDialog: ComponentContent<ToastOption>,
        promptAction: PromptAction): Toast{
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
    private async open(option?: string | ToastOption){
        let params: ToastParams = typeof option == "string" ? new ToastParams({ message: option }) : new ToastParams(option)
        if(Toast._instance.loadingDialog){
            this.hide()
        }
        let windowClass = await window.getLastWindow(getContext())
        let uiContext = windowClass.getUIContext()
        let uiObserver = uiContext.getUIObserver()
        let loadingDialog = new ComponentContent(uiContext, wrapBuilder(toastBuilder), params)
        let promptAction = uiContext.getPromptAction()
        Toast._instance = Toast.getInstance(params, uiObserver, loadingDialog, promptAction)
        await promptAction.openCustomDialog(Toast._instance.loadingDialog, {
            alignment: params.position == "top" ? DialogAlignment.Top : params.position == "bottom" ? DialogAlignment.Bottom : DialogAlignment.Center,
            offset: {dx: 0, dy: params.offsetY},
            isModal: params.isShowMask || params.type == "loading",
            maskColor: params.type == "loading" ? "transparent" : "0x33000000",
            autoCancel: false,
            onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
                // console.log("原因", JSON.stringify(dismissDialogAction.reason))
            }
        })
        params.onOpened?.()
        return params
    }
    /**
     * 显示toast
     */
    public show(option?: string | ToastOption){
        this.open(option).then((params)=>{
            // 监听路由变化，关闭toast
            Toast._instance?.uiObserver?.on("routerPageUpdate", ()=>{
                this.hide()
            })
            // 非loading自动关闭
            if(params.type!="loading" && params.duration){
                Toast._instance.timer = setTimeout(()=>{
                    this.hide()
                }, params.duration)
            }
        })
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

    /**
     * 关闭toast
     */
    public hide(){
        if(Toast._instance && Toast._instance.loadingDialog){
            Toast._instance.promptAction?.closeCustomDialog(Toast._instance.loadingDialog)
            Toast._instance.loadingDialog?.dispose()
            Toast._instance.uiObserver?.off("routerPageUpdate")
            clearTimeout(Toast._instance.timer)
            Toast._instance.loadingDialog = null
        }
    }
}
export default new Toast()