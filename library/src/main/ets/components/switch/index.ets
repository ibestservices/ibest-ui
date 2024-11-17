import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { IBestLoading } from '../loading'

@Component
export struct IBestSwitch {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
  /**
   * 自定义按钮的内容
   */
  @BuilderParam nodeBuilder: CustomBuilder
  /**
   * 开关按钮的尺寸，默认单位为 lpx
   */
  @Prop switchSize: number = 52;
  /**
   * 打开时的背景色
   */
  // 这里不能赋值一个颜色 而是使用兜底的方式处理
  // 因为如果给了一个默认色值 会导致主题色切换的逻辑出错
  @Prop activeColor: ResourceColor = '';
  /**
   * 关闭时的背景色
   */
  @Prop inactiveColor: ResourceColor = 'rgba(120, 120, 128, 0.16)';
  /**
   * 开关默认选中的状态
   */
  @Prop value: boolean = false;
  /**
   * 是否禁用 禁用状态下开关不可点击
   */
  @Prop disabled: boolean = false;
  /**
   * 是否为加载状态 加载状态下开关不可点击
   */
  @Prop loading: boolean = false;
  /**
   * 打开时的loading颜色
   */
  @Prop loadingActiveColor: ResourceColor = '';
  /**
   * 关闭时的loading颜色
   */
  @Prop loadingInactiveColor: ResourceColor = '';
  /**
   * 改变的回调
   */
  onChange?: (value: boolean) => void;
  /**
   * 改变前的回调 接受一个promise 如果promise rejcet了那么将不会改变
   */
  onBeforeChange?: (value: boolean) => Promise<void>;
  /**
   * 点击的回调
   */
  onClickSwitch?: (event: ClickEvent) => void;

  /**
   * 改变的回调
   */
  async handleChange(){
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
  getActiveColor(){
    return this.activeColor || this.baseStyle.primary as string
  }


  build(){
    Column(){
      // 圆
      Column(){
        if(typeof this.nodeBuilder === 'function'){
          this.nodeBuilder()
        }else{
          if(this.loading){
            IBestLoading({
              loadingSize: `${this.switchSize / 1.5}lpx`,
              loadingColor: this.value ? this.loadingActiveColor || this.getActiveColor() : this.loadingInactiveColor || this.activeColor
            }).transition({})
            // LoadingProgress()
            //   .width(`${this.switchSize / 1.5}lpx`)
            //   .color( this.value ? this.loadingActiveColor || this.getActiveColor() : this.loadingInactiveColor || this.activeColor )
            //   .transition({})
          }
        }
      }.width(`${this.switchSize-2}lpx`)
      .height(`${this.switchSize-2}lpx`)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderRadius(`${this.switchSize / 2}lpx`)
      .backgroundColor('#fff')
      .translate({
        x: this.value ? `${this.switchSize+2}lpx` : 2
      }).animation({
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