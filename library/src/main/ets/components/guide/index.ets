import { IBestStringNumber } from '../../model/Global.type';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { SPACE } from '../../theme-chalk/src/space';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
import { IBestButton } from '../button';
import { IBestIcon } from '../icon';
import { IBestGuideController, IBestGuideItem } from './index.type';

@Component
export struct IBestGuide {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 默认插槽
   */
  @BuilderParam defaultBuilder: CustomBuilder;

  /**
   * 气泡框宽度
   */
  @Prop popupWidth: IBestStringNumber = convertDimensionsWidthUnit(300)
  /**
   * 气泡框高度
   */
  @Prop popupHeight: IBestStringNumber = "auto"
  /**
   * 气泡框最大高度
   */
  @Prop popupMaxHeight: IBestStringNumber = "auto"
  /**
   * 气泡框背景色
   */
  @Provide({allowOverride: "bgColor"}) bgColor: ResourceColor = $r("app.color.ibest_popover_background")
  /**
   * 蒙层颜色
   */
  @Prop maskColor: string= "#99000000"
  /**
   * 引导区域的圆角半径
   */
  @Prop guideCornerRadius: number = 4
  /**
   * 弹出气泡的圆角半径
   */
  @Prop popupCornerRadius: number = 18
  /**
   * 按钮间距
   */
  @Prop buttonSpace: number = 20
  /**
   * 内容区域的行高 lineHeight
   */
  @Prop messageLineHeight: IBestStringNumber = this.baseStyle.lineHeightMd as string
  /**
   * 内容区域的fontSize
   */
  @Prop messageFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string

  ////////////////////////////////////
  /**
   * 是否显示蒙版引导层
   */
  @State isShowGuide: boolean = false;
  @State guideAreaWidth: number = 0;
  @State guideAreaHeight: number = 0;
  @State guideAreaTop: number = 0;
  @State guideAreaBottom: number = 0;
  @State guideAreaLeft: number = 0;
  @State guideAreaRight: number = 0;

  @State guideItemIsFirst: boolean = true
  @State guideItemIsLast: boolean = false
  @State guideItemValue: string = ""
  @State sortTag: string = ""
  @State guidePlacement: Placement = Placement.Bottom

  @State guideContentBuilder: WrappedBuilder<[string]>|null = null
  @State currentLabel: string = ''

  private uiContext = this.getUIContext()
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private ctx: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private controller: IBestGuideController = new IBestGuideController(this.ctx, this.uiContext, {
    onShowed: (label: string, item: IBestGuideItem, isFirst: boolean, isLast: boolean, sortTag: string, placement: Placement) => {
      this.isShowGuide = true
      this.currentLabel = label
      this.guideItemIsFirst = isFirst
      this.guideItemIsLast = isLast
      if(typeof item.value == "string") {
        this.guideItemValue = item.value
        this.guideContentBuilder = null
      } else {
        this.guideContentBuilder = item.value
      }
      this.sortTag = sortTag
      this.guidePlacement = placement

      this.guideAreaWidth = item.guideArea.getWidth()
      this.guideAreaHeight = item.guideArea.getHeight()
      this.guideAreaTop = item.guideArea.top
      this.guideAreaBottom = item.guideArea.bottom
      this.guideAreaLeft = item.guideArea.left
      this.guideAreaRight = item.guideArea.right
    },
    onClosed: () => {
      this.isShowGuide = false
      this.guideContentBuilder = null
    }
  });

  onReady: (controller: IBestGuideController) => void = (controller: IBestGuideController) => {};

  @State uniId: number = 0

  aboutToAppear(): void {
    this.uniId = this.getUniqueId()
    this.controller.setStyle({
      maskColor: this.maskColor,
      guideAreaRound: this.guideCornerRadius
    })
  }

  @Builder popupBuilder() {
    Scroll() {
      Column() {
        if(this.guideContentBuilder) {
          this.guideContentBuilder.builder(this.currentLabel)
        } else {
          Text(this.guideItemValue)
            .width(CONTAINER_SIZE.FULL)
            .padding(this.baseStyle.spaceSm)
            .textAlign(TextAlign.Start)
            .lineHeight(getSizeByUnit(this.messageLineHeight))
            .fontSize(getSizeByUnit(this.messageFontSize, true))
            .fontColor($r("app.color.ibest_dialog_message_color"))
        }

        Row({space: SPACE.XL}) {
          Row({space: SPACE.MD}) {
            Text(this.sortTag)
              .letterSpacing(this.baseStyle.spaceMini as string)
              .fontSize(this.baseStyle.fontSizeMd)
          }
          Blank()
          Row({ space: getSizeByUnit(this.buttonSpace) }) {
            IBestButton({
              text: '上一步',
              type: 'default',
              buttonSize: 'small',
              fontWeight: FontWeight.Medium,
              onBtnClick: ()=>{
                if(!this.guideItemIsFirst){
                  this.controller.prev()
                }
              },
              disabled: this.guideItemIsFirst
            })
            IBestButton({
              text: this.guideItemIsLast ? "结束导览" : "下一步",
              type: 'primary',
              buttonSize: 'small',
              fontWeight: FontWeight.Medium,
              onBtnClick: ()=>{
                if(!this.guideItemIsLast){
                  this.controller.next()
                } else {
                  this.controller.close()
                }
              }
            })
          }
        }
        .padding({ left: this.baseStyle.spaceSm, right: this.baseStyle.spaceSm })
      }
      .padding(this.baseStyle.spaceSm)
    }
    .scrollBar(BarState.Auto)
    .height(getSizeByUnit(this.popupHeight))
    .constraintSize({maxHeight: getSizeByUnit(this.popupMaxHeight)})
  }

  build() {
    Column() {
      Stack() {
        Column() {
          if (this.defaultBuilder) {
            this.defaultBuilder()
          }
        }
        .zIndex(1)

        Stack({ alignContent: Alignment.TopStart }) {
          Canvas(this.ctx)
            .onReady(() => {
              this.onReady(this.controller)
            })
            .width(CONTAINER_SIZE.FULL)
            .height(CONTAINER_SIZE.FULL)

          Button({ type: ButtonType.Normal, stateEffect: false })
            .width(this.guideAreaWidth)
            .height(this.guideAreaHeight)
            .backgroundColor(Color.Transparent)
            .position({left: this.guideAreaLeft, right: this.guideAreaRight, top: this.guideAreaTop, bottom: this.guideAreaBottom})
            .bindPopup(this.isShowGuide, {
              builder: this.popupBuilder,
              width: getSizeByUnit(this.popupWidth) as Dimension,
              placement: this.guidePlacement,
              popupColor: this.bgColor,
              backgroundBlurStyle: BlurStyle.NONE,
              shadow: ShadowStyle.OUTER_DEFAULT_MD,
              showInSubWindow: false,
              autoCancel: false,
              radius: this.popupCornerRadius,
              onWillDismiss: false,
              transition: TransitionEffect.asymmetric(
                TransitionEffect.translate({x: 20, y: 20}).animation({duration: 350, curve: Curve.Ease}),
                TransitionEffect.IDENTITY
              )
            })

        }
        .visibility(this.isShowGuide ? Visibility.Visible : Visibility.None)
        .zIndex(this.isShowGuide ? 99 : 0)
      }
      .width(CONTAINER_SIZE.FULL)
    }
  }
}