import { IBestDialogView } from './dialog'
import { IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';

const propKeys = [
  'dialogWidth',
  'dialogBorderRadius',
  'title',
  'titleColor',
  'titlePaddingTop',
  'titlePaddingX',
  'titleLineHeight',
  'titleFontSize',
  'titleTextAlign',
  'message',
  'messagePaddingX',
  'messagePaddingTop',
  'messagePaddingBottom',
  'messageFontColor',
  'messageFontSize',
  'messageLineHeight',
  'messageTextAlign',
  'messageMaxHeight',
  'showConfirmButton',
  'showCancelButton',
  'confirmButtonText',
  'cancelButtonText',
  'confirmButtonColor',
  'cancelButtonColor',
  'confirmButtonDisabled',
  'cancelButtonDisabled',
  'buttonFontSize'
]

// 这个坑爹的组件 prop在往这个组件 IBestDialogView 中传递的时候 不会触发组件的页面渲染
// 试了直接更新IBestDialogView组件的prop 也不更新
// 通过注入可以更新 遂 写这么麻烦
@CustomDialog
export struct IBestDialog {
  /**
   * 标题区域的builder
   */
  @BuilderParam titleBuilder: CustomBuilder | null  = null;
  /**
   * 内容区域的builder
   */
  @BuilderParam defaultBuilder: CustomBuilder | null  = null;
  /**
   * 底部区域的builder
   */
  @BuilderParam footerBuilder: CustomBuilder | null  = null;
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IbestUIBaseStyleType = {}
  /**
   * 弹窗宽度
   */
  @Prop @Watch('handlePropChange') private dialogWidth: string = '640lpx';
  @Provide private provide_dialogWidth: string = '640lpx';

  /**
   * 弹窗border-radius 默认 32lpx
   */
  @Prop @Watch('handlePropChange') private dialogBorderRadius: string = this.baseStyle.spaceMd;
  @Provide private provide_dialogBorderRadius: string = this.baseStyle.spaceMd;
  /**
   * 标题
   */
  @Prop @Watch('handlePropChange') private title: string = '';
  @Provide private provide_title: string = '';
  /**
   * 标题颜色
   */
  @Prop @Watch('handlePropChange') private titleColor: string = GRAY_COLOR.GRAY_8;
  @Provide private provide_titleColor: string = GRAY_COLOR.GRAY_8;
  /**
   * 标题的padding-top值
   */
  @Prop @Watch('handlePropChange') private titlePaddingTop: string = '52lpx';
  @Provide private provide_titlePaddingTop: string = '52lpx';
  /**
   * 标题的padding-left与padding-right值 默认48lpx
   */
  @Prop @Watch('handlePropChange') private titlePaddingX: string = '48lpx';
  @Provide private provide_titlePaddingX: string = '48lpx';
  /**
   * 标题的padding-top值
   */
  @Prop @Watch('handlePropChange') private titleLineHeight: string = '48lpx';
  @Provide private provide_titleLineHeight: string = '48lpx';
  /**
   * 标题的fontSize
   */
  @Prop @Watch('handlePropChange') private titleFontSize: string = this.baseStyle.fontSizeLg;
  @Provide private provide_titleFontSize: string = this.baseStyle.fontSizeLg;
  /**
   * 标题的对齐方式
   */
  @Prop @Watch('handlePropChange') private titleTextAlign: 'left' | 'center' | 'right' = 'center';
  @Provide private provide_titleTextAlign: 'left' | 'center' | 'right' = 'center';
  /**
   * 文本内容，支持通过 \n 换行
   */
  @Prop @Watch('handlePropChange') private message: string = '';
  @Provide private provide_message: string = '';
  /**
   * 内容区域的padding-left与padding-right值 默认48lpx
   */
  @Prop @Watch('handlePropChange') private messagePaddingX: string = '48lpx';
  @Provide private provide_messagePaddingX: string = '48lpx';
  /**
   * 内容区域的padding-top值 默认16lpx
   */
  @Prop @Watch('handlePropChange') private messagePaddingTop: string = '16lpx';
  @Provide private provide_messagePaddingTop: string = '16lpx';
  /**
   * 内容区域的padding-top值 默认52lpx
   */
  @Prop @Watch('handlePropChange') private messagePaddingBottom: string = '52lpx';
  @Provide private provide_messagePaddingBottom: string = '52lpx';
  /**
   * 内容区域的fontColor 默认#323233
   */
  @Prop @Watch('handlePropChange') private messageFontColor: string = '';
  @Provide private provide_messageFontColor: string = '';
  /**
   * 内容区域的fontSize
   */
  @Prop @Watch('handlePropChange') private messageFontSize: string = this.baseStyle.fontSizeMd;
  @Provide private provide_messageFontSize: string = this.baseStyle.fontSizeMd;
  /**
   * 内容区域的行高 lineHeight 默认 40lpx
   */
  @Prop @Watch('handlePropChange') private messageLineHeight: string = this.baseStyle.lineHeightMd;
  @Provide private provide_messageLineHeight: string = this.baseStyle.lineHeightMd;
  /**
   * 内容区域的文字对齐方式
   */
  @Prop @Watch('handlePropChange') private messageTextAlign: 'left' | 'center' | 'right' = 'center';
  @Provide private provide_messageTextAlign: 'left' | 'center' | 'right' = 'center';
  /**
   * 内容区域的滚动区域最大高度
   */
  @Prop @Watch('handlePropChange') private messageMaxHeight: string = '60%';
  @Provide private provide_messageMaxHeight: string = '60%';
  // /**
  //  * 样式风格
  //  * 本期暂不开发
  //  */
  // @Prop private theme: 'default' | 'round-button' = 'default';
  /**
   * 是否展示确认按钮
   */
  @Prop @Watch('handlePropChange') private showConfirmButton: boolean = true;
  @Provide private provide_showConfirmButton: boolean = true;
  /**
   * 是否展示取消按钮
   */
  @Prop @Watch('handlePropChange') private showCancelButton: boolean = true;
  @Provide private provide_showCancelButton: boolean = true;
  /**
   * 确认按钮文案
   */
  @Prop @Watch('handlePropChange') private confirmButtonText: string = '确认';
  @Provide private provide_confirmButtonText: string = '确认';
  /**
   * 取消按钮的文案
   */
  @Prop @Watch('handlePropChange') private cancelButtonText: string = '取消';
  @Provide private provide_cancelButtonText: string = '取消';
  /**
   * 确认按钮的颜色
   */
  @Prop @Watch('handlePropChange') private confirmButtonColor: string = '';
  @Provide private provide_confirmButtonColor: string = '';
  /**
   * 取消按钮的颜色
   */
  @Prop @Watch('handlePropChange') private cancelButtonColor: string = '';
  @Provide private provide_cancelButtonColor: string = '';
  /**
   * 是否禁用确认按钮
   */
  @Prop @Watch('handlePropChange') private confirmButtonDisabled: boolean = false;
  @Provide private provide_confirmButtonDisabled: boolean = false;
  /**
   * 是否禁用取消按钮
   */
  @Prop @Watch('handlePropChange') private cancelButtonDisabled: boolean = false;
  @Provide private provide_cancelButtonDisabled: boolean = false;
  /**
   * 按钮的文字大小
   */
  @Prop @Watch('handlePropChange') private buttonFontSize: string = this.baseStyle.fontSizeLg;
  @Provide private provide_buttonFontSize: string = this.baseStyle.fontSizeLg;

  /**
   * ready事件
   */
  private onReady: (dialogController: CustomDialogController) => void;

  initProps(){
    // 这种能拿到key 但是是__key 这样的 怕后续变动 还是手动拿吧
    // const keys = Object.keys(this);
    propKeys.forEach(key => {
      this[`provide_${key}`] = this[key]
    })
  }

  handlePropChange(key){
    this[`provide_${key}`] = this[key]
  }


  dialogController: CustomDialogController = new CustomDialogController({
    // 向下透传
    builder: IBestDialogView({
      titleBuilder: this.titleBuilder,
      defaultBuilder: this.defaultBuilder,
      footerBuilder: this.footerBuilder,
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  aboutToAppear(){
    this.initProps()
    typeof this.onReady === 'function' && this.onReady(this.dialogController)
  }

  aboutToDisappear(){
    this.dialogController = null;
  }
  build(){
  }
}