import { IBestInputTag } from '@ibestservices/ibest-ui'
import { SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function InputTagBuilder(_: string, title: string) {
	InputTagPage({title})
}

@Entry
@Component
struct InputTagPage {
	@State title: string = ''
	@State value: string[] = ["测试", "测试1"]
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({title: "基础用法"}){
						IBestInputTag({
							value: $value
						})
					}
				}
				ListItem() {
					ComponentShowContainer({title: "自定义样式"}){
						IBestInputTag({
							value: $value,
							space: 8,
							outerBorder: {
								width: { bottom: 1 },
								color: "#1989fa"
							},
							outerRadius: 0,
							tagBgColor: "#1989fa",
							tagFontColor: "#fff",
							fontSize: 14
						})
					}
				}
			}
			.layoutWeight(1)
			.padding({left: SPACE.SM, right: SPACE.SM})
		}
		.hideTitleBar(true)
	}
}