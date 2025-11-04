import { IBestButton, IBestRollingText, IBestRollingTextController } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function RollingTextBuilder(_: string, title: string){
    RollingTextPage({title})
}

@Entry
@Component
struct RollingTextPage {
    @State title: string = ''
    controller: IBestRollingTextController = new IBestRollingTextController()

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }) {
                        IBestRollingText({
                            targetNum: 123
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '翻滚方向' }) {
                        IBestRollingText({
                            targetNum: 888,
                            rollingDirection: "up"
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '停止顺序' }) {
                        IBestRollingText({
                            targetNum: 54321,
                            stopOrder: "rtl"
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义样式' }) {
                        IBestRollingText({
                            startNum: 12345,
                            targetNum: 54321,
                            numWidth: 40,
                            numHeight: 54,
                            textBgColor: '#1989fa',
                            fontColor: '#fff',
                            fontSize: 24,
                            gap: 6,
                            radius: 4
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '手动控制' }) {
                        IBestRollingText({
                            targetNum: 54321,
                            autoStart: false,
                            numWidth: 40,
                            numHeight: 54,
                            textBgColor: '#1989fa',
                            fontColor: '#fff',
                            fontSize: 24,
                            gap: 6,
                            radius: 4,
                            controller: this.controller
                        })
                        Row({space: SPACE.MD}){
                            IBestButton({
                                type: 'primary',
                                text: "开始",
                                onBtnClick: () => {
                                    this.controller.start()
                                }
                            })
                            IBestButton({
                                type: 'primary',
                                text: "重置",
                                onBtnClick: () => {
                                    this.controller.reset()
                                }
                            })
                        }.margin({top: SPACE.SM})
                    }
                }
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg2)
    }
}