import { IBestButton, IBestDialogUtil, IBestTree, IBestTreeController, IBestTreeData, IBestTreeNodeData } from '@ibestservices/ibest-ui'
import { modeColor } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function TreeBuilder(_: string, title: string) {
    TreePage({title})
}

@Entry
@Component
struct TreePage {
    @State title: string = ''
    @State data: IBestTreeData[] = [
        {
            label: 'Level one 1',
            children: [
                {
                    label: 'Level two 1-1',
                    children: [
                        {
                            label: 'Level three 1-1-1',
                            children: [
                                {
                                    label: 'Level four 1-1-1-1',
                                },
                                {
                                    label: 'Level four 1-1-1-2',
                                },
                            ],
                        },
                        {
                            label: 'Level three 1-1-2',
                            children: [
                                {
                                    label: 'Level four 1-1-2-1',
                                },
                                {
                                    label: 'Level four 1-1-2-2',
                                },
                            ],
                        },
                    ],
                },
                {
                    label: 'Level two 1-2',
                    children: [
                        {
                            label: 'Level three 1-2-1',
                        },
                        {
                            label: 'Level three 1-2-2',
                        },
                    ],
                },
            ],
        },
        {
            label: 'Level one 2',
            children: [
                {
                    label: 'Level two 2-1',
                    children: [
                        {
                            label: 'Level three 2-1-1',
                        },
                        {
                            label: 'Level three 2-1-2',
                        },
                    ],
                },
                {
                    label: 'Level two 2-2',
                    children: [
                        {
                            label: 'Level three 2-2-1',
                        },
                        {
                            label: 'Level three 2-2-2',
                        },
                    ],
                },
            ],
        },
        {
            label: 'Level one 3',
            children: [
                {
                    label: 'Level two 3-1',
                    children: [
                        {
                            label: 'Level three 3-1-1',
                        },
                        {
                            label: 'Level three 3-1-2',
                        },
                    ],
                },
                {
                    label: 'Level two 3-2',
                    children: [
                        {
                            label: 'Level three 3-2-1',
                        },
                        {
                            label: 'Level three 3-2-2',
                        },
                    ],
                },
            ],
        }
    ]
    @State data1: IBestTreeData[] = [
        {
            label: 'Level one 1',
            value: '1',
            children: [
                {
                    label: 'Level two 1-1',
                    value: '1-1'
                }
            ]
        },
        {
            label: 'Level one 2',
            value: '2',
            children: [
                {
                    label: 'Level two 2-1',
                    value: '2-1'
                },
                {
                    label: 'Level two 2-2',
                    value: '2-2',
                    disabled: true
                }
            ]
        },
        {
            label: 'Level one 3',
            value: '3',
            disabled: true,
            children: [
                {
                    label: 'Level two 3-1',
                    value: '3-1'
                },
                {
                    label: 'Level two 3-2',
                    value: '3-2'
                }
            ]
        }
    ]
    @State data2: IBestTreeData[] = [
        {
            label: 'Level one 1',
            value: '1'
        },
        {
            label: 'Level one 2',
            value: '2'
        }
    ]
    @State data3: IBestTreeData[] = [
        {
            label: 'Level one 1',
            children: [
                {
                    label: 'Level two 1-1',
                    children: [
                        {
                            label: 'Level three 1-1-1'
                        },
                        {
                            label: 'Level three 1-1-2'
                        },
                    ],
                },
                {
                    label: 'Level two 1-2',
                    children: [
                        {
                            label: 'Level three 1-2-1',
                        },
                        {
                            label: 'Level three 1-2-2',
                        },
                    ],
                },
            ],
        },
        {
            label: 'Level one 2',
            children: [
                {
                    label: 'Level two 2-1',
                    children: [
                        {
                            label: 'Level three 2-1-1',
                        },
                        {
                            label: 'Level three 2-1-2',
                        },
                    ],
                },
                {
                    label: 'Level two 2-2',
                    children: [
                        {
                            label: 'Level three 2-2-1',
                        },
                        {
                            label: 'Level three 2-2-2',
                        },
                    ],
                },
            ],
        },
        {
            label: 'Level one 3',
            children: [
                {
                    label: 'Level two 3-1',
                    children: [
                        {
                            label: 'Level three 3-1-1',
                        },
                        {
                            label: 'Level three 3-1-2',
                        },
                    ],
                },
                {
                    label: 'Level two 3-2',
                    children: [
                        {
                            label: 'Level three 3-2-1',
                        },
                        {
                            label: 'Level three 3-2-2',
                        },
                    ],
                },
            ],
        }
    ]
    @State data4: IBestTreeData[] = [
        {
            label: 'Level one 1',
            value: 1,
            children: [
                {
                    label: 'Level two 1-1',
                    value: 4,
                    children: [
                        {
                            label: 'Level three 1-1-1',
                            value: 9,
                        },
                        {
                            label: 'Level three 1-1-2',
                            value: 10,
                        }
                    ]
                }
            ]
        },
        {
            label: 'Level one 2',
            value: 2,
            children: [
                {
                    label: 'Level two 2-1',
                    value: 5
                },
                {
                    label: 'Level two 2-2',
                    value: 6
                }
            ]
        },
        {
            label: 'Level one 3',
            value: 3,
            children: [
                {
                    label: 'Level two 3-1',
                    value: 7
                },
                {
                    label: 'Level two 3-2',
                    value: 8
                }
            ]
        }
    ]
    private controller: IBestTreeController = new IBestTreeController()
    private nodeId: number = 1000

