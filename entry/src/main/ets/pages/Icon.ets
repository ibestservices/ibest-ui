import router from '@ohos.router';
import { IBestIcon, IBestTabItemType, IBestTabs, IbestIconData, IbestIconClassify,
  IBestNotify } from '@ibestservices/ibest-ui'
import { BACKGROUND_COLOR, COLOR_BLUE, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { ComponentRouterParams } from '../assets/global.type'
import { pasteboard } from '@kit.BasicServicesKit'
import { promptAction } from '@kit.ArkUI'

interface iconListItem {
  name: string
  value: string
}

@Styles
function IconsGap() {
  .margin({ right: SPACE.BASE, bottom: SPACE.BASE })
}

@Entry
@Component
struct IconsPage {
  @State message: string = 'Hello World';
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''
  @State curTabName: string = "1"
  @State tabsList: IBestTabItemType[] = [
    {
      label: "用法示例",
      name: "1"
    },
    {
      label: "基础图标",
      name: "2"
    },
    {
      label: "线框风格",
      name: "3"
    },
    {
      label: "实底风格",
      name: "4"
    }
  ]

  @Builder
  example() {
    List() {
      ListItem() {
        ComponentShowContainer({ title: '基础用法' }) {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
            Column() {
              IBestIcon({ name: 'like' })
            }
          }
        }
      }

      ListItem() {
        ComponentShowContainer({ title: '使用图片 URL' }) {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
            Column() {
              IBestIcon({ name: 'https://fastly.jsdelivr.net/npm/@vant/assets/icon-demo.png' })
            }
          }
        }
      }

      ListItem() {
        ComponentShowContainer({ title: '图标颜色' }) {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
            Column() {
              IBestIcon({ name: 'cart-o', color: '#1989fa' })
            }.IconsGap()

            Column() {
              IBestIcon({ name: 'fire-o', color: '#ee0a24' })
            }
          }
        }
      }

      ListItem() {
        ComponentShowContainer({ title: '图标大小' }) {
          Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
            Column() {
              IBestIcon({ name: 'chat-o', iconSize: 20 })
            }.IconsGap()

            Column() {
              IBestIcon({ name: 'chat-o', iconSize: 40 })
            }
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

  copyText(text: string) {
    const pasteboardData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    const systemPasteboard = pasteboard.getSystemPasteboard();
    systemPasteboard.setData(pasteboardData); // 将数据放入剪切板
    systemPasteboard.getData().then((data) => {
      if (data) {
        promptAction.showToast({ message: '复制成功' });
      } else {
        promptAction.showToast({ message: '复制失败' });
      }
    })
  }

  @Builder
  iconShowList(list: string[]) {
    List() {
      ListItem() {
        Flex({ wrap: FlexWrap.Wrap, direction: FlexDirection.Row }) {
          ForEach(list, (item: string) => {
            Stack() {
              Column() {
                IBestIcon({ name: item, iconSize: 30 })
                Text(item).margin({ top: SPACE.BASE, bottom: SPACE.BASE })
              }.alignItems(HorizontalAlign.Center)
            }
            .width('20%')
            .height('20%')
            .IconsGap()
            .onClick(() => {
              this.copyText(item)
              IBestNotify.show({
                message: `${item} 复制到剪切板`,
                color: Color.White,
                backgroundColor: '#58be6a'
              })
            })
          })

        }.backgroundColor(Color.White).margin({ top: SPACE.BASE, bottom: SPACE.BASE })
      }
    }.width('100%').height('100%')
  }

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')


      Column() {
        Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {
          Column() {
            IBestTabs({
              tabsList: this.tabsList,
              currentName: $curTabName
            })
            if (this.curTabName === '1') {
              this.example()
            } else if (this.curTabName === '2') {
              this.iconShowList(IbestIconClassify.basic)
            } else if (this.curTabName === '3') {
              this.iconShowList(IbestIconClassify.outline)
            } else if (this.curTabName === '4') {
              this.iconShowList(IbestIconClassify.filled)
            } else {
              Stack()
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