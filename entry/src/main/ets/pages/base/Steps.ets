import { IBestButton, IBestStep, IBestSteps } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function StepsBuilder(_: string, title: string){
	StepsPage({title})
}

@Entry
@Component
struct StepsPage {
	@State title: string = ''
	@State active: number = 0
	@State groupId: string = 'steps'
	@State groupId1: string = 'steps1'
	@State groupId2: string = 'steps2'
	@State groupId3: string = 'steps3'
	@Builder customStepContent(index: number){
		Column({space: 10}){
			Text("【城市】物流状态" + (index + 1))
				.fontColor(this.active >= index ? modeColor.primaryColor : modeColor.textColor2)
			Text("2025-01-26")
				.fontColor(this.active >= index ? modeColor.primaryColor : modeColor.textColor2)
		}
		.alignItems(HorizontalAlign.Start)
	}
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }){
						IBestSteps({
							groupId: this.groupId,
							active: this.active
						}){
							IBestStep({groupId: this.groupId, title: "步骤一"})
							IBestStep({groupId: this.groupId, title: "步骤二"})
							IBestStep({groupId: this.groupId, title: "步骤三"})
							IBestStep({groupId: this.groupId, title: "步骤四"})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '标记类型' }){
						IBestSteps({
							groupId: this.groupId1,
							active: this.active,
							type: 'dot'
						}){
							IBestStep({groupId: this.groupId1, title: "步骤一"})
							IBestStep({groupId: this.groupId1, title: "步骤二"})
							IBestStep({groupId: this.groupId1, title: "步骤三"})
							IBestStep({groupId: this.groupId1, title: "步骤四"})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式' }){
						IBestSteps({
							groupId: this.groupId2,
							active: this.active,
							type: 'icon',
							inactiveIcon: "passed",
							activeIcon: "checked",
							activeColor: "#07c160"
						}){
							IBestStep({groupId: this.groupId2, title: "步骤一", description: "一些描述信息"})
							IBestStep({groupId: this.groupId2, title: "步骤二", description: "一些描述信息"})
							IBestStep({groupId: this.groupId2, title: "步骤三", description: "一些描述信息"})
							IBestStep({groupId: this.groupId2, title: "步骤四", description: "一些描述信息"})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '竖向步骤条' }){
						IBestSteps({
							groupId: this.groupId3,
							dotSize: 8,
							active: this.active,
							placeDirection: Axis.Vertical
						}){
							ForEach([0, 1, 2, 3], (_: number, index: number) => {
								IBestStep({
									groupId: this.groupId3,
									type: index == 1 ? "dot" : "icon",
									inactiveIcon: index == 0 ? "like-o" : "passed",
									activeIcon: index == 0 ? "like" : "checked",
								}){
									this.customStepContent(index)
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer(){
						IBestButton({
							text: "下一步",
							onBtnClick: () => {
								if (this.active++ >= 3) {
									this.active = 0
								}
							}
						})
					}
				}
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg2)
	}
}