import { IBestSectorProgress, IBestSlider } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';
import { LengthMetrics } from '@kit.ArkUI';

@Builder
export function SectorProgressBuilder(_: string, title: string){
    SectorProgressPage({title})
}

@Entry
@Component
struct SectorProgressPage {
    @State title: string = ''
    @State value: number = 30

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }) {
                        IBestSectorProgress({
                            value: $value,
                            text: `${this.value}%`
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '样式定制' }) {
                        Column(){
                            Flex({wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center, space: { main: LengthMetrics.vp(14), cross: LengthMetrics.vp(14) }}){
                                IBestSectorProgress({
                                    value: $value,
                                    diameter: 80,
                                    text: "宽度定制"
                                })
                                IBestSectorProgress({
                                    value: $value,
                                    bgColor: "#ebedf0",
                                    sectorBgColor: "#ee0a24",
                                    text: "颜色定制"
                                })
                                IBestSectorProgress({
                                    value: $value,
                                    clockwise: false,
                                    text: "逆时针"
                                })
                                IBestSectorProgress({
                                    value: $value,
                                    text: "边框",
                                    outerBorder: {width: 1, color: Color.Green}
                                })
                                IBestSectorProgress({
                                    value: $value,
                                    text: "过渡动画",
                                    enableAnimation: true
                                })
                            }
                            Row({space: SPACE.SM}){
                                IBestSlider({
                                    value: $value
                                })
                            }
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '起始位置' }) {
                        Flex({wrap: FlexWrap.Wrap, space: { main: LengthMetrics.vp(14), cross: LengthMetrics.vp(14) }}){
                            IBestSectorProgress({
                                value: $value,
                                startPosition: "left",
                                text: "左侧"
                            })
                            IBestSectorProgress({
                                value: $value,
                                startPosition: "right",
                                text: "右侧"
                            })
                            IBestSectorProgress({
                                value: $value,
                                startPosition: "bottom",
                                text: "底部"
                            })
                            IBestSectorProgress({
                                value: $value,
                                startPosition: "left",
                                clockwise: false,
                                text: "左侧逆时针"
                            })
                            IBestSectorProgress({
                                value: $value,
                                startPosition: "right",
                                clockwise: false,
                                text: "右侧逆时针"
                            })
                            IBestSectorProgress({
                                value: $value,
                                startPosition: "bottom",
                                clockwise: false,
                                text: "底部逆时针"
                            })
                        }
                    }
                }

                ListItem().height(50)
            }
            .padding({left: SPACE.MD, right: SPACE.MD})
            .layoutWeight(1)
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg)
    }
}