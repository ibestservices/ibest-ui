import { IBestStringNumber } from '../../model/Global.type';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { SPACE } from '../../theme-chalk/src/space';
import GlobalStore from '../../utils/GlobalStore';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
import { IBestButton } from '../button';
import { IBestGuideColor } from './color';
import { GuideRect, IBestGuideBaseController, IBestGuideController, IBestGuideItemType } from './index.type';
import { window } from '@kit.ArkUI';

@Component
export struct IBestGuide {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 默认插槽
   */
  @BuilderParam defaultBuilder: CustomBuilder
  /**
   * 引导路径数据
   */
  @Link @Watch("updateAttributeCache") data: Array<IBestGuideItemType>
  /**
   * 严格模式,当引导的元素不在屏幕内时抛出异常
   */
  @Prop strictMode: boolean = true
  /**
   * 引导控制器
   */
  @ObjectLink controller: IBestGuideController
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
  @Provide({allowOverride: "bgColor"}) bgColor: ResourceColor = IBestGuideColor.bgColor
  /**
   * 气泡框的圆角半径
   */
  @Prop popupCornerRadius: IBestStringNumber = convertDimensionsWidthUnit(8)
  /**
   * 按钮间距
   */
  @Prop buttonSpace: IBestStringNumber = this.baseStyle.spaceMd as string
  /**
   * 内容区域的行高 lineHeight
   */
  @Prop messageLineHeight: IBestStringNumber = this.baseStyle.lineHeightMd as string
  /**
   * 内容区域的fontSize
   */
  @Prop messageFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string

  @State guideContentBuilder: WrappedBuilder<[sort: number, total: number, ctl: IBestGuideBaseController]>|null = null
  @State guideAreaWidth: number = 0
  @State guideAreaHeight: number = 0
  @State guideAreaTop: number = 0
  @State guideAreaBottom: number = 0
  @State guideAreaLeft: number = 0
  @State guideAreaRight: number = 0

  @State isLayoutFullScreen: boolean = GlobalStore.windowStage.getMainWindowSync().getWindowProperties().isLayoutFullScreen
  @State avoidTopRectHeight: number = 0
  @State avoidNavRectHeight: number = 0

  updateAttributeCache() {
    this.controller.__cache.__data = this.data
  }

