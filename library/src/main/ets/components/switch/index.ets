import { IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';

@Component
export struct IBestSwitch {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IbestUIBaseStyleType = {}
  /**
   * 开关按钮的尺寸，默认单位为 lpx
   */
  @Prop switchSize: number = 52;
  /**
   * 打开时的背景色
   */
  @Prop activeColor: string = this.baseStyle.primary;
  /**
   * 关闭时的背景色
   */
  @Prop inactiveColor: string = 'rgba(120, 120, 128, 0.16)';
  /**
   * 开关默认选中的状态
   */
  @Prop value: boolean = false;
  /**
   * 是否禁用
   */
  @Prop disabled: boolean = false;
  /**
   * 是否为加载状态
   */
  @Prop loading: boolean = false;

  build(){
    Column(){
      // 圆
      Column(){
        if(this.loading){
          LoadingProgress().width(`${this.switchSize / 1.5}lpx`).color(this.baseStyle.primary).transition({})
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
        duration: this.baseStyle.animationDuration,
      })
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .width(`${this.switchSize * 2 + 4}lpx`)
    .height(`${this.switchSize + 4}lpx`)
    .backgroundColor( this.value ? this.activeColor : this.inactiveColor )
    .borderRadius('52lpx')
    .opacity(this.disabled ? 0.5 : 1)
    .animation({
      duration: this.baseStyle.animationDuration,
    }).onClick(()=>{
      this.value = !this.value
    })
    .enabled(!this.disabled)
  }
}