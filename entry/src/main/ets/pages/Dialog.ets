import router from '@ohos.router';
import { BACKGROUND_COLOR, COLOR_GRAY, CONTAINER_SIZE, DISABLE_COLOR, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { IBestButton } from '@ibestservices/ibest-ui'
import { IBestDialog } from '../../../../../library/Index'

@Entry
@Component
struct DialogPage {
  @State title: string = router.getParams()['title'] || '';
  basicDialogController: CustomDialogController = null;
  @State disabled: boolean = false;
  @State cusTitle: string ='提示'

  @Builder TextContain(){
    Text(this.cusTitle)
  }



  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')

      List() {

        ListItem() {
          ComponentShowContainer({ title: '基础用法' }) {

            IBestDialog({
              title: this.cusTitle,
              message: '我是内容',
              dialogWidth: '320lpx',
              // confirmButtonDisabled: this.disabled,
              // defaultBuilder: this.TextContain.bind(this),
              onReady: controller => {
                this.basicDialogController = controller;

              }
            })
            IBestButton({
              text: '打开弹窗',
              type: 'primary',
              onClickBtn: ()=>{
                this.basicDialogController?.open()
                setTimeout(()=>{
                  this.disabled = true
                  this.cusTitle = this.cusTitle + new Date().getTime()
                }, 3000)
              }
            })
          }
        }
      }.layoutWeight(1)
      .padding({
        left: SPACE.BASE,
        right: SPACE.BASE
      })
    }.width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(BACKGROUND_COLOR.BASE)
  }
}