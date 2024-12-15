import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
import { IBestStepperColor } from './color';

@Component
export struct IBestStepperBtn {
  @BuilderParam defaultSlot?: CustomBuilder;
  @Prop buttonSize: string | number = convertDimensionsWidthUnit(20)
  @Prop radiusLeftTop: string | number = 0
  @Prop radiusLeftBottom: string | number = 0
  @Prop radiusRightTop: string | number = 0
  @Prop radiusRightBottom: string | number = 0
  @Prop disabled: boolean = false;
  onClickBtn: () => void = () => {}
  onLongPress: () => void = () => {}

  build() {
    Button() {
      if (this.defaultSlot) {
        this.defaultSlot()
      }
    }
    .type(
      ButtonType.Normal
    )
    .backgroundColor(this.disabled ? IBestStepperColor.disabledBg : IBestStepperColor.bg)
    .width(getSizeByUnit(this.buttonSize))
    .height(getSizeByUnit(this.buttonSize))
    .borderRadius({
      topLeft: getSizeByUnit(this.radiusLeftTop),
      topRight: getSizeByUnit(this.radiusRightTop),
      bottomLeft: getSizeByUnit(this.radiusLeftBottom),
      bottomRight: getSizeByUnit(this.radiusRightBottom)
    })
    .enabled(!this.disabled)
    .onClick(() => {
      this.onClickBtn()
    })
    .gesture(
      // duration时间过段会影响click事件生效
      LongPressGesture({ repeat: true, duration: 200 })
        // 由于repeat设置为true，长按动作存在时会连续触发，触发间隔为duration（默认值500ms）
        .onAction((event: GestureEvent) => {
          if (event && event.repeat) {
            this.onLongPress()
          }
        })
    )
  }
}