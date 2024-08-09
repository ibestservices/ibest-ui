import { IBestDatePicker, IBestField, IBestPopup, IBestToast } from '@ibestservices/ibest-ui'
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'

@Entry
@Component
struct DatePickerPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State selectValue: string[] = ["2024", "08", "09"]

	build() {
		Column() {
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SMALL, card: true }) {
						IBestDatePicker({
							title: "选择日期",
							value: this.selectValue,
							onConfirm: (selectedValues: Array<string>, selectTexts: Array<string>) => {
								IBestToast.show(selectTexts.join('-'))
							},
							onChange: (selectedValues: Array<string>, selectTexts: Array<string>) => {
								IBestToast.show(selectTexts.join('-'))
							}
						})
					}
				}
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(BACKGROUND_COLOR.BASE)
	}
}