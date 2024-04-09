import router from '@ohos.router';
import { IBestSwitch } from '../../../../../library/Index'
import { BACKGROUND_COLOR, COLOR_BLUE, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'

@Styles
function btnMargin() {
  .margin({ right: SPACE.BASE, bottom: SPACE.BASE })
}



@Entry
@Component
struct SwitchPage {
  @State title: string = router.getParams()['title'] || ''

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')


      List() {
        ListItem() {
          ComponentShowContainer({ title: '基础用法' }) {
            IBestSwitch()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '禁用状态' }) {
            IBestSwitch({
              disabled: true,
              value: true
            })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '加载状态' }) {
            IBestSwitch({
              loading: true,
              value: true
            })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义大小' }) {
            IBestSwitch({
              value: true,
              switchSize: 40
            })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义颜色' }) {
            IBestSwitch({
              value: true,
              activeColor: '#db3131'
            })
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