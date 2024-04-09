import router from '@ohos.router';
import { IBestButton, IBestCheckbox, IBestCheckboxGroup, CheckboxGroupContext } from '../../../../../library/Index'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'

@Styles
function btnMargin() {
  .margin({ right: SPACE.BASE, bottom: SPACE.BASE })
}

@Builder
function Arrow() {
  Image($r('app.media.startIcon'))
    .width(CONTAINER_SIZE.FORTY_FOUR)

}

@Entry
@Component
struct CheckboxPage {
  @State title: string = router.getParams()['title'] || '';
  /**
   * 全选反选的chekboxGroup的this指向
   */
  checkboxGroupContext: CheckboxGroupContext | null = null

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')


      List() {

        ListItem() {
          ComponentShowContainer({ title: '基础用法' }) {
            Column() {
              IBestCheckbox({
                value: true,
                label: '复选框',
                name: 'checkbox1'
              })
            }.btnMargin()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '禁用状态' }) {
            Column() {
              Column() {
                IBestCheckbox({
                  value: true,
                  disabled: true,
                  label: '复选框',
                  name: 'checkbox2'
                })
              }.btnMargin()

              Column() {
                IBestCheckbox({
                  value: false,
                  disabled: true,
                  label: '复选框',
                  name: 'checkbox3'
                })
              }.btnMargin()
            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义形状' }) {
            Column() {
              Column() {
                IBestCheckbox({
                  value: true,
                  shape: 'square',
                  label: '自定义形状a',
                  name: 'checkbox4'
                })
              }.btnMargin()

              Column() {
                IBestCheckbox({
                  value: false,
                  shape: 'square',
                  label: '自定义形状b',
                  name: 'checkbox5'
                })
              }.btnMargin()
            }
          }
        }


        ListItem() {
          ComponentShowContainer({ title: '自定义颜色' }) {
              Column() {
                IBestCheckbox({
                  value: true,
                  checkedColor: '#ee0a24',
                  shape: 'square',
                  label: '自定义颜色a',
                  name: 'checkbox5'
                })
              }.btnMargin()
            Column() {
                IBestCheckbox({
                  value: true,
                  checkedColor: '#ee0a24',
                  label: '自定义颜色b',
                  name: 'checkbox6'
                })
              }.btnMargin()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义大小' }) {
            Column() {
              IBestCheckbox({
                value: true,
                iconSize: 60,
                label: '自定义大小',
                name: 'checkbox7'
              })
            }.btnMargin()
          }
        }


        ListItem() {
          ComponentShowContainer({ title: '左侧文本' }) {
            Column() {
              IBestCheckbox({
                value: true,
                labelPosition: 'left',
                label: '左侧文本',
                name: 'checkbox8'
              })
            }.btnMargin()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '禁用文本点击' }) {
            Column() {
              IBestCheckbox({
                value: true,
                label: '复选框',
                labelDisabled: true,
                name: 'checkbox9'
              })
            }.btnMargin()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '复选框组', }) {
            IBestCheckboxGroup({ group: 'group1', onChange: (names)=>{
                // console.log(JSON.stringify(names))
              }
            })
            Column() {
              IBestCheckbox({
                value: true,
                group: 'group1',
                label: '复选框a',
                name: 'checkbox10'
              })
            }.btnMargin()

            Column() {
              IBestCheckbox({
                value: true,
                group: 'group1',
                label: '复选框b',
                name: 'checkbox11',
              })
            }.btnMargin()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '水平排列', }) {
            IBestCheckboxGroup({ group: 'group3' })
            Row(){
              Column() {
                IBestCheckbox({
                  value: true,
                  group: 'group3',
                  label: '复选框a',
                  name: 'checkbox10'
                })
              }.btnMargin()

              Column() {
                IBestCheckbox({
                  value: true,
                  group: 'group3',
                  label: '复选框b',
                  name: 'checkbox11',
                })
              }.btnMargin()
            }

          }
        }

        ListItem() {
          ComponentShowContainer({ title: '限制最大可选数', }) {
            IBestCheckboxGroup({ group: 'group2', max: 2 })
            Column() {
              IBestCheckbox({
                value: false,
                group: 'group2',
                label: '复选框a',
                name: 'checkbox1'
              })
            }.btnMargin()

            Column() {
              IBestCheckbox({
                value: false,
                group: 'group2',
                label: '复选框b',
                name: 'checkbox2',
              })
            }.btnMargin()

            Column() {
              IBestCheckbox({
                value: false,
                group: 'group2',
                label: '复选框c',
                name: 'checkbox3',
              })
            }.btnMargin()

          }
        }

        ListItem() {
          ComponentShowContainer({ title: '全选与反选' }) {
            IBestCheckboxGroup({
              group: 'group4',
              onReady: (checkboxGroupContext) => {
               this.checkboxGroupContext = checkboxGroupContext
              }
            })
            Column() {
              IBestCheckbox({
                value: true,
                group: 'group4',
                label: '复选框a',
                name: 'checkbox1'
              })
            }.btnMargin()

            Column() {
              IBestCheckbox({
                value: false,
                group: 'group4',
                label: '复选框b',
                name: 'checkbox2',
              })
            }.btnMargin()

            Column() {
              IBestCheckbox({
                value: false,
                group: 'group4',
                label: '复选框c',
                name: 'checkbox3',
              })
            }.btnMargin()

            Row(){
              Column(){
                IBestButton({
                  text: '全选',
                  onClickBtn: ()=>{
                    this.checkboxGroupContext.toggleAll(true)
                  }
                })
              }.btnMargin()

              Column(){
                IBestButton({
                  text: '反选',
                  onClickBtn: ()=>{
                    this.checkboxGroupContext.toggleAll(false)
                  }
                })
              }.btnMargin()
            }

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