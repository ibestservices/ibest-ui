import TitleBar from '../components/TitleBar';
import router from '@ohos.router';
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';
import { IBestEmpty, IBestLoading, IBestNavBar } from '@ibestservices/ibest-ui';


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
    Image($r('app.media.icon')).width(20)
  }

  build() {
    Column() {
      IBestNavBar({
        title: this.title,
        isShowStatusBar: true,
        onLeftClick: () => {
          router.back()
        }
      })
      List() {
        ListItem() {
          ComponentShowContainer({ title: '加载类型' }) {
            Row() {
              IBestLoading()
              IBestLoading({
                loadingIconType: 'spinner'
              }).margin({ left: 20 })

            }
          }
        }.margin({
          bottom: SPACE.SM
        })
        ListItem() {
          ComponentShowContainer({ title: '自定义颜色' }) {
            Row() {
              IBestLoading({
                loadingColor: '#DB3131'
              })
              IBestLoading({
                loadingColor: '#DB3131',
                loadingIconType: 'spinner'
              }).margin({ left: 20 })

            }
          }
        }.margin({
          bottom: SPACE.SM
        })
        ListItem() {
          ComponentShowContainer({ title: '自定义大小' }) {
            Row({ space: 20 }) {
              IBestLoading({
                loadingSize: 40
              })
              IBestLoading({
                loadingSize: 40,
                loadingIconType: 'spinner'
              })

            }
          }
        }.margin({
          bottom: SPACE.SM
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
          bottom: SPACE.SM
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
          bottom: SPACE.SM
        })
        ListItem() {
          ComponentShowContainer({ title: '自定义文本颜色' }) {
            Row() {
              IBestLoading({
                loadingText: '加载中...',
                loadingTextColor: 'rgb(25, 137, 250)'
              })
              IBestLoading({
                loadingText: '加载中...',
                loadingColor: '#3D8AF2',
                loadingTextColor: 'rgb(25, 137, 250)'
              }).margin({ left: 20 })
            }
          }
        }.margin({
          bottom: SPACE.SM
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
          bottom: SPACE.SM
        })
      }
      .layoutWeight(1)
      .padding({
        left: SPACE.SM,
        right: SPACE.SM
      })
    }
    .width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(modeColor.bg)
  }
}