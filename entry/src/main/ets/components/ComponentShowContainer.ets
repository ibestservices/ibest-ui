import { COLOR_GRAY, FONT_SIZE, SPACE, CONTAINER_SIZE } from '../assets/styles/BaseStyle'

@Component
export default struct ComponentShowContainer {
  @Prop title: string = '';
  @Prop titlePaddingLeft: string = '';
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

        if(typeof this.defaultBuilder === 'function'){
          this.defaultBuilder()
        }
    }.width(CONTAINER_SIZE.FULL)
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
  }
}