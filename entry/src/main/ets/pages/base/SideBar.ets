import { IBestSideBar, IBestSideBarItem, IBestToast } from '@ibestservices/ibest-ui';
import { modeColor } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';
@Builder
export function SideBarBuilder(_: string, title: string){
	SideBarPage({title})
}

@Entry
@Component
struct SideBarPage {
	@State title: string = ''

	@State groupId: string = "group"
	@State active: number = 0
	@State itemList: Array<string> = ["选项1", "选项2", "选项3"]

	@State groupId1: string = "group1"
	@State active1: number = 0

	@State groupId2: string = "group2"
	@State active2: number = 0

	@State groupId3: string = "group3"
	@State active3: number = 0

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			Grid() {
				GridItem() {
					Column(){
						ComponentShowContainer({ title: '基础用法' }){
							IBestSideBar({
								groupId: this.groupId,
								active: $active
							}){
								ForEach(this.itemList, (item: string, index) => {
									IBestSideBarItem({
										groupId: this.groupId,
										index: index,
										title: item
									})
								})
							}
						}
					}
					.width(100)
				}
				.padding({bottom: 16})
				GridItem() {
					Column(){
						ComponentShowContainer({ title: '自定义样式' }){
							IBestSideBar({
								groupId: this.groupId1,
								active: $active1,
								leftBarColor: "#ee0a24",
								activeFontColor: "#3d8af2"
							}){
								ForEach(this.itemList, (item: string, index) => {
									IBestSideBarItem({
										groupId: this.groupId1,
										index: index,
										title: item
									})
								})
							}
						}
					}
					.width(100)
				}
				.padding({bottom: 16})
				GridItem() {
					Column(){
						ComponentShowContainer({ title: '禁用选项' }){
							IBestSideBar({
								groupId: this.groupId2,
								active: $active2
							}){
								ForEach(this.itemList, (item: string, index) => {
									IBestSideBarItem({
										groupId: this.groupId2,
										index: index,
										title: item,
										disabled: index == 1
									})
								})
							}
						}
					}
					.width(100)
				}
				.padding({bottom: 16})
				GridItem() {
					Column(){
						ComponentShowContainer({ title: '切换事件' }){
							IBestSideBar({
								groupId: this.groupId3,
								active: $active3,
								onChange: (index: number) => {
									IBestToast.show(this.itemList[index])
								}
							}){
								ForEach(this.itemList, (item: string, index) => {
									IBestSideBarItem({
										groupId: this.groupId3,
										index: index,
										title: item
									})
								})
							}
						}
					}
					.width(100)
				}
				.padding({bottom: 16})
			}
			.columnsTemplate('1fr 1fr')
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg2)
	}
}