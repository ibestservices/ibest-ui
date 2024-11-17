import router from '@ohos.router';
import { IBestIcon, IBestIconClassify, IBestTabItemType, IBestTabs } from '@ibestservices/ibest-ui';
import { BACKGROUND_COLOR, COLOR_GRAY, CONTAINER_SIZE, FONT_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';


@Entry
@Component
struct IconsPage {
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

  @Builder example() {
    List() {
      ListItem() {
        ComponentShowContainer({ title: '基础用法' }) {
          IBestIcon({ name: 'like' })
        }
      }
      ListItem() {
        ComponentShowContainer({ title: '图标颜色' }) {
          Row({space: SPACE.BASE}){
            IBestIcon({ name: 'cart-o', color: '#1989fa' })
            IBestIcon({ name: 'fire-o', color: '#ee0a24' })
          }
        }
      }
      ListItem() {
        ComponentShowContainer({ title: '图标大小' }) {
          Row({space: SPACE.BASE}){
            IBestIcon({ name: 'chat-o', iconSize: 20 })
            IBestIcon({ name: 'chat-o', iconSize: 40 })
          }
        }
      }
    }
    .layoutWeight(1)
    .padding({
      left: SPACE.MEDIA,
      right: SPACE.MEDIA
    })
    .backgroundColor("#fff")
    .borderRadius(SPACE.BASE)
  }

  copyText(text: string) {
    // const pasteboardData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
    // const systemPasteboard = pasteboard.getSystemPasteboard();
    // systemPasteboard.setData(pasteboardData); // 将数据放入剪切板
    // systemPasteboard.getData().then((data) => {
    //   if (data) {
    //     // promptAction.showToast({ message: '复制成功' });
    //     IBestNotify.show({
    //       message: `已复制到剪切板`,
    //       color: Color.White,
    //       backgroundColor: '#58be6a'
    //     })
    //   } else {
    //     promptAction.showToast({ message: '复制失败' });
    //   }
    // })
  }

  @Builder iconShowList(list: string[]) {
    Grid(){
      ForEach(list, (item: string) => {
        GridItem() {
          Column({space: SPACE.MEDIA}) {
            IBestIcon({ name: item, iconSize: 30 })
            Text(item)
              .fontSize(FONT_SIZE.MINI)
              .textAlign(TextAlign.Center)
              .padding({ left: SPACE.MINI, right: SPACE.MINI })
          }
          .width(CONTAINER_SIZE.FULL)
          .alignItems(HorizontalAlign.Center)
          .padding({ top: SPACE.MEDIA, bottom: SPACE.MEDIA })
          .stateStyles({
            pressed:{
              .backgroundColor(COLOR_GRAY.GRAY_2)
            },
            normal:{
              .backgroundColor(BACKGROUND_COLOR.DEFAULT)
            }
          })
        }
        .onClick(() => {
          this.copyText(item)
        })
      })
    }
    .columnsTemplate("1fr 1fr 1fr 1fr")
    .cellLength(100)
    .layoutWeight(1)
    .backgroundColor(BACKGROUND_COLOR.DEFAULT)
    .borderRadius(SPACE.BASE)
  }

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')
      IBestTabs({
        tabsList: this.tabsList,
        currentName: $curTabName
      })
      Column() {
        if (this.curTabName === '1') {
          this.example()
        } else if (this.curTabName === '2') {
          this.iconShowList(IBestIconClassify.basic)
        } else if (this.curTabName === '3') {
          this.iconShowList(IBestIconClassify.outline)
        } else if (this.curTabName === '4') {
          this.iconShowList(IBestIconClassify.filled)
        }
      }
      .layoutWeight(1)
      .padding({
        left: SPACE.BASE,
        right: SPACE.BASE,
        bottom: SPACE.BASE
      })
      .margin({top: SPACE.BASE})
    }
    .width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(BACKGROUND_COLOR.BASE)
  }
}