import TitleBar from '../components/TitleBar'
import router from '@ohos.router';
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer'
import { ComponentRouterParams } from '../assets/global.type';
import { IBestLoading } from '@ibestservices/ibest-ui';



@Entry
@Component
struct LoadingPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''

  @Builder Content(){
    Column(){
      Text('34124124')
      Text('34124124')
      Text('34124124')
      Text('34124124')
      Text('34124124')
      Text('34124124')
      Text('34124124')
      Text('34124124')
    }
  }
  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')

      List() {
        ListItem() {
          ComponentShowContainer({ title: '基础用法' }) {
            IBestLoading()
          }
        }.margin({
          bottom: SPACE.BASE
        })


        ListItem() {
          ComponentShowContainer({ title: '包含内容' }) {
            IBestLoading({
              defaultBuilder: this.Content,
              loadingText: '加载中...'
            })
          }
        }.margin({
          bottom: SPACE.BASE
        })

        ListItem() {
          ComponentShowContainer({ title: '横向布局' }) {
            IBestLoading({
              defaultBuilder: this.Content,
              vertical: false,
              loadingText: '加载中...'
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