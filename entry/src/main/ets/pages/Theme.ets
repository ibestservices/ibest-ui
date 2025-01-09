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
import { CONTAINER_SIZE, FONT_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';
import { getRandomColor } from '../utils/utils';
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
					ComponentShowContainer({ title: '更改primary颜色' }) {
						Row() {
							TextInput({ placeholder: '请输入合法颜色值，如red、#07c16', text: $$this.colorText })
								.fontSize(FONT_SIZE.SM)
								.layoutWeight(1)
								.margin({
									right: SPACE.SM
								})
							IBestButton({
								type: 'primary',
								text: '确定',
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
					ComponentShowContainer({ title: 'Button组件' }) {
						IBestButton({
							type: 'primary',
							text: '按钮'
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: 'Checkbox组件' }) {
						IBestCheckbox({
							value: true,
							name: '1',
							label: '复选框'
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: 'Radio组件' }) {
						IBestRadioGroup({ group: this.group, active: $active }) {
							IBestRadio({ group: this.group, label: '单选框1', name: '1' })
							IBestRadio({ group: this.group, label: '单选框2', name: '2' })
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: 'Switch组件' }) {
						Row() {
							IBestSwitch({
								value: $switchValue
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: 'CircleProgress组件' }) {
						IBestCircleProgress({
							value: $progressValue,
							text: `50%`
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: 'Progress组件' }) {
						IBestProgress({
							value: 50
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: 'Tabs组件' }) {
						IBestTabs({
							tabsList: [
								{
									label: "标签一",
									name: "1"
								},
								{
									label: "标签二",
									name: "2"
								},
								{
									label: "标签三",
									name: "3"
								},
								{
									label: "标签四",
									name: "4"
								},
								{
									label: "标签五",
									name: "5"
								}
							],
							currentName: $curTabName
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: 'Tag组件' }) {
						IBestTag({
							type: 'primary',
							text: '标签'
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