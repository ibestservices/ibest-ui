import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function GaugeBuilder(_: string, title: string) {
    GaugePage({ title })
}

@Entry
@Component
struct GaugePage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: 'gauge',
        categories: [{"value":0.2,"color":"#1890ff"},{"value":0.8,"color":"#2fc25b"},{"value":1,"color":"#f04864"}],
        series: [
            {
                name: "完成率",
                data: 0.66
            }
        ],
        title: {
            value: "60Km/H",
            fontSize: 25,
            color: "#2fc25b",
            offsetY: 50
        },
        subtitle: {
            value: "实时速度",
            fontSize: 15,
            color: "#666666",
            offsetY: -50
        },
        extra: {
            gauge: {
                type: "default",
                width: 30,
                labelColor: "#666666",
                startAngle: 0.75,
                endAngle: 0.25,
                startNumber: 0,
                endNumber: 100,
                labelFormat: "",
                splitLine: {
                    fixRadius: 0,
                    splitNumber: 10,
                    width: 30,
                    color: "#FFFFFF",
                    childNumber: 5,
                    childWidth: 12
                },
                pointer: {
                    width: 24,
                    color: "auto"
                }
            }
        }
    }
    @State controller1: UChartsController = new UChartsController()
    private opts1: Partial<ChartOptions> = {
        type: 'gauge',
        categories: [{"value":0.2,"color":"#1890ff"},{"value":0.8,"color":"#2fc25b"},{"value":1,"color":"#f04864"}],
        series: [
            {
                name: "完成率",
                data: 0.66
            }
        ],
        title: {
            value: "66Km/H",
            fontSize: 25,
            color: "#2fc25b",
            offsetY: 0
        },
        subtitle: {
            value: "实时速度",
            fontSize: 15,
            color: "#1890ff",
            offsetY: 0
        },
        extra: {
            gauge: {
                type: "progress",
                width: 20,
                labelColor: "#666666",
                startAngle: 0.75,
                endAngle: 0.25,
                startNumber: 0,
                endNumber: 100,
                labelFormat: "",
                splitLine: {
                    fixRadius: -10,
                    splitNumber: 10,
                    width: 15,
                    color: "#FFFFFF",
                    childNumber: 5,
                    childWidth: 12
                },
                pointer: {
                    width: 24,
                    color: "auto"
                }
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基本仪表盘' }) {
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
                    ComponentShowContainer({ title: '其他仪表盘' }) {
                        UCharts({
                            contentHeight: CONTAINER_SIZE.CHART_HEIGHT,
                            controller: this.controller1,
                            onReady: () => {
                                this.controller1.updateData(this.opts1)
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