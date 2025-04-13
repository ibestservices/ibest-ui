import { IBestDateTimePicker, IBestPickerOption, IBestToast } from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import CustomNavBar from '../../components/CustomNavBar'
@Builder
export function DateTimePickerBuilder(_: string, title: string){
	DatePickerPage({title})
}

@Entry
@Component
struct DatePickerPage {
	@State title: string = ''
	@State selectValue: string[] = ["2025", "04", "13", "20", "12", "50"]
	@State selectValue1: string[] = []

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SM, card: true }) {
						IBestDateTimePicker({
							title: "选择日期时间",
							value: $selectValue,
							onConfirm: (value) => {
								IBestToast.show(value.year + '-' + value.month + '-' + value.day + ' ' + value.hour + ':' + value.minute + ':' + value.second)
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: "显示单位", titlePaddingLeft: SPACE.SM, card: true }) {
						IBestDateTimePicker({
							title: "选择日期",
							showUnit: true,
							value: $selectValue1,
							onConfirm: (value) => {
								IBestToast.show(value.year + '-' + value.month + '-' + value.day + ' ' + value.hour + ':' + value.minute + ':' + value.second)
							}
						})
					}
				}
				ListItem().height(50)
			}
			.layoutWeight(1)
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}