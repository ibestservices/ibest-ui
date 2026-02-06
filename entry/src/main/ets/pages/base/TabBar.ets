import { IBestButton, IBestIcon, IBestTabBar, IBestTabBarItem, IBestToast } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function TabBarBuilder(_: string, title: string){
    TabBarPage({title})
}

@Entry
@Component
struct TabBarPage {
    @State title: string = ''
    @State groupId: string = 'tabBar'
    @State active: number = 0
    @State groupId1: string = 'tabBar1'
    @State active1: string = "search"
    @State groupId2: string = 'tabBar2'
    @State active2: number = 0
    @State groupId3: string = 'tabBar3'
    @State active3: number = 0
    @State groupId4: string = 'tabBar4'
    @State active4: number = 0
    @State show: boolean = true
    @State disabled: boolean = true
    @State groupId5: string = 'tabBar5'
    @State active5: number = 0
    @State groupId6: string = 'tabBar6'
    @State active6: number = 0
    @State groupId7: string = 'tabBar7'
    @State active7: number = 0

    @Builder customActive(){
        Image($r("app.media.icon_like_o"))
            .width(20)
    }
    @Builder customBtn(){
        Row(){
            IBestIcon({
                name: "plus",
                color: Color.White
            })
        }
        .width(50)
        .aspectRatio(1)
        .borderRadius(50)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.Red)
        .position({x: '50%', y: -20})
        .translate({x: "-50%"})
    }

    build() {
		NavDestination(){
			CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SM }) {
                        IBestTabBar({ groupId: this.groupId, active: $active, onChange: active => {
                            IBestToast.show(active.toString())
                        } }){
                            IBestTabBarItem({ groupId: this.groupId, icon: 'wap-home-o', text: "首页" })
                            IBestTabBarItem({ groupId: this.groupId, icon: 'search', text: "搜索" })
                            IBestTabBarItem({ groupId: this.groupId, icon: 'chat-o', text: "消息" })
                            IBestTabBarItem({ groupId: this.groupId, icon: 'manager-o', text: "我的" })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '通过名称匹配', titlePaddingLeft: SPACE.SM }) {
                        IBestTabBar({ groupId: this.groupId1, active: $active1 }){
                            IBestTabBarItem({ groupId: this.groupId1, icon: 'wap-home-o', text: "首页", name: "home" })
                            IBestTabBarItem({ groupId: this.groupId1, icon: 'search', text: "搜索", name: "search" })
                            IBestTabBarItem({ groupId: this.groupId1, icon: 'chat-o', text: "消息", name: "message" })
                            IBestTabBarItem({ groupId: this.groupId1, icon: 'manager-o', text: "我的", name: "my" })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '徽标提示', titlePaddingLeft: SPACE.SM }) {
                        IBestTabBar({ groupId: this.groupId2, active: $active2 }){
                            IBestTabBarItem({ groupId: this.groupId2, icon: 'wap-home-o', text: "首页" })
                            IBestTabBarItem({ groupId: this.groupId2, icon: 'search', text: "搜索", dot: true })
                            IBestTabBarItem({ groupId: this.groupId2, icon: 'chat-o', text: "消息", badgeContent: 5 })
                            IBestTabBarItem({ groupId: this.groupId2, icon: 'manager-o', text: "我的", badgeContent: 88, max: 50 })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '高亮背景', titlePaddingLeft: SPACE.SM }) {
                        IBestTabBar({ groupId: this.groupId3, active: $active3, highlightType: "bgColor" }){
                            IBestTabBarItem({ groupId: this.groupId3, icon: 'wap-home-o', text: "首页" })
                            IBestTabBarItem({ groupId: this.groupId3, icon: 'search', text: "搜索" })
                            IBestTabBarItem({ groupId: this.groupId3, icon: 'chat-o', text: "消息" })
                            IBestTabBarItem({ groupId: this.groupId3, icon: 'manager-o', text: "我的" })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义激活内容', titlePaddingLeft: SPACE.SM }) {
                        IBestTabBar({ groupId: this.groupId4, active: $active4 }){
                            IBestTabBarItem({
                                groupId: this.groupId4,
                                icon: 'wap-home-o',
                                text: "首页",
                                activeBuilder: (): void => this.customActive()
                            })
                            IBestTabBarItem({ groupId: this.groupId4, icon: 'search', text: "搜索" })
                            IBestTabBarItem({ groupId: this.groupId4, icon: 'chat-o', text: "消息", activeIcon: "chat" })
                            IBestTabBarItem({ groupId: this.groupId4, icon: 'manager-o', text: "我的", activeIcon: "manager" })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义样式', titlePaddingLeft: SPACE.SM, space: SPACE.SM }) {
                        IBestTabBar({
                            groupId: this.groupId5,
                            active: $active5,
                            bgColor: "#120907",
                            inactiveColor: "#fff",
                            activeColor: "#ed4040",
                            space: 6,
                            radius: {topLeft: 10, topRight: 10}
                        }){
                            IBestTabBarItem({ groupId: this.groupId5, icon: 'wap-home-o', text: "首页" })
                            IBestTabBarItem({ groupId: this.groupId5, icon: 'search', text: "搜索", show: this.show })
                            IBestTabBarItem({ groupId: this.groupId5, icon: 'chat-o', text: "消息", disabled: this.disabled })
                            IBestTabBarItem({ groupId: this.groupId5, icon: 'manager-o', text: "我的" })
                        }
                        Row({space: SPACE.SM}){
                            IBestButton({
                                type: "primary",
                                text: "切换禁用:" + (this.disabled ? "禁用" : "启用"),
                                onBtnClick: () => {
                                    this.disabled = !this.disabled
                                }
                            })
                            IBestButton({
                                type: "primary",
                                text: "切换显示:" + (this.show ? "显示" : "隐藏"),
                                onBtnClick: () => {
                                    this.show = !this.show
                                }
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义内容', titlePaddingLeft: SPACE.SM }) {
                        IBestTabBar({ groupId: this.groupId6, active: $active6 }){
                            IBestTabBarItem({ groupId: this.groupId6, icon: 'wap-home-o', text: "首页" })
                            IBestTabBarItem({ groupId: this.groupId6, icon: 'search', text: "搜索" })
                            IBestTabBarItem({
                                groupId: this.groupId6,
                                defaultBuilder: (): void => this.customBtn()
                            })
                            IBestTabBarItem({ groupId: this.groupId6, icon: 'chat-o', text: "消息" })
                            IBestTabBarItem({ groupId: this.groupId6, icon: 'manager-o', text: "我的" })
                        }
                    }
                }
				ListItem().height(100)
            }
            .layoutWeight(1)
            IBestTabBar({
                groupId: this.groupId7,
                active: $active7,
                tabBarWidth: "70%",
                highlightType: "bgColor",
                isConvex: true,
                radius: 60,
                tabBarPosition: {
                    left: "15%",
                    bottom: 30
                },
                tabBarShadow: {
                    radius: 20,
                    color: "#f2f3f5"
                }
            }){
                IBestTabBarItem({ groupId: this.groupId7, icon: 'wap-home-o', text: "首页", badgeContent: 20 })
                IBestTabBarItem({ groupId: this.groupId7, icon: 'search', text: "搜索" })
                IBestTabBarItem({ groupId: this.groupId7, icon: 'chat-o', text: "消息" })
                IBestTabBarItem({ groupId: this.groupId7, icon: 'manager-o', text: "我的" })
            }
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg)
    }
}