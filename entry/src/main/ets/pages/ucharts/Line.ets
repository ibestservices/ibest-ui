import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function LineBuilder(_: string, title: string) {
    LinePage({ title })
}

@Entry
@Component
struct LinePage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: "line",
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
        padding: [15,10,0,15],
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
            line: {
                type: "straight",
                width: 2,
                activeType: "hollow"
            }
        }
    }
    @State controller1: UChartsController = new UChartsController()
    private opts1: Partial<ChartOptions> = {
        type: "line",
        categories: ["2018","2019","2020","2021","2022","2023"],
        series: [
            {
                name: "成交量A",
                lineType: "dash",
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
        padding: [15,10,0,15],
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
            line: {
                type: "curve",
                width: 2,
                activeType: "hollow"
            }
        }
    }
    @State controller2: UChartsController = new UChartsController()
    private opts2: Partial<ChartOptions> = {
        type: "line",
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
        padding: [15,10,0,15],
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
            line: {
                type: "step",
                width: 2,
                activeType: "hollow"
            }
        }
    }
    @State controller3: UChartsController = new UChartsController()
    private opts3: Partial<ChartOptions> = {
        type: "line",
        categories: ["2018","2019","2020","2021","2022","2023"],
        series: [
            {
                name: "成交量A",
                data: [35,8,null,37,4,20]
            },
            {
                name: "成交量B",
                connectNulls: true,
                data: [70,40,null,100,44,68]
            },
            {
                name: "成交量C",
                data: [100,80,null,150,112,132]
            }
        ],
        padding: [15,10,0,15],
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
            line: {
                type: "straight",
                width: 2,
                activeType: "hollow"
            }
        }
    }
    @State controller4: UChartsController = new UChartsController()
    private opts4: Partial<ChartOptions> = {
        type: "line",
        categories: ["2018","2019","2020","2021","2022","2023"],
        series: [
            {
                name: "成交量A",
                linearColor: [
                    [0, "#1890FF"],
                    [0.25, "#00B5FF"],
                    [0.5, "#00D1ED"],
                    [0.75, "#00E6BB"],
                    [1, "#90F489"]
                ],
                data: [15,45,15,45,15,45]
            },
            {
                name: "成交量B",
                linearColor: [
                    [0, "#91CB74"],
                    [0.25, "#2BDCA8"],
                    [0.5, "#2AE3A0"],
                    [0.75, "#C4D06E"],
                    [1, "#F2D375"]
                ],
                data: [55,85,55,85,55,85]
            },
            {
                name: "成交量C",
                linearColor: [
                    [0, "#FAC858"],
                    [0.33, "#FFC371"],
                    [0.66, "#FFC2B2"],
                    [1, "#FA7D8D"]
                ],
                data: [95,125,95,125,95,125]
            }
        ],
        padding: [15,10,0,15],
        dataLabel: false,
        dataPointShape: false,
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            gridType: "dash",
            dashLength: 2,
            data: [
                {
                    min: 0,
                    max: 150
                }
            ]
        },
        extra: {
            line: {
                type: "curve",
                width: 2,
                activeType: "hollow",
                linearType: "custom"
            }
        }
    }
    @State controller5: UChartsController = new UChartsController()
    private opts5: Partial<ChartOptions> = {
        type: "line",
        categories: ["2018","2019","2020","2021","2022","2023"],
        series: [
            {
                name: "成交量A",
                linearColor: [
                    [0, "#1890FF"],
                    [0.25, "#00B5FF"],
                    [0.5, "#00D1ED"],
                    [0.75, "#00E6BB"],
                    [1, "#90F489"]
                ],
                setShadow: [3, 8, 10, "#1890FF"],
                data: [15,45,15,45,15,45]
            },
            {
                name: "成交量B",
                data: [55,85,55,85,55,85]
            },
            {
                name: "成交量C",
                linearColor: [
                    [0, "#FAC858"],
                    [0.33, "#FFC371"],
                    [0.66, "#FFC2B2"],
                    [1, "#FA7D8D"]
                ],
                setShadow: [3, 8, 10, "#FC8452"],
                data: [95,125,95,125,95,125]
            }
        ],
        padding: [15,10,0,15],
        dataLabel: false,
        dataPointShape: false,
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            gridType: "dash",
            dashLength: 2,
            data: [
                {
                    min: 0,
                    max: 150
                }
            ]
        },
        extra: {
            line: {
                type: "curve",
                width: 2,
                activeType: "hollow",
                linearType: "custom",
                onShadow: true,
                animation: "horizontal"
            }
        }
    }
    @State controller6: UChartsController = new UChartsController()
    private opts6: Partial<ChartOptions> = {
        type: "line",
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
        padding: [15,10,0,15],
        enableScroll: true,
        legend: {},
        xAxis: {
            disableGrid: true,
            scrollShow: true,
            itemCount: 4
        },
        yAxis: {
            gridType: "dash",
            dashLength: 2
        },
        extra: {
            line: {
                type: "straight",
                width: 2,
                activeType: "hollow"
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基本折线图' }) {
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
                    ComponentShowContainer({ title: '基本曲线图' }) {
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
                    ComponentShowContainer({ title: '基本时序图' }) {
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
                    ComponentShowContainer({ title: '折线图+断点续连connectNulls' }) {
                        UCharts({
                            contentHeight: CONTAINER_SIZE.CHART_HEIGHT,
                            controller: this.controller3,
                            onReady: () => {
                                this.controller3.updateData(this.opts3)
                            }
                        })
                    }
                }

                ListItem() {
                    ComponentShowContainer({ title: '渐变色曲线图' }) {
                        UCharts({
                            contentHeight: CONTAINER_SIZE.CHART_HEIGHT,
                            controller: this.controller4,
                            onReady: () => {
                                this.controller4.updateData(this.opts4)
                            }
                        })
                    }
                }

                ListItem() {
                    ComponentShowContainer({ title: '渐变色+阴影+水平动画' }) {
                        UCharts({
                            contentHeight: CONTAINER_SIZE.CHART_HEIGHT,
                            controller: this.controller5,
                            onReady: () => {
                                this.controller5.updateData(this.opts5)
                            }
                        })
                    }
                }

                ListItem() {
                    ComponentShowContainer({ title: '折线图滚动条' }) {
                        UCharts({
                            contentHeight: CONTAINER_SIZE.CHART_HEIGHT,
                            controller: this.controller6,
                            onReady: () => {
                                this.controller6.updateData(this.opts6)
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