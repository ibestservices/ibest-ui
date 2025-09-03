import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function BubbleBuilder(_: string, title: string) {
    BubblePage({ title })
}

@Entry
@Component
struct BubblePage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: 'bubble',
        series: [
            {
                name: "气泡一",
                data: [[95,95,23,"标题1"],[30,55,33,"标题2"]]
            },
                {
                name: "气泡二",
                data: [[130,30,30,"标题3"],[200,90,40,"标题4"]]
            }
        ],
        padding: [15,15,0,15],
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: false,
            gridType: "dash",
            splitNumber: 5,
            boundaryGap: "justify",
            min: 0,
            max: 250
        },
        yAxis: {
            disableGrid: false,
            gridType: "dash",
            data: [
                {
                    min: 0,
                    max: 150
                }
            ]
        },
        extra: {
            bubble: {
                border: 2,
                opacity: 0.5
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '气泡图' }) {
                        UCharts({
                            contentHeight: CONTAINER_SIZE.CHART_HEIGHT,
                            controller: this.controller,
                            onReady: () => {
                                this.controller.updateData(this.opts)
                            }
                        })
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