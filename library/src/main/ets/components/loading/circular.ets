import { UIContext } from '@ohos.arkui.UIContext';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';

@Component
export struct IBestLoadingCircular {
  /**
   * loading的尺寸
   */
  @Prop private circularSize: string = '60lpx'
  /**
   * loading的颜色
   */
  @Prop private color: ResourceColor = GRAY_COLOR.GRAY_6;
  /**
   * 圆的边框粗细
   */
  @Prop private strokeWidth: string | number = '6lpx';
  /**
   * J间距
   */
  @State private strokeDashArray: (string|number)[] = [this.circularSize, 400]
  /**
   * 偏移
   */
  @State private strokeDashOffset: string | number = `-${this.circularSize}`
  /**
   * 旋转角度
   */
  @State rotateAngle: string = '0';
  uiContext: UIContext | undefined = undefined;
  aboutToAppear() {
    this.uiContext = this.getUIContext?.();
    // 不加延迟不执行
    setTimeout(()=>{
      this.handleAnimate()
    }, 0)
  }

  handleAnimate(){
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
      Circle()
        .width(this.circularSize)
        .height(this.circularSize)
        .fillOpacity(0)
        .strokeWidth(this.strokeWidth)
        .stroke(this.color)
        .strokeDashOffset(this.strokeDashOffset)
        .strokeDashArray(this.strokeDashArray)
        .rotate({
          angle: this.rotateAngle
        })
  }
}