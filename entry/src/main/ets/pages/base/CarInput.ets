import { IBestCarInput } from '@ibestservices/ibest-ui'
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function CarInputBuilder(_: string, title: string){
	CarInputPage({title})
}

@Entry
@Component
struct CarInputPage {
	@State title: string = ''
	@State value: string = ''
	@State value1: string = ''
	@State value2: string = ''
	@State value3: string = ''

	build() {
		NavDestination(){
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						IBestCarInput({
							value: $value
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义键盘配置' }) {
						IBestCarInput({
							value: $value1,
							keyboardConfig: {
								title: '车牌键盘',
								keyHeight: 36
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '格子间距' }) {
						IBestCarInput({
							value: $value2,
							space: 6
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式', space: SPACE.SM }) {
						IBestCarInput({
							value: $value3,
							bdColor: '#3d8af2',
							textColor: '#3d8af2',
							cursorPosition: "bottom",
							cursorColor: "#3d8af2"
						})
						IBestCarInput({
							value: $value3,
							space: 6,
							bgColor: "#1c1c1e",
							textColor: "#fff",
							highlightType: "shadow"
						})
					}
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}