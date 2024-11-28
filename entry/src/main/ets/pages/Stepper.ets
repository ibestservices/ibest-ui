import TitleBar from '../components/TitleBar';
import router from '@ohos.router';
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';
import { IBestStepper } from '@ibestservices/ibest-ui';

@Entry
@Component
struct StepperPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')

      List() {
        ListItem() {
          ComponentShowContainer({ title: '基础用法' }) {
            IBestStepper({
              onChange(val){
                console.log('触发变化了', val)
              }
            })
          }
        }.margin({
          bottom: SPACE.SM
        })

        ListItem() {
          ComponentShowContainer({ title: '步长设置' }) {
            IBestStepper({
              step: 2
            })
          }
        }.margin({
          bottom: SPACE.SM
        })

        ListItem() {
          ComponentShowContainer({ title: '限制输入范围' }) {
            IBestStepper({
              defaultValue: 5,
              min: 5,
              max: 8
            })
          }
        }.margin({
          bottom: SPACE.SM
        })

        ListItem() {
          ComponentShowContainer({ title: '限制输入整数' }) {
            IBestStepper({
              integer: true
            })
          }
        }.margin({
          bottom: SPACE.SM
        })

        ListItem() {
          ComponentShowContainer({ title: '禁用状态' }) {
            IBestStepper({
              disabled: true
            })
          }
        }.margin({
          bottom: SPACE.SM
        })

        ListItem() {
          ComponentShowContainer({ title: '禁用输入框' }) {
            IBestStepper({
              disableInput: true,
              defaultValue: 10
            })
          }
        }.margin({
          bottom: SPACE.SM
        })

        ListItem() {
          ComponentShowContainer({ title: '固定小数位数' }) {
            IBestStepper({
              defaultValue: 14,
              step: 0.2,
              decimalLength: 1
            })
          }
        }.margin({
          bottom: SPACE.SM
        })

        ListItem() {
          ComponentShowContainer({ title: '自定义大小' }) {
            IBestStepper({
              inputWidth: 40,
              buttonSize: 32
            })
          }
        }.margin({
          bottom: SPACE.SM
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
    .backgroundColor(BACKGROUND_COLOR.BASE)
  }
}