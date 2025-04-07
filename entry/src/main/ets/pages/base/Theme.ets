import {
	IBestButton,
	IBestCheckbox,
	IBestCircleProgress,
	IBestProgress,
	IBestRadio,
	IBestRadioGroup,
	IBestSwitch,
	IBestTabs,
	IBestTag,
	setIBestUIBaseStyle
} from '@ibestservices/ibest-ui';
import { FONT_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';
import { getRandomColor } from '../../utils/utils';

@Builder
export function ThemeBuilder(_: string, title: string){
	ThemePage({title})
}

@Entry
@Component
struct ThemePage {
	@State title: string = ''
	@State curTabName: string = "1"
	@State colorText: string = '#07c160';
	@State group: string = "themeGroup"
	@State active: string = "1"
	@State switchValue: boolean = true
	@State progressValue: number = 50
	aboutToDisappear() {
		setIBestUIBaseStyle({ primary: '#3D8AF2' })
	}
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_switch", $r("app.string.color")) }) {
						Row() {
							TextInput({ placeholder: $r("app.string.custom_placeholder", $r("app.string.custom_legal_color")), text: $$this.colorText })
								.fontSize(FONT_SIZE.SM)
								.layoutWeight(1)
								.margin({
									right: SPACE.SM
								})
							IBestButton({
								type: 'primary',
								text: $r("app.string.confirm"),
								round: true,
								buttonSize: 'small',
								onBtnClick: () => {
									setIBestUIBaseStyle({ primary: this.colorText || '#3D8AF2' })
									this.colorText = getRandomColor()
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.component_button") }) {
						IBestButton({
							type: 'primary',
							text: $r("app.string.button")
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.component_checkbox") }) {
						IBestCheckbox({
							value: true,
							name: '1',
							label: $r("app.string.content")
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.component_radio") }) {
						IBestRadioGroup({ group: this.group, active: $active }) {
							IBestRadio({ group: this.group, label: $r("app.string.content"), name: '1' })
							IBestRadio({ group: this.group, label: $r("app.string.content"), name: '2' })
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.component_switch") }) {
						Row() {
							IBestSwitch({
								value: $switchValue
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.component_circleprogress") }) {
						IBestCircleProgress({
							value: $progressValue,
							text: `50%`
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.component_progress") }) {
						IBestProgress({
							value: $progressValue
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.component_tab") }) {
						IBestTabs({
							tabsList: [
								{
									label: $r("app.string.custom_option", 1),
									name: "1"
								},
								{
									label: $r("app.string.custom_option", 2),
									name: "2"
								},
								{
									label: $r("app.string.custom_option", 3),
									name: "3"
								},
								{
									label: $r("app.string.custom_option", 4),
									name: "4"
								},
								{
									label: $r("app.string.custom_option", 5),
									name: "5"
								}
							],
							currentName: $curTabName
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.component_tag") }) {
						IBestTag({
							type: 'primary',
							text: $r("app.string.tag")
						})
					}
				}
				ListItem().height(50)
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}