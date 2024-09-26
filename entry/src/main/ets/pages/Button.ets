import router from '@ohos.router';
import { IBestButton } from '@ibestservices/ibest-ui'
import { BACKGROUND_COLOR, COLOR_BLUE, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { ComponentRouterParams } from '../assets/global.type';

@Styles
function btnMargin() {
  .margin({ right: SPACE.BASE, bottom: SPACE.BASE })
}

@Builder function Arrow(color = '#fff'){
  Image($r('app.media.title_back'))
    .width(CONTAINER_SIZE.FORTY_FOUR)
    .fillColor(color)

}

@Entry
@Component
struct ButtonPage {
  @State message: string = 'Hello World';
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''

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
          ComponentShowContainer({ title: '按钮类型' }) {
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              Column() {
                IBestButton({
                  text: '主要按钮',
                  type: 'primary',
                  onClickBtn: () => {
                    console.log('点击按钮了')
                  }
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '成功按钮',
                  type: 'success'
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '默认按钮',
                  type: 'default'
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '危险按钮',
                  type: 'danger'
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '警告按钮',
                  type: 'warning'
                })
              }.btnMargin()
            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '朴素按钮' }) {
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              Column() {
                IBestButton({
                  text: '朴素按钮',
                  type: 'primary',
                  plain: true
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '朴素按钮',
                  plain: true,
                  type: 'success'
                })
              }.btnMargin()

            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '禁用状态' }) {
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              Column() {
                IBestButton({
                  text: '禁用状态',
                  type: 'primary',
                  disabled: true
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '禁用状态',
                  type: 'success',
                  disabled: true
                })
              }.btnMargin()

            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '加载状态' }) {
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              Column() {
                IBestButton({
                  loading: true,
                  type: 'primary',
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '加载状态',
                  loadingText: '加载中...',
                  type: 'success',
                  loading: true
                })
              }.btnMargin()

            }
          }
        }


        ListItem() {
          ComponentShowContainer({ title: '按钮形状' }) {
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              Column() {
                IBestButton({
                  text: '方形按钮',
                  type: 'primary',
                  square: true
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '圆形按钮',
                  type: 'success',
                  round: true
                })
              }.btnMargin()
            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '图标按钮' }) {
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
              Column() {
                IBestButton({
                  text: '',
                  type: 'primary',
                  iconBuilder: Arrow
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '按钮',
                  type: 'primary',
                  iconBuilder: Arrow
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  plain: true,
                  text: '按钮',
                  type: 'default',
                  iconBuilder: Arrow.bind(this, COLOR_BLUE.MINI)
                })
              }.btnMargin()
            }
          }
        }


        ListItem() {
          ComponentShowContainer({ title: '按钮尺寸' }) {
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {
                IBestButton({
                  text: '大号按钮',
                  type: 'primary',
                  buttonSize: 'large'
                }).margin({
                  bottom: SPACE.BASE
                })

              Column() {
                IBestButton({
                  type: 'primary',
                  text: '普通按钮',
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '小型按钮',
                  type: 'primary',
                  buttonSize: 'small'
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '迷你按钮',
                  type: 'primary',
                  buttonSize: 'mini'
                })
              }.btnMargin()
            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义颜色' }) {
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {

              Column() {
                IBestButton({
                  text: '自定义颜色按钮',
                  color: "#7232dd"
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '自定义颜色按钮',
                  plain: true,
                  color: "#7232dd"
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '自定义颜色按钮',
                  plain: true,
                  disabled: true,
                  color: "#7232dd"
                })
              }.btnMargin()

            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义大小' }) {
            Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {

              Column() {
                IBestButton({
                  text: '自定义大小按钮',
                  btnWidth: 300,
                  btnHeight: 80,
                  btnFontSize: 32
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