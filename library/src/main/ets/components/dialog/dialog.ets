import { IBestDialogColor } from './color';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';

@Extend(Button)
function defaultBtnStyles(theme: 'default' | 'round-button') {
  .layoutWeight(1)
  .height(convertDimensionsWidthUnit(theme == 'default' ? 48 : 36))
}

@CustomDialog
export struct IBestDialogView {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  @StorageProp("IBestColorMode") @Watch("colorModeChange") colorMode: ColorMode = ColorMode.LIGHT
  @State whiteColor: ResourceColor = IBestDialogColor.white
  @State contentBg: ResourceColor = IBestDialogColor.contentBg
  @State titleDefaultColor: ResourceColor = IBestDialogColor.titleColor
  @State messageColor: ResourceColor = IBestDialogColor.messageColor
  @State cancelTextColor: ResourceColor = IBestDialogColor.cancelTextColor
  @State bdColor: ResourceColor = IBestDialogColor.borderColor
  @State activeBg: ResourceColor = IBestDialogColor.activeBg
  /**
   * 控制器
   */
  controller?: CustomDialogController;
  /**
   * 标题区域的builder
   */
  @BuilderParam titleBuilder?: CustomBuilder;
  /**
   * 内容区域的builder
   */
  @BuilderParam defaultBuilder?: CustomBuilder;
  /**
   * 底部区域的builder
   */
  @BuilderParam footerBuilder?: CustomBuilder;
  /**
   * 弹窗宽度
   */
  @Prop dialogWidth: string | number = convertDimensionsWidthUnit(320)
  /**
   * 弹窗圆角
   */
  @Prop dialogBorderRadius: string | number = this.baseStyle.spaceMd as string
  /**
   * 标题
   */
  @Prop title: string = ''
  /**
   * 标题颜色
   */
  @Prop titleColor: ResourceColor = ''
  /**
   * 标题的padding-top值
   */
  @Prop titlePaddingTop: string | number = convertDimensionsWidthUnit(26)
  /**
   * 标题的padding-left与padding-right值
   */
  @Prop titlePaddingX: string | number = convertDimensionsWidthUnit(24)
  /**
   * 标题的padding-top值
   */
  @Prop titleLineHeight: string | number = convertDimensionsWidthUnit(24)
  /**
   * 标题的fontSize
   */
  @Prop titleFontSize: string | number = this.baseStyle.fontSizeLg as string
  /**
   * 标题的对齐方式
   */
  @Prop titleTextAlign: 'left' | 'center' | 'right' = 'center'
  /**
   * 文本内容，支持通过 \n 换行
   */
  @Prop message: string = ''
  /**
   * 内容区域的padding-left与padding-right值
   */
  @Prop messagePaddingX: string | number = convertDimensionsWidthUnit(24)
  /**
   * 内容区域的padding-top值
   */
  @Prop messagePaddingTop: string | number = convertDimensionsWidthUnit(8)
  /**
   * 内容区域的padding-bottom值
   */
  @Prop messagePaddingBottom: string | number = convertDimensionsWidthUnit(26)
  /**
   * 内容区域的fontColor 默认#323233
   */
  @Prop messageFontColor: ResourceColor = ''
  /**
   * 内容区域的fontSize
   */
  @Prop messageFontSize: string | number = this.baseStyle.fontSizeMd as string
  /**
   * 内容区域的行高 lineHeight
   */
  @Prop messageLineHeight: string | number = this.baseStyle.lineHeightMd as string
  /**
   * 内容区域的文字对齐方式
   */
  @Prop messageTextAlign: 'left' | 'center' | 'right' = 'center'
  /**
   * 内容区域的滚动区域最大高度
   */
  @Prop messageMaxHeight: string | number = '60%'
  /**
   * 样式风格
   * @since 1.16.0
   */
  @Prop theme: 'default' | 'round-button' = 'default'
  /**
   * 按钮间距
   * @since 1.16.0
   */
  @Prop buttonSpace: string | number = 0
  /**
   * 是否展示确认按钮
   */
  @Prop showConfirmButton: boolean = true
  /**
   * 是否展示取消按钮
   */
  @Prop showCancelButton: boolean = false
  /**
   * 确认按钮文案
   */
  @Prop confirmButtonText: string = '确认'
  /**
   * 取消按钮的文案
   */
  @Prop cancelButtonText: string = '取消'
  /**
   * 确认按钮的字体颜色
   */
  @Prop confirmButtonColor: ResourceColor = ''
  /**
   * 确认按钮的背景颜色
   * @since 1.16.0
   */
  @Prop confirmButtonBgColor: ResourceColor = ''
  /**
   * 取消按钮的字体颜色
   */
  @Prop cancelButtonColor: ResourceColor = ''
  /**
   * 取消按钮的背景颜色
   * @since 1.16.0
   */
  @Prop cancelButtonBgColor: ResourceColor = ""
  /**
   * 是否禁用确认按钮
   */
  @Prop confirmButtonDisabled: boolean = false
  /**
   * 是否禁用取消按钮
   */
  @Prop cancelButtonDisabled: boolean = false
  /**
   * 按钮的文字大小
   */
  @Prop buttonFontSize: string | number = this.baseStyle.fontSizeLg as string
  /**
   * 确认按钮的loading
   */
  @Prop confirmButtonLoading: boolean = false
  /**
   * 取消按钮的loading
   */
  @Prop cancelButtonLoading: boolean = false
  /**
   * 点击取消的回调
   */
  onCancel: (event?: ClickEvent) => void = () => {}
  /**
   * 点击确认的的回调
   */
  onConfirm: (event?: ClickEvent) => void = () => {}

