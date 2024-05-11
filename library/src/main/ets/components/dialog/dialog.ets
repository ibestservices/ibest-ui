import { IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';
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
  @BuilderParam titleBuilder: CustomBuilder | null = null;
  /**
   * 内容区域的builder
   */
  @BuilderParam defaultBuilder: CustomBuilder | null = null;
  /**
   * 底部区域的builder
   */
  @BuilderParam footerBuilder: CustomBuilder | null = null;
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IbestUIBaseStyleType = {}
  /**
   * 弹窗宽度
   */
  @Consume private provide_dialogWidth: string;
  /**
   * 弹窗border-radius 默认 32lpx
   */
  @Consume private provide_dialogBorderRadius: string;
  /**
   * 标题
   */
  @Consume private provide_title: string;
  /**
   * 标题颜色
   */
  @Consume private provide_titleColor: string;
  /**
   * 标题的padding-top值
   */
  @Consume private provide_titlePaddingTop: string;
  /**
   * 标题的padding-left与padding-right值 默认48lpx
   */
  @Consume private provide_titlePaddingX: string;
  /**
   * 标题的padding-top值
   */
  @Consume private provide_titleLineHeight: string;
  /**
   * 标题的fontSize
   */
  @Consume private provide_titleFontSize: string;
  /**
   * 标题的对齐方式
   */
  @Consume private provide_titleTextAlign: 'left' | 'center' | 'right';
  /**
   * 文本内容，支持通过 \n 换行
   */
  @Consume private provide_message: string;
  /**
   * 内容区域的padding-left与padding-right值 默认48lpx
   */
  @Consume private provide_messagePaddingX: string;
  /**
   * 内容区域的padding-top值 默认16lpx
   */
  @Consume private provide_messagePaddingTop: string;
  /**
   * 内容区域的padding-top值 默认52lpx
   */
  @Consume private provide_messagePaddingBottom: string;
  /**
   * 内容区域的fontColor 默认#323233
   */
  @Consume private provide_messageFontColor: string;
  /**
   * 内容区域的fontSize
   */
  @Consume private provide_messageFontSize: string;
  /**
   * 内容区域的行高 lineHeight 默认 40lpx
   */
  @Consume private provide_messageLineHeight: string;
  /**
   * 内容区域的文字对齐方式
   */
  @Consume private provide_messageTextAlign: 'left' | 'center' | 'right';
  /**
   * 内容区域的滚动区域最大高度
   */
  @Consume private provide_messageMaxHeight: string;
  // /**
  //  * 样式风格
  //  * 本期暂不开发
  //  */
  // @Consume private provide_theme: 'default' | 'round-button';
  /**
   * 是否展示确认按钮
   */
  @Consume private provide_showConfirmButton: boolean;
  /**
   * 是否展示取消按钮
   */
  @Consume private provide_showCancelButton: boolean;
  /**
   * 确认按钮文案
   */
  @Consume private provide_confirmButtonText: string;
  /**
   * 取消按钮的文案
   */
  @Consume private provide_cancelButtonText: string;
  /**
   * 确认按钮的颜色
   */
  @Consume private provide_confirmButtonColor: string;
  /**
   * 取消按钮的颜色
   */
  @Consume private provide_cancelButtonColor: string;
  /**
   * 是否禁用确认按钮
   */
  @Consume private provide_confirmButtonDisabled: boolean;
  /**
   * 是否禁用取消按钮
   */
  @Consume private provide_cancelButtonDisabled: boolean;
  /**
   * 按钮的文字大小
   */
  @Consume private provide_buttonFontSize: string;
  /**
   * 确认按钮的loading
   */
  @Consume private provide_confirmButtonLoading: boolean;
  /**
   * 确认按钮的loading
   */
  @Consume private provide_cancelButtonLoading: boolean;
  /**
   * 点击取消的回调
   */
  private onCancel: (event?: ClickEvent) => void;
  /**
   * 点击确认的的回调
   */
  private onConfirm: (event?: ClickEvent) => void;
  /**
   * 对齐置换TextAlign
   */
  align2Align = {
    left: TextAlign.Start,
    center: TextAlign.Center,
    right: TextAlign.End
  }

  /**
   * 是否含有title
   * @returns
   */
  isHasTitle() {
    return (typeof this.provide_title === 'string' && !!this.provide_title.length) || typeof this.titleBuilder === 'function'
  }

  /**
   * 获取内容区域文字颜色
   * @returns
   */
  getMsgColor() {
    return this.provide_messageFontColor ? this.provide_messageFontColor : this.isHasTitle() ? GRAY_COLOR.GRAY_7 : GRAY_COLOR.GRAY_8;
  }

  /**
   * 确认按钮的文字颜色
   * @returns
   */
  getConfirmBtnFontColor() {
    return this.provide_confirmButtonColor ? this.provide_confirmButtonColor : this.baseStyle.primary
  }

  /**
   * 确认按钮的文字颜色
   * @returns
   */
  getCancelBtnFontColor() {
    return this.provide_cancelButtonColor ? this.provide_cancelButtonColor : GRAY_COLOR.GRAY_7
  }

  build() {
    Column() {
      // title
      if (typeof this.titleBuilder === 'function') {
        this.titleBuilder()
      } else {
        if (this.isHasTitle) {
          Text(this.provide_title)
            .fontSize(this.provide_titleFontSize)
            .fontWeight(FontWeight.Medium)
            .lineHeight(this.provide_titleLineHeight)
            .padding({
              top: this.provide_titlePaddingTop,
              left: this.provide_titlePaddingX,
              right: this.provide_titlePaddingX
            })
            .textAlign(this.align2Align[this.provide_titleTextAlign])
            .fontColor(this.provide_titleColor)
        }
      }


      // content
      if (typeof this.defaultBuilder === 'function') {
        this.defaultBuilder()
      } else {
        Scroll() {
          Text(this.provide_message)
            .padding({
              top: this.provide_messagePaddingTop,
              left: this.provide_messagePaddingX,
              right: this.provide_messagePaddingX,
              bottom: this.provide_messagePaddingBottom
            })
            .textAlign(this.align2Align[this.provide_messageTextAlign])
            .lineHeight(this.provide_messageLineHeight)
            .fontSize(this.provide_messageFontSize)
            .fontColor(this.getMsgColor())
        }
        .scrollBarColor(this.baseStyle.scrollBarColor)
        .constraintSize({
          maxHeight: this.provide_messageMaxHeight
        })
        .edgeEffect(EdgeEffect.Spring)
      }


      // footer
      if (typeof this.footerBuilder === 'function') {
        this.footerBuilder()
      } else {
        Row() {
          // 取消按钮
          if (this.provide_showCancelButton) {
            Button({ type: ButtonType.Normal }) {
              Row() {
                if (this.provide_cancelButtonLoading) {
                  LoadingProgress()
                    .width(this.provide_buttonFontSize)
                    .color(this.getCancelBtnFontColor())
                    .margin({
                      right: SPACE.MINI
                    })
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                } else {
                  Text(this.provide_cancelButtonText)
                    .fontColor(this.getCancelBtnFontColor())
                    .fontSize(this.provide_buttonFontSize)
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                }
              }
            }
            .border({
              width: { right: this.provide_showConfirmButton ? '2lpx' : 0 },
              color: '#ecedf0'
            })
            .enabled(!this.provide_cancelButtonDisabled || !this.provide_cancelButtonLoading)
            .defaultBtnStyles()
            .onClick(event => {
              typeof this.onCancel === 'function' && this.onCancel(event)
            })
          }

          // 确认按钮
          if (this.provide_showConfirmButton) {
            Button({ type: ButtonType.Normal }) {
              Row() {
                if (this.provide_confirmButtonLoading) {
                  LoadingProgress()
                    .width(this.provide_buttonFontSize)
                    .color(this.getConfirmBtnFontColor())
                    .margin({
                      right: SPACE.MINI
                    })
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                } else {
                  Text(this.provide_confirmButtonText)
                    .fontColor(this.getConfirmBtnFontColor())
                    .fontSize(this.provide_buttonFontSize)
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                }
              }
            }
            .enabled(!this.provide_confirmButtonDisabled || !this.provide_confirmButtonLoading)
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
    .width(this.provide_dialogWidth)
    .borderRadius(this.provide_dialogBorderRadius)
    .clip(true)
  }
}