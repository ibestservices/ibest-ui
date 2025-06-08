import IBestToast from '../../apis/IBestToast';
import { getComponentsInfo } from '../../utils/utils';

export class GuideRect {
  public left: number = 0
  public top: number = 0
  public right: number = 0
  public bottom: number = 0

  constructor(left: number, top: number, right: number, bottom: number) {
    this.left = left
    this.top = top
    this.right = right
    this.bottom = bottom
  }

  public isEmpty() {
    return !this.check(this.left, this.top, this.right, this.bottom, true)
  }

  /**
   * 获取中心点X轴坐标
   * @returns X坐标
   */
  public getCenterX(): number {
    return this.left + (this.right - this.left) / 2
  }

  /**
   * 获取中心点Y轴坐标
   * @returns Y坐标
   */
  public getCenterY(): number {
    return this.top + (this.bottom - this.top) / 2
  }

  /**
   * 获取宽度
   * @returns 矩形区域的宽
   */
  public getWidth(): number {
    return this.right - this.left
  }

  /**
   * 获取高度
   * @returns 矩形区域的高
   */
  public getHeight(): number {
    return this.bottom - this.top
  }

  /**
   * 检测矩形区域坐标数据的有效性
   * @param left 左上角的X坐标
   * @param top 左上角的Y坐标
   * @param right 右下角的X坐标
   * @param bottom 右下角的Y坐标
   */
  private check(left: number | null | undefined, top: number | null | undefined, right: number | null | undefined,
    bottom: number | null | undefined, isStrict: boolean): boolean {
    if (left == null || left == undefined ||
      top == null || top == undefined ||
      right == null || right == undefined ||
      bottom == null || bottom == undefined ||
      right < left || bottom < top) {
      throw new Error('Please check the rect params');
    }
    if(isStrict && (left < 0 || top < 0 || right < 0 || bottom < 0)) {
      //throw new Error('Please check if the area is within the screen');
      return false
    }
    return true
  }

  /**
   * 合并多个矩形区域，返回一个能完全覆盖所有输入矩形的最小矩形
   * @param rects 要合并的矩形数组
   * @returns 合并后的矩形
   */
  public static mergeRects(rects: GuideRect[], padding: number): GuideRect {
    if (rects.length === 0) {
      return new GuideRect(0, 0, 0, 0);
    }

    let minLeft = Infinity;
    let minTop = Infinity;
    let maxRight = -Infinity;
    let maxBottom = -Infinity;

    for (const rect of rects) {
      minLeft = Math.min(minLeft, rect.left);
      minTop = Math.min(minTop, rect.top);
      maxRight = Math.max(maxRight, rect.right);
      maxBottom = Math.max(maxBottom, rect.bottom);
    }

    return new GuideRect(minLeft-padding, minTop-padding, maxRight+padding, maxBottom+padding);
  }
}

export interface styleParamType {
  maskColor: string | number | CanvasGradient | CanvasPattern
  guideAreaRound: number
}

export interface IBestGuideBaseController {
  next(): void;
  prev(): void;
  close(): void;
}

export interface IBestGuideItemType {
  componentId: string|Array<string>
  content: string|WrappedBuilder<[sort: number, total: number, ctl: IBestGuideBaseController]>
  placement?: Placement
}

@Observed
class IBestGuideAttributeCache {
  __context: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  __data: Array<IBestGuideItemType> = []
  __isShowGuide: boolean = false
  __guideAreaChangeEvent: (rect: GuideRect) => void = (rect: GuideRect) => {}
  __guidePlacement: Placement = Placement.Bottom
  __currentSort: number = 0
  __guideTotal: number = 0
  /**
   * @Observed 无法收到WrappedBuilder属性的变更??
   */
  //__guideContentBuilder: WrappedBuilder<[sort: number, total: number, ctl: IBestGuideBaseController]>|null = null
  __guideContentBuilderEvent: (_: WrappedBuilder<[sort: number, total: number, ctl: IBestGuideBaseController]>|null) => void = (_: WrappedBuilder<[sort: number, total: number, ctl: IBestGuideBaseController]>|null) => {}
  __guideItemValue: string = ""
  __guideItemIsFirst: boolean = false
  __guideItemIsLast: boolean = false
  __strictMode: boolean = true
  __styleParam: styleParamType = {
    maskColor: '#99000000',
    guideAreaRound: 4
  }
}

@Observed
export class IBestGuideController implements IBestGuideBaseController {
  private context: UIContext
  private currentIndex: number = -1
  __cache: IBestGuideAttributeCache = new IBestGuideAttributeCache()

  constructor(context: UIContext) {
    this.context = context
  }

