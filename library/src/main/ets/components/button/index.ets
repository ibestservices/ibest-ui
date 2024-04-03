import { IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { ColorType, COLOR, COLOR_TYPE, GRAY_COLOR } from '../../theme-chalk/src/color.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type';
import { IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';
import { SIZE } from '../../theme-chalk/src/size.type';

@Extend(Button)
function btnSizeStyle(data: {
  height: string,
  padding: string,
  width?: string
}) {
  .padding({ top: 0, right: data.padding, bottom: 0, left: data.padding })
  .height(data.height)
  .width(data.width || 'auto')
}

@Builder function DefaultBuilder(){}

DefaultBuilder._name = 'defalutBuilder'

@Component
export struct IBestButton {
  /**
   * 类型，可选值为 primary success warning danger
   */
  @Prop type: ColorType = COLOR_TYPE.PRIMARY;
  /**
   * defaultSlot 默认插槽
   */
  @BuilderParam defaultBuilder?: CustomBuilder = DefaultBuilder;
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IbestUIBaseStyleType = {}
  /**
   * 大小，可选值为 large normal small mini
   */
  @Prop buttonSize: string = SIZE.NORMAL;
  /**
   * 是否为朴素按钮
   */
  @Prop plain: boolean = false;
  /**
   * 是否为方形按钮
   */
  @Prop square: boolean = false;
  /**
   * 是否为圆形按钮
   */
  @Prop round: boolean = false;

  /**
   * 是否使用 0.5px 边框
   */
  @Prop hairline: boolean = false;

  /**
   * 是否显示为加载状态
   */
  @Prop loading: boolean = false;

  /**
   * loading加载的文案
   */
  @Prop loadingText: string = '加载中...';

  /**
   * 按钮展示的文字
   */
  @Prop text: string = ''

  /**
   * 是否使用自定义插槽替换按钮中的内容
   * 他的builder必须要定义一个默认渲染builder函数 导致没法区分到底有没有传进来
   * 所以又通过一个prop区分
   */
  @Prop useCustomContent: boolean = false;

  /**
   * 是否禁用
   */
  @Prop disabled: boolean = false;

  /**
   * 图标的builder
   */
  @BuilderParam iconBuilder?: CustomBuilder = DefaultBuilder

  /**
   * 按钮颜色
   */
  @Prop color: string = ''

  /**
   * 点击按钮，且按钮状态不为加载或禁用时触发
   */
  onClickBtn?: (event: ClickEvent) => void;



  /**
   * 根据buttonSize换对应的按钮尺寸
   */
  buttonSizeMap = {
    [SIZE.SMALL]: {
      padding: this.baseStyle.spaceXs,
      height: '64lpx',
      fontSize: this.baseStyle.fontSizeSm
    },
    [SIZE.MINI]: {
      padding: this.baseStyle.spaceBase,
      height: '48lpx',
      fontSize: this.baseStyle.fontSizeXs
    },
    [SIZE.LARGE]: {
      padding: this.baseStyle.spaceXs,
      width: CONTAINER_SIZE.FULL,
      height: '100lpx',
      fontSize: this.baseStyle.fontSizeLg
    },
    // 默认尺寸配置
    default: {
      padding: '30lpx',
      height: '88lpx',
      fontSize: this.baseStyle.fontSizeMd
    },
  };

  /**
   * 根据颜色type获取背景色
   * @param {ColorType} type 颜色类型
   * @returns
   */
  getBackgroundColor(type: ColorType) {
    return this.color ? this.color : this.baseStyle[type]
  }

  /**
   * 根据size获取按钮的尺寸
   * @returns
   */
  getBtnSize() {
    return this.buttonSizeMap[this.buttonSize] || this.buttonSizeMap.default;
  }

  /**
   * 获取按钮的borderRadius
   * @returns
   */
  getBtnBorderRadius() {
    return this.square ? 0 : this.baseStyle[`borderRadius${this.round ? 'MAX' : 'Md'}`]
  }

  /**
   * 获取按钮的颜色
   * @param {boolean} isHasColor 是否需要展示颜色
   * @returns
   */
  getBtnColor(isHasColor: boolean) {
    return isHasColor ? this.getBackgroundColor(this.type) : '#fff'
  }

  build() {
    Button({ type: ButtonType.Normal }) {
      if(this.useCustomContent){
        if(typeof this.defaultBuilder === 'function'){
          this.defaultBuilder()
        }
      }else{
        Row(){
          if(this.loading){
            LoadingProgress()
              .width(this.getBtnSize()?.fontSize)
              .height(this.getBtnSize()?.fontSize)
              .color( this.type === COLOR_TYPE.DEFAULT ? GRAY_COLOR.GRAY_8 : this.getBtnColor(this.plain))
              .margin({right: this.text?.length ? this.getBtnSize().padding : 0})
          }else if(typeof this.iconBuilder === 'function'){
            this.iconBuilder()
          }
          Text(this.loading ? this.loadingText ?? this.text : this.text).fontSize(this.getBtnSize()?.fontSize).fontColor( this.type === COLOR_TYPE.DEFAULT ? GRAY_COLOR.GRAY_8 : this.getBtnColor(this.plain))
        }
      }

    }
    .borderWidth( this.hairline ? '1lpx' : '2lpx')
    .borderRadius(this.getBtnBorderRadius())
    .fontColor(this.getBtnColor(this.plain))
    .backgroundColor(this.getBtnColor(!this.plain))
    .borderColor( this.type === COLOR_TYPE.DEFAULT ? GRAY_COLOR.GRAY_4 : this.getBtnColor(this.plain))
    .btnSizeStyle(this.getBtnSize())
    .hitTestBehavior( this.loading ? HitTestMode.None : HitTestMode.Default)
    .enabled(!this.disabled)
    .onClick((event)=>{
      typeof this.onClickBtn === 'function' && this.onClickBtn(event)
    })
  }
}