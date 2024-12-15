import router from '@ohos.router';
import { IBestTag } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, FONT_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';

@Extend(Row) function rowStyles(hasBottomBorder: boolean = true){
  .width(CONTAINER_SIZE.FULL)
    .padding({top: SPACE.SM, bottom: SPACE.SM})
    .justifyContent(FlexAlign.SpaceBetween)
    .border({width: {bottom:  hasBottomBorder ? 1 : 0}, color: '#f5f6f8'})
}

@Extend(List) function listStyles(){
  .backgroundColor('#fff')
  .borderRadius(4)
  .padding({
    left: SPACE.SM,
    right: SPACE.SM
  })
}

@Entry
@Component
struct TagPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''
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
                  Text('primary 类型').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    text: '标签',
                    type: 'primary'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('success 类型').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    text: '标签',
                    type: 'success'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('warning 类型').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    text: '标签',
                    type: 'warning'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('danger 类型').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    text: '标签',
                    type: 'danger'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('default 类型').fontSize(FONT_SIZE.MD)
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
                  Text('空心样式').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    text: '标签',
                    type: 'primary',
                    plain: true
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('圆角样式').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    text: '标签',
                    type: 'primary',
                    round: true
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('标记样式').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    text: '标签',
                    type: 'primary',
                    mark: true
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('可关闭标签').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    text: '标签',
                    type: 'primary',
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
                  Text('小号标签').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    type: 'primary',
                    text: '标签',
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('中号标签').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    type: 'primary',
                    text: '标签',
                    tagSize: 'medium'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('大号标签').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    type: 'primary',
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
                  Text('背景颜色').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    text: '标签',
                    type: 'primary',
                    color: "#7232dd"
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('文字颜色').fontSize(FONT_SIZE.MD)
                  IBestTag({
                    text: '标签',
                    color: "#ffe1e1",
                    textColor: '#ad0000'
                  })
                }.rowStyles()
              }.width(CONTAINER_SIZE.FULL)
              ListItem(){
                Row(){
                  Text('空心颜色').fontSize(FONT_SIZE.MD)
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
          bottom: SPACE.MD
        })

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