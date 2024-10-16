import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { IBestUIBaseStyleObjType, IBestUIBaseStyleType } from '../../theme-chalk/src/index.type';
import { SPACE } from '../../theme-chalk/src/space.type';

@Extend(Button)
function defaultBtnStyles() {
  .layoutWeight(1)
  .backgroundColor('transparent')
  .height('96lpx')
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
  @Link dialogWidth: string;
  /**
   * 弹窗border-radius 默认 32lpx
   */
  @Link dialogBorderRadius: string;
  /**
   * 标题
   */
  @Link title: string;
  /**
   * 标题颜色
   */
  @Link titleColor: ResourceColor;
  /**
   * 标题的padding-top值
   */
  @Link titlePaddingTop: string;
  /**
   * 标题的padding-left与padding-right值 默认48lpx
   */
  @Link titlePaddingX: string;
  /**
   * 标题的padding-top值
   */
  @Link titleLineHeight: string;
  /**
   * 标题的fontSize
   */
  @Link titleFontSize: string;
  /**
   * 标题的对齐方式
   */
  @Link titleTextAlign: 'left' | 'center' | 'right';
  /**
   * 文本内容，支持通过 \n 换行
   */
  @Link message: string;
  /**
   * 内容区域的padding-left与padding-right值 默认48lpx
   */
  @Link messagePaddingX: string;
  /**
   * 内容区域的padding-top值 默认16lpx
   */
  @Link messagePaddingTop: string;
  /**
   * 内容区域的padding-bottom值 默认52lpx
   */
  @Link messagePaddingBottom: string;
  /**
   * 内容区域的fontColor 默认#323233
   */
  @Link messageFontColor: string;
  /**
   * 内容区域的fontSize
   */
  @Link messageFontSize: string;
  /**
   * 内容区域的行高 lineHeight 默认 40lpx
   */
  @Link messageLineHeight: string;
  /**
   * 内容区域的文字对齐方式
   */
  @Link messageTextAlign: 'left' | 'center' | 'right';
  /**
   * 内容区域的滚动区域最大高度
   */
  @Link messageMaxHeight: string;
  // /**
  //  * 样式风格
  //  * 本期暂不开发
  //  */
  // @Link private theme: 'default' | 'round-button' ';
  /**
   * 是否展示确认按钮
   */
  @Link showConfirmButton: boolean;
  /**
   * 是否展示取消按钮
   */
  @Link showCancelButton: boolean;
  /**
   * 确认按钮文案
   */
  @Link confirmButtonText: string;
  /**
   * 取消按钮的文案
   */
  @Link cancelButtonText: string;
  /**
   * 确认按钮的颜色
   */
  @Link confirmButtonColor: ResourceColor;
  /**
   * 取消按钮的颜色
   */
  @Link cancelButtonColor: ResourceColor;
  /**
   * 是否禁用确认按钮
   */
  @Link confirmButtonDisabled: boolean;
  /**
   * 是否禁用取消按钮
   */
  @Link cancelButtonDisabled: boolean;
  /**
   * 按钮的文字大小
   */
  @Link buttonFontSize: string;
  /**
   * 确认按钮的loading
   */
  @Link confirmButtonLoading: boolean;
  /**
   * 取消按钮的loading
   */
  @Link cancelButtonLoading: boolean;
  /**
   * 点击取消的回调
   */
  private onCancel?: (event?: ClickEvent) => void;
  /**
   * 点击确认的的回调
   */
  private onConfirm?: (event?: ClickEvent) => void;

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
    return (typeof this.title === 'string' && !!this.title.length) || typeof this.titleBuilder === 'function'
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
      if (typeof this.titleBuilder === 'function') {
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
      if (typeof this.defaultBuilder === 'function') {
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
      if (typeof this.footerBuilder === 'function') {
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
            .defaultBtnStyles()
            .onClick(event => {
              typeof this.onCancel === 'function' && this.onCancel(event)
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
            .defaultBtnStyles()
            .onClick(event => {
              typeof this.onConfirm === 'function' && this.onConfirm(event)
            })
          }

        }.border({
          width: {
            top: '2lpx'
          },
          color: '#ecedf0'
        })
      }
    }
    .backgroundColor('#fff')
    .width(this.dialogWidth)
    .borderRadius(this.dialogBorderRadius)
    .clip(true)
  }
}