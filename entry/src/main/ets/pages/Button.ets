import router from '@ohos.router';
import { IBestButton } from '../../../../../library/Index'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'

@Styles
function btnMargin() {
  .margin({ right: SPACE.BASE, bottom: SPACE.BASE })
}

@Builder function Arrow(){
  Image($r('app.media.title_back'))
    .width(CONTAINER_SIZE.FORTY_FOUR)

}

@Entry
@Component
struct ButtonPage {
  @State message: string = 'Hello World';
  @State title: string = router.getParams()['title'] || ''

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
                  text: '主要按钮'
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
                  loading: true
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
                  iconBuilder: Arrow
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '按钮',
                  iconBuilder: Arrow
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  plain: true,
                  text: '按钮',
                  type: 'default',
                  iconBuilder: Arrow
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
                  buttonSize: 'large'
                }).margin({
                  bottom: SPACE.BASE
                })

              Column() {
                IBestButton({
                  text: '普通按钮',
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '小型按钮',
                  buttonSize: 'small'
                })
              }.btnMargin()

              Column() {
                IBestButton({
                  text: '迷你按钮',
                  buttonSize: 'mini'
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