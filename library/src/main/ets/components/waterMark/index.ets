import { WatermarkCanvas } from './watermarkCanvas'

@Component
export struct IBestWatermark {
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
  @Prop waterMarkOpacity: number
  /**
   * 水印之间的水平间隔 默认0
   */
  @Prop gapX: number
  /**
   * 水印之间的垂直间隔 默认0
   */
  @Prop gapY: number = 0;
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
  @Prop fontFamily: string = 'sans-serif';
  /**
   * 文字颜色
   */
  @Prop fontColor: string | number | CanvasGradient | CanvasPattern = '#000'
  /**
   * 水印的z-index
   */
  @Prop waterMarkZIndex: number = -1;
  /**
   * 水印区域的总高度
   */
  @State waterMarkContainHeight: number = 0;
  /**
   * 水印区域的总宽度
   */
  @State waterMarkContainWidth: number = 0;

  build() {
    Stack() {
      WatermarkCanvas({
        waterMarkContainHeight: this.waterMarkContainHeight,
        waterMarkContainWidth: this.waterMarkContainWidth,
        waterMarkOpacity: this.waterMarkOpacity,
        waterMarkZIndex: this.waterMarkZIndex,
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
      })
      if(this.defaultSlot){
        this.defaultSlot()
      }
      //   通过这个事件的回调可以拿到组件的宽高
    }.onAreaChange((oldValue: Area, newValue: Area) => {
      this.waterMarkContainHeight = newValue.height as number;
      this.waterMarkContainWidth = newValue.width as number;
    })
  }
}

