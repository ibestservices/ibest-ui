import { IBestButton, IBestDatePicker, IBestPicker, IBestPickerGroup, IBestPickerOption, IBestToast } from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function PickerGroupBuilder(_: string, title: string){
	PickerGroupPage({title})
}

@Entry
@Component
struct PickerGroupPage {
	@State title: string = ''
	@State groupId: string = "1"
	@State options1: IBestPickerOption[] = [
		{ text: '南京', value: '南京' },
		{ text: '苏州', value: '苏州' },
		{ text: '常州', value: '常州' },
		{ text: '扬州', value: '扬州' },
		{ text: '镇江', value: '镇江' }
	]
	@State options2: IBestPickerOption[] = [
		{ text: '周一', value: '周一' },
		{ text: '周二', value: '周二' },
		{ text: '周三', value: '周三' },
		{ text: '周四', value: '周四' },
		{ text: '周五', value: '周五' }
	]
	@State tabs: string[] = ["选择地点", "选择星期"]
	@State tabs1: string[] = ["开始日期", "结束日期"]
	@State selectValue1: string[] = []
	@State selectValue2: string[] = []
	@State selectValue3: string[] = []
	@State selectValue4: string[] = []
	@State selectValue5: string[] = []
	@State selectValue6: string[] = []

	@State currentName: number = 0

	changeName(){
		this.currentName = this.currentName === 0 ? 1 : 0
	}

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SM, card: true }) {
						IBestPickerGroup({
							title: "选择地点时间",
							tabs: this.tabs,
							onConfirm: () => {
								IBestToast.show({
									message: `${this.selectValue1[0]} ${this.selectValue2[0]}`
								})
							}
						}){
							IBestPicker({
								options: this.options1,
								value: $selectValue1
							})
							IBestPicker({
								options: this.options2,
								value: $selectValue2
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '下一步按钮', titlePaddingLeft: SPACE.SM, card: true }) {
						IBestPickerGroup({
							title: "选择地点时间",
							tabs: this.tabs,
							nextStepText: "下一步",
							onConfirm: () => {
								IBestToast.show({
									message: `${this.selectValue3[0]} ${this.selectValue4[0]}`
								})
							}
						}){
							IBestPicker({
								options: this.options1,
								value: $selectValue3
							})
							IBestPicker({
								options: this.options2,
								value: $selectValue4
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '选择日期范围', titlePaddingLeft: SPACE.SM, card: true }) {
						IBestPickerGroup({
							title: "预约日期",
							tabs: this.tabs1,
							nextStepText: "下一步",
							onConfirm: () => {
								IBestToast.show({
									message: `${this.selectValue5.join("-")}-${this.selectValue6.join("-")}`
								})
							}
						}){
							IBestDatePicker({
								groupId: this.groupId,
								value: $selectValue5
							})
							IBestDatePicker({
								groupId: this.groupId,
								value: $selectValue6
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '手动切换', titlePaddingLeft: SPACE.SM, card: true }) {
						Column({space: SPACE.SM}){
							IBestButton({
								text: `点击切换tab 当前为${this.currentName}`,
								type: "primary",
								buttonSize: "small",
								onBtnClick: () => {
									this.changeName()
								}
							})
							IBestPickerGroup({
								title: "选择地点时间",
								tabs: this.tabs,
								nextStepText: "下一步",
								currentName: this.currentName,
								onTabNameChange: name => {
									this.currentName = name
								},
								onConfirm: () => {
									IBestToast.show({
										message: `${this.selectValue1[0]} ${this.selectValue2[0]}`
									})
								}
							}) {
								IBestPicker({
									options: this.options1,
									value: $selectValue1
								})
								IBestPicker({
									options: this.options2,
									value: $selectValue2
								})
							}
						}
						.alignItems(HorizontalAlign.Start)
						.padding({top: SPACE.SM})
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