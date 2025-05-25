import { IBestIcon, IBestStringNumber } from "../../../../../Index"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { getComponentsInfo } from "../../utils/utils"
import { IBestDropdownMenuOption, IBestDropdownOption, MenuContentController } from "./index.type"

const popupDuration = 200
const hideDuration = 220

@Component
export struct IBestDropdownMenu{
    @StorageProp("IBestTopAvoidHeight") topAvoidHeight: number = 0
    /**
     * 分组id
     */
    @Prop @Require groupId: IBestStringNumber
    /**
     *
     */

    @State uniId: number = 0
    private uiContext = this.getUIContext()
    private promptAction = this.uiContext.getPromptAction()
    @State menuList: IBestDropdownMenuOption[] = []

    @Builder filterItem(){
        Row(){
            Text("全部商品")
            IBestIcon({
                name: "arrow-down"
            })
        }
        .layoutWeight(1)
        .height(CONTAINER_SIZE.FULL)
        .justifyContent(FlexAlign.Center)
        .id("dropdown_menu")
        .onClick(() => {
            this.openFilter()
        })
    }
    @Builder filterContent(){
        IBestDropdownMenuContent()
    }
    aboutToAppear(){
        this.uniId = this.getUniqueId()
    }
    aboutToDisappear(){

    }
    // 获取遮罩层顶部距离
    getMaskTop(){
        let info = getComponentsInfo(this.uiContext, "dropdown_menu")
        return info.screenTop + info.height
    }
    // 打开筛选
    openFilter(){
        let y = this.getMaskTop()
        this.promptAction.openCustomDialog({
            builder: () => this.filterContent(),
            width: CONTAINER_SIZE.FULL,
            backgroundBlurStyle: BlurStyle.NONE,
            alignment: DialogAlignment.Top,
            cornerRadius: 0,
            maskRect: {
                x: 0,
                y: y,
                width: CONTAINER_SIZE.FULL,
                height: CONTAINER_SIZE.FULL
            },
            offset: { dx: 0, dy: y - this.topAvoidHeight }
        })
    }
    build() {
        Row(){
            this.filterItem()
            this.filterItem()
        }
        .width(CONTAINER_SIZE.FULL)
        .height(48)
        .backgroundColor("#fff")
    }
}

@Component
export struct IBestDropdownMenuItem{
    /**
     * 分组id
     */
    @Prop @Require groupId: IBestStringNumber
    /**
     * 当前选中项对应的value
     */
    @Link value: IBestStringNumber
    /**
     * 菜单项标题
     */
    @Prop title: ResourceStr
    /**
     * 选项数组
     */
    @Prop options: IBestDropdownOption[]
    /**
     * 是否禁用菜单
     */
    @Prop disabled: boolean = false
    build(){}
}

@Component
struct IBestDropdownMenuContent{
    @State transY: IBestStringNumber = "-100%"
    controller: MenuContentController = new MenuContentController()
    aboutToAppear(): void {
        this.controller.hide = (): void => this.init()
        this.init()
    }
    // 初始化
    init(){
        this.transY = "-100%"
    }
    build(){
        Column(){
            Text("筛选")
        }
        .width(CONTAINER_SIZE.FULL)
        .height(300)
        .backgroundColor("#fff")
        .translate({ y: this.transY })
        .animation({ duration: popupDuration, curve: Curve.EaseInOut })
        .onAppear(() => {
            setTimeout(() => {
                this.transY = 0
            }, 100)
        })
    }
}