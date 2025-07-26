import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function FunnelBuilder(_: string, title: string) {
    FunnelPage({ title })
}

@Entry
@Component
struct FunnelPage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: "funnel",
        series: [
            {
                data: [
                    {"name":"一班","centerText":"50","value":50},
                    {"name":"二班","centerText":"30","value":30},
                    {"name":"三班","centerText":"20","value":20},
                    {"name":"四班","centerText":"18","value":18},
                    {"name":"五班","centerText":"8","value":8}
                ]
            }
        ],
        padding: [15,15,0,15],
        enableScroll: false,
        extra: {
            funnel: {
                activeOpacity: 0.3,
                activeWidth: 10,
                border: true,
                borderWidth: 2,
                borderColor: "#FFFFFF",
                fillOpacity: 1,
                labelAlign: "right"
            }
        }
    }
    @State controller1: UChartsController = new UChartsController()
    private opts1: Partial<ChartOptions> = {
        type: "funnel",
        series: [
            {
                data: [
                    {"name":"一班","centerText":"50","value":50},
                    {"name":"二班","centerText":"30","value":30,"labelShow":false},
                    {"name":"三班","centerText":"20","value":20,"labelShow":false},
                    {"name":"四班","centerText":"18","value":18,"labelText":"四班:18人"},
                    {"name":"五班","centerText":"8","value":8,"labelShow":false}
                ]
            }
        ],
        padding: [15,15,0,15],
        enableScroll: false,
        extra: {
            funnel: {
                activeOpacity: 0.3,
                activeWidth: 10,
                border: true,
                borderWidth: 2,
                borderColor: "#FFFFFF",
                fillOpacity: 1,
                labelAlign: "right",
                linearType: "custom",
                minSize: 20
            }
        }
    }
    @State controller2: UChartsController = new UChartsController()
    private opts2: Partial<ChartOptions> = {
        type: "funnel",
        series: [
            {
                data: [
                    {"name":"一班","centerText":"50","value":50},
                    {"name":"二班","centerText":"30","value":30},
                    {"name":"三班","centerText":"20","value":20},
                    {"name":"四班","centerText":"18","value":18},
                    {"name":"五班","centerText":"8","value":8}
                ]
            }
        ],
        padding: [15,15,0,15],
        enableScroll: false,
        extra: {
            funnel: {
                activeOpacity: 0.3,
                activeWidth: 10,
                border: true,
                borderWidth: 2,
                borderColor: "#FFFFFF",
                fillOpacity: 1,
                labelAlign: "right",
                type: "triangle"
            }
        }
    }
    @State controller3: UChartsController = new UChartsController()
    private opts3: Partial<ChartOptions> = {
        type: "funnel",
        series: [
            {
                data: [
                    {"name":"一班","centerText":"50","value":50},
                    {"name":"二班","centerText":"30","value":30},
                    {"name":"三班","centerText":"20","value":20},
                    {"name":"四班","centerText":"18","value":18},
                    {"name":"五班","centerText":"8","value":8}
                ]
            }
        ],
        padding: [15,15,0,15],
        enableScroll: false,
        extra: {
            funnel: {
                activeOpacity: 0.3,
                activeWidth: 10,
                border: true,
                borderWidth: 2,
                borderColor: "#FFFFFF",
                fillOpacity: 1,
                labelAlign: "left",
                type: "pyramid"
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '标准漏斗图' }) {
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
                    ComponentShowContainer({ title: '渐变色+自定义标签' }) {
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
                    ComponentShowContainer({ title: '倒三角形漏斗图' }) {
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
                    ComponentShowContainer({ title: '金字塔形漏斗图' }) {
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