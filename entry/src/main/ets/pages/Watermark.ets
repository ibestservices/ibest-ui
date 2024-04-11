import router from '@ohos.router';
import { IBestWatermark } from '../../../../../library/Index'
import { BACKGROUND_COLOR, CONTAINER_SIZE, FONT_SIZE, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import TitleBar from '../components/TitleBar';

@Entry
@Component
struct WatermarkPage {
  @State title: string = router.getParams()['title'] || '';


  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')


      List() {

        ListItem() {
          ComponentShowContainer({ title: '文字水印', titlePaddingLeft: SPACE.SMALL }) {
            IBestWatermark({
              text: 'IBest-UI',
              waterMarkZIndex: 1,
              fontSize: 14,
              gapX: 40,
              gapY: 40
            }){
              Column(){}
              .width(CONTAINER_SIZE.FULL)
              .height(200)
              .backgroundColor('#FFF')
            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '图片水印', titlePaddingLeft: SPACE.SMALL }) {
            IBestWatermark({
              imageUrl: 'https://fastly.jsdelivr.net/npm/@vant/assets/logo.png',
              waterMarkWidth: 40,
              waterMarkHeight: 40,
              waterMarkZIndex: 1,
              gapX: 40,
              gapY: 40
            }){
              Column(){}
              .width(CONTAINER_SIZE.FULL)
              .height(200)
              .backgroundColor('#FFF')
            }
          }
        }


        ListItem() {
          ComponentShowContainer({ title: '自定义间隔', titlePaddingLeft: SPACE.SMALL }) {
            IBestWatermark({
              text: 'IBest-UI',
              waterMarkZIndex: 1,
              fontSize: 14,
              gapX: 80,
              gapY: 80
            }){
              Column(){}
              .width(CONTAINER_SIZE.FULL)
              .height(200)
              .backgroundColor('#FFF')
            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义倾斜角度', titlePaddingLeft: SPACE.SMALL }) {
            IBestWatermark({
              text: 'IBest-UI',
              waterMarkZIndex: 1,
              fontSize: 14,
              gapX: 20,
              gapY: 20,
              rotateDeg: 0
            }){
              Column(){}
              .width(CONTAINER_SIZE.FULL)
              .height(200)
              .backgroundColor('#FFF')
            }
          }
        }.margin({
          bottom: SPACE.MEDIA
        })





      }
      .layoutWeight(1)

    }
    .width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(BACKGROUND_COLOR.BASE)
  }
}