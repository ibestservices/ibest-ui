import router from '@ohos.router';
import {
    CheckboxGroupContext,
    IBestButton,
    IBestCell,
    IBestCheckbox,
    IBestCheckboxGroup,
    IBestNavBar
} from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, DISABLE_COLOR, modeColor, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';

@Entry
@Component
struct CheckboxPage {
  @State title: string = (router.getParams() as ComponentRouterParams).title || ''
  /**
   * 全选反选的checkboxGroup的this指向
   */
  checkboxGroupContext: CheckboxGroupContext | null = null;
  /**
   * 不确定状态
   */
  @State isIndeterminate: boolean = true;
  /**
   * 不确定状态数据是否选中了全部
   */
  @State isIndeterminateCheckAll: boolean = false;
  /**
   * 全选反选的checkboxGroup的this指向
   */
  checkboxGroupIndeterminateContext: CheckboxGroupContext | null = null;

  /**
   * 搭配单元格组件选中的name
   */
  @State cellCheckedNames: string[] = [];

  /**
   * 最大可选数量
   */
  cellCheckedMaxNum = 2

  @Builder CellCheckbox(name: string, group: string){
    IBestCheckbox({
      name,
      group,
      value: this.cellCheckedNames.includes(name)
    })
  }

  handleClickCell(name: string){
    const index = this.cellCheckedNames.indexOf(name)
    if(index > -1){
      this.cellCheckedNames.splice(index ,1)
    }else{
      (this.cellCheckedMaxNum > this.cellCheckedNames.length) && this.cellCheckedNames.push(name)
    }
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
          ComponentShowContainer({ title: '基础用法' }) {
            IBestCheckbox({
              value: true,
              label: '复选框',
              name: 'checkbox1'
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '禁用状态' }) {
            Column({space: SPACE.SM}) {
              IBestCheckbox({
                value: false,
                disabled: true,
                label: '复选框',
                name: 'checkbox3'
              })
              IBestCheckbox({
                value: true,
                disabled: true,
                label: '复选框',
                name: 'checkbox2'
              })
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '自定义形状' }) {
            IBestCheckbox({
              value: true,
              shape: 'square',
              label: '自定义形状',
              name: 'checkbox4'
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '自定义颜色' }) {
            IBestCheckbox({
              value: true,
              checkedColor: '#ee0a24',
              label: '自定义颜色b',
              name: 'checkbox6'
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '自定义大小' }) {
            IBestCheckbox({
              value: true,
              iconSize: 30,
              label: '自定义大小',
              name: 'checkbox7'
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '左侧文本' }) {
            IBestCheckbox({
              value: true,
              labelPosition: 'left',
              label: '左侧文本',
              name: 'checkbox8'
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '禁用文本点击' }) {
            IBestCheckbox({
              value: true,
              label: '复选框',
              labelDisabled: true,
              name: 'checkbox9'
            })
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '复选框组', }) {
            IBestCheckboxGroup({ group: 'group1', onChange: (names)=>{
                console.log(JSON.stringify(names))
              }
            })
            Column({space: SPACE.SM}) {
              IBestCheckbox({
                value: true,
                group: 'group1',
                label: '复选框a',
                name: 'checkbox10'
              })
              IBestCheckbox({
                value: true,
                group: 'group1',
                label: '复选框b',
                name: 'checkbox11',
              })
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '水平排列', }) {
            IBestCheckboxGroup({ group: 'group3' })
            Row({space: SPACE.SM}){
              IBestCheckbox({
                value: true,
                group: 'group3',
                label: '复选框a',
                name: 'checkbox10'
              })
              IBestCheckbox({
                value: true,
                group: 'group3',
                label: '复选框b',
                name: 'checkbox11',
              })
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '限制最大可选数', }) {
            IBestCheckboxGroup({ group: 'group2', max: 2 })
            Column({space: SPACE.SM}) {
              IBestCheckbox({
                value: false,
                group: 'group2',
                label: '复选框a',
                name: 'checkbox1'
              })
              IBestCheckbox({
                value: false,
                group: 'group2',
                label: '复选框b',
                name: 'checkbox2',
              })
              IBestCheckbox({
                value: false,
                group: 'group2',
                label: '复选框c',
                name: 'checkbox3',
              })
            }
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
            Column({space: SPACE.SM}) {
              IBestCheckbox({
                value: true,
                group: 'group4',
                label: '复选框a',
                name: 'checkbox1'
              })
              IBestCheckbox({
                value: false,
                group: 'group4',
                label: '复选框b',
                name: 'checkbox2',
              })
              IBestCheckbox({
                value: false,
                group: 'group4',
                label: '复选框c',
                name: 'checkbox3',
              })

            }
            Row({space: SPACE.SM}){
              IBestButton({
                text: '全选',
                type: 'primary',
                onClickBtn: ()=>{
                  this.checkboxGroupContext?.toggleAll(true)
                }
              })
              IBestButton({
                text: '反选',
                type: 'warning',
                onClickBtn: ()=>{
                  this.checkboxGroupContext?.toggleAll()
                }
              })
              IBestButton({
                text: '取消选中',
                onClickBtn: ()=>{
                  this.checkboxGroupContext?.toggleAll(false)
                }
              })
            }
            .margin({top: SPACE.XS})
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '不确定状态' }) {
            Column() {
              IBestCheckbox({
                value: this.isIndeterminateCheckAll,
                label: '全选',
                indeterminate: this.isIndeterminate,
                name: 'checkbox10',
                onChange: (checked)=>{
                  this.checkboxGroupIndeterminateContext?.toggleAll(checked)
                }
              })
            }
            .alignItems(HorizontalAlign.Start)
            .width(CONTAINER_SIZE.FULL)
            .padding({
              bottom: SPACE.SM
            })
            .border({width:  {bottom: 1}, color: DISABLE_COLOR.VERY_MINI})
            .margin({
              bottom: SPACE.SM
            })
            IBestCheckboxGroup({
              group: 'group5',
              onChange: (checkedNames)=>{
                const length = checkedNames.length
                this.isIndeterminate = length < 2 && length > 0;
                this.isIndeterminateCheckAll = length === 2
              },
              onReady: (checkboxGroupContext)=>{
                this.checkboxGroupIndeterminateContext = checkboxGroupContext
              }
            })
            Column({space: SPACE.SM}) {
              IBestCheckbox({
                value: false,
                group: 'group5',
                label: '复选框a',
                name: 'checkbox10'
              })
              IBestCheckbox({
                value: true,
                group: 'group5',
                label: '复选框b',
                name: 'checkbox11',
              })
            }
          }
        }
        ListItem() {
          ComponentShowContainer({ title: '搭配单元格组件使用', }) {
            IBestCheckboxGroup({ group: 'group17', max: this.cellCheckedMaxNum})
            IBestCell({
              clickable: true,
              title: '复选框1',
              rightIconBuilder: (): void=>this.CellCheckbox('checkbox1-cell', 'group17'),
              onClickCell: (): void => this.handleClickCell('checkbox1-cell')
            })
            IBestCell({
              clickable: true,
              title: '复选框2',
              rightIconBuilder: (): void=>this.CellCheckbox('checkbox2-cell', 'group17'),
              onClickCell: (): void=>this.handleClickCell('checkbox2-cell')
            })
            IBestCell({
              clickable: true,
              title: '复选框3',
              hasBorder: false,
              rightIconBuilder: (): void=>this.CellCheckbox('checkbox3-cell', 'group17'),
              onClickCell: (): void=>this.handleClickCell('checkbox3-cell')
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
    .backgroundColor(modeColor.bg)
  }
}