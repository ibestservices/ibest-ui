import {
	IBestButton,
	IBestCell,
	IBestCheckbox,
	IBestCheckboxBuilderParams,
	IBestCheckboxGroup,
	IBestCheckboxGroupController,
	IBestDialogUtil,
	IBestIcon
} from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function CheckboxBuilder(_: string, title: string){
	CheckboxPage({title})
}

@Entry
@Component
struct CheckboxPage {
	@State title: string = ''
	@State isChecked: boolean = true
	@State isChecked1: string = '1'
	@State isChecked2: number = 1
	@State group: string = "group"
	@State activeList: string[] = ["1", "2"]
	@State group1: string = "group1"
	@State activeList1: number[] = [1]
	@State group2: string = "group2"
	@State activeList2: string[] = ["1", "2"]
	@State group3: string = "group3"
	@State activeList3: string[] = ["1"]
	@State group4: string = "group4"
	@State activeList4: string[] = ["2"]
	@State isIndeterminate: boolean = true;
	@State isIndeterminateCheckAll: boolean = false;
	@State group5: string = "group5"
	@State activeList5: string[] = []
	@State cellCheckedMaxNum: number = 2
	private controller: IBestCheckboxGroupController = new IBestCheckboxGroupController()
	private controller1: IBestCheckboxGroupController = new IBestCheckboxGroupController()

