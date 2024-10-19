import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { SPACE } from '../../theme-chalk/src/space.type';

@Extend(Button)
function defaultBtnStyles(theme: 'default' | 'round-button') {
  .layoutWeight(1)
  .backgroundColor('transparent')
  .height(theme == 'default' ? '96lpx' : "72lpx")
}

@CustomDialog
export struct IBestDialogView {
  /**
   * 控制器
   */
  controller?: CustomDialogController;
  /**
   * 标题区域的builder
   */
  @BuilderParam titleBuilder: CustomBuilder;
  /**
   * 内容区域的builder
   */
  @BuilderParam defaultBuilder: CustomBuilder;
  /**
   * 底部区域的builder
   */
  @BuilderParam footerBuilder: CustomBuilder;
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 弹窗宽度
   */
  @Prop dialogWidth: string;
  /**
   * 弹窗border-radius 默认 32lpx
   */
  @Prop dialogBorderRadius: string;
  /**
   * 标题
   */
  @Prop title: string;
  /**
   * 标题颜色
   */
  @Prop titleColor: ResourceColor;
  /**
   * 标题的padding-top值
   */
  @Prop titlePaddingTop: string;
  /**
   * 标题的padding-left与padding-right值 默认48lpx
   */
  @Prop titlePaddingX: string;
  /**
   * 标题的padding-top值
   */
  @Prop titleLineHeight: string;
  /**
   * 标题的fontSize
   */
  @Prop titleFontSize: string;
  /**
   * 标题的对齐方式
   */
  @Prop titleTextAlign: 'left' | 'center' | 'right';
  /**
   * 文本内容，支持通过 \n 换行
   */
  @Prop message: string;
  /**
   * 内容区域的padding-left与padding-right值 默认48lpx
   */
  @Prop messagePaddingX: string;
  /**
   * 内容区域的padding-top值 默认16lpx
   */
  @Prop messagePaddingTop: string;
  /**
   * 内容区域的padding-bottom值 默认52lpx
   */
  @Prop messagePaddingBottom: string;
  /**
   * 内容区域的fontColor 默认#323233
   */
  @Prop messageFontColor: ResourceColor;
  /**
   * 内容区域的fontSize
   */
  @Prop messageFontSize: string;
  /**
   * 内容区域的行高 lineHeight 默认 40lpx
   */
  @Prop messageLineHeight: string;
  /**
   * 内容区域的文字对齐方式
   */
  @Prop messageTextAlign: 'left' | 'center' | 'right';
  /**
   * 内容区域的滚动区域最大高度
   */
  @Prop messageMaxHeight: string;
  /**
   * 样式风格
   * @since 1.16.0
   */
  @Prop theme: 'default' | 'round-button'
  /**
   * 是否展示确认按钮
   */
  @Prop showConfirmButton: boolean;
  /**
   * 是否展示取消按钮
   */
  @Prop showCancelButton: boolean;
  /**
   * 确认按钮文案
   */
  @Prop confirmButtonText: string;
  /**
   * 取消按钮的文案
   */
  @Prop cancelButtonText: string;
  /**
   * 确认按钮的字体颜色
   */
  @Prop confirmButtonColor: ResourceColor;
  /**
   * 确认按钮的背景颜色
   * @since 1.16.0
   */
  @Prop confirmButtonBgColor: ResourceColor;
  /**
   * 取消按钮的字体颜色
   */
  @Prop cancelButtonColor: ResourceColor;
  /**
   * 取消按钮的背景颜色
   * @since 1.16.0
   */
  @Prop cancelButtonBgColor: ResourceColor;
  /**
   * 是否禁用确认按钮
   */
  @Prop confirmButtonDisabled: boolean;
  /**
   * 是否禁用取消按钮
   */
  @Prop cancelButtonDisabled: boolean;
  /**
   * 按钮的文字大小
   */
  @Prop buttonFontSize: string;
  /**
   * 确认按钮的loading
   */
  @Prop confirmButtonLoading: boolean;
  /**
   * 取消按钮的loading
   */
  @Prop cancelButtonLoading: boolean;
  /**
   * 点击取消的回调
   */
  onCancel: (event?: ClickEvent) => void = () => {}
  /**
   * 点击确认的的回调
   */
  onConfirm: (event?: ClickEvent) => void = () => {}

  /**
   * 对齐置换TextAlign
   */
  getFormatAlign(align: string) {
    switch (align) {
      case 'left':
        return TextAlign.Start
      case 'center':
        return TextAlign.Center
      case 'right':
        return TextAlign.End
      default:
        return TextAlign.Center
    }
  }

  /**
   * 是否含有title
   * @returns
   */
  isHasTitle() {
    return typeof this.title === 'string' && !!this.title.length
  }

