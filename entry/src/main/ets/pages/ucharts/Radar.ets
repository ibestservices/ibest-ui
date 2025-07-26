import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function RadarBuilder(_: string, title: string) {
    RadarPage({ title })
}

@Entry
@Component
struct RadarPage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: "radar",
        categories: ["维度1","维度2","维度3","维度4","维度5","维度6"],
        series: [
            {
                name: "成交量1",
                data: [90,110,165,195,187,172]
            },
            {
                name: "成交量2",
                data: [190,210,105,35,27,102]
            }
        ],
        padding: [5,5,5,5],
        dataLabel: false,
        enableScroll: false,
        legend: {
            show: true,
            position: "right",
            lineHeight: 25
        },
        extra: {
            radar: {
                gridType: "radar",
                gridColor: "#CCCCCC",
                gridCount: 3,
                opacity: 0.2,
                max: 200,
                labelShow: true,
                border: true
            }
        }
    }
    @State controller1: UChartsController = new UChartsController()
    private opts1: Partial<ChartOptions> = {
        type: "radar",
        categories: ["维度1","维度2","维度3","维度4","维度5","维度6"],
        series: [
            {
                name: "成交量1",
                data: [90,110,165,195,187,172]
            },
            {
                name: "成交量2",
                data: [190,210,105,35,27,102]
            }
        ],
        padding: [5,5,5,5],
        dataLabel: false,
        enableScroll: false,
        legend: {
            show: true,
            position: "right",
            lineHeight: 25
        },
        extra: {
            radar: {
                gridType: "circle",
                gridColor: "#CCCCCC",
                gridCount: 3,
                opacity: 0.2,
                max: 200,
                labelShow: true
            }
        }
    }
    @State controller2: UChartsController = new UChartsController()
    private opts2: Partial<ChartOptions> = {
        type: "radar",
        categories: ["维度1","维度2","维度3","维度4","维度5","维度6"],
        series: [
            {
                name: "成交量1",
                data: [90,110,165,195,187,172]
            },
            {
                name: "成交量2",
                data: [190,210,105,35,27,102]
            }
        ],
        padding: [5,5,5,5],
        dataLabel: false,
        dataPointShape: false,
        enableScroll: false,
        legend: {
            show: true,
            position: "right",
            lineHeight: 25
        },
        extra: {
            radar: {
                gridType: "circle",
                gridColor: "#CCCCCC",
                gridCount: 3,
                opacity: 0.2,
                max: 200,
                labelShow: true,
                axisLabel: true,
                gridEval: 2,
                border: true
            }
        }
    }
    @State controller3: UChartsController = new UChartsController()
    private opts3: Partial<ChartOptions> = {
        type: "radar",
        categories: ["维度1","维度2","维度3","维度4","维度5","维度6"],
        series: [
            {
                name: "成交量1",
                data: [90,110,165,195,187,172]
            }
        ],
        padding: [5,5,5,5],
        dataLabel: true,
        dataPointShape: false,
        enableScroll: false,
        legend: {
            show: true,
            position: "right",
            lineHeight: 25
        },
        extra: {
            radar: {
                gridType: "circle",
                gridColor: "#CCCCCC",
                gridCount: 3,
                opacity: 1,
                max: 240,
                labelShow: true,
                linearType: "custom",
                border: false
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '多边形雷达图' }) {
                        Column() {
                            UCharts({
                                controller: this.controller,
                                onReady: () => {
                                    this.controller.updateData(this.opts)
                                }
                            })
                        }
                        .height(CONTAINER_SIZE.CHART_HEIGHT)
                    }
                }

                ListItem() {
                    ComponentShowContainer({ title: '圆形雷达图' }) {
                        Column() {
                            UCharts({
                                controller: this.controller1,
                                onReady: () => {
                                    this.controller1.updateData(this.opts1)
                                }
                            })
                        }
                        .height(CONTAINER_SIZE.CHART_HEIGHT)
                    }
                }

                ListItem() {
                    ComponentShowContainer({ title: '刻度标签+网格抽稀' }) {
                        Column() {
                            UCharts({
                                controller: this.controller2,
                                onReady: () => {
                                    this.controller2.updateData(this.opts2)
                                }
                            })
                        }
                        .height(CONTAINER_SIZE.CHART_HEIGHT)
                    }
                }

                ListItem() {
                    ComponentShowContainer({ title: '渐变色雷达图' }) {
                        Column() {
                            UCharts({
                                controller: this.controller3,
                                onReady: () => {
                                    this.controller3.updateData(this.opts3)
                                }
                            })
                        }
                        .height(CONTAINER_SIZE.CHART_HEIGHT)
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