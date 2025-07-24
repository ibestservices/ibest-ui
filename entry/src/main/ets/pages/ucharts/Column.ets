import { modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"
// import { ChartOptions, UCharts, UChartsController } from '@ibestservices/ucharts'

@Builder
export function ColumnBuilder(_: string, title: string){
	ColumnPage({title})
}

@Entry
@Component
struct ColumnPage{
	@State title: string = ''
	// @State chart: UChartsController = new UChartsController()
	// private opts: Partial<ChartOptions> = {
	// 	type: "column",
	// 	categories: ["2018","2019","2020","2021","2022","2023"],
	// 	series: [
	// 		{
	// 			name: "目标值",
	// 			data: [35,36,31,33,13,34]
	// 		},
	// 		{
	// 			name: "完成量",
	// 			data: [18,27,21,24,6,28]
	// 		}
	// 	],
	// 	padding: [15,15,0,5],
	// 	xAxis: {
	// 		disableGrid: true
	// 	},
	// 	yAxis: {
	// 		data: [{min: 0}]
	// 	},
	// 	extra: {
	// 		column: {
	// 			type: "group",
	// 			// width: 30,
	// 			// activeBgColor: "#000000",
	// 			// activeBgOpacity: 0.08
	// 		}
	// 	}
	// }
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }){
						Column() {
							// UCharts({
							// 	controller: this.chart,
							// 	onReady: () => {
							// 		this.chart.updateData(this.opts)
							// 	}
							// })
						}
						.height(300)
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