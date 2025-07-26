import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function ArcbarBuilder(_: string, title: string) {
    ArcbarPage({ title })
}

@Entry
@Component
struct ArcbarPage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: "arcbar",
        series: [
            {
                name: "正确率",
                color: "#2fc25b",
                data: 0.8
            }
        ],
        title: {
            value: "80%",
            fontSize: 35,
            color: "#2fc25b"
        },
        subtitle: {
            value: "正确率",
            fontSize: 25,
            color: "#666666"
        },
        extra: {
            arcbar: {
                type: "default",
                width: 12,
                backgroundColor: "#E9E9E9",
                startAngle: 0.75,
                endAngle: 0.25,
                gap: 2,
                linearType: "custom"
            }
        }
    }
    @State controller1: UChartsController = new UChartsController()
    private opts1: Partial<ChartOptions> = {
        type: "arcbar",
        series: [
            {
                name: "一班",
                data: 0.8
            },
            {
                name: "二班",
                data: 0.6
            },
            {
                name: "三班",
                data: 0.45
            },
            {
                name: "四班",
                data: 0.3
            },
            {
                name: "五班",
                data: 0.15
            }
        ],
        title: {
            value: "指标",
            fontSize: 35,
            color: "#1890ff"
        },
        subtitle: {
            value: "默认标题",
            fontSize: 15,
            color: "#666666"
        },
        extra: {
            arcbar: {
                type: "circle",
                width: 12,
                backgroundColor: "#E9E9E9",
                startAngle: 1.5,
                endAngle: 0.25,
                gap: 2
            }
        }
    }
    @State controller2: UChartsController = new UChartsController()
    private opts2: Partial<ChartOptions> = {
        type: "arcbar",
        series: [
            {
                name: "正确率",
                color: "#2fc25b",
                data: 0.8
            }
        ],
        title: {
            value: "80%",
            fontSize: 35,
            color: "#2fc25b"
        },
        subtitle: {
            value: "正确率",
            fontSize: 25,
            color: "#666666"
        },
        extra: {
            arcbar: {
                type: "default",
                width: 12,
                backgroundColor: "#E9E9E9",
                startAngle: 0.25,
                endAngle: 0.75,
                gap: 2,
                direction: "ccw",
                linearType: "custom"
            }
        }
    }
    @State controller3: UChartsController = new UChartsController()
    private opts3: Partial<ChartOptions> = {
        type: "arcbar",
        series: [
            {
                name: "一班",
                data: 0.8
            },
            {
                name: "二班",
                data: 0.6
            },
            {
                name: "三班",
                data: 0.45
            },
            {
                name: "四班",
                data: 0.3
            },
            {
                name: "五班",
                data: 0.15
            }
        ],
        title: {
            value: "指标",
            fontSize: 35,
            color: "#1890ff"
        },
        subtitle: {
            value: "默认标题",
            fontSize: 15,
            color: "#666666"
        },
        extra: {
            arcbar: {
                type: "circle",
                width: 12,
                backgroundColor: "#E9E9E9",
                startAngle: 1.5,
                endAngle: 0.25,
                gap: 2,
                direction: "ccw"
            }
        }
    }
    @State controller4: UChartsController = new UChartsController()
    private opts4: Partial<ChartOptions> = {
        type: "arcbar",
        series: [
            {
                name: "正确率",
                color: "#2fc25b",
                data: 0.8
            }
        ],
        title: {
            value: "80%",
            fontSize: 35,
            color: "#2fc25b"
        },
        subtitle: {
            value: "正确率",
            fontSize: 25,
            color: "#666666"
        },
        extra: {
            arcbar: {
                type: "circle",
                width: 12,
                backgroundColor: "#E9E9E9",
                startAngle: 1.5,
                endAngle: 0.25,
                gap: 2
            }
        }
    }
    @State controller5: UChartsController = new UChartsController()
    private opts5: Partial<ChartOptions> = {
        type: "arcbar",
        series: [
            {
                name: "正确率",
                color: "#2fc25b",
                data: 0.8
            }
        ],
        title: {
            value: "80%",
            fontSize: 35,
            color: "#2fc25b"
        },
        subtitle: {
            value: "正确率",
            fontSize: 25,
            color: "#666666"
        },
        extra: {
            arcbar: {
                type: "circle",
                width: 12,
                backgroundColor: "#E9E9E9",
                startAngle: 1.5,
                endAngle: 0.25,
                gap: 2,
                lineCap: "butt"
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '圆弧进度条+渐变色' }) {
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
                    ComponentShowContainer({ title: '多重整圆进度条' }) {
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
                    ComponentShowContainer({ title: '逆时针+圆弧进度条' }) {
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
                    ComponentShowContainer({ title: '逆时针+多重整圆进度条' }) {
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
                    ComponentShowContainer({ title: '圆角整圆进度条' }) {
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
                    ComponentShowContainer({ title: '平角整圆进度条' }) {
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