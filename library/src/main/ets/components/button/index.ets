import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { ColorType, COLOR_TYPE, GRAY_COLOR } from '../../theme-chalk/src/color.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { SIZE, SizeType } from '../../theme-chalk/src/size.type';
import { ButtonSizeData } from './index.type'
import { IBestLoading } from '../loading/index'

@Extend(Button)
function btnSizeStyle(data: ButtonSizeData) {
  .padding({
    top: 0,
    right: data.padding,
    bottom: 0,
    left: data.padding
  })
  .height(data.height)
  .width(data.width || 'auto')
}


@Component
export struct IBestButton {
  /**
   * defaultSlot 默认插槽
   */
  @BuilderParam private defaultBuilder?: CustomBuilder;
  /**
   * 图标的builder
   */
  @BuilderParam private iconBuilder?: CustomBuilder;
  /**
   * 加载图标的builder
   */
  @BuilderParam private loadingIconBuilder?: CustomBuilder;
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 类型，可选值为 primary success warning danger 默认值为default
   */
  @Prop private type: ColorType = COLOR_TYPE.DEFAULT;
  /**
   * 大小，可选值为 large normal small mini
   * size是保留字所以没使用size
   */
  @Prop private buttonSize: SizeType = SIZE.NORMAL;
  /**
   * 是否为朴素按钮
   */
  @Prop private plain: boolean = false;
  /**
   * 是否为方形按钮
   */
  @Prop private square: boolean = false;
  /**
   * 是否为圆形按钮
   */
  @Prop private round: boolean = false;
  /**
   * 是否使用 0.5px 边框
   */
  @Prop private hairline: boolean = false;
  /**
   * 是否显示为加载状态
   */
  @Prop private loading: boolean = false;
  /**
   * loading加载的文案
   */
  @Prop private loadingText: string | null = null;
  /**
   * 按钮展示的文字
   */
  @Prop private text: string = '';
  /**
   * 是否禁用
   */
  @Prop private disabled: boolean = false;
  /**
   * 按钮颜色
   */
  @Prop @Watch('handleColorChange') private color: string = '';
  /**
   * 加载图标的大小，默认单位为 lpx 如果为-1就是默认值 默认值跟随字体大小
   */
  @Prop private loadingSize: number = -1;
  @Prop private btnWidth?: number | string = undefined;
  @Prop private btnHeight?: number | string = undefined;
  @Prop private btnFontSize?: number | string = undefined;
  /**
   * 点击按钮，且按钮状态不为加载或禁用时触发
   */
  private onClickBtn?: (event?: ClickEvent) => void;

  /**
   * 根据颜色type获取背景色
   * @returns
   */
  private getBackgroundColor(type = this.type) {
    return this.color ? this.color : this.baseStyle[type] as string
  }

  /**
   * 根据buttonSize换对应的按钮尺寸
   * 根据size获取按钮的尺寸
   * 字典形式写起来校验问题很多 改成switch了
   * @returns
   */
  private getBtnSize() {
    if (this.btnWidth || this.btnHeight) {
      return new ButtonSizeData(this.btnWidth ? 0 : '30lpx', this.btnHeight || '88lpx',
        this.btnFontSize || this.baseStyle.fontSizeMd, this.btnWidth)
    }
    const buttonSize = this.buttonSize;
    switch (buttonSize) {
      case SIZE.SMALL:
        return new ButtonSizeData(this.baseStyle.spaceXs, '64lpx', this.baseStyle.fontSizeSm);
      case SIZE.MINI:
        return new ButtonSizeData(this.baseStyle.spaceBase, '64lpx', this.baseStyle.fontSizeXs);
      case SIZE.LARGE:
        return new ButtonSizeData(this.baseStyle.spaceXs, '100lpx', this.baseStyle.fontSizeLg, CONTAINER_SIZE.FULL);
      default:
        return new ButtonSizeData('30lpx', '88lpx', this.baseStyle.fontSizeMd);
    }
  }

  /**
   * 获取按钮的borderRadius
   * @returns
   */
  private getBtnBorderRadius() {
    return this.square ? 0 : this.baseStyle[`borderRadius${this.round ? 'Max' : 'Md'}`]
  }

  /**
   * 获取按钮的颜色
   * @param {boolean} isHasColor 是否需要展示颜色
   * @returns
   */
  private getBtnColor(isHasColor: boolean) {
    return isHasColor ? this.getBackgroundColor() : '#fff'
  }

  /**
   * 获取按钮文字的颜色
   * @returns
   */
  private getBtnTextColor() {
    return this.type === COLOR_TYPE.DEFAULT ? GRAY_COLOR.GRAY_8 : this.getBtnColor(this.plain)
  }

  /**
   * 获取loading的大小
   * @returns
   */
  private getLoadingSize() {
    return this.loadingSize != -1 ? `${this.loadingSize}lpx` : this.getBtnSize()?.fontSize as string
  }

  /**
   * 当传入自定义颜色时 设置type保证颜色渲染正常
   */
  private handleColorChange() {
    if (this.color) {
      this.type = 'primary'
    }
  }

  aboutToAppear() {
    this.handleColorChange()
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
              IBestLoading({
                loadingSize: this.getLoadingSize(),
                loadingColor: this.getBtnTextColor()
              }).margin({ right: this.text?.length ? this.getBtnSize().padding : 0 })

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
    .opacity(this.disabled && this.plain ? 0.5 : 1)
    .onClick((event) => {
      typeof this.onClickBtn === 'function' && this.onClickBtn(event)
    })
    .animation({ duration: this.baseStyle.animationDuration as number })
  }
}