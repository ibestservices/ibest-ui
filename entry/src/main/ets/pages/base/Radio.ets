import { IBestCell, IBestDialogUtil, IBestRadio, IBestRadioGroup } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function RadioBuilder(_: string, title: string){
	RadioPage({title})
}

@Entry
@Component
struct RadioPage {
	@State title: string = ''

	@State group: string = "group"
	@State active: string = "1"

	@State group1: string = "group1"
	@State active1: string = "1"

	@State group2: string = "group2"
	@State active2: number = 1

	@State group3: string = "group3"
	@State active3: number = 1

	@State group4: string = "group4"
	@State active4: boolean = false

	@Builder
	CellRadio(name: boolean, group: string) {
		IBestRadio({ name, group })
	}
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						Text("当前选中radio" + this.active).fontSize(14).margin({bottom: 10})
						IBestRadioGroup({ group: this.group, active: $active }){
							IBestRadio({
								group: this.group,
								label: '单选框1',
								name: '1'
							})
							IBestRadio({
								group:this.group,
								label: '单选框2',
								name: '2'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '水平排列' }) {
						IBestRadioGroup({ group: this.group, active: $active, placeDirection: Axis.Horizontal }){
							IBestRadio({
								group: this.group,
								label: '单选框1',
								name: '1'
							})
							IBestRadio({
								group:this.group,
								label: '单选框2',
								name: '2'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用状态' }) {
						IBestRadioGroup({ group: this.group1, active: $active1 }){
							IBestRadio({
								group: this.group1,
								label: '单选框1',
								disabled: true,
								name: '1'
							})
							IBestRadio({
								group:this.group1,
								label: '单选框2',
								name: '2'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义形状' }) {
						IBestRadioGroup({ group: this.group, active: $active }){
							IBestRadio({
								group: this.group,
								label: '单选框1',
								shape: 'square',
								name: '1'
							})
							IBestRadio({
								group:this.group,
								label: '单选框2',
								shape: 'dot',
								name: '2'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义颜色' }) {
						Row({space: SPACE.XL}){
							IBestRadioGroup({ group: this.group, active: $active }){
								IBestRadio({
									group: this.group,
									label: '单选框',
									checkedColor: '#ee0a24',
									name: '1'
								})
								IBestRadio({
									group: this.group,
									label: '单选框',
									checkedColor: '#ee0a24',
									name: '2'
								})
							}
							IBestRadioGroup({ group: this.group, active: $active }){
								IBestRadio({
									group: this.group,
									label: '单选框',
									bgColor: "#fff",
									bdColor: "#ee0a24",
									name: '1'
								})
								IBestRadio({
									group: this.group,
									label: '单选框',
									bgColor: "#fff",
									bdColor: "#ee0a24",
									name: '2'
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义大小' }) {
						IBestRadioGroup({ group: this.group, active: $active }){
							IBestRadio({
								group: this.group,
								label: '自定义大小',
								iconSize: 30,
								name: '1'
							})
							IBestRadio({
								group: this.group,
								label: '自定义大小',
								iconSize: 30,
								name: '2'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '左侧文本' }) {
						IBestRadioGroup({ group: this.group, active: $active }){
							IBestRadio({
								group: this.group,
								label: '单选框',
								labelPosition: 'left',
								name: '1'
							})
							IBestRadio({
								group: this.group,
								label: '单选框',
								labelPosition: 'left',
								name: '2'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用文本点击' }) {
						IBestRadioGroup({ group: this.group2, active: $active2 }){
							IBestRadio({
								group: this.group2,
								label: '单选框',
								labelDisabled: true,
								name: 1
							})
							IBestRadio({
								group: this.group2,
								label: '单选框',
								labelDisabled: true,
								name: 2
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '异步切换' }) {
						IBestRadioGroup({ group: this.group3, active: $active3, beforeChange: () => {
							return new Promise((resolve, reject) => {
								IBestDialogUtil.open({
									title: "提示",
									message: "确定切换?",
									showCancelButton: true,
									onConfirm: () => {
										resolve(true)
									},
									onCancel: () => {
										reject(false)
									}
								})
							})
						} }){
							IBestRadio({
								group: this.group3,
								label: '单选框',
								name: 1
							})
							IBestRadio({
								group: this.group3,
								label: '单选框',
								name: 2
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '搭配单元格组件使用' }) {
						IBestRadioGroup({ group: this.group4, active: $active4 }){
							IBestCell({
								title: '是',
								center: true,
								rightIconBuilder: () => this.CellRadio(true, this.group4),
								clickable: true,
								onCellClick: () => {
									this.active4 = true
								}
							})
							IBestCell({
								title: '否',
								center: true,
								rightIconBuilder: () => this.CellRadio(false, this.group4),
								hasBorder: false,
								clickable: true,
								onCellClick: () => {
									this.active4 = false
								}
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