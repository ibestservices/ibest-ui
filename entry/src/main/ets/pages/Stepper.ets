import TitleBar from '../components/TitleBar'
import router from '@ohos.router';
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer'
import { IBestButton } from '@ibestservices/ibest-ui'
import {IBestStepper} from '../../../../../library/Index'
import { ComponentRouterParams } from '../assets/global.type';

@Entry
@Component
struct EmptyPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''


  @Builder
  Arrow() {
    Image($r('app.media.title_back')).height('320lpx').margin({ left: SPACE.MINI, top: '6lpx' }).rotate({ angle: 180 })
  }

  @Builder
  Btn() {
    IBestButton({ text: '按钮', type: 'primary' }).margin({ top: SPACE.BASE })
  }

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')

      List() {
        ListItem() {
          ComponentShowContainer({ title: '基础用法' }) {
            IBestStepper()
          }
        }.margin({
          bottom: SPACE.BASE
        })

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