import { UIContext } from '@ohos.arkui.UIContext';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';

@Component
export struct IBestLoadingSpinner {
  /**
   * 菊花图尺寸
   */
  @Prop private spinnerSize: string = '';
  /**
   * 菊花图线的宽度
   */
  @Prop private strokeWidth: string = '6lpx';
  /**
   * 滚动的角度
   */
  @State private rotateAngle: string = '0';
  /**
   * 当前菊花图的每条线的长度
   */
  @Prop private strokeHeight: string | number = '15lpx';
  /**
   * loading的颜色
   */
  @Prop private color: string | number = GRAY_COLOR.GRAY_6
  /**
   * 循环渲染的数据
   */
  private list: number[] = new Array(12).fill(1);
  /**
   * uiContext实例
   */
  private uiContext: UIContext | undefined = undefined;

  aboutToAppear() {
    this.uiContext = this.getUIContext?.();
    setTimeout(() => {
      this.handleAnimate()
    }, 100)
  }

  handleAnimate() {
    this.uiContext?.keyframeAnimateTo({ iterations: -1 }, [
      {
        duration: 500,
        curve: Curve.Linear,
        event: () => {
          this.rotateAngle = '180deg';
        }
      },
      {
        duration: 500,
        curve: Curve.Linear,
        event: () => {
          this.rotateAngle = '360deg';
        }
      }
    ]);
  }

  build() {
    Column() {
      ForEach(this.list, (item: number, index) => {
        Column() {
          Column()
            .width(this.strokeWidth)
            .height(this.strokeHeight)
            .borderRadius('2.4lpx')
            .backgroundColor(this.color)
        }
        .position({ top: 0, left: 0 })
        .width(this.spinnerSize)
        .height(this.spinnerSize)
        .rotate({
          angle: (index + 1) * 30 + 'deg'
        })
        .opacity(1 - index * 0.083)
        .align(Alignment.Top)
      })
    }.width(this.spinnerSize)
    .height(this.spinnerSize)
    .rotate({
      angle: this.rotateAngle
    })
  }
}