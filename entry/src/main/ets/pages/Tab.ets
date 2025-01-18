import { IBestButton, IBestNavBar, IBestTabController, IBestTabItem, IBestTabItemType, IBestTabs, IBestToast } from '@ibestservices/ibest-ui'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle'
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
        },
        {
            label: "标签十一",
            name: "11"
        },
        {
            label: "标签十二",
            name: "12"
        },
        {
            label: "标签十三",
            name: "13"
        },
        {
            label: "标签十四",
            name: "14"
        },
        {
            label: "标签十五",
            name: "15"
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

    // @Builder tabContent(){
    //     ForEach([1,2,3], (item: number) => {
    //         Row(){
    //             Text(item.toString())
    //         }
    //         .width("100%")
    //         .height(100)
    //     })
    // }

    build() {
        Column(){
            IBestNavBar({
                title: this.title,
                isShowStatusBar: true,
                onLeftClick: () => {
                    router.back()
                }
            })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }) {
                        IBestTabs({
                            tabsList: this.tabsList,
                            currentName: $curTabName
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '样式风格', titlePaddingLeft: SPACE.MD }) {
                        IBestTabs({
                            type: "card",
                            tabsList: this.tabsList,
                            currentName: $curTabName
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '收缩布局', titlePaddingLeft: SPACE.MD }) {
                        Column({space: 20}){
                            IBestTabs({
                                tabWidthType: "auto",
                                tabsList: this.tabsList,
                                currentName: $curTabName,
                                isShowActiveBg: true,
                                tabBgColor: "transparent",
                                tabLineColor: "#904742",
                                activeBgColor: "#fff",
                                inactiveBgColor: "#904742",
                                inactiveTextColor: '#fff',
                                radius: 4
                            })
                            IBestTabs({
                                tabWidthType: "auto",
                                tabsList: this.tabsList1,
                                currentName: $curTabName2
                            })
                            IBestTabs({
                                tabWidthType: "auto",
                                type: "card",
                                tabsList: this.tabsList,
                                currentName: $curTabName
                            })
                            IBestTabs({
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
                    ComponentShowContainer({ title: '固定线宽', titlePaddingLeft: SPACE.MD }) {
                        IBestTabs({
                            tabsList: this.tabsList,
                            isTabLineWidthFixed: true,
                            tabLineWidth: 15,
                            lineOffsetY: 5,
                            currentName: $curTabName
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '禁用标签', titlePaddingLeft: SPACE.MD }) {
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
                    ComponentShowContainer({ title: 'change事件', titlePaddingLeft: SPACE.MD }) {
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
                    ComponentShowContainer({ title: '自定义标签', titlePaddingLeft: SPACE.MD }) {
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
                    ComponentShowContainer({ title: 'controller 切换', titlePaddingLeft: SPACE.MD }) {
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
            .padding({ bottom: SPACE.SM })
        }
        .width(CONTAINER_SIZE.FULL)
        .height(CONTAINER_SIZE.FULL)
        .backgroundColor(modeColor.bg)
    }
}