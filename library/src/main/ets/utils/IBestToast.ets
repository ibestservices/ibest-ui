import { ComponentContent, PromptAction, UIObserver, window } from '@kit.ArkUI'
import { IBestLoading } from '../components/loading'
import { AnyType } from './AnyType'
import { LoadingIconType, WordBreakType } from './Global.type'
import { fontSizeData } from '../theme-chalk/src/font'
import { spaceData } from '../theme-chalk/src/space'

class ToastParams{
    /*
     * 展示类型
     */
    type?: "" | "success" | "warning" | "fail" | "loading" = ""
    /*
     * 展示文本
     */
    message?: string = ""
    /*
     * 显示时长
     */
    duration?: number = 1500
    /*
     * 换行方式
     */
    wordBreak?: WordBreakType = "normal"
    /*
     * 自定义图标
     */
    icon?: string | Resource = ""
    /*
     * 是否显示背景遮罩层
     */
    isShowMask?: boolean = false
    /*
     * 加载类型  type为loading时有效
     */
    loadingType?: LoadingIconType = "circular"
    /*
     * 位置
     */
    position?: "top" | "center" | "bottom" = "center"
    /*
     * 偏移量
     */
    offsetY?: number | string = 0
    /*
     * toast打开后回调
     */
    onOpened?: (() => void) | null = null
}

class ToastOption extends ToastParams{
    constructor(value: ToastParams) {
        super()
        this.type = value.type || ""
        this.message = value.message || ""
        this.duration = typeof value.duration != "undefined" ? value.duration : 1500
        this.wordBreak = value.wordBreak || "normal"
        this.icon = value.icon || ""
        this.isShowMask = value.isShowMask || false
        this.loadingType = value.loadingType || "circular"
        this.position = value.position || "center"
        this.offsetY = value.offsetY || 0
        this.onOpened = value.onOpened
    }
}

@Extend(Image) function imageStyle(){
    .width('72lpx')
    .aspectRatio(1)
    .margin({bottom: '20lpx'})
}

@Builder function toastBuilder($$: ToastParams){
    Column(){
        if($$.icon){
            Image($$.icon).imageStyle()
        }else if($$.type){
            if($$.type == "loading"){
                IBestLoading({
                    loadingIconType: $$.loadingType,
                    loadingSize: "38lpx",
                    loadingStrokeWidth: "3lpx"
                }).margin({bottom: '20lpx'})
            }else{
                Image($$.type == "success" ? $r("app.media.success") : $$.type ==
                    "warning" ? $r("app.media.icon_warn") :$r("app.media.icon_cuo"))
                    .imageStyle()
                    .fillColor("#fff")
            }
        }
        Text($$.message)
            .fontColor('#fff')
            .fontSize(fontSizeData.fontSizeMd)
            .wordBreak($$.wordBreak == "normal" ? WordBreak.NORMAL : $$.wordBreak == "break-all" ? WordBreak.BREAK_ALL : WordBreak.BREAK_WORD)
    }
    .constraintSize({minWidth: "192lpx", maxWidth: "60%", minHeight: $$.type == "" && $$.icon == "" ? 0 :
        "196lpx"})
    .backgroundColor("rgba(0,0,0,0.7)")
    .borderRadius("12lpx")
    .padding({left: spaceData.spaceSm, right: spaceData.spaceSm, top: spaceData.spaceXs, bottom: spaceData.spaceXs})
    .justifyContent(FlexAlign.Center)
}

class Toast{
    private static _instance: Toast | null = null
    private toastOption: ToastParams | null = null
    private uiObserver: UIObserver | null = null
    private loadingDialog: ComponentContent<AnyType> | null = null
    private promptAction: PromptAction
    private timer: number = 0
    public _message?: string = ""

    set message(msg: string){
        // console.log("message改变为", msg)
        if(Toast._instance && Toast._instance.toastOption){
            Toast._instance.toastOption.message = msg
            Toast._instance?.loadingDialog?.update(new ToastOption(Toast._instance.toastOption))
        }
    }

    private constructor(option: ToastParams, uiObserver: UIObserver, loadingDialog: ComponentContent<AnyType>, promptAction:
    PromptAction) {
        this.toastOption = option
        this._message = option.message
        this.uiObserver = uiObserver
        this.loadingDialog = loadingDialog
        this.promptAction = promptAction
    }

    private static getInstance(option: ToastParams, uiObserver: UIObserver, loadingDialog: ComponentContent<AnyType>,
        promptAction: PromptAction): Toast{
        if(!Toast._instance){
            Toast._instance = new Toast(option, uiObserver, loadingDialog, promptAction)
        }
        return Toast._instance
    }
    /*
     * 显示toast
     */
    public static async show(value: string | ToastParams){
        let option: ToastParams = typeof value == "string" ? new ToastOption({ message: value }) : new ToastOption(value)
        if(Toast._instance){
            Toast.hide()
        }
        let windowClass = await window.getLastWindow(getContext())
        let uiContext = windowClass.getUIContext()
        let uiObserver = uiContext.getUIObserver()
        let loadingDialog = new ComponentContent(uiContext, wrapBuilder(toastBuilder), option)
        let promptAction = uiContext.getPromptAction()
        Toast._instance = Toast.getInstance(option, uiObserver, loadingDialog, promptAction)
        Toast._instance.promptAction.openCustomDialog(Toast._instance.loadingDialog, {
            alignment: option.position == "top" ? DialogAlignment.Top : option.position == "bottom" ? DialogAlignment.Bottom : DialogAlignment.Center,
            offset: {dx: 0, dy: option.offsetY},
            isModal: option.isShowMask || option.type == "loading",
            maskColor: option.type == "loading" ? "transparent" : "0x33000000",
            autoCancel: false,
            onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
                // console.log("原因", JSON.stringify(dismissDialogAction.reason))
            }
        }).then(()=>{
            option.onOpened?.()
        })
        // 监听路由变化，关闭toast
        Toast._instance.uiObserver?.on("routerPageUpdate", ()=>{
            Toast.hide()
        })
        if(option.type!="loading" && option.duration){
            Toast._instance.timer = setTimeout(()=>{
                Toast.hide()
            }, option.duration)
        }
        return Toast._instance
    }

    /*
     * 关闭toast
     */
    static hide(){
        if(Toast._instance){
            Toast._instance.promptAction.closeCustomDialog(Toast._instance.loadingDialog)
            Toast._instance.loadingDialog?.dispose()
            Toast._instance.uiObserver?.off("routerPageUpdate")
            clearTimeout(Toast._instance?.timer)
            Toast._instance = null
        }
    }
}
export default Toast