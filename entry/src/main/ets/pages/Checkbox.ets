import router from '@ohos.router';
import {  IBestCheckbox, IBestCheckboxGroup } from '../../../../../library/Index'
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
struct CheckboxPage {
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
          ComponentShowContainer({ title: '基础用法',  }) {
            Text(String(this.select))
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              Column() {
                IBestCheckbox({
                  value: this.select,
                  label: '复选框1',
                  name: 'checkbox3'
                })
              }.btnMargin()

              Column() {
                IBestCheckbox({
                  value: this.select,
                  shape: 'square',
                  label: '复选框2',
                  disabled: true,
                  name: 'checkbox4'
                })
              }.btnMargin()
            }
          }
        }


        ListItem() {
          ComponentShowContainer({ title: '组',  }) {
            Text(String(this.select))
            IBestCheckboxGroup({group: 'group1'})
            Column() {
              IBestCheckbox({
                value: true,
                group: 'group1',
                label: '组1',
                name: 'checkbox1'
              })
            }.btnMargin()

            Column() {
              IBestCheckbox({
                value: this.select,
                group: 'group1',
                label: '组1',
                name: 'checkbox2'
              })
            }.btnMargin()
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