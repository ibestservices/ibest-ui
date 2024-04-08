import router from '@ohos.router';
import {  IBestCheckbox } from '../../../../../library/Index'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'

@Styles
function btnMargin() {
  .margin({ right: SPACE.BASE, bottom: SPACE.BASE })
}

@Builder function Arrow(){
  Image($r('app.media.startIcon'))
    .width(CONTAINER_SIZE.FORTY_FOUR)

}

@Entry
@Component
struct ButtonPage {
  @State message: string = 'Hello World';
  @State title: string = router.getParams()['title'] || '';
  @State select: boolean = false;

  @Builder
  TextBuilder() {
    Text('default slot  ' + this.message)
  }

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')


      List() {
        ListItem() {

          ComponentShowContainer({ title: '基础用法' }) {
            Text(String(this.select))
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              Column() {
                IBestCheckbox({
                  value: this.select,
                  label: '复选框1'
                })
              }.btnMargin()

              Column() {
                IBestCheckbox({
                  value: this.select,
                  shape: 'square',
                  label: '复选框2',
                  disabled: true
                })
              }.btnMargin()

            }
          }
        }

      }
      .layoutWeight(1)
      .padding({
        left: SPACE.BASE,
        right: SPACE.BASE
      })

    }
    .width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(BACKGROUND_COLOR.BASE)
  }
}