	@Builder iconBuilder($$: IBestCheckboxBuilderParams){
		IBestIcon({
			name: "like-o",
			color: "#fff",
			iconSize: 18
		})
			.opacity($$.checked ? 1 : 0)
	}
	@Builder labelBuilder($$: IBestCheckboxBuilderParams) {
		Text($$.checked ? "选中" : "未选中")
	}
	@Builder CellCheckbox(name: string, group: string) {
		IBestCheckbox({
			name,
			group
		})
	}
	handleClickCell(name: string) {
		const index = this.activeList5.indexOf(name)
		if (index > -1) {
			this.activeList5.splice(index, 1)
		} else {
			this.activeList5.push(name)
		}
	}
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						IBestCheckbox({
							value: this.isChecked,
							label: this.isChecked + "",
							onChange: checked => {
								this.isChecked = checked as boolean
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用状态' }) {
						Column({ space: SPACE.SM }) {
							IBestCheckbox({
								value: false,
								disabled: true,
								label: '复选框'
							})
							IBestCheckbox({
								value: true,
								disabled: true,
								label: '复选框'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义形状' }) {
						IBestCheckbox({
							value: this.isChecked,
							shape: 'square',
							label: '自定义形状',
							onChange: checked => {
								this.isChecked = checked as boolean
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义颜色' }) {
						Column({ space: SPACE.SM }) {
							IBestCheckbox({
								value: this.isChecked,
								checkedColor: '#ee0a24',
								label: '自定义颜色',
								onChange: checked => {
									this.isChecked = checked as boolean
								}
							})
							IBestCheckbox({
								value: false,
								bdColor: '#ee0a24',
								bgColor: "#fff",
								label: '自定义背景色'
							})
						}.alignItems(HorizontalAlign.Start)
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义大小' }) {
						IBestCheckbox({
							value: this.isChecked,
							iconSize: 30,
							label: '自定义大小',
							onChange: checked => {
								this.isChecked = checked as boolean
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义内容' }) {
						Column({space: 14}){
							IBestCheckbox({
								value: this.isChecked,
								iconBuilder: this.iconBuilder,
								label: '自定义图标',
								onChange: checked => {
									this.isChecked = checked as boolean
								}
							})
							IBestCheckbox({
								value: this.isChecked,
								defaultBuilder: this.labelBuilder,
								onChange: checked => {
									this.isChecked = checked as boolean
								}
							})
						}
						.alignItems(HorizontalAlign.Start)
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '左侧文本' }) {
						IBestCheckbox({
							value: this.isChecked,
							labelPosition: 'left',
							label: '左侧文本',
							onChange: checked => {
								this.isChecked = checked as boolean
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用文本点击' }) {
						IBestCheckbox({
							value: this.isChecked,
							label: '复选框',
							labelDisabled: true,
							onChange: checked => {
								this.isChecked = checked as boolean
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '异步切换' }) {
						IBestCheckbox({
							value: this.isChecked,
							label: '复选框',
							beforeChange: () => {
								return new Promise((resolve, reject) => {
									IBestDialogUtil.open({
										title: "提示",
										message: "确定更改状态?",
										showCancelButton: true,
										onConfirm: () => {
											resolve(true)
										},
										onCancel: () => {
											reject(false)
										}
									})
								})
							},
							onChange: checked => {
								this.isChecked = checked as boolean
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '其他类型' }) {
						Column({ space: SPACE.SM }) {
							IBestCheckbox({
								value: this.isChecked1,
								label: "string：" + this.isChecked1,
								trueValue: "1",
								falseValue: "2",
								onChange: checked => {
									this.isChecked1 = checked as string
								}
							})
							IBestCheckbox({
								value: this.isChecked2,
								label: "number：" + this.isChecked2.toString(),
								trueValue: 1,
								falseValue: 0,
								onChange: checked => {
									this.isChecked2 = checked as number
								}
							})
						}.alignItems(HorizontalAlign.Start)
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '复选框组', }) {
						Text("选中标识 " + this.activeList.join(',')).fontSize(14).margin({ bottom: 10 })
						IBestCheckboxGroup({ group: this.group, activeList: $activeList, beforeChange: () => {
							return new Promise((resolve, reject) => {
								IBestDialogUtil.open({
									title: "提示",
									message: "确定更改状态?",
									showCancelButton: true,
									onConfirm: () => {
										resolve(true)
									},
									onCancel: () => {
										reject(false)
									}
								})
							})
						}}) {
							IBestCheckbox({
								group: this.group,
								label: '复选框1',
								name: '1'
							})
							IBestCheckbox({
								group: this.group,
								label: '复选框2',
								name: '2'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '水平排列', }) {
						Text("选中标识 " + this.activeList1.join(',')).fontSize(14).margin({ bottom: 10 })
						IBestCheckboxGroup({
							group: this.group1,
							activeList: $activeList1,
							placeDirection: Axis.Horizontal
						}) {
							IBestCheckbox({
								group: this.group1,
								label: '复选框1',
								name: 1
							})
							IBestCheckbox({
								group: this.group1,
								label: '复选框2',
								name: 2
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '限制最大可选数', }) {
						Text("选中标识 " + this.activeList2.join(',')).fontSize(14).margin({ bottom: 10 })
						IBestCheckboxGroup({ group: this.group2, activeList: $activeList2, max: 2 }) {
							IBestCheckbox({
								group: this.group2,
								label: '复选框1',
								name: '1'
							})
							IBestCheckbox({
								group: this.group2,
								label: '复选框2',
								name: '2'
							})
							IBestCheckbox({
								group: this.group2,
								label: '复选框3',
								name: '3'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '全选与反选' }) {
						Text("选中标识 " + this.activeList3.join(',')).fontSize(14).margin({ bottom: 10 })
						IBestCheckboxGroup({
							group: this.group3,
							activeList: $activeList3,
							controller: this.controller
						}) {
							IBestCheckbox({
								group: this.group3,
								label: '复选框1',
								name: '1'
							})
							IBestCheckbox({
								group: this.group3,
								label: '复选框2',
								name: '2'
							})
							IBestCheckbox({
								group: this.group3,
								label: '复选框3',
								name: '3'
							})
						}
						Row({ space: SPACE.SM }) {
							IBestButton({
								text: '全选',
								type: 'primary',
								onBtnClick: () => {
									this.controller.toggleAll(true)
								}
							})
							IBestButton({
								text: '反选',
								type: 'warning',
								onBtnClick: () => {
									this.controller.toggleAll()
								}
							})
							IBestButton({
								text: '取消选中',
								onBtnClick: () => {
									this.controller.toggleAll(false)
								}
							})
						}
						.margin({ top: SPACE.XS })
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '不确定状态' }) {
						Column() {
							Text("选中标识 " + this.activeList4.join(',')).fontSize(14).margin({ bottom: 10 })
							IBestCheckbox({
								value: this.isIndeterminateCheckAll,
								label: '全选',
								indeterminate: this.isIndeterminate,
								onChange: checked => {
									this.controller1.toggleAll(checked as boolean)
								}
							})
						}
						.alignItems(HorizontalAlign.Start)
						.width(CONTAINER_SIZE.FULL)
						.padding({ bottom: SPACE.SM })
						.border({ width: { bottom: 1 }, color: "#ccc" })
						.margin({ bottom: SPACE.SM })
						IBestCheckboxGroup({
							group: this.group4,
							activeList: $activeList4,
							controller: this.controller1,
							onChange: checkedNames => {
								const length = checkedNames.length
								this.isIndeterminate = length < 2 && length > 0
								this.isIndeterminateCheckAll = length === 2
							}
						}) {
							IBestCheckbox({
								group: this.group4,
								label: '复选框1',
								name: '1'
							})
							IBestCheckbox({
								group: this.group4,
								label: '复选框2',
								name: '2'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '搭配单元格组件使用', }) {
						IBestCheckboxGroup({
							group: this.group5,
							activeList: $activeList5,
							max: this.cellCheckedMaxNum,
							space: 0
						}) {
							IBestCell({
								clickable: true,
								title: '复选框1',
								disabled: this.activeList5.length >= this.cellCheckedMaxNum &&
									!this.activeList5.includes('1'),
								rightIconBuilder: (): void => this.CellCheckbox('1', this.group5),
								onCellClick: (): void => this.handleClickCell('1')
							})
							IBestCell({
								clickable: true,
								title: '复选框2',
								disabled: this.activeList5.length >= this.cellCheckedMaxNum &&
									!this.activeList5.includes('2'),
								rightIconBuilder: (): void => this.CellCheckbox('2', this.group5),
								onCellClick: (): void => this.handleClickCell('2')
							})
							IBestCell({
								clickable: true,
								title: '复选框3',
								disabled: this.activeList5.length >= this.cellCheckedMaxNum &&
									!this.activeList5.includes('3'),
								hasBorder: false,
								rightIconBuilder: (): void => this.CellCheckbox('3', this.group5),
								onCellClick: (): void => this.handleClickCell('3')
							})
						}
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