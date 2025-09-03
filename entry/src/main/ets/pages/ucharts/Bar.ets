import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function BarBuilder(_: string, title: string) {
    BarPage({ title })
}

@Entry
@Component
struct BarPage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: 'bar',
        categories: ["2018", "2019", "2020", "2021", "2022", "2023"],
        series: [
            {
                name: "目标值",
                data: [35, 36, 31, 33, 13, 34]
            },
            {
                name: "完成量",
                data: [18, 27, 21, 24, 6, 28]
            }
        ],
        padding: [15, 30, 0, 5],
        enableScroll: false,
        legend: {},
        xAxis: {
            boundaryGap: "justify",
            disableGrid: false,
            min: 0,
            axisLine: false,
            max: 70
        },
        yAxis: {},
        extra: {
            bar: {
                type: "stack",
                width: 30,
                meterBorder: 1,
                meterFillColor: "#FFFFFF",
                activeBgColor: "#000000",
                activeBgOpacity: 0.08,
                categoryGap: 2
            }
        }
    }
    @State controller1: UChartsController = new UChartsController()
    private opts1: Partial<ChartOptions> = {
        type: 'bar',
        categories: ["2020", "2021", "2022", "2023"],
        series: [
            {
                name: "目标值",
                data: [31, 33, 13, 34]
            },
            {
                name: "完成量",
                data: [21, 24, 6, 28]
            }
        ],
        padding: [15, 30, 0, 5],
        enableScroll: false,
        legend: {},
        xAxis: {
            boundaryGap: "justify",
            disableGrid: false,
            min: 0,
            axisLine: false,
            max: 40
        },
        yAxis: {},
        extra: {
            bar: {
                type: "group",
                width: 30,
                meterBorder: 1,
                meterFillColor: "#FFFFFF",
                activeBgColor: "#000000",
                activeBgOpacity: 0.08,
                linearType: "custom",
                barBorderCircle: true,
                seriesGap: 2,
                categoryGap: 2
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '堆叠条状图' }) {
                        UCharts({
                            contentHeight: CONTAINER_SIZE.CHART_HEIGHT,
                            controller: this.controller,
                            onReady: () => {
                                this.controller.updateData(this.opts)
                            }
                        })
                    }
                }

                ListItem() {
                    ComponentShowContainer({ title: '圆角条状图+渐变色' }) {
                        UCharts({
                            contentHeight: CONTAINER_SIZE.CHART_HEIGHT,
                            controller: this.controller1,
                            onReady: () => {
                                this.controller1.updateData(this.opts1)
                            }
                        })
                    }
                }

                ListItem().height(50)
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg2)
    }
}