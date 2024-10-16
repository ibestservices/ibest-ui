import { IBestDialogView } from './dialog'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { sleep } from '../../assets/ets/utils';

@CustomDialog
export struct IBestDialog {
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
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 弹窗宽度
   */
  @Prop dialogWidth: string = '640lpx';
  /**
   * 弹窗border-radius 默认 32lpx
   */
  @Prop dialogBorderRadius: string = this.baseStyle.spaceMd as string;
  /**
   * 标题
   */
  @Prop title: string = '';
  /**
   * 标题颜色
   */
  @Prop titleColor: ResourceColor = GRAY_COLOR.GRAY_8;
  /**
   * 标题的padding-top值
   */
  @Prop titlePaddingTop: string = '52lpx';
  /**
   * 标题的padding-left与padding-right值 默认48lpx
   */
  @Prop titlePaddingX: string = '48lpx';
  /**
   * 标题的padding-top值
   */
  @Prop titleLineHeight: string = '48lpx';
  /**
   * 标题的fontSize
   */
  @Prop titleFontSize: string = this.baseStyle.fontSizeLg as string;
  /**
   * 标题的对齐方式
   */
  @Prop titleTextAlign: 'left' | 'center' | 'right' = 'center';
  /**
   * 文本内容，支持通过 \n 换行
   */
  @Prop message: string = '';
  /**
   * 内容区域的padding-left与padding-right值 默认48lpx
   */
  @Prop messagePaddingX: string = '48lpx';
  /**
   * 内容区域的padding-top值 默认16lpx
   */
  @Prop messagePaddingTop: string = '16lpx';
  /**
   * 内容区域的padding-bottom值 默认52lpx
   */
  @Prop messagePaddingBottom: string = '52lpx';
  /**
   * 内容区域的fontColor 默认#323233
   */
  @Prop messageFontColor: string = '';
  /**
   * 内容区域的fontSize
   */
  @Prop messageFontSize: string = this.baseStyle.fontSizeMd as string;
  /**
   * 内容区域的行高 lineHeight 默认 40lpx
   */
  @Prop messageLineHeight: string = this.baseStyle.lineHeightMd as string;
  /**
   * 内容区域的文字对齐方式
   */
  @Prop messageTextAlign: 'left' | 'center' | 'right' = 'center';
  /**
   * 内容区域的滚动区域最大高度
   */
  @Prop messageMaxHeight: string = '60%';
  // /**
  //  * 样式风格
  //  * 本期暂不开发
  //  */
  // @Prop theme: 'default' | 'round-button' = 'default';
  /**
   * 是否展示确认按钮
   */
  @Prop showConfirmButton: boolean = true;
  /**
   * 是否展示取消按钮
   */
  @Prop showCancelButton: boolean = false;
  /**
   * 确认按钮文案
   */
  @Prop confirmButtonText: string = '确认';
  /**
   * 取消按钮的文案
   */
  @Prop cancelButtonText: string = '取消';
  /**
   * 确认按钮的颜色
   */
  @Prop confirmButtonColor: ResourceColor = '';
  /**
   * 取消按钮的颜色
   */
  @Prop cancelButtonColor: ResourceColor = '';
  /**
   * 是否禁用确认按钮
   */
  @Prop confirmButtonDisabled: boolean = false;
  /**
   * 是否禁用取消按钮
   */
  @Prop cancelButtonDisabled: boolean = false;
  /**
   * 按钮的文字大小
   */
  @Prop buttonFontSize: string = this.baseStyle.fontSizeLg as string;
  /**
   * 确认按钮的loading
   */
  @State confirmButtonLoading: boolean = false;
  /**
   * 取消按钮的loading
   */
  @State cancelButtonLoading: boolean = false;
  /**
   * 是否在点击遮罩层后关闭弹窗
   */
  @Prop closeOnClickOverlay: boolean = false;
  /**
   * 弹窗在竖直方向上的对齐方式 默认center
   */
  @Prop alignment: 'center' | 'top' | 'bottom' = 'center';
  /**
   * 弹窗相对alignment所在位置的横向偏移量。
   */
  @Prop offsetX: string | number = 0;
  /**
   * 弹窗相对alignment所在位置的纵向偏移量。
   */
  @Prop offsetY: string | number = 0;
  /**
   * 弹窗是否为模态窗口，模态窗口有蒙层，非模态窗口无蒙层。
   * API11+
   */
  @Prop showOverlay: boolean = true;
  /**
   * 某弹框需要显示在主窗口之外时，是否在子窗口显示此弹窗。
   * 默认值：false，弹窗显示在应用内，而非独立子窗口。
   * API 10 +
   */
  @Prop showInSubWindow: boolean = false;
  /**
   * 自定义蒙层颜色。默认值: 0x33000000 API10以上支持
   */
  @Prop overlayColor: ResourceColor = '0x33000000'
  /**
   * 关闭前的回调函数，返回 false 可阻止关闭，支持返回 Promise
   */
  private beforeClose?: (action?: 'cancel' | 'confirm') => Promise<boolean> | boolean;
  /**
   * ready事件
   */
  private onReady?: (dialogController: CustomDialogController) => void;
  /**
   * 点击取消的回调
   */
  private onCancel?: (event?: ClickEvent) => void;
  /**
   * 点击确认的的回调
   */
  private onConfirm?: (event?: ClickEvent) => void;