  start() {
    // 做一些必要检查
    if(this.__cache.__data.length == 0 || this.currentIndex != -1) {
      return
    }
    for (let index = 0; index < this.__cache.__data.length; index++) {
      const guideArea = this.getGuideRect(index)
      if(this.__cache.__strictMode && guideArea.isEmpty()) {
        IBestToast.show("请检查第"+(index+1)+"个引导区域是否在屏幕内!")
        return
      }
    }

    // 引导第一个
    this.currentIndex = 0
    this.draw()
  }

  next() {
    if(this.currentIndex < this.__cache.__data.length - 1) {
      this.currentIndex +=1
      this.draw()
    }
  }

  prev() {
    if(this.currentIndex > 0) {
      this.currentIndex -=1
      this.draw()
    }
  }

  close() {
    this.__cache.__isShowGuide = false
    //this.__guideContentBuilder = null
    this.__cache.__guideContentBuilderEvent(null)
    this.currentIndex = -1
    this.__cache.__context.clearRect(0, 0, this.__cache.__context.width, this.__cache.__context.height)
  }

  private draw() {
    const item = this.__cache.__data[this.currentIndex]
    const guideArea = this.getGuideRect(this.currentIndex)

    this.__cache.__isShowGuide = true

    if(typeof item.content == "string") {
      this.__cache.__guideItemValue = item.content
      //this.__guideContentBuilder = null
      this.__cache.__guideContentBuilderEvent(null)
    } else {
      //this.__guideContentBuilder = item.content
      this.__cache.__guideContentBuilderEvent(item.content)
    }

    this.__cache.__guideAreaChangeEvent(guideArea)

    this.drawMask(guideArea)

    this.__cache.__guideItemIsFirst = this.currentIndex > 0 ? false : true
    this.__cache.__guideItemIsLast = (this.currentIndex == this.__cache.__data.length - 1 ? true : false)
    this.__cache.__currentSort = this.currentIndex+1
    this.__cache.__guideTotal = this.__cache.__data.length
    this.__cache.__guidePlacement = item.placement ? item.placement : Placement.Bottom
  }

  private getGuideRect(index: number) {
    let guideArea = new GuideRect(0, 0, 0, 0)
    const padding = 8
    const element = this.__cache.__data[index]
    if(typeof element.componentId == "string") {
      const data = getComponentsInfo(this.context, element.componentId)
      guideArea = new GuideRect(data.windowLeft-padding, data.windowTop-padding, data.width+data.windowLeft+padding, data.height+data.windowTop+padding)
    } else {
      let rectList: Array<GuideRect> = []
      for (let j = 0; j < element.componentId.length; j++) {
        const item = element.componentId[j]
        const data = getComponentsInfo(this.context, item)
        rectList.push(new GuideRect(data.windowLeft, data.windowTop, data.width+data.windowLeft, data.height+data.windowTop))
      }
      guideArea = GuideRect.mergeRects(rectList, padding)
    }
    return guideArea
  }

  /**
   * 绘制蒙层
   */
  private drawMask(rect: GuideRect): void {
    this.__cache.__context.clearRect(0, 0, this.__cache.__context.width, this.__cache.__context.height);

    // 绘制全屏蒙版
    this.__cache.__context.fillStyle = this.__cache.__styleParam.maskColor;
    this.__cache.__context.fillRect(0, 0, this.__cache.__context.width, this.__cache.__context.height);
    this.__cache.__context.globalCompositeOperation = "destination-out";
    this.__cache.__context.fillStyle = '#ff0000'

    let round = this.__cache.__styleParam.guideAreaRound
    let minLength = Math.min(rect.getWidth(), rect.getHeight());
    if (round > minLength / 2) {
      round = minLength / 2;
    }
    if (round <= 0) {
      round = 4;
    }
    this.__cache.__context.beginPath();
    this.__cache.__context.moveTo(rect.left + round, rect.top);
    this.__cache.__context.lineTo(rect.right - round, rect.top);
    this.__cache.__context.arc(rect.right - round, rect.top + round, round, 3 / 2 * Math.PI, 0);
    this.__cache.__context.lineTo(rect.right, rect.bottom - round);
    this.__cache.__context.arc(rect.right - round, rect.bottom - round, round, 0, Math.PI / 2);
    this.__cache.__context.lineTo(rect.left + round, rect.bottom);
    this.__cache.__context.arc(rect.left + round, rect.bottom - round, round, Math.PI / 2, Math.PI);
    this.__cache.__context.lineTo(rect.left, rect.top + round);
    this.__cache.__context.arc(rect.left + round, rect.top + round, round, Math.PI, 3 / 2 * Math.PI);
    this.__cache.__context.closePath();
    this.__cache.__context.fill();

    // 还原混合模式：叠加绘制
    this.__cache.__context.globalCompositeOperation = "source-over";
  }
}
