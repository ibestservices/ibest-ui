import { IBestButton, IBestDatePicker, IBestPickerOption, IBestToast } from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import dayjs from '@hview/dayjs'
import BasePage from '../../components/BasePage'

@Builder
export function DatePickerBuilder(_: string, title: string){
	DatePickerPage({title})
}

@Entry
@Component
struct DatePickerPage {
	@State title: string = ''
	@State selectValue: string[] = dayjs().format("YYYY-MM-DD").split("-")
	@State selectValue1: string[] = dayjs().format("YYYY-MM").split("-")
	@State selectValue2: string[] = dayjs().format("YYYY-MM-DD").split("-")
	@State selectValue3: string[] = dayjs().format("YYYY-MM").split("-")
	@State selectValue4: string[] = []
	@State minDate: Date = dayjs().subtract(5, 'year').toDate()
	@State maxDate: Date = dayjs().add(5, 'year').toDate()
	@State showLunar: boolean = true
	filter(type: string, options: IBestPickerOption[]): IBestPickerOption[]{
		if (type === 'month') {
			return options.filter((option) => Number(option.value) % 6 === 0)
		}
		return options
	}
	build() {
		Column(){
			BasePage({ title: this.title, bgColor: modeColor.bg }) {
				List() {
					ListItem().height(84)
					ListItem() {
						ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SM, card: true }) {
							IBestDatePicker({
								title: "选择日期",
								minDate: this.minDate,
								maxDate: this.maxDate,
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
								minDate: this.minDate,
								maxDate: this.maxDate,
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
								minDate: this.minDate,
								maxDate: this.maxDate,
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
								minDate: this.minDate,
								maxDate: this.maxDate,
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

					ListItem() {
						ComponentShowContainer({ title: "显示农历", titlePaddingLeft: SPACE.SM, card: true }) {
							IBestButton({
								text: "切换农历",
								type: "primary",
								onBtnClick: () => {
									this.showLunar = !this.showLunar
								}
							})
							IBestDatePicker({
								title: "选择年月日",
								value: $selectValue4,
								lunar: this.showLunar,
								showUnit: true,
								onConfirm: (value) => {
									if (this.showLunar) {
										IBestToast.show(value.year + "年" + value.lunarMonth + "月" + value.lunarDay)
									} else {
										IBestToast.show(value.dateStr)
									}
								},
								onChange: (value) => {
									if (this.showLunar) {
										IBestToast.show(value.year + "年" + value.lunarMonth + "月" + value.lunarDay)
									} else {
										IBestToast.show(value.dateStr)
									}
								}
							})
						}
					}

					ListItem().height(50)
				}
			}
		}
	}
}