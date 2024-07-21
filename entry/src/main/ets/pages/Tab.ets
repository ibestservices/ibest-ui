import { IBestButton, IBestTabController, IBestTabItem, IBestTabs, IBestToast } from '@ibestservices/ibest-ui'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import TitleBar from '../components/TitleBar'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'

@Entry
@Component
struct Tab {
    @State title: string = (router.getParams() as ComponentRouterParams).title || ''
    @State tabsList: IBestTabItem[] = [
        new IBestTabItem({
            label: "标签一",
            name: "1"
        }),
        new IBestTabItem({
            label: "标签二",
            name: "2"
        }),
        new IBestTabItem({
            label: "标签三",
            name: "3"
        }),
        new IBestTabItem({
            label: "标签四",
            name: "4"
        }),
        new IBestTabItem({
            label: "标签五",
            name: "5"
        })
    ]
    @State tabsList1: IBestTabItem[] = [
        new IBestTabItem({
            label: "标签一",
            name: "1"
        }),
        new IBestTabItem({
            label: "标签二",
            name: "2"
        }),
        new IBestTabItem({
            label: "标签三",
            name: "3"
        }),
        new IBestTabItem({
            label: "标签四",
            name: "4"
        }),
        new IBestTabItem({
            label: "标签五",
            name: "5"
        }),
        new IBestTabItem({
            label: "标签六",
            name: "6"
        }),
        new IBestTabItem({
            label: "标签七",
            name: "7"
        }),
        new IBestTabItem({
            label: "标签八",
            name: "8"
        }),
        new IBestTabItem({
            label: "标签九",
            name: "9"
        }),
        new IBestTabItem({
            label: "标签十",
            name: "10"
        })
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
            name: "1"
        }),
        new IBestTabItem({
            label: "标签二",
            name: "2"
        }),
        new IBestTabItem({
            label: "标签三",
            name: "3"
        })
    ]
    @State tabsList4: IBestTabItem[] = [
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
    @State curTabName7: string = "1"

    private tabController: IBestTabController = new IBestTabController()

    build() {
        Column(){
            TitleBar({
                title: this.title
            }).backgroundColor('#FFF')
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基本用法' }) {
                        IBestTabs({
                            tabsList: this.tabsList,
                            currentName: this.curTabName
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '样式风格' }) {
                        IBestTabs({
                            type: "card",
                            tabsList: this.tabsList,
                            currentName: this.curTabName1
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
                                currentName: this.curTabName2
                            })
                            IBestTabs({
                                tabHeight: 60,
                                tabWidthType: "auto",
                                tabsList: this.tabsList1,
                                currentName: this.curTabName2
                            })
                            IBestTabs({
                                tabHeight: 60,
                                tabWidthType: "auto",
                                type: "card",
                                tabsList: this.tabsList,
                                currentName: this.curTabName3
                            })
                            IBestTabs({
                                tabHeight: 60,
                                tabWidthType: "auto",
                                type: "card",
                                tabsList: this.tabsList1,
                                currentName: this.curTabName3
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
                            currentName: this.curTabName
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '禁用标签' }) {
                        IBestTabs({
                            tabsList: this.tabsList2,
                            currentName: this.curTabName4
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: 'change事件' }) {
                        IBestTabs({
                            tabsList: this.tabsList,
                            currentName: this.curTabName5,
                            onChange: (name: string) => {
                                IBestToast.show("当前点击的是：" + name)
                            }
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义标签' }) {
                        IBestTabs({
                            tabsList: this.tabsList4,
                            currentName: this.curTabName6
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: 'controller 切换' }) {
                        Column({space: 20}){
                            IBestTabs({
                                tabsList: this.tabsList,
                                currentName: this.curTabName7,
                                tabController: this.tabController
                            })
                            IBestButton({
                                text: "跳转标签3",
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
                right: SPACE.BASE
            })
        }
        .width(CONTAINER_SIZE.FULL)
        .height(CONTAINER_SIZE.FULL)
        .backgroundColor(BACKGROUND_COLOR.BASE)
    }
}