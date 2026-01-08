import { IBestAwaitable, IBestStorageKey, IBestStringNumber } from "../../model/Global.type"
import { getDefaultBaseStyle } from "../../theme-chalk/src"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit, handleBeforeFunction } from "../../utils/utils"
import { IBestIcon } from "../icon"

@Component
export struct IBestReadMore{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @StorageProp(IBestStorageKey.COLOR_MODE) colorMode: ColorMode = ColorMode.LIGHT
    /**
     * 展开状态
     */
    @Link value: boolean
    /**
     * 展开操作文案
     */
    @Prop expandText: ResourceStr = $r("app.string.ibest_text_expand")
    /**
     * 收起操作文案
     */
    @Prop collapseText: ResourceStr = $r("app.string.ibest_text_collapse")
    /**
     * 展开时显示的图标
     */
    @Prop expandIcon: ResourceStr = 'arrow-down'
    /**
     * 收起时显示的图标
     */
    @Prop collapseIcon: ResourceStr = 'arrow-up'
    /**
     * 操作文字颜色
     */
    @Prop actionColor: ResourceColor = ""
    /**
     * 文字大小
     */
    @Prop actionFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 收起高度
     */
    @Prop collapseHeight: IBestStringNumber = convertDimensionsWidthUnit(50)
    /**
     * 动画时长, 单位ms
     */
    @Prop duration: number = 200
    /**
     * 置灰
     */
    @Prop inactive: boolean = false
    /**
     * 是否为一次性展开, 即展开后不再显示收起
     */
    @Prop once: boolean = false
    /**
     * 展开前回调
     */
    beforeExpand?: () => IBestAwaitable
    /**
     * 默认内容
     */
    @BuilderParam defaultBuilder: CustomBuilder
    /**
     * 切换回调
     */
    toggle: (value: boolean) => void = () => {}

    @State contentHeight: number = 0
    @State uniId: number = 0
    @State isReady: boolean = false
    @State isShow: boolean = false
    private context: UIContext = this.getUIContext()

    aboutToAppear(): void {
        this.uniId = this.getUniqueId()
        setTimeout(() => {
            this.getContentHeight()
        }, 50)
    }
    // 获取高度
    getContentHeight(){
        let info = getComponentsInfo(this.context, `ibest_readmore_${this.uniId}`)
        this.contentHeight = info.height
        if(!this.isShow){
            this.isReady = true
            setTimeout(() => {
                this.isShow = true
            }, 50)
        }
    }
    // 切换
    async changeExpand(){
        let status = await handleBeforeFunction(this.beforeExpand)
        if(!status){
            return
        }
        this.value = !this.value
        this.toggle(this.value)
    }

    build() {
        Column({space: this.baseStyle.spaceXs}){
            Column(){
                Column(){
                    if(this.defaultBuilder){
                        this.defaultBuilder()
                    }
                }
                .width(CONTAINER_SIZE.FULL)
                .alignItems(HorizontalAlign.Start)
                Row()
                    .width(CONTAINER_SIZE.FULL)
                    .height(convertDimensionsWidthUnit(50))
                    .position({left: 0, bottom: 0})
                    .opacity(this.value ? 0 : 1)
                    .animation({
                        duration: this.isShow ? this.duration : 0
                    })
                    .linearGradient({
                        direction: GradientDirection.Top,
                        colors: this.colorMode == 0 ? [["#000", 0], ["rgba(0,0,0,0)", 1]] : [["#fff", 0], ["rgba(255, 255, 255, 0)", 1]]
                    })
            }
            .width(CONTAINER_SIZE.FULL)
            .height(this.isReady ? this.value ? this.contentHeight : getSizeByUnit(this.collapseHeight) : "auto")
            .id(`ibest_readmore_${this.uniId}`)
            .clip(true)
            .animation({
                duration: this.isShow ? this.duration : 0
            })
            if(!(this.value && this.once)){
                Row({space: this.baseStyle.spaceX}){
                    Text(this.value ? this.collapseText : this.expandText)
                        .fontColor(this.actionColor || this.baseStyle.primary)
                        .fontSize(this.actionFontSize)
                    IBestIcon({
                        name: this.value ? this.collapseIcon : this.expandIcon,
                        color: this.actionColor || this.baseStyle.primary,
                        iconSize: this.actionFontSize
                    })
                }
                .width(CONTAINER_SIZE.FULL)
                .justifyContent(FlexAlign.Center)
                .opacity(this.inactive ? 0.5 : 1)
                .onClick(() => {
                    this.changeExpand()
                })
            }
        }
    }
}