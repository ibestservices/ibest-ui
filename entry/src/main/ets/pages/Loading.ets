import TitleBar from '../components/TitleBar'
import router from '@ohos.router';
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer'
import { ComponentRouterParams } from '../assets/global.type';
import { IBestLoading, IBestEmpty } from '@ibestservices/ibest-ui';


@Entry
@Component
struct LoadingPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''

  @Builder
  EmptyContain() {
    IBestEmpty()
  }

  @Builder
  ImageContain() {
    Image($r('app.media.icon')).width('40lpx')
  }

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')

      List() {
        ListItem() {
          ComponentShowContainer({ title: '加载类型' }) {
            Row() {
              IBestLoading()
              IBestLoading({
                loadingIconType: 'spinner'
              }).margin({ left: '40lpx' })

            }
          }
        }.margin({
          bottom: SPACE.BASE
        })

        ListItem() {
          ComponentShowContainer({ title: '自定义颜色' }) {
            Row() {
              IBestLoading({
                loadingColor: 'rgb(25, 137, 250)'
              })
              IBestLoading({
                loadingColor: 'rgb(25, 137, 250)',
                loadingIconType: 'spinner'
              }).margin({ left: '40lpx' })

            }
          }
        }.margin({
          bottom: SPACE.BASE
        })


        ListItem() {
          ComponentShowContainer({ title: '自定义大小' }) {
            Row() {
              IBestLoading({
                loadingSize: '80lpx'
              })
              IBestLoading({
                loadingSize: '80lpx',
                loadingIconType: 'spinner'
              }).margin({ left: '40lpx' })

            }
          }
        }.margin({
          bottom: SPACE.BASE
        })


        ListItem() {
          ComponentShowContainer({ title: '加载文案' }) {
            Row() {
              IBestLoading({
                loadingText: '加载中...'
              })

            }
          }
        }.margin({
          bottom: SPACE.BASE
        })

        ListItem() {
          ComponentShowContainer({ title: '水平排列' }) {
            Row() {
              IBestLoading({
                loadingText: '加载中...',
                vertical: false
              })

            }
          }
        }.margin({
          bottom: SPACE.BASE
        })

        ListItem() {
          ComponentShowContainer({ title: '自定义文本颜色' }) {
            Row() {
              IBestLoading({
                loadingText: '加载中...',
                loadingColor: 'rgb(25, 137, 250)',
                loadingTextColor: 'rgb(25, 137, 250)'
              })
              IBestLoading({
                loadingText: '加载中...',
                loadingTextColor: 'rgb(25, 137, 250)'
              }).margin({ left: '40lpx' })
            }
          }
        }.margin({
          bottom: SPACE.BASE
        })

        ListItem() {
          ComponentShowContainer({ title: '包含内容' }) {
            IBestLoading({
              defaultBuilder: this.EmptyContain,
              loadingMaskColor: 'rgba(0,0,0,0.5)',
              loadingColor: 'rgb(25, 137, 250)'
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