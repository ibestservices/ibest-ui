import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function AreaBuilder(_: string, title: string) {
    AreaPage({ title })
}

@Entry
@Component
struct AreaPage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: "area",
        categories: ["2018","2019","2020","2021","2022","2023"],
        series: [
            {
                name: "成交量A",
                data: [35,8,25,37,4,20]
            },
            {
                name: "成交量B",
                data: [70,40,65,100,44,68]
            },
            {
                name: "成交量C",
                data: [100,80,95,150,112,132]
            }
        ],
        padding: [15,15,0,15],
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            gridType: "dash",
            dashLength: 2
        },
        extra: {
            area: {
                type: "straight",
                opacity: 0.2,
                addLine: true,
                width: 2,
                gradient: false,
                activeType: "hollow"
            }
        }
    }
    @State controller1: UChartsController = new UChartsController()
    private opts1: Partial<ChartOptions> = {
        type: "area",
        categories: ["2018","2019","2020","2021","2022","2023"],
        series: [
            {
                name: "成交量A",
                data: [35,8,25,37,4,20]
            },
            {
                name: "成交量B",
                data: [70,40,65,100,44,68]
            },
            {
                name: "成交量C",
                data: [100,80,95,150,112,132]
            }
        ],
        padding: [15,15,0,15],
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            gridType: "dash",
            dashLength: 2
        },
        extra: {
            area: {
                type: "curve",
                opacity: 0.2,
                addLine: true,
                width: 2,
                gradient: true,
                activeType: "hollow"
            }
        }
    }
    @State controller2: UChartsController = new UChartsController()
    private opts2: Partial<ChartOptions> = {
        type: "area",
        categories: ["2018","2019","2020","2021","2022","2023"],
        series: [
            {
                name: "成交量A",
                data: [35,8,25,37,4,20]
            },
            {
                name: "成交量B",
                data: [70,40,65,100,44,68]
            },
            {
                name: "成交量C",
                data: [100,80,95,150,112,132]
            }
        ],
        padding: [15,15,0,15],
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            gridType: "dash",
            dashLength: 2
        },
        extra: {
            area: {
                type: "step",
                opacity: 0.2,
                addLine: true,
                width: 2,
                gradient: true,
                activeType: "hollow"
            }
        }
    }
    @State controller3: UChartsController = new UChartsController()
    private opts3: Partial<ChartOptions> = {
        type: "area",
        series: [
            {
                name: "时间轴1",
                data: [[10000,55],[30000,25],[50000,55],[70000,25],[90000,55]]
            },
            {
                name: "时间轴2",
                data: [[0,25],[20000,55],[40000,25],[60000,55],[80000,25]]
            },
            {
                name: "时间轴3",
                data: [[0,55],[15000,25],[30000,55],[45000,25],[60000,55]]
            }
        ],
        padding: [15,10,0,15],
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: true,
            boundaryGap: "justify"
        },
        yAxis: {
            gridType: "dash",
            dashLength: 2,
            data: [
                {
                    min: 0,
                    max: 80
                }
            ]
        },
        extra: {
            area: {
                type: "curve",
                opacity: 0.2,
                addLine: true,
                width: 2,
                gradient: true,
                activeType: "hollow"
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基本折线区域图' }) {
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
                    ComponentShowContainer({ title: '渐变色曲线区域图' }) {
                        UCharts({
                            contentHeight: CONTAINER_SIZE.CHART_HEIGHT,
                            controller: this.controller1,
                            onReady: () => {
                                this.controller1.updateData(this.opts1)
                            }
                        })
                    }
                }

                ListItem() {
                    ComponentShowContainer({ title: '渐变色时序区域图' }) {
                        UCharts({
                            contentHeight: CONTAINER_SIZE.CHART_HEIGHT,
                            controller: this.controller2,
                            onReady: () => {
                                this.controller2.updateData(this.opts2)
                            }
                        })
                    }
                }

                ListItem() {
                    ComponentShowContainer({ title: '时间轴(矢量轴)区域图' }) {
                        UCharts({
                            contentHeight: CONTAINER_SIZE.CHART_HEIGHT,
                            controller: this.controller3,
                            onReady: () => {
                                this.controller3.updateData(this.opts3)
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