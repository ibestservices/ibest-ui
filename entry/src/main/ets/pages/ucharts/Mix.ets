import { CONTAINER_SIZE, modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function MixBuilder(_: string, title: string) {
    MixPage({ title })
}

@Entry
@Component
struct MixPage {
    @State title: string = ''
    @State controller: UChartsController = new UChartsController()
    private opts: Partial<ChartOptions> = {
        type: 'mix',
        categories: ["2018","2019","2020","2021","2022","2023"],
        series: [
            {
                name: "曲面",
                type: "area",
                style: "curve",
                data: [70,50,85,130,64,88]
            },
            {
                name: "柱1",
                index: 1,
                type: "column",
                data: [40,{"value":30,"color":"#f04864"},55,110,24,58]
            },
            {
                name: "柱2",
                index: 1,
                type: "column",
                data: [50,20,75,60,34,38]
            },
            {
                name: "曲线",
                type: "line",
                style: "curve",
                color: "#1890ff",
                disableLegend: true,
                data: [70,50,85,130,64,88]
            },
            {
                name: "折线",
                type: "line",
                color: "#2fc25b",
                data: [120,140,105,170,95,160]
            },
            {
                name: "点",
                index: 2,
                type: "point",
                color: "#f04864",
                data: [100,80,125,150,112,132]
            }
        ],
        padding: [15,15,0,15],
        enableScroll: false,
        legend: {},
        xAxis: {
            disableGrid: true,
            title: "单位：年"
        },
        yAxis: {
            disabled: false,
            disableGrid: false,
            splitNumber: 5,
            gridType: "dash",
            dashLength: 4,
            gridColor: "#CCCCCC",
            padding: 10,
            showTitle: true,
            data: [
                {
                    position: "left",
                    title: "折线"
                },
                {
                    position: "right",
                    min: 0,
                    max: 200,
                    title: "柱状图",
                    textAlign: "left"
                },
                {
                    position: "right",
                    min: 0,
                    max: 200,
                    title: "点",
                    textAlign: "left"
                }
            ]
        },
        extra: {
            mix: {
                column: {
                    width: 20
                }
            }
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({ title: this.title })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '多坐标系混合图' }) {
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
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg2)
    }
}