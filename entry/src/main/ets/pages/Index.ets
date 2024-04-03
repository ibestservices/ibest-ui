import {IBestButton} from '../../../../../library/Index'

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        IBestButton({
          buttonSize: 'mini',
          text: '超小按钮'
        })

        IBestButton({
          buttonSize: 'small',
          type: 'warning',
          loading: true,
          text: '小按钮'
        })

        IBestButton({
          type: 'default',
          loading: true,
          text: '普通按钮'
        })

        IBestButton({
          type: 'danger',
          text: '普通按钮',
          color: 'blue',
          onClickBtn(event){
            console.log('523525', event)
          }
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}