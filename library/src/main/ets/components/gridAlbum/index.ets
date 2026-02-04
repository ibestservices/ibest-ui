import { common } from "@kit.AbilityKit"
import { image } from "@kit.ImageKit"
import { IBestStringNumber } from "../../model/Global.type"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { dealUrlToSandbox, getSizeByUnit } from "../../utils/utils"

@Component
export struct IBestGridAlbum {
    /**
     * 图片地址
     */
    @Prop @Require @Watch("init") url: ResourceStr
    /**
     * 整体宽度
     */
    @Prop componentWidth: IBestStringNumber = CONTAINER_SIZE.FULL
    /**
     * 背景色
     */
    @Prop bgColor: ResourceColor = ''
    /**
     * 格子背景色
     */
    @Prop gridBgColor: ResourceColor = ''
    /**
     * 格子间距
     */
    @Prop space: number = 3
    /**
     * 外圆角
     */
    @Prop radius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0

    @State imgModel: PixelMap | null = null
    @State imgInitWidth: number = 0
    @State imgInitHeight: number = 0
    @State itemWidth: number = 0
    private uiContext = this.getUIContext()
    private pageContext = this.uiContext.getHostContext() as common.UIAbilityContext
    private settings: RenderingContextSettings = new RenderingContextSettings(true)
    private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)

    async init() {
        if(!this.url){
            this.imgModel = null
            return
        }
        let path = `${this.pageContext.cacheDir}/ibestGridAlbum_${this.getUniqueId()}.jpg`
        await dealUrlToSandbox(this.pageContext, this.url, path)
        this.getImageInfo(path)
    }
    async getImageInfo(path: string) {
        let imageSource = image.createImageSource(path)
        this.imgModel = await imageSource.createPixelMap()
        let imageInfo = await imageSource.getImageInfo()
        let width = this.uiContext.px2vp(imageInfo.size.width)
        let height = this.uiContext.px2vp(imageInfo.size.height)
        let aspect = width / height
        let canvasWidth = this.ctx.width
        if(width == height){
            this.imgInitWidth = this.imgInitHeight = canvasWidth
        }else if (width >= height) {
            this.imgInitWidth = canvasWidth
            this.imgInitHeight = this.imgInitWidth / aspect
        } else {
            this.imgInitHeight = canvasWidth
            this.imgInitWidth = this.imgInitHeight * aspect
        }
        this.itemWidth = (canvasWidth - this.space * 2) / 3
        this.draw()
    }
    getPosition(index: number): Edges{
        const remainder = index % 3
        const modular = Math.floor(index / 3)
        return {
            left: remainder * (this.itemWidth + this.space),
            top: modular * (this.itemWidth + this.space),
        }
    }
    draw(){
        let topOffset = (this.ctx.height - this.imgInitHeight) / 2
        let leftOffset = (this.ctx.width - this.imgInitWidth) / 2
        this.ctx.clearRect(0, 0, this.ctx.width, this.ctx.height)
        for (const item of [0,1,2,3,4,5,6,7,8]) {
            this.ctx.save()
            this.ctx.beginPath()
            const pos = this.getPosition(item)
            this.ctx.rect(pos.left as number, pos.top as number, this.itemWidth, this.itemWidth)
            this.ctx.clip()
            this.ctx.drawImage(this.imgModel, leftOffset, topOffset, this.imgInitWidth, this.imgInitHeight)
            this.ctx.restore()
        }
    }

    build() {
        Canvas(this.ctx)
            .width(getSizeByUnit(this.componentWidth))
            .aspectRatio(1)
            .backgroundColor(this.bgColor)
            .borderRadius(getSizeByUnit(this.radius))
            .onReady(() => {
                this.init()
            })
    }
}
