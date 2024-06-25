import router from '@ohos.router';
import { BACKGROUND_COLOR, COLOR_GRAY, CONTAINER_SIZE, DISABLE_COLOR, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { IBestDialog, IBestCell, IBestCellGroup } from '@ibestservices/ibest-ui'
import { ComponentRouterParams } from '../assets/global.type';

export interface TextData {
  title: string,
  code: string,
  life: string
  program: string
}

const textData: TextData = {
  title: '提示',
  code: '代码是写出来给人看的，附带能在机器上运行。',
  life: '生命远不止连轴转和忙到极限，人类的体验远比这辽阔、丰富得多。',
  program: '如果解决方法是丑陋的，那就肯定还有更好的解决方法，只是还没有发现而已。'
}

@Entry
@Component
struct DialogPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''
  @State disabled: boolean = false;
  @State dialogTitle: string = '';
  @State dialogMsg: string = '';
  @State showDialogCancelBtn: boolean = false;
  @State inputValue: string = '';
  @State formInputError: boolean = false;
  basicDialogController: CustomDialogController | null = null;
  asyncDialogController: CustomDialogController | null = null;
  slotDialogController: CustomDialogController | null = null;

  @Builder
  FormInputContain() {
    Column() {
      TextInput({ 'placeholder': '请输入' })
        .fontSize('28lpx')
        .placeholderFont({ size: '28lpx' })
        .onChange((value) => {
          this.inputValue = value;
          this.formInputError = false
        })
      if (this.formInputError) {
        Text('不能为空')
          .width(CONTAINER_SIZE.FULL)
          .textAlign(TextAlign.Start)
          .margin({
            top: SPACE.BASE,
            left: SPACE.MINI
          })
          .fontColor(Color.Red)
          .fontSize('24lpx')
          .transition({ type: TransitionType.Insert, opacity: 1 })
          .transition({ type: TransitionType.Delete, opacity: 0 })
      }

    }.width('90%').margin({ top: SPACE.LARGE, bottom: SPACE.LARGE })
  }

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')

      // 基础弹窗
      IBestDialog({
        title: this.dialogTitle,
        message: this.dialogMsg,
        showCancelButton: this.showDialogCancelBtn,
        onReady: controller => {
          this.basicDialogController = controller;
        },
        onConfirm: () => {
          setTimeout(()=>{
            this.showDialogCancelBtn = false
          }, 400)
        },
        onCancel: () => {
          setTimeout(()=>{
            this.showDialogCancelBtn = false
          }, 400)
        }
      })

      // 异步关闭弹窗
      IBestDialog({
        title: textData.title,
        message: textData.life,
        onReady: controller => {
          this.asyncDialogController = controller;
        },
        showCancelButton: true,
        beforeClose: (action) => {
          return new Promise((resolve) => {
            setTimeout(() => {
              resolve(action === 'confirm')
            }, 1000)
          })
        }
      })

      // 使用插槽
      IBestDialog({
        title: textData.title,
        confirmButtonText: '提交',
        showCancelButton: true,
        defaultBuilder: this.FormInputContain.bind(this),
        onReady: controller => {
          this.slotDialogController = controller;
        },
        beforeClose: (action) => {
          if (action === 'cancel') {
            return true
          }
          const valueLength = this.inputValue.trim().length;
          this.formInputError = !valueLength;
          return !this.formInputError
        },
        onConfirm: () => {

        }
      })

      List() {
        ListItem() {
          ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SMALL }) {
            IBestCellGroup({ inset: true }) {
              IBestCell({
                title: '提示弹窗',
                isLink: true,
                onClickCell: () => {
                  this.dialogTitle = textData.title
                  this.dialogMsg = textData.code
                  this.basicDialogController?.open()
                }
              })
              IBestCell({
                title: '提示弹窗（无标题）',
                isLink: true,
                onClickCell: () => {
                  this.dialogTitle = ''
                  this.dialogMsg = textData.life
                  this.basicDialogController?.open()
                }
              })
              IBestCell({
                title: '确认弹窗',
                isLink: true,
                hasBorder: false,
                onClickCell: () => {
                  this.dialogTitle = textData.title
                  this.dialogMsg = textData.life
                  this.showDialogCancelBtn = true;
                  this.basicDialogController?.open()
                }
              })
            }

          }
        }

        ListItem() {
          ComponentShowContainer({ title: '异步关闭', titlePaddingLeft: SPACE.SMALL }) {
            IBestCellGroup({ inset: true }) {
              IBestCell({
                title: '异步关闭',
                isLink: true,
                hasBorder: false,
                onClickCell: () => {
                  this.asyncDialogController?.open()
                }
              })
            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '使用插槽', titlePaddingLeft: SPACE.SMALL }) {
            IBestCellGroup({ inset: true }) {
              IBestCell({
                title: '使用插槽',
                isLink: true,
                hasBorder: false,
                onClickCell: () => {
                  this.formInputError = false;
                  this.inputValue = '';
                  this.slotDialogController?.open()
                }
              })
            }
          }
        }
      }.layoutWeight(1)

    }.width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(BACKGROUND_COLOR.BASE)
  }
}