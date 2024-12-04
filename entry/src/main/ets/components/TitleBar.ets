import router from '@ohos.router'
import { COLOR_BLUE, CONTAINER_SIZE, FONT_SIZE, FONT_WEIGHT, LINE_HEIGHT, SPACE } from '../assets/styles/BaseStyle'

@Styles
function btnPressedStyles() {
  .scale({
    x: .95,
    y: .95,
    z: 1,
    centerX: '50%',
    centerY: '50%'
  })
}

@Styles
function btnNormalStyles() {
  .scale({
    x: 1,
    y: 1,
    z: 1,
    centerX: '50%',
    centerY: '50%'
  })
}

@Extend(Button)
function btnStyles(isLeft = true) {
  .padding({
    right: isLeft ? SPACE.BASE : SPACE.MD,
    top: SPACE.SM,
    bottom: SPACE.SM,
    left: isLeft ? SPACE.MD : SPACE.BASE
  })
  .backgroundColor('transparent')
  .stateStyles({
    pressed: btnPressedStyles,
    normal: btnNormalStyles
  })
}

@Component
export default struct TitleBar {
  /**
   * 中间内容的builder
   */
  @BuilderParam contentBuilder?: CustomBuilder;
  /**
   * 右侧按钮的builder
   */
  @BuilderParam rightIconBuilder?: CustomBuilder;
  /**
   * 标题 如果传入contentBuilder 那么该传参不生效
   */
  @Prop title: string | Resource = '';
  /**
   * 点击右侧按钮
   */
  onClickRightBtn: () => void = () => {}

  build() {
    Row() {
      // 返回按钮
      Button({
        type: ButtonType.Normal,
        stateEffect: false
      }) {
        Image($r('app.media.title_back')).width(CONTAINER_SIZE.TWENTY_TWO)
      }
      .onClick(() => {
        router.back()
      })
      .btnStyles()

      // 内容区域
      Row() {
        if (this.contentBuilder) {
          this.contentBuilder()
        } else {
          Text(this.title)
            .layoutWeight(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .lineHeight(LINE_HEIGHT.LG)
            .fontSize(FONT_SIZE.LG)
            .fontWeight(FONT_WEIGHT.MEDIUM)
            .fontColor(COLOR_BLUE.MEDIUM)
        }
      }.layoutWeight(1)

      // 右侧按钮区域
      if (this.rightIconBuilder) {
        Button({ type: ButtonType.Normal, stateEffect: false }) {
          this.rightIconBuilder()
        }.btnStyles(false)
        .onClick(() => {
          typeof this.onClickRightBtn === 'function' && this.onClickRightBtn()
        })
      }
    }.backgroundColor(COLOR_BLUE.DEFAULT)
  }
}