  colorModeChange(){
    this.whiteColor = IBestDialogColor.white
    this.contentBg = IBestDialogColor.contentBg
    this.bdColor = IBestDialogColor.borderColor
    this.activeBg = IBestDialogColor.activeBg
  }

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

  getTitleColor(){
    return this.titleColor || this.titleDefaultColor
  }

  /**
   * 获取内容区域文字颜色
   * @returns
   */
  getMsgColor() {
    return this.messageFontColor || (this.isHasTitle() ? GRAY_COLOR.GRAY_7 : this.messageColor)
  }

  /**
   * 确认按钮的文字颜色
   * @returns
   */
  getConfirmBtnFontColor() {
    return this.confirmButtonColor || (this.theme == 'round-button' ? this.whiteColor : this.baseStyle.primary)
  }
  /**
   * 确认按钮背景色
   */
  getConfirmBtnBgColor() {
    return this.confirmButtonBgColor || (this.theme == 'round-button' ? this.baseStyle.primary : this.contentBg)
  }

  /**
   * 取消按钮的文字颜色
   * @returns
   */
  getCancelBtnFontColor() {
    return this.cancelButtonColor || this.cancelTextColor
  }
  /**
   * 取消按钮背景色
   */
  getCancelBtnBgColor() {
    return this.cancelButtonBgColor || this.contentBg
  }

