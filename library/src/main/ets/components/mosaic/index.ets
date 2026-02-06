import { IBestStorageKey } from "../../model/Global.type"
import { IBestMosaicColor } from "./color"
import { applyMosaicToImage } from "./util"

@Component
export struct IBestMosaic {
    @StorageProp(IBestStorageKey.COLOR_MODE) @Watch("onDidBuild") colorMode: ColorMode = ColorMode.LIGHT
    /**
     * 是否展示马赛克
     */
    @Prop @Watch("onDidBuild") showMosaic: boolean = true
    /**
     * 延迟时长，单位ms，若在使用中马赛克无法正常显示，可设置更长的延迟时长
     */
    @Prop delay: number = 300
    /**
     * 马赛克块大小
     */
    @Prop blockSize: number = 16
    /**
     * 是否同步展示马赛克，即马赛克与内容同步展示
     */
    @Prop syncShow: boolean = true
    /**
     * 背景色
     */
    @Prop bgColor: ResourceColor = IBestMosaicColor.bgColor
    /**
     * 圆角，当内容部分含有圆角时，请设置该属性
     */
    @Prop radius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0
    /**
     * 默认插槽
     */
    @BuilderParam defaultBuilder: CustomBuilder

    @State isReady: boolean = false
    @State mskPixelMap: PixelMap | null = null
    @State contentWidth: number = 0
    @State contentHeight: number = 0
    private uiContext = this.getUIContext()

    @Builder mskContent() {
        Column(){
            if(this.defaultBuilder){
                this.defaultBuilder()
            }
        }
        .backgroundColor(this.bgColor)
        .alignItems(HorizontalAlign.Start)
        .onAreaChange((_: Area, newVal: Area) => {
            if(!this.contentWidth && newVal.width && newVal.height){
                this.contentWidth = newVal.width as number
                this.contentHeight = newVal.height as number
            }
        })
    }

    onDidBuild() {
        if(this.showMosaic){
            this.getMskPixel()
        }
    }
    getMskPixel(){
        this.uiContext.getComponentSnapshot().createFromBuilder(() => {
            this.mskContent()
        }, this.delay, true, { waitUntilRenderFinished: true }).then(async (pixmap: PixelMap) => {
            this.mskPixelMap = await applyMosaicToImage(pixmap, this.blockSize)
            this.isReady = true
        }).catch(() => {})
    }

    build() {
        Stack({alignContent: Alignment.TopStart}){
            this.mskContent()
            Image(this.mskPixelMap)
                .width(this.contentWidth)
                .height(this.contentHeight)
                .draggable(false)
                .objectFit(ImageFit.Fill)
                .borderRadius(this.radius)
                .visibility(this.showMosaic ? Visibility.Visible : Visibility.None)
        }
        .opacity(this.syncShow && !this.isReady ? 0 : 1)
    }
}