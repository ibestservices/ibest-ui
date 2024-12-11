import router from '@ohos.router';
import { IBestSideBar, IBestSideBarItem, IBestToast } from '@ibestservices/ibest-ui'
import { CONTAINER_SIZE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { ComponentRouterParams } from '../assets/global.type';
@Entry
@Component
struct SideBarPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''

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
		Column(){
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
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
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
	}
}