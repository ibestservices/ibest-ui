import { IBestButton, IBestTabController, IBestTabItem,
    IBestTabItemType,
    IBestTabs, IBestToast } from '@ibestservices/ibest-ui'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import TitleBar from '../components/TitleBar'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'

@Entry
@Component
struct TabPage {
    @State title: string = (router.getParams() as ComponentRouterParams).title || ''
    @State tabsList: IBestTabItemType[] = [
        {
            label: "标签一",
            name: "1"
        },
        {
            label: "标签二",
            name: "2"
        },
        {
            label: "标签三",
            name: "3"
        },
        {
            label: "标签四",
            name: "4"
        },
        {
            label: "标签五",
            name: "5"
        }
    ]
    @State tabsList1: IBestTabItemType[] = [
        {
            label: "标签一",
            name: "1"
        },
        {
            label: "标签二",
            name: "2"
        },
        {
            label: "标签三",
            name: "3"
        },
        {
            label: "标签四",
            name: "4"
        },
        {
            label: "标签五",
            name: "5"
        },
        {
            label: "标签六",
            name: "6"
        },
        {
            label: "标签七",
            name: "7"
        },
        {
            label: "标签八",
            name: "8"
        },
        {
            label: "标签九",
            name: "9"
        },
        {
            label: "标签十",
            name: "10"
        }
    ]
    @State tabsList2: IBestTabItem[] = [
        new IBestTabItem({
            label: "标签一",
            name: "1"
        }),
        new IBestTabItem({
            label: "标签二",
            name: "2",
            isDisable: true
        }),
        new IBestTabItem({
            label: "标签三",
            name: "3"
        })
    ]
    @State tabsList3: IBestTabItem[] = [
        new IBestTabItem({
            label: "标签一",
            name: "1",
            icon: "https://ibestui.ibestservices.com/favicon.ico"
        }),
        new IBestTabItem({
            label: "标签二",
            name: "2",
            number: 8
        }),
        new IBestTabItem({
            label: "标签三",
            name: "3"
        })
    ]

    @State curTabName: string = "1"
    @State curTabName1: string = "1"
    @State curTabName2: string = "1"
    @State curTabName3: string = "1"
    @State curTabName4: string = "1"
    @State curTabName5: string = "1"
    @State curTabName6: string = "1"

    private tabController: IBestTabController = new IBestTabController()

    build() {
        Column(){
            TitleBar({
                title: this.title
            }).backgroundColor('#FFF')
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }) {
                        IBestTabs({
                            tabsList: this.tabsList,
                            currentName: $curTabName
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '样式风格' }) {
                        IBestTabs({
                            type: "card",
                            tabsList: this.tabsList,
                            currentName: $curTabName
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '收缩布局' }) {
                        Column({space: 20}){
                            IBestTabs({
                                tabHeight: 60,
                                tabWidthType: "auto",
                                tabsList: this.tabsList,
                                currentName: $curTabName
                            })
                            IBestTabs({
                                tabHeight: 60,
                                tabWidthType: "auto",
                                tabsList: this.tabsList1,
                                currentName: $curTabName2
                            })
                            IBestTabs({
                                tabHeight: 60,
                                tabWidthType: "auto",
                                type: "card",
                                tabsList: this.tabsList,
                                currentName: $curTabName
                            })
                            IBestTabs({
                                tabHeight: 60,
                                tabWidthType: "auto",
                                type: "card",
                                tabsList: this.tabsList1,
                                currentName: $curTabName2
                            })
                        }
                        .alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '固定线宽' }) {
                        IBestTabs({
                            tabsList: this.tabsList,
                            tabHeight: 80,
                            isTabLineWidthFixed: true,
                            tabLineWidth: 30,
                            lineOffsetY: 10,
                            currentName: $curTabName
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '禁用标签' }) {
                        Column({space: 20}){
                            IBestTabs({
                                tabsList: this.tabsList2,
                                currentName: $curTabName3
                            })
                            IBestButton({
                                text: "禁用标签3",
                                buttonSize: "small",
                                onClickBtn: () => {
                                    this.tabsList2[2].isDisable = true
                                }
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: 'change事件' }) {
                        IBestTabs({
                            tabsList: this.tabsList,
                            currentName: $curTabName4,
                            onChange: (name: string) => {
                                IBestToast.show("当前点击的是：" + name)
                            }
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义标签' }) {
                        Column({space: 20}){
                            IBestTabs({
                                tabsList: this.tabsList3,
                                currentName: $curTabName5
                            })
                            IBestButton({
                                text: "修改数字",
                                buttonSize: "small",
                                onClickBtn: () => {
                                    if(this.tabsList3[1].number != undefined){
                                        this.tabsList3[1].number += 1
                                    }
                                }
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: 'controller 切换' }) {
                        Column({space: 20}){
                            IBestTabs({
                                tabsList: this.tabsList,
                                currentName: $curTabName6,
                                tabController: this.tabController
                            })
                            IBestButton({
                                text: "跳转标签3",
                                buttonSize: "small",
                                onClickBtn: () => {
                                    this.tabController.changeTab("3")
                                }
                            })
                        }
                    }
                }
            }
            .width(CONTAINER_SIZE.FULL)
            .layoutWeight(1)
            .padding({
                left: SPACE.BASE,
                right: SPACE.BASE,
                bottom: SPACE.BASE
            })
        }
        .width(CONTAINER_SIZE.FULL)
        .height(CONTAINER_SIZE.FULL)
        .backgroundColor(BACKGROUND_COLOR.BASE)
    }
}