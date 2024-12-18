import router from '@ohos.router';
import { CONTAINER_SIZE } from '../assets/styles/BaseStyle';
import { IBestNavBar, IBestPullRefresh, IBestRefreshContentParams, IBestTabItemType, IBestTabs } from '@ibestservices/ibest-ui';
import { ComponentRouterParams } from '../assets/global.type';
@Entry
@Component
struct PullRefreshPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
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

	private scroller: Scroller = new Scroller()
	private listScroller: ListScroller = new ListScroller()

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
			}
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

	onRefresh(){
		// 此处模拟请求 延时关闭
		setTimeout(() => {
			this.isLoading = false
		}, 1500)
	}

	build() {
		Column(){
			IBestNavBar({
				title: this.title,
				isShowStatusBar: true,
				onLeftClick: () => {
					router.back()
				}
			})
			IBestTabs({
				tabsList: this.tabsList,
				currentName: $currentTab
			})
			if(this.currentTab == "1"){
				IBestPullRefresh({
					loading: $isLoading,
					scroller: this.listScroller,
					defaultContent: (): void => this.customContent("1"),
					onRefresh: (): void => this.onRefresh()
				})
			}
			if(this.currentTab == "2"){
				IBestPullRefresh({
					loading: $isLoading,
					successText: "加载成功",
					scroller: this.scroller,
					defaultContent: (): void => this.customContent("2"),
					onRefresh: (): void => this.onRefresh()
				})
			}
			if(this.currentTab == "3"){
				IBestPullRefresh({
					loading: $isLoading,
					defaultContent: (): void => this.customContent("2"),
					pullingContent: this.customPullingContent,
					loosingContent: this.customLoosingContent,
					loadingContent: (): void => this.customLoadingContent(),
					onRefresh: (): void => this.onRefresh()
				})
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
	}
}