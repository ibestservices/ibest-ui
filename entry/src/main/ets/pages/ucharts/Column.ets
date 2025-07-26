import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'
import { IBestButton, IBestToast } from "@ibestservices/ibest-ui"

@Builder
export function ColumnBuilder(_: string, title: string) {
    ColumnPage({ title })
}

@Entry
@Component
struct ColumnPage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: "column",
        padding: [15, 15, 0, 5],
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            data: [{ min: 0 }]
        },
        extra: {
            column: {
                type: "group",
                width: 20,
                activeBgColor: "#000000",
                activeBgOpacity: 0.08
            }
        }
    }
    @State controller1: UChartsController = new UChartsController()
    private opts1: Partial<ChartOptions> = {
        type: "column",
        categories: ["2018", "2019", "2020", "2021", "2022", "2023"],
        series: [
            {
                name: "目标值",
                textColor: "#FFFFFF",
                data: [35, 36, 31, 33, 13, 34],
                color: "#FA7D8D"
            },
            {
                name: "完成量",
                textColor: "#FFFFFF",
                data: [18, 27, 21, 24, 6, 28],
                color: "#EB88E2"
            }
        ],
        padding: [15, 15, 0, 5],
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            data: [{ min: 0 }]
        },
        extra: {
            column: {
                type: "stack",
                width: 30,
                activeBgColor: "#000000",
                activeBgOpacity: 0.08,
                labelPosition: "center"
            }
        }
    }
    @State controller2: UChartsController = new UChartsController()
    private opts2: Partial<ChartOptions> = {
        type: "column",
        categories: ["2021", "2022", "2023"],
        series: [
            {
                name: "目标值",
                data: [33, 13, 34]
            },
            {
                name: "完成量",
                data: [24, 6, 28]
            }
        ],
        padding: [15, 15, 0, 5],
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            data: [{ min: 0 }]
        },
        extra: {
            column: {
                type: "group",
                width: 30,
                activeBgColor: "#000000",
                activeBgOpacity: 0.08,
                linearType: "custom",
                seriesGap: 5,
                linearOpacity: 0.5,
                barBorderCircle: true,
                customColor: [
                    "#FA7D8D",
                    "#EB88E2"
                ]
            }
        }
    }
    @State controller3: UChartsController = new UChartsController()
    private opts3: Partial<ChartOptions> = {
        type: "column",
        categories: ["2018", "2019", "2020", "2021", "2022", "2023"],
        series: [
            {
                name: "成交量A",
                data: [20, -20, 25, -25, 30, -30]
            }
        ],
        padding: [15, 15, 0, 5],
        enableScroll: false,
        legend: {
            show: false
        },
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            data: [
                {
                    min: -40,
                    max: 40
                }
            ],
            splitNumber: 4
        },
        extra: {
            column: {
                type: "group",
                width: 30,
                activeBgColor: "#000000",
                activeBgOpacity: 0.08,
                barBorderCircle: true,
                linearType: "custom"
            }
        }
    }
    @State controller4: UChartsController = new UChartsController()
    private opts4: Partial<ChartOptions> = {
        type: "column",
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
        padding: [15, 15, 0, 5],
        touchMoveLimit: 24,
        enableScroll: true,
        legend: {},
        xAxis: {
            disableGrid: true,
            scrollShow: true,
            itemCount: 4
        },
        yAxis: {
            data: [
                {
                    min: 0
                }
            ]
        },
        extra: {
            column: {
                type: "group",
                width: 30,
                activeBgColor: "#000000",
                activeBgOpacity: 0.08
            }
        }
    }
    @State controller5: UChartsController = new UChartsController()
    private opts5: Partial<ChartOptions> = {
        type: "column",
        categories: ["2020", "2021", "2022", "2023"],
        series: [
            {
                name: "目标值",
                data: [31, 33, 13, 34]
            },
            {
                name: "完成量",
                data: [{ "value": 21, "color": "#EE6666" }, 24, 6, 28]
            }
        ],
        padding: [15, 15, 0, 5],
        enableScroll: false,
        enableMarkLine: true,
        legend: {},
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            data: [{ min: 0 }]
        },
        extra: {
            column: {
                type: "group",
                width: 30,
                activeBgColor: "#000000",
                activeBgOpacity: 0.08,
                seriesGap: 5,
                barBorderRadius: [6, 6, 6, 6]
            },
            markLine: {
                data: [
                    {
                        value: 21,
                        showLabel: true
                    }
                ]
            }
        }
    }

    onDidBuild(): void {
        this.getChartData()
    }

    randomArray(): number[]{
        return Array.from<number, number>({ length: 6 }, () => Math.floor(10 + Math.random() * 90))
    }
    // 获取图表数据
    getChartData(){
        IBestToast.showLoading()
        setTimeout(() => {
            this.opts.categories = ["2018", "2019", "2020", "2021", "2022", "2023"]
            this.opts.series = [
                {
                    name: "目标值",
                    data: this.randomArray()
                },
                {
                    name: "完成量",
                    data: this.randomArray()
                }
            ]
            this.controller.updateData(this.opts)
            IBestToast.hide()
        }, 1500)
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基本柱状图+异步数据' }) {
                        IBestButton({
                            type: 'primary',
                            text: '更新数据',
                            onBtnClick: () => {
                                this.getChartData()
                            }
                        })
                        Column() {
                            UCharts({
                                controller: this.controller
                            })
                        }
                        .height(CONTAINER_SIZE.CHART_HEIGHT)
                    }
                }

                ListItem() {
                    ComponentShowContainer({ title: '堆叠柱状图' }) {
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
                    ComponentShowContainer({ title: '圆角+渐变+半透明柱状图' }) {
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
                    ComponentShowContainer({ title: '正负柱状图' }) {
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

                ListItem() {
                    ComponentShowContainer({ title: '柱状图滚动条' }) {
                        Column() {
                            UCharts({
                                controller: this.controller4,
                                onReady: () => {
                                    this.controller4.updateData(this.opts4)
                                }
                            })
                        }
                        .height(CONTAINER_SIZE.CHART_HEIGHT)
                    }
                }

                ListItem() {
                    ComponentShowContainer({ title: '全圆角柱状图+标记线' }) {
                        Column() {
                            UCharts({
                                controller: this.controller5,
                                onReady: () => {
                                    this.controller5.updateData(this.opts5)
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