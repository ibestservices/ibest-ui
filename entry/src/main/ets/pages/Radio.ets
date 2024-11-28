import router from '@ohos.router';
import { IBestCell, IBestRadio, IBestRadioGroup } from '@ibestservices/ibest-ui';
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { ComponentRouterParams } from '../assets/global.type';

@Styles
function btnMargin() {
  .margin({ right: SPACE.SM, bottom: SPACE.SM })
}


@Entry
@Component
struct CheckboxPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''

  @State slectedRadioName: string = '';

  @Builder
  CellRadio(name: string, group: string) {
    IBestRadio({
      name,
      group,
      value: name === this.slectedRadioName
    })
  }

  build() {
    Column() {
      TitleBar({
        title: this.title
      }).backgroundColor('#FFF')


      List() {

        ListItem() {
          ComponentShowContainer({ title: '基础用法' }) {
            Column() {
              IBestRadioGroup({ group: 'group1', onChange: val => {
                  console.log('parent', val)
                }
              })
              Column() {
                IBestRadio({
                  value: true,
                  label: '单选框1',
                  name: 'radio1',
                  group: 'group1'
                })
              }.btnMargin()

              Column() {
                IBestRadio({
                  // 如果你多个都设置true了 那么onchange返回的将会是最后一个的name
                  // value: true,
                  label: '单选框2',
                  name: 'radio2',
                  group: 'group1'
                })
              }.btnMargin()

            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '水平排列' }) {
            Row() {
              IBestRadioGroup({ group: 'group3' })
              Column() {
                IBestRadio({
                  value: true,
                  label: '单选框1',
                  name: 'radio2',
                  group: 'group3'
                })
              }.btnMargin()

              Column() {
                IBestRadio({
                  value: false,
                  label: '单选框2',
                  group: 'group3',
                  name: 'checkbox3'
                })
              }.btnMargin()
            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '禁用状态' }) {
            Column() {
              IBestRadioGroup({ group: 'group2' })
              Column() {
                IBestRadio({
                  value: true,
                  disabled: true,
                  label: '单选框1',
                  name: 'radio2',
                  group: 'radio2'
                })
              }.btnMargin()

              Column() {
                IBestRadio({
                  value: false,
                  disabled: true,
                  label: '单选框2',
                  group: 'group2',
                  name: 'radio3'
                })
              }.btnMargin()
            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义形状' }) {
            Column() {
              IBestRadioGroup({ group: 'group4' })
              Column() {
                IBestRadio({
                  value: true,
                  shape: 'square',
                  group: 'group4',
                  label: '单选框1',
                  name: 'radio4'
                })
              }.btnMargin()

              Column() {
                IBestRadio({
                  value: false,
                  shape: 'square',
                  group: 'group4',
                  label: '单选框2',
                  name: 'radio5'
                })
              }.btnMargin().padding({
                bottom: SPACE.SM
              })


              IBestRadioGroup({ group: 'group5' })
              Column() {
                IBestRadio({
                  value: true,
                  shape: 'dot',
                  group: 'group5',
                  label: '单选框3',
                  name: 'radio6'
                })
              }.btnMargin()

              Column() {
                IBestRadio({
                  value: false,
                  shape: 'dot',
                  group: 'group5',
                  label: '单选框4',
                  name: 'radio7'
                })
              }.btnMargin()
            }
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义颜色' }) {
            IBestRadioGroup({ group: 'group7' })

            Column() {
              IBestRadio({
                group: 'group7',
                checkedColor: '#ee0a24',
                shape: 'square',
                label: '自定义颜色a',
                name: 'radio5'
              })
            }.btnMargin()

            Column() {
              IBestRadio({
                value: true,
                group: 'group7',
                checkedColor: '#ee0a24',
                label: '自定义颜色b',
                name: 'radio6'
              })
            }.btnMargin()

            Column() {
              IBestRadio({
                group: 'group7',
                shape: 'dot',
                checkedColor: '#ee0a24',
                label: '自定义颜色c',
                name: 'radio4'
              })
            }.btnMargin()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '自定义大小' }) {
            IBestRadioGroup({ group: 'group8' })

            Column() {
              IBestRadio({
                value: true,
                iconSize: 30,
                group: 'group8',
                label: '自定义大小',
                name: 'radio'
              })
            }.btnMargin()

            Column() {
              IBestRadio({
                iconSize: 30,
                group: 'group8',
                label: '自定义大小',
                name: 'radio2'
              })
            }.btnMargin()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '左侧文本' }) {
            IBestRadioGroup({ group: 'group9' })

            Column() {
              IBestRadio({
                value: true,
                labelPosition: 'left',
                group: 'group9',
                label: '单选框1',
                name: 'radio'
              })
            }.btnMargin()

            Column() {
              IBestRadio({
                group: 'group9',
                labelPosition: 'left',
                label: '单选框2',
                name: 'radio2'
              })
            }.btnMargin()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '禁用文本点击' }) {
            IBestRadioGroup({ group: 'group10' })

            Column() {
              IBestRadio({
                value: true,
                group: 'group10',
                labelDisabled: true,
                label: '单选框1',
                name: 'radio'
              })
            }.btnMargin()

            Column() {
              IBestRadio({
                group: 'group10',
                labelDisabled: true,
                label: '单选框2',
                name: 'radio2'
              })
            }.btnMargin()
          }
        }

        ListItem() {
          ComponentShowContainer({ title: '搭配单元格组件使用' }) {
            IBestRadioGroup({ group: 'group12' })

            IBestCell({
              title: '单选框1',
              rightIconBuilder: () => this.CellRadio('radio1', 'group12'),
              clickable: true,
              onClickCell: () => {
                this.slectedRadioName = 'radio1'
              }
            })

            IBestCell({
              title: '单选框2',
              rightIconBuilder: () => this.CellRadio('radio2', 'group12'),
              hasBorder: false,
              clickable: true,
              onClickCell: () => {
                this.slectedRadioName = 'radio2'
              }
            })
          }
        }.margin({
          bottom: SPACE.MD
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