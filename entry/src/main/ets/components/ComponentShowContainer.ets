import { BORDER_RADIUS, CONTAINER_SIZE, FONT_SIZE, SPACE } from '../assets/styles/BaseStyle';

@Component
export default struct ComponentShowContainer {
    @Prop title: string
    @Prop titlePaddingLeft: number
    @Prop card: boolean = false
    @BuilderParam defaultBuilder?: CustomBuilder

    build() {
        Column() {
            Text(this.title)
                .fontSize(FONT_SIZE.MD)
                .padding({
                    top: SPACE.MD,
                    right: SPACE.XS,
                    bottom: this.card ? SPACE.XS : 0,
                    left: this.titlePaddingLeft
                })
                .textAlign(TextAlign.Start)
                .fontColor($r("app.color.doc_text_color_4"))
            Column() {
                if (this.defaultBuilder) {
                    this.defaultBuilder()
                }
            }
            .alignItems(HorizontalAlign.Start)
            .margin({ left: this.card ? SPACE.SM : 0, right: this.card ? SPACE.SM : 0 })
            .borderRadius(BORDER_RADIUS.MEDIUM)
            .padding(this.card ? undefined : { top: SPACE.XS, bottom: SPACE.XS })
            .clip(true)
        }
        .width(CONTAINER_SIZE.FULL)
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
    }
}