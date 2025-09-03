import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function RoseBuilder(_: string, title: string) {
    RosePage({ title })
}

@Entry
@Component
struct RosePage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: "rose",
        series: [
            {
                data: [
                    {"name":"一班","value":50},
                    {"name":"二班","value":30},
                    {"name":"三班","value":20},
                    {"name":"四班","value":18},
                    {"name":"五班","value":8}
                ]
            }
        ],
        padding: [5,5,5,5],
        enableScroll: false,
        legend: {
            show: true,
            position: "left",
            lineHeight: 25
        },
        extra: {
            rose: {
                type: "area",
                minRadius: 50,
                activeOpacity: 0.5,
                activeRadius: 10,
                offsetAngle: 0,
                labelWidth: 15,
                border: false,
                borderWidth: 2,
                borderColor: "#FFFFFF"
            }
        }
    }
    @State controller1: UChartsController = new UChartsController()
    private opts1: Partial<ChartOptions> = {
        type: "rose",
        series: [
            {
                data: [
                    {"name":"一班","value":50},
                    {"name":"二班","value":30},
                    {"name":"三班","value":20},
                    {"name":"四班","value":18},
                    {"name":"五班","value":8}
                ]
            }
        ],
        padding: [5,5,5,5],
        enableScroll: false,
        legend: {
            show: true,
            position: "left",
            lineHeight: 25
        },
        extra: {
            rose: {
                type: "radius",
                minRadius: 50,
                activeOpacity: 0.5,
                activeRadius: 10,
                offsetAngle: 0,
                labelWidth: 15,
                border: true,
                borderWidth: 2,
                borderColor: "#FFFFFF",
                linearType: "custom"
            }
        }
    }
    @State controller2: UChartsController = new UChartsController()
    private opts2: Partial<ChartOptions> = {
        type: "rose",
        series: [
            {
                data: [
                    {"name":"一班","value":50},
                    {"name":"二班","value":30},
                    {"name":"三班","value":20},
                    {"name":"四班","value":18,"labelText":"四班:18人"},
                    {"name":"五班","value":8}
                ]
            }
        ],
        padding: [5,5,5,5],
        enableScroll: false,
        legend: {
            show: true,
            position: "left",
            lineHeight: 25
        },
        extra: {
            rose: {
                type: "area",
                minRadius: 50,
                activeOpacity: 0.5,
                activeRadius: 10,
                offsetAngle: 0,
                labelWidth: 15,
                border: false,
                borderWidth: 2,
                borderColor: "#FFFFFF"
            }
        }
    }
    @State controller3: UChartsController = new UChartsController()
    private opts3: Partial<ChartOptions> = {
        type: "rose",
        series: [
            {
                data: [
                    {"name":"一班","value":50,"labelShow":false},
                    {"name":"二班","value":30,"labelShow":false},
                    {"name":"三班","value":20,"labelShow":false},
                    {"name":"四班","value":18},
                    {"name":"五班","value":8,"labelShow":false}
                ]
            }
        ],
        padding: [5,5,5,5],
        enableScroll: false,
        legend: {
            show: true,
            position: "left",
            lineHeight: 25
        },
        extra: {
            rose: {
                type: "area",
                minRadius: 50,
                activeOpacity: 0.5,
                activeRadius: 10,
                offsetAngle: 0,
                labelWidth: 15,
                border: false,
                borderWidth: 2,
                borderColor: "#FFFFFF"
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '面积玫瑰图' }) {
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
                    ComponentShowContainer({ title: '半径玫瑰图+分割线+渐变色' }) {
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
                    ComponentShowContainer({ title: '自定义标签内容' }) {
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
                    ComponentShowContainer({ title: '自定义标签隐藏' }) {
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