import router from '@ohos.router';
import { IBestButton, IBestCheckbox, IBestSwitch, IBestTag, setIBestUIBaseStyle } from '@ibestservices/ibest-ui';
import { BACKGROUND_COLOR, CONTAINER_SIZE, FONT_SIZE, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import TitleBar from '../components/TitleBar';

@Entry
@Component
struct ThemePage {
  @State title: string = router.getParams()['title'] || '';
  colorText: string = '#07c160';

  aboutToDisappear(){
    // 还原
    setIBestUIBaseStyle({primary: '#3D8AF2'})
  }

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')


      List() {

        ListItem() {
          ComponentShowContainer({ title: '更改primary颜色' }) {
            Row(){
              TextInput({placeholder: '请输入合法颜色值，如red、#07c16', text: this.colorText})
                .fontSize(FONT_SIZE.MINI)
                .layoutWeight(1)
                .margin({
                  right: SPACE.BASE
                })
                .onChange(value=>{
                  this.colorText = value
                })

              IBestButton({
                type: 'primary',
                text: '确定',
                round: true,
                buttonSize: 'small',
                onClickBtn: ()=>{
                 setIBestUIBaseStyle({primary: this.colorText || '#3D8AF2'})
                }
              })
            }

          }
        }


        ListItem() {
          ComponentShowContainer({ title: 'Button组件' }) {
              IBestButton({
                type: 'primary',
                text: '按钮'
              })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: 'Checkbox组件' }) {
            IBestCheckbox({
              value: true,
              name: '1',
              label: '复选框'
            })
          }
        }

        ListItem() {
          ComponentShowContainer({ title: 'Switch组件' }) {
            Row(){
              IBestSwitch({
                value: true
              }).margin({
                right: SPACE.BASE
              })
              IBestSwitch({
                value: true,
                loading: true
              })
            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: 'Tag组件' }) {
            IBestTag({
              type: 'primary',
              text: '标签'
            })
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