  build() {
    Column() {
      // title
      if (this.titleBuilder) {
        this.titleBuilder()
      } else {
        if (this.isHasTitle()) {
          Text(this.title)
            .fontSize(getSizeByUnit(this.titleFontSize, true))
            .fontWeight(FontWeight.Medium)
            .lineHeight(getSizeByUnit(this.titleLineHeight))
            .padding({
              top: getSizeByUnit(this.titlePaddingTop),
              left: getSizeByUnit(this.titlePaddingX),
              right: getSizeByUnit(this.titlePaddingX)
            })
            .textAlign(this.getFormatAlign(this.titleTextAlign))
            .fontColor(this.getTitleColor())
        }
      }
      // content
      if (this.defaultBuilder) {
        this.defaultBuilder()
      } else {
        Scroll() {
          Text(this.message)
            .padding({
              top: getSizeByUnit(this.messagePaddingTop),
              left: getSizeByUnit(this.messagePaddingX),
              right: getSizeByUnit(this.messagePaddingX),
              bottom: getSizeByUnit(this.messagePaddingBottom)
            })
            .margin({top: this.isHasTitle() ? 0 : getSizeByUnit(this.messagePaddingBottom)})
            .textAlign(this.getFormatAlign(this.messageTextAlign))
            .lineHeight(getSizeByUnit(this.messageLineHeight))
            .fontSize(getSizeByUnit(this.messageFontSize, true))
            .fontColor(this.getMsgColor())
        }
        .scrollBarColor(this.baseStyle.scrollBarColor as string)
        .constraintSize({
          maxHeight: getSizeByUnit(this.messageMaxHeight)
        })
        .edgeEffect(EdgeEffect.Spring)
      }
      // footer
      if (this.footerBuilder) {
        this.footerBuilder()
      } else {
        Row({ space: getSizeByUnit(this.buttonSpace) }) {
          // 取消按钮
          if (this.showCancelButton) {
            Button({ type: ButtonType.Normal }) {
              Row() {
                if (this.cancelButtonLoading) {
                  LoadingProgress()
                    .width(getSizeByUnit(this.buttonFontSize))
                    .color(this.getCancelBtnFontColor())
                    .margin({
                      right: this.baseStyle.spaceMini
                    })
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                } else {
                  Text(this.cancelButtonText)
                    .fontColor(this.getCancelBtnFontColor())
                    .fontSize(getSizeByUnit(this.buttonFontSize, true))
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                }
              }
            }
            .border({ width: this.theme == 'default' ? { right: this.showConfirmButton ? 1 : 0 } : 1, color: this.bdColor })
            .enabled(!this.cancelButtonDisabled || !this.cancelButtonLoading)
            .defaultBtnStyles(this.theme)
            .backgroundColor(this.getCancelBtnBgColor())
            .borderRadius(this.theme == "round-button" ? { topLeft: 999, bottomLeft: 999, topRight: this.showConfirmButton && this.buttonSpace == 0 ? 0 : 999, bottomRight: this.showConfirmButton && this.buttonSpace == 0 ? 0 : 999 } : 0)
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
                    .width(getSizeByUnit(this.buttonFontSize))
                    .color(this.getConfirmBtnFontColor())
                    .margin({
                      right: this.baseStyle.spaceMini
                    })
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                } else {
                  Text(this.confirmButtonText)
                    .fontColor(this.getConfirmBtnFontColor())
                    .fontSize(getSizeByUnit(this.buttonFontSize, true))
                    .transition({ type: TransitionType.Insert, opacity: 1 })
                    .transition({ type: TransitionType.Delete, opacity: 0 })
                }
              }
            }
            .enabled(!this.confirmButtonDisabled || !this.confirmButtonLoading)
            .defaultBtnStyles(this.theme)
            .backgroundColor(this.getConfirmBtnBgColor())
            .borderRadius(this.theme == "round-button" ? { topLeft: this.showCancelButton && this.buttonSpace == 0 ? 0 : 999, bottomLeft: this.showCancelButton && this.buttonSpace == 0 ? 0 : 999, topRight: 999, bottomRight: 999 } : 0)
            .onClick(event => {
              this.onConfirm(event)
            })
          }
        }.border({ width: { top: this.theme == 'default' ? 1 : 0 }, color: this.bdColor })
        .padding(this.theme == "round-button" ? { top: this.baseStyle.spaceXs, left: this.baseStyle.spaceLg, right: this.baseStyle.spaceLg, bottom: this.baseStyle.spaceMd } : "")
      }
    }
    .backgroundColor(this.contentBg)
    .width(getSizeByUnit(this.dialogWidth))
    .borderRadius(getSizeByUnit(this.dialogBorderRadius))
    .clip(true)
  }
}