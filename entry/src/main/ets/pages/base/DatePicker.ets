import { IBestDatePicker, IBestPickerOption, IBestToast } from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import CustomNavBar from '../../components/CustomNavBar'
@Builder
export function DatePickerBuilder(_: string, title: string){
	DatePickerPage({title})
}

@Entry
@Component
struct DatePickerPage {
	@State title: string = ''
	@State selectValue: string[] = ["2024", "08", "10"]
	@State selectValue1: string[] = ["2024", "08"]
	@State selectValue2: string[] = ["2024", "08", "10"]
	@State selectValue3: string[] = ["2024", "08"]
	filter(type: string, options: IBestPickerOption[]): IBestPickerOption[]{
		if (type === 'month') {
			return options.filter((option) => Number(option.value) % 6 === 0)
		}
		return options
	}
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SM, card: true }) {
						IBestDatePicker({
							title: "选择日期",
							minDate: new Date("2020-05-01"),
							maxDate: new Date("2028-05-01"),
							value: $selectValue,
							onConfirm: (value) => {
								IBestToast.show(value.dateStr)
							},
							onChange: (value) => {
								IBestToast.show(value.dateStr)
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: "选项类型", titlePaddingLeft: SPACE.SM, card: true }) {
						IBestDatePicker({
							title: "选择年月",
							minDate: new Date("2020-05"),
							maxDate: new Date("2028-05"),
							isShowDay: false,
							value: $selectValue1,
							onConfirm: (value) => {
								IBestToast.show(value.dateStr)
							},
							onChange: (value) => {
								IBestToast.show(value.dateStr)
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: "显示单位", titlePaddingLeft: SPACE.SM, card: true }) {
						IBestDatePicker({
							title: "选择日期",
							minDate: new Date("2020-05-01"),
							maxDate: new Date("2028-05-01"),
							showUnit: true,
							value: $selectValue2,
							onConfirm: (value) => {
								IBestToast.show(value.dateStr)
							},
							onChange: (value) => {
								IBestToast.show(value.dateStr)
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: "过滤选项", titlePaddingLeft: SPACE.SM, card: true }) {
						IBestDatePicker({
							title: "选择年月",
							minDate: new Date("2020-05"),
							maxDate: new Date("2028-05"),
							isShowDay: false,
							filter: this.filter,
							value: $selectValue3,
							onConfirm: (value) => {
								IBestToast.show(value.dateStr)
							},
							onChange: (value) => {
								IBestToast.show(value.dateStr)
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