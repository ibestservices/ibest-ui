import { UIContext } from '@ohos.arkui.UIContext';
import { GRAY_COLOR } from '../../theme-chalk/src/color';

class Point {
  x: number
  y: number

  constructor(x: number, y: number) {
    this.x = x
    this.y = y
  }
  plus(rhs: Point): Point {
    return new Point(this.x + rhs.x, this.y + rhs.y)
  }
  subtract(rhs: Point): Point {
    return new Point(this.x - rhs.x, this.y - rhs.y)
  }
  multiply(scale: number): Point {
    return new Point(this.x * scale, this.y * scale)
  }
  equals(rhs: Point): boolean {
    return this.x === rhs.x && this.y === rhs.y
  }
}

@AnimatableExtend(Circle) function animatableDashArray(point: Point) {
  .strokeDashArray([point.x, point.y])
}
@AnimatableExtend(Circle) function animatableDashOffset(strokeDashOffset: number) {
  .strokeDashOffset(strokeDashOffset)
}

@Component
export struct IBestLoadingCircular {
  /**
   * loading的尺寸
   */
  @Prop circularSize: string = '60lpx'
  /**
   * loading的颜色
   */
  @Prop color: ResourceColor = GRAY_COLOR.GRAY_5;
  /**
   * 圆的边框粗细
   */
  @Prop strokeWidth: Length = '6lpx';
  /**
   * 旋转角度
   */
  @State rotateAngle: number = 0
  @State maxPerimeter: number = 0
  @State strokeDashArray: Point = new Point(0,0)
  @State strokeDashOffset: number = 0
  private uiContext: UIContext = this.getUIContext()

  aboutToAppear() {
    this.maxPerimeter = Math.floor(Math.PI * parseFloat(this.circularSize)) + 20
    this.strokeDashArray = new Point(0,this.maxPerimeter)
  }

  keyframeAnimateTo(){
    this.uiContext?.keyframeAnimateTo({iterations: -1},[
      {
        // 第一段关键帧动画时长为100ms
        duration: 100,
        curve: Curve.EaseInOut,
        event: () => {
          this.strokeDashOffset = 0
          this.strokeDashArray = new Point(0,this.maxPerimeter)
        }
      },
      {
        // 第一段关键帧动画时长为700ms
        duration: 700,
        curve: Curve.EaseInOut,
        event: () => {
          this.strokeDashOffset = -this.maxPerimeter*0.3
          this.strokeDashArray = new Point(this.maxPerimeter*0.6,this.maxPerimeter)
        }
      },
      {
        // 第二段关键帧动画时长为700ms
        duration: 700,
        curve: Curve.EaseInOut,
        event: () => {
          this.strokeDashOffset = -this.maxPerimeter*0.5
          this.strokeDashArray = new Point(this.maxPerimeter*0.6,this.maxPerimeter)
        }
      }
    ])
  }

  build() {
    Circle({width: this.circularSize, height: this.circularSize})
      .fill("transparent")
      .strokeWidth(2)
      .stroke(this.color)
      .strokeLineCap(LineCapStyle.Round)
      .animatableDashArray(this.strokeDashArray)
      .animatableDashOffset(this.strokeDashOffset)
      .rotate({ angle: this.rotateAngle })
      .animation({
        duration: 2000,
        iterations: -1,
        curve: Curve.Linear,
        playMode: PlayMode.Normal
      })
      .onAppear(() => {
        this.rotateAngle = 360
        this.keyframeAnimateTo()
      })
  }
}