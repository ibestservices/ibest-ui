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

  /**
   * 获取中心点X轴坐标
   */
  public getCenterX(): number {
    return this.left + (this.right - this.left) / 2
  }

  /**
   * 获取中心点Y轴坐标
   */
  public getCenterY(): number {
    return this.top + (this.bottom - this.top) / 2
  }

  /**
   * 获取宽度
   */
  public getWidth(): number {
    return this.right - this.left
  }

  /**
   * 获取高度
   */
  public getHeight(): number {
    return this.bottom - this.top
  }
}

export interface IBestGuideItem {
  value: string|WrappedBuilder<[string]>
  guideArea: GuideRect
  placement: Placement
}

export interface IBestGuideItemOption {
  componentId: string
  content: string|WrappedBuilder<[string]>
  placement?: Placement
}

export interface OnGuideChangedListener {
  onShowed: (label: string, item: IBestGuideItem, isFirst: boolean, isLast: boolean, sortTag: string, placement: Placement) => void;
  onClosed: () => void
}

export interface styleParamType {
  maskColor: string
  guideAreaRound: number
}

export class IBestGuideController {
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

  constructor(ctx: CanvasRenderingContext2D, ctx_ui: UIContext, listener: OnGuideChangedListener) {
    this.context = ctx
    this.contextUi = ctx_ui
    this.guideChangedListener = listener
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
    let data = getComponentsInfo(this.contextUi, option.componentId)
    let space = 8
    let item: IBestGuideItem = {
      value: option.content,
      guideArea: new GuideRect(data.screenLeft-space, data.screenTop-space, data.width+data.screenLeft+space, data.height+data.screenTop+space),
      placement: option.placement ? option.placement : Placement.Bottom
    }
    this.guideGather.set(label, item)
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
      this.guideWay.add(element)
    }

    if(autoStart) {
      this.currentLabelIndex = 0
      const sortTag = "1 / " + this.guideWay.length
      this._drawMask(this.guideWay.get(this.currentLabelIndex), true, false, sortTag)
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
      const sortTag = "1 / " + this.guideWay.length
      this._drawMask(currentLabel, true, false, sortTag)
    }else{
      if(this.currentLabelIndex < this.guideWay.getIndexOf(this.guideWay.getLast())) {
        this.currentLabelIndex += 1
        currentLabel = this.guideWay.get(this.currentLabelIndex)
        const isEnd = (this.currentLabelIndex === this.guideWay.getIndexOf(this.guideWay.getLast()))
        const sortTag = this.currentLabelIndex+1 + " / " + this.guideWay.length
        this._drawMask(currentLabel, false, isEnd, sortTag)
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
      const sortTag = this.currentLabelIndex+1 + " / " + this.guideWay.length
      this._drawMask(currentLabel, (this.currentLabelIndex === 0), false, sortTag)
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
  private _drawMask(label: string, isFirst: boolean, isLast: boolean, sortTag: string): void {
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

    this.guideChangedListener?.onShowed(label, guideItem, isFirst, isLast, sortTag, guideItem.placement)

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