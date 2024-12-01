import router from '@ohos.router';
import { IBestButton, IBestCircleProgress } from '@ibestservices/ibest-ui';
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';
import TitleBar from '../components/TitleBar';
import { LengthMetrics } from '@kit.ArkUI';

@Entry
@Component
struct CircleProgressPage {
    @State title: string = (router.getParams() as ComponentRouterParams).title || ''
    @State value: number = 30

    build() {
        Column() {
            TitleBar({
                title: this.title
            })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }) {
                        IBestCircleProgress({
                            value: $value,
                            text: `${this.value}%`
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '样式定制' }) {
                        Column(){
                            Flex({wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(20), cross: LengthMetrics.vp(20) }}){
                                IBestCircleProgress({
                                    value: $value,
                                    strokeWidth: 6,
                                    text: "宽度定制"
                                })
                                IBestCircleProgress({
                                    value: $value,
                                    color: "#ee0a24",
                                    bgColor: "#ebedf0",
                                    text: "颜色定制"
                                })
                                IBestCircleProgress({
                                    value: $value,
                                    clockwise: false,
                                    text: "逆时针",
                                    color: "#07c160"
                                })
                                IBestCircleProgress({
                                    value: $value,
                                    diameter: 120,
                                    clockwise: false,
                                    text: "大小定制",
                                    color: "#7232dd"
                                })
                            }
                            Row({space: SPACE.SM}){
                                IBestButton({
                                    text: "增加",
                                    type: "primary",
                                    buttonSize: "small",
                                    onClickBtn: () => {
                                        this.value = this.value < 100 ? this.value + 10 : 100
                                    }
                                })
                                IBestButton({
                                    text: "减少",
                                    type: "danger",
                                    buttonSize: "small",
                                    onClickBtn: () => {
                                        this.value = this.value > 0 ? this.value - 10 : 0
                                    }
                                })
                            }
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '起始位置' }) {
                        Flex({wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(20), cross: LengthMetrics.vp(20) }}){
                            IBestCircleProgress({
                                value: $value,
                                startPosition: "left",
                                text: "左侧"
                            })
                            IBestCircleProgress({
                                value: $value,
                                startPosition: "right",
                                text: "右侧"
                            })
                            IBestCircleProgress({
                                value: $value,
                                startPosition: "bottom",
                                text: "底部"
                            })
                            IBestCircleProgress({
                                value: $value,
                                startPosition: "left",
                                clockwise: false,
                                text: "左侧逆时针"
                            })
                            IBestCircleProgress({
                                value: $value,
                                startPosition: "right",
                                clockwise: false,
                                text: "右侧逆时针"
                            })
                            IBestCircleProgress({
                                value: $value,
                                startPosition: "bottom",
                                clockwise: false,
                                text: "底部逆时针"
                            })
                        }
                    }
                }
            }
            .padding({left: SPACE.MD, right: SPACE.MD})
            .width(CONTAINER_SIZE.FULL)
            .layoutWeight(1)
        }
        .height(CONTAINER_SIZE.FULL)
        .backgroundColor(BACKGROUND_COLOR.BASE)
    }
}