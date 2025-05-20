import { IBestCell, IBestCellGroup, IBestCarKeyboard } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function CarKeyboardBuilder(_:string, title: string){
	CarKeyboardPage({title})
}

@Entry
@Component
struct CarKeyboardPage {
	@State title: string = ''
	@State visible: boolean = false
	@State value: string = ''
	@State visible1: boolean = false
	@State value1: string = ''
	@State visible2: boolean = false
	@State value2: string = ''

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					IBestCellGroup({ inset: true }) {
						IBestCell({
							title: '默认键盘',
							value: this.value,
							clickable: true,
							onCellClick: () => {
								this.visible = true
							}
						})
						IBestCell({
							title: '最大长度',
							value: this.value1,
							clickable: true,
							onCellClick: () => {
								this.visible1 = true
							}
						})
						IBestCell({
							title: '自定义样式',
							value: this.value2,
							clickable: true,
							hasBorder: false,
							onCellClick: () => {
								this.visible2 = true
							}
						})
					}
				}
			}
			.layoutWeight(1)
			.padding({ top: SPACE.SM, bottom: SPACE.SM })
			IBestCarKeyboard({
				visible: $visible,
				value: $value
			})
			IBestCarKeyboard({
				visible: $visible1,
				value: $value1,
				maxLength: 7
			})
			IBestCarKeyboard({
				visible: $visible2,
				value: $value2,
				title: "车牌键盘",
				keyHeight: 36
			})
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}