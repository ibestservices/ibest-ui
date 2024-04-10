import router from '@ohos.router';
import { IBestCell, IBestTag } from '../../../../../library/Index'
import { BACKGROUND_COLOR, COLOR_BLUE, COLOR_GRAY,
  COLOR_RED,
  CONTAINER_SIZE, FONT_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'


@Entry
@Component
struct CellPage {
  @State title: string = router.getParams()['title'] || '';
  @State showTag: boolean = true;
  @State inputValue: string = ''
  @Builder StarIcon(height = '48lpx'){
    Image($r('app.media.startIcon')).height(height).margin({right: SPACE.MINI})
  }

  @Builder Arrow(){
    Image($r('app.media.title_back')).height('24lpx').margin({left: SPACE.MINI, top: '6lpx'}).rotate({angle: 180})
  }

  @Builder Title(){
    Row(){
      Text('单元格')
        .fontSize('28lpx')
      IBestTag({text: '标签'}).margin({
        left: SPACE.MINI
      })
    }
  }

  @Builder InputContain(){
    TextInput({placeholder: '请输入内容'})
  }

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')


      List() {
        ListItem() {
          ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SMALL }) {
            IBestCell({title: '标题', value: '内容'})
            IBestCell({title: '标题', value: '内容', label: '描述信息', hasBorder: false})
          }
        }


        ListItem() {
          ComponentShowContainer({ title: '单元格大小', titlePaddingLeft: SPACE.SMALL }) {
            IBestCell({title: '标题', value: '内容', cellSize: 'large'})
            IBestCell({title: '标题', value: '内容', label: '描述信息', hasBorder: false, cellSize: 'large'})
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '展示图标', titlePaddingLeft: SPACE.SMALL }) {
            IBestCell({title: '标题', value: '内容', iconBuilder: this.StarIcon(), hasBorder: false })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '展示箭头', titlePaddingLeft: SPACE.SMALL }) {
            IBestCell({title: '标题', value: '箭头朝右', isLink: true })
            IBestCell({title: '标题', value: '箭头朝下', isLink: true, arrowDirection: 'bottom' })
            IBestCell({title: '标题', value: '箭头朝左', isLink: true, arrowDirection: 'left' })
            IBestCell({title: '标题', value: '箭头朝上', isLink: true, arrowDirection: 'top', hasBorder: false })

          }
        }

        ListItem() {
          ComponentShowContainer({ title: '必填项', titlePaddingLeft: SPACE.SMALL }) {
            IBestCell({title: '标题', value: '内容', required: true, hasBorder: false, valueBuilder: this.InputContain.bind(this)})
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '内容居中', titlePaddingLeft: SPACE.SMALL }) {
            IBestCell({title: '居中', value: '内容内容内容内容内容内容内容内容内容内容内容内容内容内容', center: true,  iconBuilder: this.StarIcon('32lpx'), isLink: true })
            IBestCell({title: '居上', value: '内容内容内容内容内容内容内容内容内容内容内容内容内容内容', hasBorder: false, iconBuilder: this.StarIcon('32lpx'), isLink: true })

          }
        }

        ListItem() {
          ComponentShowContainer({ title: '使用插槽', titlePaddingLeft: SPACE.SMALL }) {
            IBestCell({title: '标题', value: '内容内容内容内容内容内容内容内容内容内容内容内容内容内容', iconBuilder: this.StarIcon('32lpx'), rightIconBuilder: this.Arrow, clickable: true })
            IBestCell({titleBuilder: this.Title, value: '内容', rightIconBuilder: this.Arrow, clickable: true })
            IBestCell({title: '标题',  iconBuilder: this.StarIcon(), hasBorder: false, rightIconBuilder: this.Arrow, clickable: true })
          }
        }



      }
      .layoutWeight(1)

    }
    .width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(BACKGROUND_COLOR.BASE)
  }
}