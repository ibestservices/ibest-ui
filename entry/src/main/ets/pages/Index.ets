import router from '@ohos.router'
import { BACKGROUND_COLOR, SPACE, CONTAINER_SIZE, FONT_SIZE, FONT_WEIGHT } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'

interface ComponentPart{
  title: string
  list: ComponentItem[]
}

interface ComponentItem {
  name: string,
  path: string
}

@Entry
@Component
struct Index {
  @State componentList: ComponentPart[] = [
    {
      title: '基础组件',
      list: [
        {
          name: 'PullRefresh 下拉刷新',
          path: 'pages/PullRefresh'
        },
        {
          name: 'Button 按钮',
          path: 'pages/Button'
        },
        {
          name: 'Cell 单元格',
          path: 'pages/Cell'
        },
        {
          name: 'Popup 弹出层',
          path: 'pages/Popup'
        },
        {
          name: 'Theme 主题',
          path: 'pages/Theme'
        },
        {
          name: 'Toast 轻提示',
          path: 'pages/Toast'
        }
      ]
    },
    {
      title: '表单组件',
      list: [
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
          name: 'DatePicker 日期选择',
          path: 'pages/DatePicker'
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
          name: 'NumberKeyboard 数字键盘',
          path: 'pages/NumberKeyboard'
        },
        {
          name: 'PasswordInput 密码输入框',
          path: 'pages/PasswordInput'
        },
        {
          name: 'Picker 选择器',
          path: 'pages/Picker'
        },
        {
          name: 'PickerGroup 选择器组',
          path: 'pages/PickerGroup'
        },
        {
          name: 'Radio 单选框',
          path: 'pages/Radio'
        },
        {
          name: 'Rate 评分',
          path: 'pages/Rate'
        },
        {
          name: 'Search 搜索',
          path: 'pages/Search'
        },
        {
          name: 'Slider 滑块',
          path: 'pages/Slider'
        },
        {
          name: 'Signature 签名',
          path: 'pages/Signature'
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
          name: 'TimePicker 时间选择',
          path: 'pages/TimePicker'
        },
        {
          name: 'Uploader 文件上传',
          path: 'pages/Uploader'
        }
      ]
    },
    {
      title: '反馈组件',
      list: [
        {
          name: "ActionSheet 动作面板",
          path: "pages/ActionSheet"
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
          name: 'Notify 消息通知',
          path: 'pages/Notify'
        },
        {
          name: 'PullRefresh 下拉刷新',
          path: 'pages/PullRefresh'
        }
      ]
    },
    {
      title: '展示组件',
      list: [
        {
          name: 'Empty 空状态',
          path: 'pages/Empty'
        },
        {
          name: 'ImagePreview 图片预览',
          path: 'pages/ImagePreview'
        },
        {
          name: 'Tag 标签',
          path: 'pages/Tag'
        },
        {
          name: 'Watermark 水印',
          path: 'pages/Watermark'
        },
      ]
    },
    {
      title: '导航组件',
      list: [
        {
          name: 'Tab 标签页',
          path: 'pages/Tab'
        }
      ]
    }
  ]

  build() {
    Column() {
      List() {
        ForEach(this.componentList, (part: ComponentPart) => {
          ListItem() {
            ComponentShowContainer({ title: part.title, titlePaddingLeft: SPACE.SMALL }) {
              ForEach(part.list, (item: ComponentItem) => {
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
                .animation({
                  duration: 200
                })
                .onClick(() => {
                  router.pushUrl({
                    url: item.path,
                    params: {
                      title: item.name
                    }
                  })
                })
              })
            }
          }
        })
      }
      .listDirection(Axis.Vertical) // 排列方向
      .padding(SPACE.MEDIA)
    }.width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(BACKGROUND_COLOR.BASE)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
  }
}