import router from '@ohos.router';
import { IBestTag } from '../../../../../library/Index'
import { BACKGROUND_COLOR, COLOR_BLUE, COLOR_GRAY, CONTAINER_SIZE, FONT_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'

@Extend(Row) function rowStyles(hasBottomBorder: boolean = true){
  .width(CONTAINER_SIZE.FULL)
    .padding({top: SPACE.BASE, bottom: SPACE.BASE})
    .justifyContent(FlexAlign.SpaceBetween)
    .border({width: {bottom:  hasBottomBorder ? '2lpx' : 0}, color: '#f5f6f8'})
}

@Extend(List) function listStyles(){
  .backgroundColor('#fff')
  .borderRadius('8lpx')
  .padding({
    left: SPACE.BASE,
    right: SPACE.BASE
  })
}

@Entry
@Component
struct TagPage {
  @State title: string = router.getParams()['title'] || '';
  @State showTag: boolean = true

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')


      List() {
        ListItem() {
          ComponentShowContainer({ title: '基础用法' }) {
            List(){
              ListItem(){
                Row(){
                  Text('primary 类型').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    type: 'primary'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('success 类型').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    type: 'success'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('warning 类型').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    type: 'warning'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('danger 类型').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    type: 'danger'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('default 类型').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    type: 'default'
                  })
                }.rowStyles(false)
              }.width(CONTAINER_SIZE.FULL)
            }.listStyles()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '样式风格' }) {
            List(){
              ListItem(){
                Row(){
                  Text('空心样式').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    plain: true
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('圆角样式').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    round: true
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('标记样式').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    mark: true
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('可关闭标签').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    closeable: true,
                    show: this.showTag,
                    onClose: () => {
                      this.showTag = false;
                    }

                  })
                }.rowStyles(false)
              }.width(CONTAINER_SIZE.FULL)
            }.listStyles()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '标签大小' }) {
            List(){
              ListItem(){
                Row(){
                  Text('小号标签').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('中号标签').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    tagSize: 'medium'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('大号标签').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    tagSize: 'large'
                  })
                }.rowStyles(false)
              }.width(CONTAINER_SIZE.FULL)
            }.listStyles()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义颜色' }) {
            List(){
              ListItem(){
                Row(){
                  Text('背景颜色').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    color: "#7232dd"
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('文字颜色').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    color: "#ffe1e1",
                    textColor: '#ad0000'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('空心颜色').fontSize(FONT_SIZE.BASE)
                  IBestTag({
                    text: '标签',
                    color: "#7232dd",
                    plain: true
                  })
                }.rowStyles(false)
              }.width(CONTAINER_SIZE.FULL)
            }.listStyles()
          }
        }
        .margin({
          bottom: SPACE.MEDIA
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