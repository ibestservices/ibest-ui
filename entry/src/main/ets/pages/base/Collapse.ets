import {
	IBestButton,
	IBestCollapse,
	IBestCollapseController,
	IBestCollapseItem
} from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';
@Builder
export function CollapseBuilder(_: string, title: string){
	CollapsePage({title})
}

@Entry
@Component
struct CollapsePage {
    @State title: string = ''
    @State activeName: string[] = ['1']
    @State groupId: string = 'group'
    @State list: string[] = ['1']

    @State activeName1: number = 1
    @State groupId1: string = "group1"

    @State activeName2: string[] = ['1']
    @State groupId2: string = "group2"

    @State activeName3: string[] = []
    @State groupId3: string = "group3"

    @State activeName4: number[] = [2]
    @State groupId4: string = "group4"
    private controller: IBestCollapseController = new IBestCollapseController()

    build() {
		NavDestination() {
			CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }) {
                        IBestCollapse({
                            groupId: this.groupId,
                            activeName: $activeName
                        }){
                            IBestCollapseItem({
                                groupId: this.groupId,
                                name: '1',
                                index: 0,
                                title: '标题1'
                            }){
                                ForEach(this.list, (item: string, index: number) => {
                                    Text('代码是写出来给人看的，附带能在机器上运行。')
                                        .fontSize(14)
                                        .fontColor(modeColor.textColor4)
                                        .onClick(() => {
                                            this.list.push('1')
                                        })
                                })
                            }
                            IBestCollapseItem({
                                groupId: this.groupId,
                                name: '2',
                                index: 1,
                                title: '标题2'
                            }){
                                Text('技术无非就是那些开发它的人的共同灵魂。').fontSize(14).fontColor(modeColor.textColor4)
                            }
                            IBestCollapseItem({
                                groupId: this.groupId,
                                name: '3',
                                index: 2,
                                title: '标题3'
                            }){
                                Text('在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准。').fontSize(14).fontColor(modeColor.textColor4)
                            }
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '手风琴', titlePaddingLeft: SPACE.MD }) {
                        IBestCollapse({
                            groupId: this.groupId1,
                            activeName: $activeName1,
                            accordion: true
                        }){
                            IBestCollapseItem({
                                groupId: this.groupId1,
                                name: 1,
                                index: 0,
                                title: '标题1'
                            }){
                                Text('代码是写出来给人看的，附带能在机器上运行。').fontSize(14).fontColor(modeColor.textColor4)
                            }
                            IBestCollapseItem({
                                groupId: this.groupId1,
                                name: 2,
                                index: 1,
                                title: '标题2'
                            }){
                                Text('技术无非就是那些开发它的人的共同灵魂。').fontSize(14).fontColor(modeColor.textColor4)
                            }
                            IBestCollapseItem({
                                groupId: this.groupId1,
                                name: 3,
                                index: 2,
                                title: '标题3'
                            }){
                                Text('在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准。').fontSize(14).fontColor(modeColor.textColor4)
                            }
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '禁用状态', titlePaddingLeft: SPACE.MD }) {
                        IBestCollapse({
                            groupId: this.groupId2,
                            activeName: $activeName2
                        }){
                            IBestCollapseItem({
                                groupId: this.groupId2,
                                name: '1',
                                index: 0,
                                title: '标题1'
                            }){
                                Text('代码是写出来给人看的，附带能在机器上运行。').fontSize(14).fontColor(modeColor.textColor4)
                            }
                            IBestCollapseItem({
                                groupId: this.groupId2,
                                name: '2',
                                index: 1,
                                title: '禁用标题2',
                                disabled: true
                            }){
                                Text('技术无非就是那些开发它的人的共同灵魂。').fontSize(14).fontColor(modeColor.textColor4)
                            }
                            IBestCollapseItem({
                                groupId: this.groupId2,
                                name: '3',
                                index: 2,
                                title: '只读标题3',
                                readOnly: true
                            }){
                                Text('在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准。').fontSize(14).fontColor(modeColor.textColor4)
                            }
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义标题', titlePaddingLeft: SPACE.MD }) {
                        IBestCollapse({
                            groupId: this.groupId3,
                            activeName: $activeName3
                        }){
                            IBestCollapseItem({
                                groupId: this.groupId3,
                                name: '1',
                                index: 0,
                                icon: $r("app.media.icon_like"),
                                title: '标题1',
                                value: "右侧内容"
                            }){
                                Text('代码是写出来给人看的，附带能在机器上运行。').fontSize(14).fontColor(modeColor.textColor4)
                            }
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '实例方法', titlePaddingLeft: SPACE.MD }) {
                        Column(){
                            Text("当前禁用name: 2, 当前激活names: " + this.activeName4.join(",")).margin({bottom: SPACE.BASE})
                            IBestCollapse({
                                groupId: this.groupId4,
                                activeName: $activeName4,
                                controller: this.controller
                            }){
                                IBestCollapseItem({
                                    groupId: this.groupId4,
                                    name: 1,
                                    index: 0,
                                    title: '标题1'
                                }){
                                    Text('代码是写出来给人看的，附带能在机器上运行。').fontSize(14).fontColor(modeColor.textColor4)
                                }
                                IBestCollapseItem({
                                    groupId: this.groupId4,
                                    name: 2,
                                    index: 1,
                                    title: '标题2',
                                    disabled: true
                                }){
                                    Text('技术无非就是那些开发它的人的共同灵魂。').fontSize(14).fontColor(modeColor.textColor4)
                                }
                                IBestCollapseItem({
                                    groupId: this.groupId4,
                                    name: 3,
                                    index: 2,
                                    title: '标题3'
                                }){
                                    Text('在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准。').fontSize(14).fontColor(modeColor.textColor4)
                                }
                            }
                            Column(){
                                Row({space: SPACE.MD}){
                                    IBestButton({
                                        type: "primary",
                                        text: "全部展开",
                                        buttonSize: "small",
                                        onBtnClick: () => {
                                            this.controller.toggleAll(true)
                                        }
                                    })
                                    IBestButton({
                                        type: "primary",
                                        text: "全部收起",
                                        buttonSize: "small",
                                        onBtnClick: () => {
                                            this.controller.toggleAll(false)
                                        }
                                    })
                                    IBestButton({
                                        type: "primary",
                                        text: "切换",
                                        buttonSize: "small",
                                        onBtnClick: () => {
                                            this.controller.toggleAll()
                                        }
                                    })
                                }
                                .padding({top: SPACE.MD, left: SPACE.MD})
                                Row({space: SPACE.MD}){
                                    IBestButton({
                                        type: "primary",
                                        text: "跳过禁用展开",
                                        buttonSize: "small",
                                        onBtnClick: () => {
                                            this.controller.toggleAll({
                                                expanded: true,
                                                skipDisabled: true
                                            })
                                        }
                                    })
                                    IBestButton({
                                        type: "primary",
                                        text: "跳过禁用收起",
                                        buttonSize: "small",
                                        onBtnClick: () => {
                                            this.controller.toggleAll({
                                                expanded: false,
                                                skipDisabled: true
                                            })
                                        }
                                    })
                                    IBestButton({
                                        type: "primary",
                                        text: "跳过禁用切换",
                                        buttonSize: "small",
                                        onBtnClick: () => {
                                            this.controller.toggleAll({
                                                skipDisabled: true
                                            })
                                        }
                                    })
                                }
                                .padding({top: SPACE.MD, left: SPACE.MD})
                            }
                        }.alignItems(HorizontalAlign.Center)
                    }
                }
				ListItem().height(true)
            }
            .layoutWeight(1)
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg)
    }
}