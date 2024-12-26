import router from '@ohos.router'
import { IBestCell, IBestNavBar, IBestRadio, IBestRadioGroup } from '@ibestservices/ibest-ui'
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { ComponentRouterParams } from '../assets/global.type'

@Entry
@Component
struct CheckboxPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''

	@State group: string = "group"
	@State active: string = "1"

	@State group1: string = "group1"
	@State active1: string = "1"
	
	@Builder
	CellRadio(name: string, group: string) {
		IBestRadio({ name, group })
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
						IBestRadioGroup({ group: this.group, active: $active }){
							IBestRadio({
								group: this.group,
								label: '单选框',
								shape: 'square',
								checkedColor: '#ee0a24',
								name: '1'
							})
							IBestRadio({
								group: this.group,
								label: '单选框',
								checkedColor: '#ee0a24',
								name: '2'
							})
							IBestRadio({
								group: this.group,
								label: '单选框',
								shape: 'dot',
								checkedColor: '#ee0a24',
								name: '3'
							})
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
						IBestRadioGroup({ group: this.group, active: $active }){
							IBestRadio({
								group: this.group,
								label: '单选框',
								labelDisabled: true,
								name: '1'
							})
							IBestRadio({
								group: this.group,
								label: '单选框',
								labelDisabled: true,
								name: '2'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '搭配单元格组件使用' }) {
						IBestRadioGroup({ group: this.group, active: $active }){
							IBestCell({
								title: '单选框1',
								rightIconBuilder: () => this.CellRadio('1', this.group),
								clickable: true,
								onClickCell: () => {
									this.active = '1'
								}
							})
							IBestCell({
								title: '单选框2',
								rightIconBuilder: () => this.CellRadio('2', this.group),
								hasBorder: false,
								clickable: true,
								onClickCell: () => {
									this.active = '2'
								}
							})
						}
					}
				}
			}
			.layoutWeight(1)
			.padding({
				left: SPACE.SM,
				right: SPACE.SM,
				bottom: SPACE.MD
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}