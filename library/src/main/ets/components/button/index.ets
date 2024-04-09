import { IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { ColorType, COLOR, COLOR_TYPE, GRAY_COLOR } from '../../theme-chalk/src/color.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type';
import { IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';
import { SIZE, SizeType } from '../../theme-chalk/src/size.type';

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

@Component
export struct IBestButton {
  /**
   * defaultSlot 默认插槽
   */
  @BuilderParam defaultBuilder?: CustomBuilder = null;
  /**
   * 图标的builder
   */
  @BuilderParam iconBuilder?: CustomBuilder = null;
  /**
   * 加载图标的builder
   */
  @BuilderParam loadingIconBuilder?: CustomBuilder = null;
  /**
   * 类型，可选值为 primary success warning danger
   */
  @Prop type: ColorType = COLOR_TYPE.PRIMARY;
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IbestUIBaseStyleType = {}
  /**
   * 大小，可选值为 large normal small mini
   * size是保留字所以没使用size
   */
  @Prop buttonSize: SizeType = SIZE.NORMAL;
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
  @Prop loadingText: string = null;
  /**
   * 按钮展示的文字
   */
  @Prop text: string = '';
  /**
   * 是否禁用
   */
  @Prop disabled: boolean = false;
  /**
   * 按钮颜色
   */
  @Prop color: string = '';
  /**
   * 加载图标的大小，默认单位为 lpx 如果为-1就是默认值 默认值跟随字体大小
   */
  @Prop loadingSize: number = -1;
  /**
   * 点击按钮，且按钮状态不为加载或禁用时触发
   */
  onClickBtn?: (event?: ClickEvent) => void;
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

  /**
   * 获取按钮文字的颜色
   * @returns
   */
  getBtnTextColor() {
    return this.type === COLOR_TYPE.DEFAULT ? GRAY_COLOR.GRAY_8 : this.getBtnColor(this.plain)
  }

  /**
   * 获取loading的大小
   * @returns
   */
  getLoadingSize() {
    return this.loadingSize != -1 ? `${this.loadingSize}lpx` : this.getBtnSize()?.fontSize
  }

  build() {
    Button({ type: ButtonType.Normal }) {
      if (typeof this.defaultBuilder === 'function') {
        this.defaultBuilder()
      } else {
        Row() {
          if (this.loading) {
            // 如果有自定义loading
            if (typeof this.loadingIconBuilder === 'function') {
              this.loadingIconBuilder()
            } else {
              // 默认的loading
              LoadingProgress()
                .width(this.getLoadingSize())
                .height(this.getLoadingSize())
                .color(this.getBtnTextColor())
                .margin({ right: this.text?.length ? this.getBtnSize().padding : 0 })
            }
            // 加载loading显示的时候不显示图标
          } else if (typeof this.iconBuilder === 'function') {
            this.iconBuilder()
          }
          Text(this.loading ? this.loadingText ?? this.text : this.text)
            .fontSize(this.getBtnSize()?.fontSize)
            .fontColor(this.getBtnTextColor())
        }
      }

    }
    .btnSizeStyle(this.getBtnSize())
    .borderWidth(this.hairline ? '1lpx' : '2lpx')
    .borderRadius(this.getBtnBorderRadius())
    .fontColor(this.getBtnColor(this.plain))
    .backgroundColor(this.getBtnColor(!this.plain))
    .borderColor(this.type === COLOR_TYPE.DEFAULT ? GRAY_COLOR.GRAY_4 : this.getBtnColor(this.plain))
    .hitTestBehavior(this.loading ? HitTestMode.None : HitTestMode.Default)
    .enabled(!this.disabled)
    .onClick((event) => {
      typeof this.onClickBtn === 'function' && this.onClickBtn(event)
    })
  }
}