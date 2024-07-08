import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { IBestUIBaseStyleObjType, IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';

@Component
export struct IBestSwitch {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
  /**
   * 自定义按钮的内容
   */
  @BuilderParam private nodeBuilder?: CustomBuilder
  /**
   * 开关按钮的尺寸，默认单位为 lpx
   */
  @Prop private switchSize: number = 52;
  /**
   * 打开时的背景色
   */
  // 这里不能赋值一个颜色 而是使用兜底的方式处理
  // 因为如果给了一个默认色值 会导致主题色切换的逻辑出错
  @Prop private activeColor: string = '';
  /**
   * 关闭时的背景色
   */
  @Prop private inactiveColor: string = 'rgba(120, 120, 128, 0.16)';
  /**
   * 开关默认选中的状态
   */
  @Prop private value: boolean = false;
  /**
   * 是否禁用 禁用状态下开关不可点击
   */
  @Prop private disabled: boolean = false;
  /**
   * 是否为加载状态 加载状态下开关不可点击
   */
  @Prop private loading: boolean = false;
  /**
   * 打开时的loading颜色
   */
  @Prop private loadingActiveColor: string = '';
  /**
   * 关闭时的loading颜色
   */
  @Prop private loadingInactiveColor: string = '';
  /**
   * 改变的回调
   */
  private onChange?: (value: boolean) => void;
  /**
   * 改变前的回调 接受一个promise 如果promise rejcet了那么将不会改变
   */
  private onBeforeChange?: (value: boolean) => Promise<void>;
  /**
   * 点击的回调
   */
  private onClickSwitch?: (event: ClickEvent) => void;

  /**
   * 改变的回调
   */
  private async handleChange(){
    const nextValue = !this.value;
    if(typeof this.onBeforeChange === 'function'){
      await this.onBeforeChange(nextValue)
    }
    if(typeof this.onChange === 'function'){
      this.onChange(nextValue)
    }
    this.value = nextValue;
  }

  /**
   * 获取激活的颜色
   * 优先使用传进来的颜色 如果没有就使用主题色
   * @returns
   */
  private getActiveColor(){
    return this.activeColor || this.baseStyle.primary
  }


  build(){
    Column(){
      // 圆
      Column(){
        if(typeof this.nodeBuilder === 'function'){
          this.nodeBuilder()
        }else{
          if(this.loading){
            LoadingProgress()
              .width(`${this.switchSize / 1.5}lpx`)
              .color( this.value ? this.loadingActiveColor || this.getActiveColor() : this.loadingInactiveColor || this.activeColor )
              .transition({})
          }
        }
      }.width(`${this.switchSize}lpx`)
      .height(`${this.switchSize}lpx`)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderRadius(`${this.switchSize / 2}lpx`)
      .shadow({
        color: 'rgba(0, 0, 0, 0.05)',
        offsetY: px2vp(3),
        radius:  px2vp(1)
      })
      .margin({
        left: '4lpx',
        right: '4lpx'
      })
      .backgroundColor('#fff')
      .translate({
        x: this.value ? `${this.switchSize - 4}lpx` : 0
      })
      .animation({
        duration: this.baseStyle.animationDuration as number,
      })
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .width(`${this.switchSize * 2 + 4}lpx`)
    .height(`${this.switchSize + 4}lpx`)
    .backgroundColor( this.value ? this.getActiveColor() : this.inactiveColor )
    .borderRadius('52lpx')
    .opacity(this.disabled ? 0.5 : 1)
    .animation({
      duration: this.baseStyle.animationDuration as number,
    }).onClick((event)=>{
      typeof this.onClickSwitch === 'function' && this.onClickSwitch(event)
      this.handleChange()
    })
    .enabled(!this.disabled && !this.loading)
  }
}