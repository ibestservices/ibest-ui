import { GRAY_COLOR } from '../../theme-chalk/src/color.type';

@Component
export struct IBestStepperBtn {
  @BuilderParam defaultSlot: CustomBuilder;
  @Prop private buttonSize: string = '40lpx';
  @Prop private radiusLeftTop: string = '0';
  @Prop private radiusLeftBottom: string = '0';
  @Prop private radiusRightTop: string = '0';
  @Prop private radiusRightBottom: string = '0';
  @Prop private disabled: boolean = false;
  private onClickBtn?: () => void;
  private onLongPress?: () => void;

  build() {
    Button() {
      if (typeof this.defaultSlot === 'function') {
        this.defaultSlot()
      }
    }
    .type(
      ButtonType.Normal
    )
    .backgroundColor(GRAY_COLOR.GRAY_2)
    .width(this.buttonSize)
    .height(this.buttonSize)
    .borderRadius({
      topLeft: this.radiusLeftTop,
      topRight: this.radiusRightTop,
      bottomLeft: this.radiusLeftBottom,
      bottomRight: this.radiusRightBottom
    })
    .opacity(this.disabled ? 0.4 : 1)
    .enabled(!this.disabled)
    .onClick(() => {
      typeof this.onClickBtn === 'function' && this.onClickBtn()
    })
    .gesture(
      // duration时间过段会影响click事件生效
      LongPressGesture({ repeat: true, duration: 200 })
        // 由于repeat设置为true，长按动作存在时会连续触发，触发间隔为duration（默认值500ms）
        .onAction((event: GestureEvent) => {
          if (event && event.repeat && typeof this.onLongPress === 'function') {
            this.onLongPress()
          }
        })

    )
  }
}