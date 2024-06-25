interface DrawCanvasItemArgs {
  height:  number,
  width: number,
  rotateDeg: number,
  callback: ()=>void
}

interface CountData {
  countX: number,
  countY: number
}

@Component
export struct WatermarkCanvas {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  /**
   * 图片水印的宽度
   */
  @Prop @Watch('drawWaterMark') private waterMarkWidth: number = 100;
  /**
   * 图片水印的高度
   */
  @Prop @Watch('drawWaterMark') private waterMarkHeight: number = 100;
  /**
   * 旋转角度
   */
  @Prop @Watch('drawWaterMark') private rotateDeg: number = -22;
  /**
   * 水印透明度
   */
  @Prop @Watch('drawWaterMark') private waterMarkOpacity: number = 0.3;
  /**
   * 水印区域的总高度
   */
  @Prop @Watch('drawWaterMark') private waterMarkContainHeight: number = 0;
  /**
   * 水印区域的总宽度
   */
  @Prop @Watch('drawWaterMark') private waterMarkContainWidth: number = 0;
  /**
   * 水印之间的水平间隔 默认0
   */
  @Prop @Watch('drawWaterMark') private gapX: number = 0;
  /**
   * 水印之间的垂直间隔 默认0
   */
  @Prop @Watch('drawWaterMark') private gapY: number = 0;
  /**
   * 图片水印的链接
   */
  @Prop @Watch('drawWaterMark') private imageUrl: string = '';
  /**
   * 文字水印的文案 文字水印优先级高于图片水印
   */
  @Prop @Watch('drawWaterMark') private text: string = '';
  /**
   * 文字的大小
   */
  @Prop @Watch('drawWaterMark') private fontSize: number = 30;
  /**
   * 文字字体
   */
  @Prop @Watch('drawWaterMark') private fontFamily: string = 'sans-serif';
  /**
   * 文字颜色
   */
  @Prop @Watch('drawWaterMark') private fontColor: string = '#000'
  /**
   * 水印的z-index
   */
  @Prop private waterMarkZIndex: number = -1;

  private clearCanvas() {
    // 清除画布
    this.context?.clearRect(0, 0, this.waterMarkWidth, this.waterMarkHeight)
  }

  /**
   * 获取x轴与y轴的绘制数量
   * @param width
   * @param height
   * @returns
   */
  private getXYCount(width: number, height: number) {
    // 计算出水平数量
    let countX = Math.ceil(this.waterMarkContainWidth / (width + this.gapX));
    // 保证最少有一个
    if (countX <= 0) {
      countX = 1
    }
    // 计算出垂直数量
    let countY = Math.ceil(this.waterMarkContainHeight / (height + this.gapY));
    // 保证最少有一个
    if (countY <= 0) {
      countY = 1
    }
    // 避免因为旋转导致有部分留白 所以多渲染点
    countY = countY + 2;
    countX = countX + 2;
    const countData: CountData = {
      countX,
      countY
    }
    return countData
  }

  /**
   * 创建矩阵绘制canvas
   * @param {number} width 每个绘制块的宽度
   * @param {number} height 每个绘制块的高度
   * @param {number} rotateDeg 旋转的角度
   * @param {()=>void} callback 每次绘制的内容
   */
  private drawCanvasItem(data: DrawCanvasItemArgs) {
    const width = data.width;
    const height = data.height;
    const rotateDeg = data.rotateDeg;
    const callback = data.callback;
    const countData = this.getXYCount(width, height);
    const countX = countData.countX;
    const countY = countData.countY
    // 根据计算出的数量创建矩阵
    // i是Y轴
    for (let i = 0; i < countY; i++) {
      // j是X轴
      for (let j = 0; j < countX; j++) {
        const x = width * j + this.gapX * j;
        const y = height * i + this.gapY * i
        this.context.save()
        this.context.translate(x, y);
        this.context.rotate(rotateDeg)
        callback()
        // 还原之前保存的状态
        this.context.restore();
      }
    }
  }

  /**
   * 绘制图片
   */
  private handleLayoutImg(rotateDeg: number) {
    const waterMarkImg: ImageBitmap = new ImageBitmap(this.imageUrl)
    this.drawCanvasItem({
      width: this.waterMarkWidth,
      height: this.waterMarkHeight,
      rotateDeg,
      callback: () => {
        this.context.drawImage(waterMarkImg, 0, 0, this.waterMarkWidth, this.waterMarkHeight);
      }
    })
    waterMarkImg.close();
  }

  /**
   * 绘制文字
   */
  private handleLayoutText(rotateDeg: number) {
    this.context.fillStyle = this.fontColor;
    this.context.font = `${vp2px(this.fontSize)}px ${this.fontFamily}`;
    const data = this.context.measureText(this.text);
    this.drawCanvasItem({
      width: data.width,
      height: data.height,
      rotateDeg,
      callback: () => {
        this.context.fillText(this.text, 0, 0);
      }
    })
  }

  /**
   * 绘制水印
   */
  private drawWaterMark() {
      this.context.textBaseline = 'top'
      this.clearCanvas();
      const rotateDeg = this.rotateDeg * Math.PI / 180;
      this.text?.length ? this.handleLayoutText(rotateDeg) : this.handleLayoutImg(rotateDeg);
  }

  build() {
    Canvas(this.context)
      .width(this.waterMarkContainWidth)
      .height(this.waterMarkContainHeight)
      .backgroundColor('transparent')
      .onReady(() => {
        this.drawWaterMark();
      })
      .enabled(false)
      .opacity(this.waterMarkOpacity)
      .zIndex(this.waterMarkZIndex)
      .position({})
  }
}

