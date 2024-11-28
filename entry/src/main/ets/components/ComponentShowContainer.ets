import { COLOR_GRAY, CONTAINER_SIZE, FONT_SIZE, SPACE } from '../assets/styles/BaseStyle';

@Component
export default struct ComponentShowContainer {
  @Prop title: string
  @Prop titlePaddingLeft: number
  @Prop card: boolean = false
  @BuilderParam defaultBuilder?: CustomBuilder

  build(){
    Column(){
      Text(this.title)
        .fontSize(FONT_SIZE.MD)
        .padding({
          top: SPACE.MD,
          bottom: SPACE.XS,
          right: SPACE.XS,
          left: this.titlePaddingLeft
        })
        .textAlign(TextAlign.Start)
        .fontColor(COLOR_GRAY.GRAY_6)
      Column(){
        if(typeof this.defaultBuilder === 'function'){
          this.defaultBuilder()
        }
      }
      .margin({ left: this.card ? SPACE.SM : 0, right: this.card ? SPACE.SM : 0  })
    }.width(CONTAINER_SIZE.FULL)
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
  }
}