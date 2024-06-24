import TitleBar from '../components/TitleBar'
import router from '@ohos.router';
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer'
import { IBestButton, IBestEmpty } from '@ibestservices/ibest-ui'
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
            IBestEmpty({
              description: '描述文字'
            })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '图片类型' }) {
            IBestEmpty({
              emptyImage: 'error',
              description: '通用错误'
            })
            IBestEmpty({
              emptyImage: 'network',
              description: '网络错误'
            })
            IBestEmpty({
              emptyImage: 'search',
              description: '搜索提示'
            })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义大小' }) {
            IBestEmpty({
              imageSize: '200lpx',
              description: '描述文字'
            })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义图片' }) {
            IBestEmpty({
              description: '描述文字',
              emptyImgBuilder: this.Arrow
            })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '底部内容' }) {
            IBestEmpty({
              description: '描述文字',
              defaultBuilder: this.Btn
            })
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