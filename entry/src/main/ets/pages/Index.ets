import router from '@ohos.router'
import { BACKGROUND_COLOR, SPACE, CONTAINER_SIZE, FONT_SIZE, FONT_WEIGHT } from '../assets/styles/BaseStyle'

interface ComponentItem {
  name: string,
  path: string
}

@Entry
@Component
struct Index {
  @State componentList: ComponentItem[] = [
    {
      name: 'Theme主题',
      path: 'pages/Theme'
    },
    {
      name: 'Button按钮',
      path: 'pages/Button'
    },
    {
      name: 'Cell单元格',
      path: 'pages/Cell'
    },
    {
      name: 'Popup弹出层',
      path: 'pages/Popup'
    },
    {
      name: 'Toast 轻提示',
      path: 'pages/Toast'
    },


    {
      name: 'Calendar 日历',
      path: 'pages/Calendar'
    },
    {
      name: 'Cascader 级联选择',
      path: 'pages/Cascader'
    },
    {
      name: 'Checkbox 复选框',
      path: 'pages/Checkbox'
    },
    {
      name: 'Field 输入框',
      path: 'pages/Field'
    },
    {
      name: 'Form 表单',
      path: 'pages/Form'
    },
    {
      name: 'Radio 单选框',
      path: 'pages/Radio'
    },
    {
      name: 'Stepper 步进器',
      path: 'pages/Stepper'
    },
    {
      name: 'Switch 开关',
      path: 'pages/Switch'
    },
    {
      name: 'Tag 标签',
      path: 'pages/Tag'
    },
    {
      name: 'Watermark 水印',
      path: 'pages/Watermark'
    },
    {
      name: 'Empty 空状态',
      path: 'pages/Empty'
    },
    {
      name: 'Dialog 弹出框',
      path: 'pages/Dialog'
    },
    {
      name: 'Loading 加载',
      path: 'pages/Loading'
    },
    {
      name: 'Tab 标签页',
      path: 'pages/Tab'
    }
  ]

  build() {
    Column() {
      List() {
        ForEach(this.componentList, (item: ComponentItem) => {
          ListItem() {
            Row() {
              Text(item.name)
                .fontSize(FONT_SIZE.BASE)
                .fontWeight(FONT_WEIGHT.MEDIUM)
                .textAlign(TextAlign.Start)
                .fontColor('#34495e')
                .layoutWeight(1)

              Image($r('app.media.title_back'))
                .width(CONTAINER_SIZE.THIRTY)
                .margin({
                  right: SPACE.BASE
                })
                .rotate({
                  angle: 180
                })
            }
          }
          .width(CONTAINER_SIZE.FULL)
          .height(CONTAINER_SIZE.EIGHTY)
          .borderRadius(99)
          .padding({ left: SPACE.LARGE })
          .margin({
            bottom: SPACE.BASE
          })
          .backgroundColor(0xFFFFFF)
          .stateStyles({
            normal: {
              .scale({
                x: 1,
                y: 1
              })
            },
            pressed: {
              .scale({
                x: .98,
                y: .98
              })
            }
          })
          .onClick(() => {
            router.pushUrl({
              url: item.path,
              params: {
                title: item.name
              }
            })
          })
          .animation({
            duration: 200
          })
        })

      }
      .listDirection(Axis.Vertical) // 排列方向
      .padding(SPACE.LARGE)
    }.width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(BACKGROUND_COLOR.BASE)
  }
}