    @Builder customNodeBuilder(node: IBestTreeNodeData){
        Row(){
            Text(node.label).fontSize(14)
            Row({space: 10}){
                Text("添加").fontColor("#1989fa").onClick(() => {
                    node.append({
                        label: "添加节点",
                        value: this.nodeId++
                    })
                })
                Text("删除").fontColor("#ed4040").onClick(() => {
                    node.remove()
                })
            }
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.SpaceBetween)
    }

    lazyLoad(nodeData: IBestTreeData, level: number, cb: (arr: IBestTreeData[]) => void){
        console.log('lazyLoad', JSON.stringify(nodeData), level)
        setTimeout(() => {
            if(level == 0){
                cb(nodeData.value == '1' ? [
                    {
                        label: 'Level two 1-1',
                        value: '1-1'
                    },
                    {
                        label: 'Level two 1-2',
                        value: '1-2'
                    }
                ] : [
                    {
                        label: 'Level two 2-1',
                        value: '2-1'
                    },
                    {
                        label: 'Level two 2-2',
                        value: '2-2'
                    }
                ])
            }else if(level == 1){
                cb(nodeData.value == '1-1' ? [
                    {
                        label: 'Level three 1-1-1',
                        value: '1-1-1'
                    },
                    {
                        label: 'Level three 1-1-2',
                        value: '1-1-2',
                        isLeaf: true
                    }
                ] : [
                    {
                        label: 'Level three 2-1-1',
                        value: '2-1-1'
                    },
                    {
                        label: 'Level three 2-1-2',
                        value: '2-1-2'
                    }
                ])
            }else {
                cb([])
            }
        }, 1000)
    }
    build() {
        NavDestination(){
            CustomNavBar({title: this.title})
            List(){
                ListItem(){
                    ComponentShowContainer({ title: "基础用法" }) {
                        IBestTree({
                            data: $data,
                            onNodeClick: (data: IBestTreeData, level: number) => {
                                console.log('onNodeClick', JSON.stringify(data), level)
                            }
                        })
                    }
                }
                ListItem(){
                    ComponentShowContainer({ title: "可选择" }) {
                        Column(){
                            Text("单选")
                            IBestTree({
                                data: $data1,
                                selectType: "single",
                                selectOnClickNode: true,
                                defaultExpandKeys: ['2', '3'],
                                onSelectChange: (data: IBestTreeData, level: number) => {
                                    console.log('onSelectChange', data.label, level)
                                }
                            })
                        }.alignItems(HorizontalAlign.Start)
                        Column() {
                            Text("多选")
                            IBestTree({
                                data: $data1,
                                selectType: "multiple",
                                defaultExpandKeys: ['2', '3'],
                                onSelectChange: (data: IBestTreeData, level: number, selected?: boolean, indeterminate?: boolean) => {
                                    console.log('onSelectChange', data.label, level, selected, indeterminate)
                                }
                            })
                        }.margin({top: 12}).alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem(){
                    ComponentShowContainer({ title: "懒加载节点" }) {
                        IBestTree({
                            data: $data2,
                            lazyLoad: (nodeData: IBestTreeData, level: number, cb: (arr: IBestTreeData[]) => void): void => this.lazyLoad(nodeData, level, cb)
                        })
                    }
                }
                ListItem(){
                    ComponentShowContainer({ title: "手风琴" }) {
                        IBestTree({
                            data: $data,
                            accordion: true
                        })
                    }
                }
                ListItem(){
                    ComponentShowContainer({ title: "可拖拽" }) {
                        IBestTree({
                            data: $data3,
                            enableDrag: true,
                            onNodeDrop: (dragNode: IBestTreeNodeData, dropNode: IBestTreeNodeData) => {
                                IBestDialogUtil.open({
                                    message: `拖拽节点为${dragNode.label}, 拖入节点为${dropNode.label}`
                                })
                            }
                        })
                    }
                }
                ListItem(){
                    ComponentShowContainer({ title: "自定义节点" }) {
                        IBestTree({
                            data: $data4,
                            defaultExpandAll: true,
                            nodeBuilder: (node: IBestTreeNodeData): void => this.customNodeBuilder(node)
                        })
                    }
                }
                ListItem(){
                    ComponentShowContainer({ title: "组件方法" }) {
                        IBestTree({
                            data: $data4,
                            selectType: "multiple",
                            defaultExpandAll: true,
                            controller: this.controller
                        })
                        Row({space: 12}){
                            IBestButton({
                                type: "primary",
                                text: "设置选中节点",
                                onBtnClick: () => {
                                    this.controller.setCheckedNodes([5, 6, 9])
                                }
                            })
                            IBestButton({
                                type: "primary",
                                text: "获取选中节点",
                                onBtnClick: () => {
                                    const nodes = this.controller.getCheckedNodes()
                                    IBestDialogUtil.open({
                                        message: `选中节点为${nodes.map(e => e.label).join("、")}`
                                    })
                                }
                            })
                            IBestButton({
                                type: "primary",
                                text: "重置",
                                onBtnClick: () => {
                                    this.controller.reset()
                                }
                            })
                        }
                        .margin({top: 12})
                    }
                }
                ListItem().height(100)
            }
            .layoutWeight(1)
            .padding({left: 20, right: 20})
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg2)
    }
}