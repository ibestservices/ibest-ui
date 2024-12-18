import router from '@ohos.router';
import { IBestCell, IBestCellGroup, IBestNavBar, IBestTag } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';


@Entry
@Component
struct CellPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''
  @State showTag: boolean = true;
  @State inputValue: string = ''

  @Builder
  StarIcon(width = 16) {
    Image($r('app.media.app_icon')).width(width)
  }

  @Builder
  Arrow() {
    Image($r('app.media.title_back')).height(14).margin({ left: SPACE.BASE }).rotate({ angle: 180 })
  }

  @Builder
  Title() {
    Row() {
      Text('单元格')
        .fontSize(14)
      IBestTag({ text: '标签' }).margin({
        left: SPACE.BASE
      })
    }
  }

  @Builder
  InputContain() {
    TextInput({ placeholder: '请输入内容' })
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
          ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.XS }) {
            IBestCellGroup() {
              IBestCell({ title: '标题', value: '内容' })
              IBestCell({
                title: '标题',
                value: '内容',
                label: '描述信息',
                hasBorder: false
              })
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '下边框样式', titlePaddingLeft: SPACE.XS }) {
            IBestCellGroup() {
              IBestCell({ title: 'full', value: '内容', borderSizeType: 'full' })
              IBestCell({ title: 'center', value: '内容', borderSizeType: 'center' })
              IBestCell({
                leftIcon: $r("app.media.icon_like_o"),
                title: 'right',
                value: '内容',
                borderSizeType: 'right'
              })
              IBestCell({ title: '占位', value: '内容', hasBorder: false })
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '卡片风格', titlePaddingLeft: SPACE.XS }) {
            IBestCellGroup({ inset: true }) {
              IBestCell({ title: '标题', value: '内容' })
              IBestCell({
                title: '标题',
                value: '内容',
                label: '描述信息',
                hasBorder: false
              })
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '分组标题', titlePaddingLeft: SPACE.XS }) {
            IBestCellGroup({ title: '分组1' }) {
              IBestCell({
                title: '标题',
                value: '内容',
                label: '描述信息',
                hasBorder: false
              })
            }
            IBestCellGroup({ title: '分组2' }) {
              IBestCell({
                title: '标题',
                value: '内容',
                label: '描述信息',
                hasBorder: false
              })
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '单元格大小', titlePaddingLeft: SPACE.XS }) {
            IBestCell({ title: '标题', value: '内容', cellSize: 'large' })
            IBestCell({
              title: '标题',
              value: '内容',
              label: '描述信息',
              hasBorder: false,
              cellSize: 'large'
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '展示图标', titlePaddingLeft: SPACE.XS }) {
            IBestCell({
              title: '标题',
              value: '内容',
              leftIcon: $r("app.media.icon_like")
            })
            IBestCell({
              title: '标题',
              value: '内容',
              iconBuilder: () => {
                this.StarIcon()
              }
            })
            IBestCell({
              title: '标题',
              value: '内容',
              rightIcon: $r("app.media.ibest_icon_star"),
              rightIconColor: '#FF0000',
              hasBorder: false
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '展示箭头', titlePaddingLeft: SPACE.XS }) {
            IBestCell({ title: '标题', value: '箭头朝右', isLink: true })
            IBestCell({
              title: '标题',
              value: '箭头朝下',
              isLink: true,
              arrowDirection: 'bottom'
            })
            IBestCell({
              title: '标题',
              value: '箭头朝左',
              isLink: true,
              arrowDirection: 'left'
            })
            IBestCell({
              title: '标题',
              value: '箭头朝上',
              isLink: true,
              arrowDirection: 'top',
              hasBorder: false
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '必填项', titlePaddingLeft: SPACE.XS }) {
            IBestCell({
              title: '标题',
              value: '内容',
              center: true,
              required: true,
              hasBorder: false,
              valueBuilder: (): void => this.InputContain()
            })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '内容居中', titlePaddingLeft: SPACE.XS }) {
            IBestCell({
              title: '居中',
              label: '描述内容',
              leftContentWidth: 100,
              value: '内容内容内容内容内容内容内容内容内容内容内容内容内容内容',
              center: true,
              iconBuilder: () => this.StarIcon(),
              isLink: true
            })
            IBestCell({
              title: '居上',
              label: '描述内容',
              value: '内容内容内容内容内容内容内容内容内容内容内容内容内容内容',
              hasBorder: false,
              iconBuilder: () => this.StarIcon(),
              isLink: true
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '使用插槽', titlePaddingLeft: SPACE.XS }) {
            IBestCell({
              title: '标题',
              value: '内容内容内容内容内容内容内容内容内容内容内容内容内容内容',
              iconBuilder: () => this.StarIcon(),
              rightIconBuilder: this.Arrow,
              clickable: true
            })
            IBestCell({
              titleBuilder: this.Title,
              value: '内容',
              rightIconBuilder: this.Arrow,
              clickable: true
            })
            IBestCell({
              title: '标题',
              iconBuilder: () => this.StarIcon(),
              hasBorder: false,
              rightIconBuilder: this.Arrow,
              clickable: true
            })
          }
        }
      }
      .layoutWeight(1)
      .padding({bottom: SPACE.MD})
    }
    .width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(modeColor.bg)
  }
}