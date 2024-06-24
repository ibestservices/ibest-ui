import router from '@ohos.router'
import { BACKGROUND_COLOR, SPACE, CONTAINER_SIZE, FONT_SIZE, FONT_WEIGHT, COLOR_GRAY } from '../assets/styles/BaseStyle'

@Entry
@Component
struct Index {
  @State componentList: {
    name: string,
    path: string
  }[] = [
    {
      name: 'Theme主题',
      path: 'pages/Theme'
    },
    {
      name: 'Button按钮',
      path: 'pages/Button'
    },
    {
      name: 'Radio单选框',
      path: 'pages/Radio'
    },
    {
      name: 'Checkbox复选框',
      path: 'pages/Checkbox'
    },
    {
      name: 'Switch开关',
      path: 'pages/Switch'
    },
    {
      name: 'Tag标签',
      path: 'pages/Tag'
    },
    {
      name: 'Cell单元格',
      path: 'pages/Cell'
    },
    {
      name: 'Watermark水印',
      path: 'pages/Watermark'
    },
    {
      name: 'Empty空状态',
      path: 'pages/Empty'
    },
    {
      name: 'Dialog 弹出框',
      path: 'pages/Dialog'
    },
    {
      name: 'Stepper 步进器',
      path: 'pages/Stepper'
    },
  ]

  build() {
    Column() {
      List() {
        ForEach(this.componentList, item => {
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

      }.listDirection(Axis.Vertical) // 排列方向
    }.width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(BACKGROUND_COLOR.BASE)
    .padding(SPACE.LARGE)

  }
}