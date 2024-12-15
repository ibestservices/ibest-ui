import router from '@ohos.router';
import { IBestNavBar, IBestSwitch } from '@ibestservices/ibest-ui';
import { COLOR_GRAY, CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';


@Entry
@Component
struct SwitchPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''
  @State arrowDirection: 'left' | 'right' = 'left';

  @Builder Arrow(){
    Row(){
      Image($r('app.media.title_back'))
        .width(CONTAINER_SIZE.FOURTEEN)
        .fillColor(this.arrowDirection === 'left' ? '#db3131' : '#e2e3e7')
        .rotate({
          angle: this.arrowDirection === 'left' ? 0 : -180
        }).animation({
        duration: 200,
      })
    }
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
          ComponentShowContainer({ title: '基础用法' }) {
            IBestSwitch()
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '禁用状态' }) {
            IBestSwitch({
              loading: true,
              value: false,
              disabled: true,
            }).margin({
              bottom: SPACE.SM
            })
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
            }).margin({
              bottom: SPACE.SM
            })
            IBestSwitch({
              loading: true,
              value: false,
              activeColor: '#07c160'
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '自定义大小' }) {
            IBestSwitch({
              value: true,
              switchSize: 20
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '自定义按钮' }) {
            IBestSwitch({
              value: true,
              activeColor: '#db3131',
              nodeBuilder: () => this.Arrow(),
              onChange: (value) => {
                this.arrowDirection = value ? 'left' : 'right';
              }
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '异步控制' }) {
            IBestSwitch({
              value: true,
              onBeforeChange: ()=>{
                return new Promise((resolve, reject)=>{
                  AlertDialog.show({
                    title: '提示',
                    message: '确定更改状态吗',
                    autoCancel: true,
                    alignment: DialogAlignment.Bottom,
                    offset: { dx: 0, dy: -20 },
                    gridCount: 3,
                    primaryButton: {
                      value: '取消',
                      fontColor: COLOR_GRAY.GRAY_6,
                      action: () => {
                        reject()
                      }
                    },
                    secondaryButton: {
                      value: '确认',
                      action: () => {
                        resolve()
                      }
                    },
                    cancel: () => {
                      reject()
                    }
                  })
                })
              }
            })
          }
        }
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