import { IBestButton, IBestPicker, IBestPickerGroup, IBestPickerOption, IBestDatePicker, IBestToast,
	Throttle } from '@ibestservices/ibest-ui'
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'

@Entry
@Component
struct PickerGroupPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State groupId: string = "1"
	@State groupId1: string = "2"
	@State groupId2: string = "3"
	@State groupId3: string = "4"
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

	@State currentName: string = "0"
	@Throttle(1000)
	changeName(){
		this.currentName = this.currentName === "0" ? "1" : "0"
	}

	build() {
		Column() {
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SMALL, card: true }) {
						IBestPickerGroup({
							groupId: this.groupId,
							title: "选择地点时间",
							tabs: this.tabs,
							onConfirm: () => {
								IBestToast.show({
									message: `${this.selectValue1[0]} ${this.selectValue2[0]}`
								})
							}
						}){
							IBestPicker({
								groupId: this.groupId,
								options: this.options1,
								value: $selectValue1
							})
							IBestPicker({
								groupId: this.groupId,
								options: this.options2,
								value: $selectValue2
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '下一步按钮', titlePaddingLeft: SPACE.SMALL, card: true }) {
						IBestPickerGroup({
							groupId: this.groupId1,
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
								groupId: this.groupId1,
								options: this.options1,
								value: $selectValue3
							})
							IBestPicker({
								groupId: this.groupId1,
								options: this.options2,
								value: $selectValue4
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '选择日期范围', titlePaddingLeft: SPACE.SMALL, card: true }) {
						IBestPickerGroup({
							groupId: this.groupId2,
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
								groupId: this.groupId2,
								value: $selectValue5
							})
							IBestDatePicker({
								groupId: this.groupId2,
								value: $selectValue6
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '手动切换', titlePaddingLeft: SPACE.SMALL, card: true }) {
						Column({space: SPACE.SMALL}){
							IBestButton({
								text: `点击切换tab 当前为${this.currentName}`,
								type: "primary",
								buttonSize: "small",
								onClickBtn: () => {
									this.changeName()
								}
							})
							IBestPickerGroup({
								groupId: this.groupId3,
								title: "选择地点时间",
								tabs: this.tabs,
								nextStepText: "下一步",
								currentName: this.currentName,
								onTabNameChange: (name: string) => {
									this.currentName = name
								},
								onConfirm: () => {
									IBestToast.show({
										message: `${this.selectValue1[0]} ${this.selectValue2[0]}`
									})
								}
							}){
								IBestPicker({
									groupId: this.groupId3,
									options: this.options1,
									value: $selectValue1
								})
								IBestPicker({
									groupId: this.groupId3,
									options: this.options2,
									value: $selectValue2
								})
							}
						}
						.alignItems(HorizontalAlign.Start)
					}
				}
			}
			.layoutWeight(1)
			.padding({ bottom: SPACE.LARGE })
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(BACKGROUND_COLOR.BASE)
	}
}