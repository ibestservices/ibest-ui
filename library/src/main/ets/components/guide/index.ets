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
   * 自定义气泡宽度
   */
  @Prop popupWidth: IBestStringNumber = convertDimensionsWidthUnit(300)
  /**
   * 自定义气泡高度
   */
  @Prop popupHeight: IBestStringNumber = convertDimensionsWidthUnit(180)
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
   * 是否显示关闭图标
   */
  @Prop isShowClose: boolean = true
  /**
   * 自定义关闭图标
   */
  @Prop closeIcon: string = "cross"
  /**
   * 关闭图标颜色
   */
  @Prop closeIconColor: string = "#c8c9cc"
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
      animateTo({
        delay: 0,
        duration: isFirst ? 350 : 500
      }, () => {
        this.guideAreaWidth = item.guideArea.getWidth()
        this.guideAreaHeight = item.guideArea.getHeight()
        this.guideAreaTop = item.guideArea.top
        this.guideAreaBottom = item.guideArea.bottom
        this.guideAreaLeft = item.guideArea.left
        this.guideAreaRight = item.guideArea.right
      })
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

  @Builder popupTitle(){
    Row(){
      Blank()
      IBestIcon({
        name: this.closeIcon,
        iconSize: convertDimensionsWidthUnit(20),
        color: this.closeIconColor,
        onIconClick: ()=>{
          this.controller.close()
        }
      })
        .visibility(this.isShowClose ? Visibility.Visible : Visibility.None)
    }
    .width(CONTAINER_SIZE.FULL)
    .height('15%')
    .padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Bottom)
  }

  @Builder popupContent(){
    Row() {
      if(this.guideContentBuilder) {
        this.guideContentBuilder.builder(this.currentLabel)
      } else {
        Scroll() {
          Text(this.guideItemValue)
            .width(CONTAINER_SIZE.FULL)
            .padding(this.baseStyle.spaceSm)
            .textAlign(TextAlign.Start)
            .lineHeight(getSizeByUnit(this.messageLineHeight))
            .fontSize(getSizeByUnit(this.messageFontSize, true))
            .fontColor($r("app.color.ibest_dialog_message_color"))
        }
        .scrollBarColor(this.baseStyle.scrollBarColor as string)
        .edgeEffect(EdgeEffect.None)
        .constraintSize({
          maxHeight: getSizeByUnit('auto')
        })
      }
    }
    .width('100%')
    .height('70%')
  }

  @Builder popupBuilder() {
    Column() {
      //this.popupTitle()
      this.popupContent()

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
      .height('15%')
    }
    .width(this.popupWidth)
    .height(this.popupHeight)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r("app.color.ibest_dialog_background"))
    .padding(this.baseStyle.spaceSm)
  }

  build() {
    Column() {
      Stack() {
        Column() {
          if (this.defaultBuilder) {
            this.defaultBuilder()
          }
        }
        .id('ibest_guide_container_' + this.uniId)
        .width(CONTAINER_SIZE.FULL)
        .height(CONTAINER_SIZE.FULL)
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
              placement: this.guidePlacement,
              showInSubWindow: false,
              autoCancel: false,
              radius: this.popupCornerRadius,
              onWillDismiss: false
            })

        }
        .visibility(this.isShowGuide ? Visibility.Visible : Visibility.None)
        .zIndex(this.isShowGuide ? 99 : 0)
      }
      .width(CONTAINER_SIZE.FULL)
    }
    .height(CONTAINER_SIZE.FULL)
  }
}