import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function ScatterBuilder(_: string, title: string) {
    ScatterPage({ title })
}

@Entry
@Component
struct ScatterPage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: 'scatter',
        series: [
            {
                name: "散点一",
                data: [[10,8.04],[8.07,6.95],[13,7.58],[9.05,8.81],[11,8.33],[14,7.66],[13.4,6.81],[10,6.33],[14,8.96],[12.5,6.82]]
            },
            {
                name: "散点二",
                data: [[9.15,7.2],[11.5,7.2],[3.03,4.23],[12.2,7.83],[2.02,4.47],[1.05,3.33],[4.05,4.96],[6.03,7.24],[12,6.26],[12,8.84],[7.08,5.82],[5.02,5.68]]
            }
        ],
        padding: [15,15,0,15],
        dataLabel: false,
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: false,
            gridType: "dash",
            splitNumber: 5,
            boundaryGap: "justify",
            min: 0
        },
        yAxis: {
            disableGrid: false,
            gridType: "dash"
        },
        extra: {
            // scatter: {}
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '散点图' }) {
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