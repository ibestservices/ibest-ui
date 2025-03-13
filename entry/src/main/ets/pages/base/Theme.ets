import router from '@ohos.router';
import {
	IBestButton,
	IBestCheckbox,
	IBestCircleProgress,
	IBestNavBar,
	IBestProgress,
	IBestRadio,
	IBestRadioGroup,
	IBestSwitch,
	IBestTabs,
	IBestTag,
	setIBestUIBaseStyle
} from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, FONT_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { ComponentRouterParams } from '../../assets/global.type';
import { getRandomColor } from '../../utils/utils';
@Entry
@Component
struct ThemePage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
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
								onClickBtn: () => {
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
							value: 50
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
			}
			.layoutWeight(1)
			.padding({
				left: SPACE.SM,
				right: SPACE.SM
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}