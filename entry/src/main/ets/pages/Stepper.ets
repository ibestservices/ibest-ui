import router from '@ohos.router';
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';
import { IBestNavBar, IBestStepper } from '@ibestservices/ibest-ui';

@Entry
@Component
struct StepperPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''

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
          ComponentShowContainer({ title: '基础用法' }) {
            IBestStepper({
              onChange(val){
                console.log('触发变化了', val)
              }
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '步长设置' }) {
            IBestStepper({
              step: 2
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '限制输入范围' }) {
            IBestStepper({
              defaultValue: 5,
              min: 5,
              max: 8
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '限制输入整数' }) {
            IBestStepper({
              integer: true
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '禁用状态' }) {
            IBestStepper({
              disabled: true
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '禁用输入框' }) {
            IBestStepper({
              disableInput: true,
              defaultValue: 10
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '固定小数位数' }) {
            IBestStepper({
              defaultValue: 14,
              step: 0.2,
              decimalLength: 1
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '自定义大小' }) {
            IBestStepper({
              inputWidth: 40,
              buttonSize: 32
            })
          }
        }
      }
      .layoutWeight(1)
      .padding({
        left: SPACE.SM,
        right: SPACE.SM
      })
    }
    .width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(modeColor.bg2)
  }
}