import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function WordBuilder(_: string, title: string) {
    WordPage({ title })
}

@Entry
@Component
struct WordPage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: 'word',
        series: [
            {
                name: "IBest-UI",
                textSize: 25
            },
            {
                name: "轻量",
                textSize: 20
            },
            {
                name: "易用",
                textSize: 20
            },
            {
                name: "可定制主题",
                textSize: 20
            },
            {
                name: "深色模式",
                textSize: 20
            },
            {
                name: "V2",
                textSize: 20
            },
            {
                name: "组件丰富",
                textSize: 20
            },
            {
                name: "UCharts",
                textSize: 20
            },
            {
                name: "图表",
                textSize: 20
            },
            {
                name: "类型支持",
                textSize: 12
            }
        ],
        enableScroll: false,
        extra: {
            word: {
                type: "normal"
            }
        }
    }
    @State controller1: UChartsController = new UChartsController()
    private opts1: Partial<ChartOptions> = {
        type: 'word',
        series: [
            {
                name: "IBest-UI",
                textSize: 25
            },
            {
                name: "轻量",
                textSize: 20
            },
            {
                name: "易用",
                textSize: 20
            },
            {
                name: "可定制主题",
                textSize: 20
            },
            {
                name: "深色模式",
                textSize: 20
            },
            {
                name: "V2",
                textSize: 20
            },
            {
                name: "组件丰富",
                textSize: 20
            },
            {
                name: "UCharts",
                textSize: 20
            },
            {
                name: "图表",
                textSize: 20
            },
            {
                name: "类型支持",
                textSize: 12
            }
        ],
        enableScroll: false,
        extra: {
            word: {
                type: "vertical"
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '词云图水平排列' }) {
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
                    ComponentShowContainer({ title: '词云图水平垂直混排' }) {
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

                ListItem().height(50)
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg2)
    }
}