  @Builder popupBuilder() {
    if(this.guideContentBuilder) {
      this.guideContentBuilder.builder(this.controller.__cache.__currentSort, this.controller.__cache.__guideTotal, this.controller)
    } else {
      Scroll() {
        Column() {
          Text(this.controller.__cache.__guideItemValue)

            .width(CONTAINER_SIZE.FULL)
            .padding(this.baseStyle.spaceSm)
            .textAlign(TextAlign.Start)
            .lineHeight(getSizeByUnit(this.messageLineHeight))
            .fontSize(getSizeByUnit(this.messageFontSize, true))
            .fontColor($r("app.color.ibest_dialog_message_color"))

          Row({space: SPACE.XL}) {
            Row({space: SPACE.MD}) {
              Text(this.controller.__cache.__currentSort.toString() + " / " + this.controller.__cache.__guideTotal.toString())
                .letterSpacing(this.baseStyle.spaceMini as string)
                .fontSize(this.baseStyle.fontSizeMd)
            }
            Blank()
            Row({ space: getSizeByUnit(this.buttonSpace) }) {
              IBestButton({
                text: $r('app.string.ibest_guide_previous'),
                type: 'default',
                buttonSize: 'small',
                fontWeight: FontWeight.Medium,
                onBtnClick: ()=>{
                  if(!this.controller.__cache.__guideItemIsFirst){
                    this.controller.prev()
                  }
                },
                disabled: this.controller.__cache.__guideItemIsFirst
              }).visibility(this.controller.__cache.__guideTotal == 1 ? Visibility.Hidden : Visibility.Visible)
              IBestButton({
                text: this.controller.__cache.__guideItemIsLast ? $r('app.string.ibest_guide_complete') : $r('app.string.ibest_guide_next'),
                type: 'primary',
                buttonSize: 'small',
                fontWeight: FontWeight.Medium,
                onBtnClick: ()=>{
                  if(!this.controller.__cache.__guideItemIsLast){
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
  }

  aboutToAppear(): void {
    this.controller.__cache.__data = this.data
    this.controller.__cache.__strictMode = this.strictMode
    this.controller.__cache.__guideContentBuilderEvent = (builder: WrappedBuilder<[sort: number, total: number, ctl: IBestGuideBaseController]>|null)=>{
      this.guideContentBuilder = builder
    }
    this.controller.__cache.__guideAreaChangeEvent = (rect: GuideRect) => {
      this.guideAreaWidth = rect.getWidth()
      this.guideAreaHeight = rect.getHeight()
      this.guideAreaTop = rect.top
      this.guideAreaBottom = rect.bottom
      this.guideAreaLeft = rect.left
      this.guideAreaRight = rect.right

      this.isLayoutFullScreen = GlobalStore.windowStage.getMainWindowSync().getWindowProperties().isLayoutFullScreen
      this.avoidTopRectHeight = px2vp(GlobalStore.windowStage.getMainWindowSync().getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height)
      this.avoidNavRectHeight = px2vp(GlobalStore.windowStage.getMainWindowSync().getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height)
    }
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

        Column() {
          Column()
            .width(CONTAINER_SIZE.FULL)
            .height(this.avoidTopRectHeight)
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.START])
            .backgroundColor(this.controller.__cache.__styleParam.maskColor as string)
          Blank().height(CONTAINER_SIZE.FULL).layoutWeight(1)
            .borderWidth({top: 0, left: 0, right:0, bottom: 0.5})
            .borderColor(this.controller.__cache.__styleParam.maskColor as string)
          Column()
            .width(CONTAINER_SIZE.FULL)
            .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM, SafeAreaEdge.END])
            .backgroundColor(this.controller.__cache.__styleParam.maskColor as string)
        }
          .width(CONTAINER_SIZE.FULL)
          .height(CONTAINER_SIZE.FULL)
          .visibility((this.controller.__cache.__isShowGuide && !this.isLayoutFullScreen) ? Visibility.Visible : Visibility.None)
          .zIndex(this.controller.__cache.__isShowGuide ? 100 : 0)

        Stack({ alignContent: Alignment.TopStart }) {
          Canvas(this.controller.__cache.__context).width(CONTAINER_SIZE.FULL).height(CONTAINER_SIZE.FULL)
          Button({ type: ButtonType.Normal, stateEffect: false })
            .width(this.guideAreaWidth)
            .height(this.guideAreaHeight)
            .backgroundColor(Color.Transparent)
            .position({left: this.guideAreaLeft, right: this.guideAreaRight, top: this.guideAreaTop, bottom: this.guideAreaBottom})
            .bindPopup(this.controller.__cache.__isShowGuide, {
              builder: this.popupBuilder,
              width: getSizeByUnit(this.popupWidth) as Dimension,
              placement: this.controller.__cache.__guidePlacement,
              popupColor: this.bgColor,
              backgroundBlurStyle: BlurStyle.NONE,
              shadow: ShadowStyle.OUTER_DEFAULT_MD,
              showInSubWindow: false,
              autoCancel: false,
              radius: getSizeByUnit(this.popupCornerRadius) as Dimension,
              onWillDismiss: false,
              transition: TransitionEffect.asymmetric(
                TransitionEffect.opacity(0).animation({duration: 20, delay: 50}),
                TransitionEffect.IDENTITY
              )
            })
        }
        .visibility(this.controller.__cache.__isShowGuide ? Visibility.Visible : Visibility.None)
        .zIndex(this.controller.__cache.__isShowGuide ? 99 : 0)
      }
      .width(CONTAINER_SIZE.FULL)
    }
  }
}