  /**
   * 获取内容区域文字颜色
   * @returns
   */
  getMsgColor() {
    return this.messageFontColor ? this.messageFontColor : this.isHasTitle() ? GRAY_COLOR.GRAY_7 : GRAY_COLOR.GRAY_8;
  }

  /**
   * 确认按钮的文字颜色
   * @returns
   */
  getConfirmBtnFontColor() {
    return this.confirmButtonColor ? this.confirmButtonColor : this.baseStyle.primary
  }

  /**
   * 确认按钮的文字颜色
   * @returns
   */
  getCancelBtnFontColor() {
    return this.cancelButtonColor ? this.cancelButtonColor : GRAY_COLOR.GRAY_7
  }

  build() {
    Column() {
      // title
      if (this.titleBuilder) {
        this.titleBuilder()
      } else {
        if (this.isHasTitle()) {
          Text(this.title)
            .fontSize(this.titleFontSize)
            .fontWeight(FontWeight.Medium)
            .lineHeight(this.titleLineHeight)
            .padding({
              top: this.titlePaddingTop,
              left: this.titlePaddingX,
              right: this.titlePaddingX
            })
            .textAlign(this.getFormatAlign(this.titleTextAlign))
            .fontColor(this.titleColor)
        }
      }


      // content
      if (this.defaultBuilder) {
        this.defaultBuilder()
      } else {
        Scroll() {
          Text(this.message)
            .padding({
              top: this.messagePaddingTop,
              left: this.messagePaddingX,
              right: this.messagePaddingX,
              bottom: this.messagePaddingBottom
            })
            .margin({top: this.isHasTitle() ? 0 : this.messagePaddingBottom})
            .textAlign(this.getFormatAlign(this.messageTextAlign))
            .lineHeight(this.messageLineHeight)
            .fontSize(this.messageFontSize)
            .fontColor(this.getMsgColor())
        }
        .scrollBarColor(this.baseStyle.scrollBarColor)
        .constraintSize({
          maxHeight: this.messageMaxHeight
        })
        .edgeEffect(EdgeEffect.Spring)
      }


      // footer
      if (this.footerBuilder) {
        this.footerBuilder()
      } else {
        Row() {
          // 取消按钮
          if (this.showCancelButton) {
            Button({ type: ButtonType.Normal }) {
              Row() {
                if (this.cancelButtonLoading) {
                  LoadingProgress()
                    .width(this.buttonFontSize)
                    .color(this.getCancelBtnFontColor())
                    .margin({
                      right: SPACE.MINI
                    })
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                } else {
                  Text(this.cancelButtonText)
                    .fontColor(this.getCancelBtnFontColor())
                    .fontSize(this.buttonFontSize)
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                }
              }
            }
            .border({
              width: { right: this.showConfirmButton ? '2lpx' : 0 },
              color: '#ecedf0'
            })
            .enabled(!this.cancelButtonDisabled || !this.cancelButtonLoading)
            .defaultBtnStyles(this.theme)
            .backgroundColor(this.cancelButtonBgColor)
            .borderRadius(this.theme == "round-button" ? { topLeft: 999, bottomLeft: 999, topRight: this.showConfirmButton ? 0 : 999, bottomRight: this.showConfirmButton ? 0 : 999 } : 0)
            .onClick(event => {
              this.onCancel(event)
            })
          }

          // 确认按钮
          if (this.showConfirmButton) {
            Button({ type: ButtonType.Normal }) {
              Row() {
                if (this.confirmButtonLoading) {
                  LoadingProgress()
                    .width(this.buttonFontSize)
                    .color(this.getConfirmBtnFontColor())
                    .margin({
                      right: SPACE.MINI
                    })
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                } else {
                  Text(this.confirmButtonText)
                    .fontColor(this.getConfirmBtnFontColor())
                    .fontSize(this.buttonFontSize)
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                }
              }
            }
            .enabled(!this.confirmButtonDisabled || !this.confirmButtonLoading)
            .defaultBtnStyles(this.theme)
            .backgroundColor(this.confirmButtonBgColor)
            .borderRadius(this.theme == "round-button" ? { topLeft: this.showCancelButton ? 0 : 999, bottomLeft: this.showCancelButton ? 0 : 999, topRight: 999, bottomRight: 999 } : 0)
            .onClick(event => {
              this.onConfirm(event)
            })
          }

        }.border({
          width: {
            top: this.theme == 'default' ? '2lpx' : 0
          },
          color: '#ecedf0'
        })
        .padding(this.theme == "round-button" ? { top: this.baseStyle.spaceXs, left: this.baseStyle.spaceLg, right: this.baseStyle.spaceLg, bottom: this.baseStyle.spaceMd } : "")
      }
    }
    .backgroundColor('#fff')
    .width(this.dialogWidth)
    .borderRadius(this.dialogBorderRadius)
    .clip(true)
  }
}