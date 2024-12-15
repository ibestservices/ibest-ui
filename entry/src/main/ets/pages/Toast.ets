import { IBestCell, IBestCellGroup, IBestNavBar, IBestToast } from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle'

@Entry
@Component
struct ToastPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''

  showSpinnerLoading(){
    IBestToast.show({
      type: "loading",
      loadingType: "spinner",
      message: "加载中...",
      onOpened: () => {
        // 可在此处延时关闭toast
        console.log("toast打开成功")
      }
    })
    setTimeout(() => {
      // 也可在此处关闭toast
      IBestToast.hide()
    }, 2000)
  }
  // 动态更新提示
  showCountDownLoading(){
    let count = 3
    let toast = IBestToast.show({
      type: "loading",
      message: `倒计时 ${count} 秒`,
      duration: 0
    })
    let timer = setInterval(() => {
      count--
      if (count) {
        toast.message = `倒计时 ${count} 秒`
      } else {
        clearInterval(timer)
        IBestToast.hide()
      }
    }, 1000)
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
              Column() {
                IBestCell({
                  title: '文字提示',
                  isLink: true,
                  onClickCell: () => {
                    IBestToast.show("提示内容")
                  }
                })
                IBestCell({
                  title: '成功提示',
                  isLink: true,
                  onClickCell: () => {
                    IBestToast.show({
                      type: "success",
                      message: "提示内容"
                    })
                  }
                })
                IBestCell({
                  title: '警告提示',
                  isLink: true,
                  onClickCell: () => {
                    IBestToast.show({
                      type: "warning",
                      message: "提示内容"
                    })
                  }
                })
                IBestCell({
                  title: '失败提示',
                  isLink: true,
                  onClickCell: () => {
                    IBestToast.show({
                      type: "fail",
                      message: "提示内容"
                    })
                  }
                })
                IBestCell({
                  title: '加载提示',
                  isLink: true,
                  hasBorder: false,
                  onClickCell: () => {
                    IBestToast.showLoading()
                    setTimeout(() => {
                      IBestToast.hide()
                    }, 1500)
                  }
                })
              }
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '自定义图标', titlePaddingLeft: SPACE.XS }) {
            IBestCellGroup() {
              Column() {
                IBestCell({
                  title: '自定义图标',
                  isLink: true,
                  onClickCell: () => {
                    IBestToast.show({
                      icon: $r("app.media.app_icon"),
                      message: "提示内容",
                      iconWidth: 50
                    })
                  }
                })
                IBestCell({
                  title: '自定义图片',
                  isLink: true,
                  onClickCell: () => {
                    IBestToast.show({
                      icon: "https://ibestui.ibestservices.com/favicon.ico",
                      message: "提示内容"
                    })
                  }
                })
                IBestCell({
                  title: '自定义加载图标类型',
                  isLink: true,
                  hasBorder: false,
                  onClickCell: () => {
                    this.showSpinnerLoading()
                  }
                })
              }
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '自定义位置', titlePaddingLeft: SPACE.XS }) {
            IBestCellGroup() {
              Column() {
                IBestCell({
                  title: '顶部',
                  isLink: true,
                  onClickCell: () => {
                    IBestToast.show({
                      position: "top",
                      offsetY: "20%",
                      message: "提示内容"
                    })
                  }
                })
                IBestCell({
                  title: '底部',
                  isLink: true,
                  hasBorder: false,
                  onClickCell: () => {
                    IBestToast.show({
                      position: "bottom",
                      offsetY: "-20%",
                      message: "提示内容"
                    })
                  }
                })
              }
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '文字换行方式', titlePaddingLeft: SPACE.XS }) {
            IBestCellGroup() {
              Column() {
                IBestCell({
                  title: '换行时截断单词',
                  isLink: true,
                  onClickCell: () => {
                    IBestToast.show({
                      wordBreak: "break-all",
                      message: "This message will contain a incomprehensibilities long word."
                    })
                  }
                })
                IBestCell({
                  title: '换行时不截断单词',
                  isLink: true,
                  hasBorder: false,
                  onClickCell: () => {
                    IBestToast.show({
                      wordBreak: "break-word",
                      message: "This message will contain a incomprehensibilities long word."
                    })
                  }
                })
              }
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '动态更新提示', titlePaddingLeft: SPACE.XS }) {
            IBestCellGroup() {
              Column() {
                IBestCell({
                  title: '动态更新提示',
                  isLink: true,
                  hasBorder: false,
                  onClickCell: () => {
                    this.showCountDownLoading()
                  }
                })
              }
            }
          }
        }
      }.layoutWeight(1)
      .padding({ bottom: SPACE.SM })
    }
    .width(CONTAINER_SIZE.FULL)
    .height(CONTAINER_SIZE.FULL)
    .backgroundColor(modeColor.bg)
  }
}