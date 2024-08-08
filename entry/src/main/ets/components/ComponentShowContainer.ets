import { COLOR_GRAY, FONT_SIZE, SPACE, CONTAINER_SIZE } from '../assets/styles/BaseStyle'

@Component
export default struct ComponentShowContainer {
  @Prop title: string = '';
  @Prop titlePaddingLeft: string = '';
  @Prop card: boolean = false
  @BuilderParam defaultBuilder?: CustomBuilder

  build(){
    Column(){
      Text(this.title)
        .fontSize(FONT_SIZE.BASE)
        .padding({
          top: SPACE.THIRTY,
          bottom: SPACE.SMALL,
          right: SPACE.SMALL,
          left: this.titlePaddingLeft
        })
        .textAlign(TextAlign.Start)
        .fontColor(COLOR_GRAY.BASE)
      Column(){
        if(typeof this.defaultBuilder === 'function'){
          this.defaultBuilder()
        }
      }
      .margin({ left: this.card ? SPACE.BASE : 0, right: this.card ? SPACE.BASE : 0  })
      .borderRadius(this.card ? SPACE.SMALL : 0)
      .clip(true)
    }.width(CONTAINER_SIZE.FULL)
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
  }
}