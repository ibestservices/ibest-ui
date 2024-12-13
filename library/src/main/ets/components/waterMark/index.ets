import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { WatermarkCanvas } from './watermarkCanvas'

@Component
export struct IBestWatermark {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 默认的插槽
   */
  @BuilderParam defaultSlot?: CustomBuilder
  /**
   * 图片水印的宽度
   */
  @Prop waterMarkWidth: number
  /**
   * 图片水印的高度
   */
  @Prop waterMarkHeight: number
  /**
   * 水印透明度
   */
  @Prop waterMarkOpacity: number = 0.3
  /**
   * 水印之间的水平间隔 默认0
   */
  @Prop gapX: number
  /**
   * 水印之间的垂直间隔 默认0
   */
  @Prop gapY: number
  /**
   * 旋转角度
   */
  @Prop rotateDeg: number
  /**
   * 图片水印的链接
   */
  @Prop imageUrl: string
  /**
   * 文字水印
   */
  @Prop text: string
  /**
   * 文字的大小
   */
  @Prop fontSize: number
  /**
   * 文字字体
   */
  @Prop fontFamily: string
  /**
   * 文字颜色
   */
  @Prop fontColor: string | number | CanvasGradient | CanvasPattern
  /**
   * 水印的z-index
   * @deprecated
   */
  @Prop waterMarkZIndex: number = -1;
  /**
   * 背景色
   * @since 2.0.1
   */
  @Prop bgColor: ResourceColor = this.baseStyle.default
  /**
   * 水印区域的总高度
   */
  @State waterMarkContainHeight: number = 0;
  /**
   * 水印区域的总宽度
   */
  @State waterMarkContainWidth: number = 0;

  @State url: string = ''

  @Builder bgBuilder(){
    Row(){
      Image(this.url)
        .width(CONTAINER_SIZE.FULL)
        .height(CONTAINER_SIZE.FULL)
        .opacity(this.waterMarkOpacity)
    }
    .backgroundColor(this.bgColor)
    .width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
  }

  build() {
    Row() {
      if(!this.url){
        WatermarkCanvas({
          waterMarkContainHeight: this.waterMarkContainHeight,
          waterMarkContainWidth: this.waterMarkContainWidth,
          waterMarkHeight: this.waterMarkHeight,
          waterMarkWidth: this.waterMarkWidth,
          fontFamily: this.fontFamily,
          rotateDeg: this.rotateDeg,
          fontColor: this.fontColor,
          imageUrl: this.imageUrl,
          fontSize: this.fontSize,
          gapY: this.gapY,
          gapX: this.gapX,
          text: this.text,
          onComplete: (url: string) => {
            console.log('complete', url)
            this.url = url
          }
        })
      }
      if(this.defaultSlot){
        this.defaultSlot()
      }
    }
    .background(this.url ? this.bgBuilder : undefined)
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.waterMarkContainHeight = newValue.height as number;
      this.waterMarkContainWidth = newValue.width as number;
    })
  }
}

