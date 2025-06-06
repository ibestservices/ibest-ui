import { HashMap, List } from '@kit.ArkTS';
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

export interface IBestGuideItem {
  value: string|WrappedBuilder<[sort: number, total: number, ctl: IBestGuideBaseController]>
  guideArea: GuideRect
  placement: Placement
}

export interface IBestGuideItemOption {
  componentId: string|Array<string>
  content: string|WrappedBuilder<[sort: number, total: number, ctl: IBestGuideBaseController]>
  placement?: Placement
}

export interface OnGuideChangedListener {
  onShowed: (label: string, item: IBestGuideItem, isFirst: boolean, isLast: boolean, currentSort: number, total: number, placement: Placement) => void;
  onClosed: () => void
}

export interface styleParamType {
  maskColor: string
  guideAreaRound: number
}

export interface IBestGuideBaseController {
  next(): void;
  prev(): void;
  close(): void;
}

export class IBestGuideController implements IBestGuideBaseController {
  private contextUi: UIContext
  private context: CanvasRenderingContext2D
  private guideGather: HashMap<string, IBestGuideItem> = new HashMap();
  private guideChangedListener: OnGuideChangedListener | null = null;
  private guideWay: List<string> = new List();
  private currentLabelIndex: number = -1
  private styleParam: styleParamType = {
    maskColor: '#99000000',
    guideAreaRound: 4
  }
  private isStrict: boolean = false

  constructor(ctx: CanvasRenderingContext2D, ctx_ui: UIContext, listener: OnGuideChangedListener) {
    this.context = ctx
    this.contextUi = ctx_ui
    this.guideChangedListener = listener
  }
  /**
   * 严格模式,当引导的元素不在屏幕内时抛出异常
   */
  setStrictMode(isStrict: boolean) {
    this.isStrict = isStrict
  }
  /**
   * 设置样式相关
   */
  setStyle(style: styleParamType) {
    this.styleParam = style
  }
  /**
   * 设置引导节点
   */
  setGuideItem(label: string, option: IBestGuideItemOption) {
    let item: IBestGuideItem = {
      value: option.content,
      guideArea: new GuideRect(0, 0, 0, 0),
      placement: option.placement ? option.placement : Placement.Bottom
    }
    const padding = 8

    if(typeof option.componentId == "string") {
      const data = getComponentsInfo(this.contextUi, option.componentId)
      item.guideArea = new GuideRect(data.windowLeft-padding, data.windowTop-padding, data.width+data.windowLeft+padding, data.height+data.windowTop+padding)
    } else {
      let rectList: Array<GuideRect> = []
      for (let index = 0; index < option.componentId.length; index++) {
        const element = option.componentId[index]
        const data = getComponentsInfo(this.contextUi, element)
        rectList.push(new GuideRect(data.windowLeft, data.windowTop, data.width+data.windowLeft, data.height+data.windowTop))
      }
      item.guideArea = GuideRect.mergeRects(rectList, padding)
    }

    if(this.isStrict && item.guideArea.isEmpty()) {
      return false
    }
    this.guideGather.set(label, item)
    return true
  }
  /**
   * 设置引导路径
   */
  setGuideWay(guideWay: Array<string>, autoStart?: boolean) {
    if(this.guideGather.isEmpty() || !guideWay.length){
      return
    }
    for (let index = 0; index < guideWay.length; index++) {
      const element = guideWay[index];
      if(this.guideGather.hasKey(element)) {
        this.guideWay.add(element)
      }
    }

    if(autoStart) {
      this.currentLabelIndex = 0
      this._drawMask(this.guideWay.get(this.currentLabelIndex), true, (this.guideWay.length > 1 ? false : true), 1, this.guideWay.length)
    }
  }
  /**
   * 下一个引导节点
   */
  next() {
    if(this.guideGather.isEmpty() || this.guideWay.isEmpty()){
      return
    }

    let currentLabel: string = ""
    if(this.currentLabelIndex == -1) {
      currentLabel = this.guideWay.getFirst()
      this.currentLabelIndex = this.guideWay.getIndexOf(currentLabel)
      this._drawMask(currentLabel, true, (this.guideWay.length > 1 ? false : true), 1, this.guideWay.length)
    }else{
      if(this.currentLabelIndex < this.guideWay.getIndexOf(this.guideWay.getLast())) {
        this.currentLabelIndex += 1
        currentLabel = this.guideWay.get(this.currentLabelIndex)
        const isEnd = (this.currentLabelIndex === this.guideWay.getIndexOf(this.guideWay.getLast()))
        this._drawMask(currentLabel, false, isEnd, this.currentLabelIndex+1, this.guideWay.length)
      }
    }
  }
  /**
   * 上一个引导节点
   */
  prev() {
    if(this.currentLabelIndex > 0) {
      this.currentLabelIndex -= 1
      const currentLabel = this.guideWay.get(this.currentLabelIndex)
      this._drawMask(currentLabel, (this.currentLabelIndex === 0), false, this.currentLabelIndex+1, this.guideWay.length)
    }
  }
  /**
   * 清除所有引导节点和路径
   */
  cleanAll() {
    this.cleanGuideWay()
    this.guideGather.clear()
  }
  /**
   * 清除引导路径
   */
  cleanGuideWay() {
    this.guideWay.clear()
  }
  /**
   * 关闭引导
   */
  close() {
    if(this.guideGather.isEmpty()){
      return
    }
    this.guideChangedListener?.onClosed()
    this.currentLabelIndex = -1
    this.context.clearRect(0, 0, this.context.width, this.context.height);
  }

  /**
   * 绘制蒙层
   */
  private _drawMask(label: string, isFirst: boolean, isLast: boolean, currentSort: number, total: number): void {
    this.context.clearRect(0, 0, this.context.width, this.context.height);

    // 绘制全屏蒙版
    this.context.fillStyle = this.styleParam.maskColor;
    this.context.fillRect(0, 0, this.context.width, this.context.height);
    this.context.globalCompositeOperation = "destination-out";
    this.context.fillStyle = '#ff0000'

    let guideItem = this.guideGather.get(label)
    let rect = guideItem.guideArea
    let round = this.styleParam.guideAreaRound
    let minLength = Math.min(rect.getWidth(), rect.getHeight());
    if (round > minLength / 2) {
      round = minLength / 2;
    }
    if (round <= 0) {
      round = 4;
    }

    this.guideChangedListener?.onShowed(label, guideItem, isFirst, isLast, currentSort, total, guideItem.placement)

    this.context.beginPath();
    this.context.moveTo(rect.left + round, rect.top);
    this.context.lineTo(rect.right - round, rect.top);
    this.context.arc(rect.right - round, rect.top + round, round, 3 / 2 * Math.PI, 0);
    this.context.lineTo(rect.right, rect.bottom - round);
    this.context.arc(rect.right - round, rect.bottom - round, round, 0, Math.PI / 2);
    this.context.lineTo(rect.left + round, rect.bottom);
    this.context.arc(rect.left + round, rect.bottom - round, round, Math.PI / 2, Math.PI);
    this.context.lineTo(rect.left, rect.top + round);
    this.context.arc(rect.left + round, rect.top + round, round, Math.PI, 3 / 2 * Math.PI);
    this.context.closePath();
    this.context.fill();

    // 还原混合模式：叠加绘制
    this.context.globalCompositeOperation = "source-over";
  }
}