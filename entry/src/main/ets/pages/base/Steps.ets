import { IBestStep, IBestSteps } from "@ibestservices/ibest-ui"
import { modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"

@Builder
export function StepsBuilder(_: string, title: string){
	StepsPage({title})
}

@Entry
@Component
struct StepsPage {
	@State title: string = ''
	@State active: number = 0
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }){
						IBestSteps({
							active: $active
						}){
							IBestStep({title: "步骤一"})
							IBestStep({title: "步骤二"})
							IBestStep({title: "步骤三"})
						}
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