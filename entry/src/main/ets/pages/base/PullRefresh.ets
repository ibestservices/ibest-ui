import { IBestPullRefresh, IBestRefreshContentParams, IBestTabItemType, IBestTabs } from '@ibestservices/ibest-ui';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function PullRefreshBuilder(_: string, title: string){
	PullRefreshPage({title})
}

@Entry
@Component
struct PullRefreshPage {
	@State title: string = ''
	@State tabsList: Array<IBestTabItemType> = [
		{
			name: "1",
			label: '基础用法'
		},
		{
			name: "2",
			label: '成功提示'
		},
		{
			name: "3",
			label: '自定义提示'
		}
	]
	@State currentTab: string = "1"
	@State isLoading: boolean = false

	private listScroller: ListScroller = new ListScroller()
	private scroller: Scroller = new Scroller()
	private scroller1: Scroller = new Scroller()

	@State isRefreshing: boolean = false
	@State arr: String[] = ['0', '1', '2', '3', '4','5','6','7','8','9','10']
	@Builder customContent(type: string) {
		if(type == "1"){
			List({scroller: this.listScroller }) {
				ForEach(this.arr, (item: string) => {
					ListItem() {
						Text('' + item)
							.width('70%')
							.height(80)
							.fontSize(16)
							.margin(10)
							.textAlign(TextAlign.Center)
							.borderRadius(10)
							.backgroundColor(0x89CFF0)
					}.width("100%")
				}, (item: string) => item)
			}.width("100%").edgeEffect(EdgeEffect.None).height("100%")
		}else if(type == "2"){
			Scroll(this.scroller){
				Column(){
					ForEach(this.arr, (item: string) => {
						Text('' + item)
							.width('70%')
							.height(80)
							.fontSize(16)
							.margin(10)
							.textAlign(TextAlign.Center)
							.borderRadius(10)
							.backgroundColor(0x89CFF0)
					}, (item: string) => item)
				}.width("100%")
			}.height("100%")
		}else if(type == "3"){
			Scroll(this.scroller1){
				Column(){
					ForEach(this.arr, (item: string) => {
						Text('' + item)
							.width('70%')
							.height(80)
							.fontSize(16)
							.margin(10)
							.textAlign(TextAlign.Center)
							.borderRadius(10)
							.backgroundColor(0x89CFF0)
					}, (item: string) => item)
				}.width("100%")
			}.height("100%")
		}
	}

	@Builder customPullingContent($$: IBestRefreshContentParams){
		Image($r("app.media.icon_loading_point_static"))
			.width(60)
			.scale({ x: $$.distance / 50, y: $$.distance / 50 })
	}
	@Builder customLoosingContent(){
		Image($r("app.media.icon_loading_point_static"))
			.width(60)
	}
	@Builder customLoadingContent(){
		Image($r("app.media.icon_loading_point_dynamics"))
			.width(60)
	}

	onRefresh(direction: string){
		console.log("direction:" + direction)
		// 此处模拟请求 延时关闭
		setTimeout(() => {
			this.isLoading = false
		}, 1500)
	}

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			IBestTabs({
				tabsList: this.tabsList,
				currentName: $currentTab
			})
			Column(){
				if(this.currentTab == "1"){
					IBestPullRefresh({
						loading: $isLoading,
						scroller: this.listScroller,
						defaultContent: (): void => this.customContent("1"),
						onRefresh: (direction): void => this.onRefresh(direction)
					})
				}
				if(this.currentTab == "2"){
					IBestPullRefresh({
						loading: $isLoading,
						scroller: this.scroller,
						successText: "加载成功",
						defaultContent: (): void => this.customContent("2"),
						onRefresh: (direction): void => this.onRefresh(direction)
					})
				}
				if(this.currentTab == "3"){
					IBestPullRefresh({
						loading: $isLoading,
						scroller: this.scroller1,
						defaultContent: (): void => this.customContent("3"),
						pullingContent: this.customPullingContent,
						loosingContent: this.customLoosingContent,
						loadingContent: (): void => this.customLoadingContent(),
						onRefresh: (direction): void => this.onRefresh(direction)
					})
				}
			}
			.layoutWeight(1)
		}
		.hideTitleBar(true)
	}
}