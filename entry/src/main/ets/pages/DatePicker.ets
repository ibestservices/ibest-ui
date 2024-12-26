import {
    IBestDatePicker,
    IBestDatePickerResultType,
    IBestNavBar,
    IBestPickerOption,
    IBestToast
} from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'

@Entry
@Component
struct DatePickerPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
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
		Column() {
			IBestNavBar({
				title: this.title,
				isShowStatusBar: true,
				onLeftClick: () => {
					router.back()
				}
			})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SM, card: true }) {
						IBestDatePicker({
							title: "选择日期",
							minDate: new Date("2020-05-01"),
							maxDate: new Date("2028-05-01"),
							value: $selectValue,
							onConfirm: (value: IBestDatePickerResultType) => {
								IBestToast.show(value.dateStr)
							},
							onChange: (value: IBestDatePickerResultType) => {
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
							onConfirm: (value: IBestDatePickerResultType) => {
								IBestToast.show(value.dateStr)
							},
							onChange: (value: IBestDatePickerResultType) => {
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
							onConfirm: (value: IBestDatePickerResultType) => {
								IBestToast.show(value.dateStr)
							},
							onChange: (value: IBestDatePickerResultType) => {
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
							onConfirm: (value: IBestDatePickerResultType) => {
								IBestToast.show(value.dateStr)
							},
							onChange: (value: IBestDatePickerResultType) => {
								IBestToast.show(value.dateStr)
							}
						})
					}
				}
			}
			.layoutWeight(1)
			.padding({ bottom: SPACE.LG })
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}