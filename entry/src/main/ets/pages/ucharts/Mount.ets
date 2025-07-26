import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function MountBuilder(_: string, title: string) {
    MountPage({ title })
}

@Entry
@Component
struct MountPage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: "mount",
        series: [
            {
                data: [{"name":"一班","value":82},{"name":"二班","value":63},{"name":"三班","value":86},{"name":"四班","value":65},{"name":"五班","value":79}]
            }
        ],
        padding: [15,15,0,5],
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            data: [
                {
                    min: 0
                }
            ]
        },
        extra: {
            mount: {
                type: "mount",
                widthRatio: 1.5
            }
        }
    }
    @State controller1: UChartsController = new UChartsController()
    private opts1: Partial<ChartOptions> = {
        type: "mount",
        series: [
            {
                data: [{"name":"一班","value":82},{"name":"二班","value":63},{"name":"三班","value":86},{"name":"四班","value":65},{"name":"五班","value":79}]
            }
        ],
        padding: [15,15,0,5],
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            data: [
                {
                    min: 0
                }
            ]
        },
        extra: {
            mount: {
                type: "triangle",
                widthRatio: 1.5
            }
        }
    }
    @State controller2: UChartsController = new UChartsController()
    private opts2: Partial<ChartOptions> = {
        type: "mount",
        series: [
            {
                data: [
                    {"name":"一班","value":82},
                    {"name":"二班","value":-63},
                    {"name":"三班","value":86},
                    {"name":"四班","value":-75},
                    {"name":"五班","value":79}
                ]
            }
        ],
        padding: [15,15,0,5],
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            data: [
                {
                    min: -100,
                    max: 100
                }
            ],
            splitNumber: 4
        },
        extra: {
            mount: {
                type: "mount",
                widthRatio: 1.5,
                borderWidth: 0,
                linearType: "custom"
            }
        }
    }
    @State controller3: UChartsController = new UChartsController()
    private opts3: Partial<ChartOptions> = {
        type: "mount",
        series: [
            {
                data: [
                    {"name":"一班","value":82},
                    {"name":"二班","value":63},
                    {"name":"三班","value":86},
                    {"name":"四班","value":65},
                    {"name":"五班","value":79}
                ]
            }
        ],
        padding: [15,15,0,5],
        enableScroll: true,
        legend: {},
        xAxis: {
            disableGrid: true,
            itemCount: 4,
            scrollShow: true
        },
        yAxis: {
            data: [
                {
                    min: 0
                }
            ]
        },
        extra: {
            mount: {
                type: "sharp",
                widthRatio: 1.5,
                borderWidth: 2,
                linearType: "opacity",
                linearOpacity: 0.1
            }
        }
    }
    @State controller4: UChartsController = new UChartsController()
    private opts4: Partial<ChartOptions> = {
        type: "mount",
        series: [
            {
                data: [
                    {"name":"一班","value":82},
                    {"name":"二班","value":63},
                    {"name":"三班","value":86},
                    {"name":"四班","value":65},
                    {"name":"五班","value":79}
                ]
            }
        ],
        padding: [15,40,0,15],
        enableScroll: false,
        enableMarkLine: true,
        legend: {},
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            data: [
                {
                    min: 0
                }
            ]
        },
        extra: {
            mount: {
                type: "triangle",
                widthRatio: 1,
                borderWidth: 2,
                linearType: "custom"
            },
            markLine: {
                type: "solid",
                dashLength: 4,
                data: [
                    {
                        value: 45,
                        lineColor: "#DE4A42",
                        showLabel: true,
                        labelAlign: "right",
                        labelOffsetX: 0,
                        labelOffsetY: 0,
                        labelText: "均值",
                        labelFontColor: "#666666",
                        labelBgColor: "#DFE8FF",
                        labelBgOpacity: 0.8
                    }
                ]
            }
        }
    }
    @State controller5: UChartsController = new UChartsController()
    private opts5: Partial<ChartOptions> = {
        type: "mount",
        series: [
            {
                data: [
                    {"name":"一班","value":82},
                    {"name":"二班","value":63},
                    {"name":"三班","value":86},
                    {"name":"四班","value":65},
                    {"name":"五班","value":79}
                ]
            }
        ],
        padding: [15,15,0,5],
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: true
        },
        yAxis: {
            data: [
                {
                    min: 0
                }
            ]
        },
        extra: {
            mount: {
                type: "bar",
                widthRatio: 0.3,
                borderWidth: 0,
                barBorderRadius: [
                    50,
                    50,
                    50,
                    50
                ],
                linearType: "custom"
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '圆角山峰图' }) {
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
                    ComponentShowContainer({ title: '三角山峰图' }) {
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
                    ComponentShowContainer({ title: '正负山峰图无边渐变色' }) {
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
                    ComponentShowContainer({ title: '山峰图有边透明渐变+滚动条' }) {
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
                    ComponentShowContainer({ title: '山峰图有边渐变+标记线' }) {
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
                    ComponentShowContainer({ title: '山峰图圆角渐变色柱状图' }) {
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