  getAlignment(type: string) {
    switch (type) {
      case 'center':
        return DialogAlignment.Center
      case 'top':
        return DialogAlignment.Top
      case 'bottom':
        return DialogAlignment.Bottom
      default:
        return DialogAlignment.Center
    }
  }

  /**
   * 结束前的动画
   * @param from
   * @returns
   */
  async handleBeforeClose(action: 'cancel' | 'confirm') {
    let status = true
    try {
      if (typeof this.beforeClose === 'function') {
        status = await this.beforeClose(action);
      }
    } catch (e) {
      status = false
    }
    return status
  }

  /**
   * 点击取消的回调
   */
  async handleCancel(event?: ClickEvent) {
    if (this.cancelButtonDisabled || this.cancelButtonLoading) {
      return
    }
    if (typeof this.beforeClose === 'function') {
      this.cancelButtonLoading = true
      const status = await this.handleBeforeClose('cancel');
      this.cancelButtonLoading = false
      if (!status) {
        return
      }
    }
    this.cancelButtonDisabled = true
    this.dialogController?.close()
    // 等待动画结束
    await sleep()
    if (typeof this.onCancel === 'function') {
      this.onCancel(event)
    }
    this.cancelButtonDisabled = false
  }

  /**
   * 点击确定的回调
   */
  async handleConfirm(event?: ClickEvent) {
    if (this.confirmButtonDisabled || this.confirmButtonLoading) {
      return
    }
    if (typeof this.beforeClose === 'function') {
      this.confirmButtonLoading = true
      const status = await this.handleBeforeClose('confirm');
      this.confirmButtonLoading = false
      if (!status) {
        return
      }
    }
    this.confirmButtonDisabled = true;
    if (typeof this.onConfirm === 'function') {
       this.onConfirm(event)
    }
    this.dialogController?.close()
    // 等待动画结束
    await sleep()
    this.confirmButtonDisabled = false;
    this.confirmButtonLoading = false;

  }

  // 按照文档类型允许null 组件校验会报错
  dialogController?: CustomDialogController = new CustomDialogController({
    // 向下透传
    builder: IBestDialogView({
      titleBuilder: this.titleBuilder,
      defaultBuilder: this.defaultBuilder,
      footerBuilder: this.footerBuilder,
      dialogBorderRadius: $dialogBorderRadius,
      title: $title,
      titleColor: $titleColor,
      titlePaddingTop: $titlePaddingTop,
      titlePaddingX: $titlePaddingX,
      titleLineHeight: $titleLineHeight,
      titleFontSize: $titleFontSize,
      titleTextAlign: $titleTextAlign,
      message: $message,
      dialogWidth: $dialogWidth,
      messagePaddingX: $messagePaddingX,
      messagePaddingTop: $messagePaddingTop,
      messagePaddingBottom: $messagePaddingBottom,
      messageFontColor: $messageFontColor,
      messageFontSize: $messageFontSize,
      messageLineHeight: $messageLineHeight,
      messageTextAlign: $messageTextAlign,
      messageMaxHeight: $messageMaxHeight,
      showConfirmButton: $showConfirmButton,
      showCancelButton: $showCancelButton,
      confirmButtonText: $confirmButtonText,
      cancelButtonText: $cancelButtonText,
      confirmButtonColor: $confirmButtonColor,
      cancelButtonColor: $cancelButtonColor,
      confirmButtonDisabled: $confirmButtonDisabled,
      cancelButtonDisabled: $cancelButtonDisabled,
      buttonFontSize: $buttonFontSize,
      confirmButtonLoading: $confirmButtonLoading,
      cancelButtonLoading: $cancelButtonLoading,
      onCancel: (event) => {
        typeof this.handleCancel === 'function' && this.handleCancel(event)
      },
      onConfirm: (event) => {
        typeof this.handleConfirm === 'function' && this.handleConfirm(event)
      },
    }),
    // 不转一下就无效了
    autoCancel: !!this.closeOnClickOverlay,
    alignment: this.getAlignment(this.alignment),
    customStyle: true,
    offset: {
      dx: this.offsetX,
      dy: this.offsetY
    },
    cancel: () => {
      this.closeOnClickOverlay && this.handleCancel()
    },
    isModal: this.showOverlay,
    maskColor: this.overlayColor,
    showInSubWindow: this.showInSubWindow
  })

  aboutToAppear() {
    typeof this.onReady === 'function' && this.dialogController && this.onReady(this.dialogController)
  }

  aboutToDisappear() {
    this.dialogController = undefined;
  }

  build() {
  }
}