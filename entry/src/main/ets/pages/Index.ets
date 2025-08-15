import { IBestCell, IBestCellGroup, IBestNavBar } from '@ibestservices/ibest-ui'
import { BORDER_RADIUS, CONTAINER_SIZE, FONT_SIZE, FONT_WEIGHT, modeColor, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'
import GlobalStore from '../utils/global'
import { common, Want } from '@kit.AbilityKit'
import { getAppVersion, getResourceStr } from '../utils/utils'
import { rcp } from '@kit.RemoteCommunicationKit'
import fs from '@ohos.file.fs'
import { updateManager } from '@kit.AppGalleryKit'
import RouterUtil from '../utils/routerUtil'

interface ComponentPart {
	title: Resource
	list: ComponentItem[]
}
interface ComponentItem {
	name: ResourceStr,
	path: string
}
interface Tab {
	name: ResourceStr
	icon: Resource
}

@Extend(List) function listStyle(){
	.width(CONTAINER_SIZE.FULL)
	.height(CONTAINER_SIZE.FULL)
	.edgeEffect(EdgeEffect.None)
	.padding({ left: SPACE.MD, right: SPACE.MD })
}

@Entry
@Component
struct Index {
	@State baseComponentList: ComponentPart[] = [
		{
			title: $r("app.string.basic_component"),
			list: [
				{
					name: $r("app.string.component_button"),
					path: "Button"
				},
				{
					name: $r("app.string.component_cell"),
					path: "Cell"
				},
				{
					name: $r("app.string.component_icon"),
					path: "Icon"
				},
				{
					name: $r("app.string.component_popup"),
					path: "Popup"
				},
				{
					name: $r("app.string.component_theme"),
					path: "Theme"
				},
				{
					name: $r("app.string.component_toast"),
					path: "Toast"
				}
			]
		},
		{
			title: $r("app.string.form_component"),
			list: [
				{
					name: $r("app.string.component_calendar"),
					path: "Calendar"
				},
				{
					name: $r("app.string.component_carInput"),
					path: "CarInput"
				},
				{
					name: $r("app.string.component_carKeyboard"),
					path: "CarKeyboard"
				},
				{
					name: $r("app.string.component_cascader"),
					path: "Cascader"
				},
				{
					name: $r("app.string.component_checkbox"),
					path: "Checkbox"
				},
				{
					name: $r("app.string.component_datePicker"),
					path: "DatePicker"
				},
				{
					name: $r("app.string.component_dateTimePicker"),
					path: "DateTimePicker"
				},
				{
					name: $r("app.string.component_field"),
					path: "Field"
				},
				{
					name: $r("app.string.component_form"),
					path: "Form"
				},
				{
					name: $r("app.string.component_numberKeyboard"),
					path: "NumberKeyboard"
				},
				{
					name: $r("app.string.component_passwordInput"),
					path: "PasswordInput"
				},
				{
					name: $r("app.string.component_picker"),
					path: "Picker"
				},
				{
					name: $r("app.string.component_pickerGroup"),
					path: "PickerGroup"
				},
				{
					name: $r("app.string.component_radio"),
					path: "Radio"
				},
				{
					name: $r("app.string.component_rate"),
					path: "Rate"
				},
				{
					name: $r("app.string.component_search"),
					path: "Search"
				},
				{
					name: $r("app.string.component_slider"),
					path: "Slider"
				},
				{
					name: $r("app.string.component_signature"),
					path: "Signature"
				},
				{
					name: $r("app.string.component_stepper"),
					path: "Stepper"
				},
				{
					name: $r("app.string.component_switch"),
					path: "Switch"
				},
				{
					name: $r("app.string.component_timePicker"),
					path: "TimePicker"
				},
				{
					name: $r("app.string.component_uploader"),
					path: "Uploader"
				}
			]
		},
		{
			title: $r("app.string.action_component"),
			list: [
				{
					name: $r("app.string.component_actionSheet"),
					path: "ActionSheet"
				},
				{
					name: $r("app.string.component_dialog"),
					path: "Dialog"
				},
				{
					name: $r("app.string.component_dropdownMenu"),
					path: "DropdownMenu"
				},
                {
                    name: $r("app.string.component_float_bubble"),
                    path: "FloatBubble"
                },
				{
					name: $r("app.string.component_guide"),
					path: "Guide"
				},
				{
					name: $r("app.string.component_loading"),
					path: "Loading"
				},
				{
					name: $r("app.string.component_notify"),
					path: "Notify"
				},
				{
					name: $r("app.string.component_pullRefresh"),
					path: "PullRefresh"
				},
				{
					name: $r("app.string.component_swipeCell"),
					path: "SwipeCell"
				}
			]
		},
		{
			title: $r("app.string.display_component"),
			list: [
				{
					name: $r("app.string.component_avatar"),
					path: "Avatar"
				},
				{
					name: $r("app.string.component_badge"),
					path: "Badge"
				},
				{
					name: $r("app.string.component_circleprogress"),
					path: "CircleProgress"
				},
				{
					name: $r("app.string.component_collapse"),
					path: "Collapse"
				},
				{
					name: $r("app.string.component_countdown"),
					path: "CountDown"
				},
				{
					name: $r("app.string.component_countTo"),
					path: "CountTo"
				},
				{
					name: $r("app.string.component_divider"),
					path: "Divider"
				},
				{
					name: $r("app.string.component_empty"),
					path: "Empty"
				},
				{
					name: $r("app.string.component_highlight"),
					path: "Highlight"
				},
				{
					name: $r("app.string.component_imagepreview"),
					path: "ImagePreview"
				},
				{
					name: $r("app.string.component_noticebar"),
					path: "NoticeBar"
				},
				{
					name: $r("app.string.component_popover"),
					path: "Popover"
				},
				{
					name: $r("app.string.component_progress"),
					path: "Progress"
				},
				{
					name: $r("app.string.component_sectorprogress"),
					path: "SectorProgress"
				},
				{
					name: $r("app.string.component_skeleton"),
					path: "Skeleton"
				},
				{
					name: $r("app.string.component_steps"),
					path: "Steps"
				},
				{
					name: $r("app.string.component_table"),
					path: "Table"
				},
				{
					name: $r("app.string.component_tag"),
					path: "Tag"
				},
				{
					name: $r("app.string.component_textellipsis"),
					path: "TextEllipsis"
				},
				{
					name: $r("app.string.component_watermark"),
					path: "Watermark"
				}
			]
		},
		{
			title: $r("app.string.navigation_component"),
			list: [
				{
					name: $r("app.string.component_navBar"),
					path: "NavBar"
				},
				{
					name: $r("app.string.component_pagination"),
					path: "Pagination"
				},
				{
					name: $r("app.string.component_sideBar"),
					path: "SideBar"
				},
				{
					name: $r("app.string.component_tab"),
					path: "Tab"
				}
			]
		}
	]
	@State extendComponentList: ComponentItem[] = [
		{
			name: $r("app.string.component_canvasDrawer"),
			path: "CanvasDrawer"
		},
		{
			name: $r("app.string.component_colorPicker"),
			path: "ColorPicker"
		},
		{
			name: $r("app.string.component_contactAddress"),
			path: "ContactAddress"
		},
		{
			name: $r("app.string.component_imageCropper"),
			path: "ImageCropper"
		}
	]
	@State chartsComponentList: ComponentItem[] = [
		{
			name: 'Column 柱状图',
			path: "Column"
		},
		{
			name: 'Mount 山峰图',
			path: "Mount"
		},
		{
			name: 'Bar 条状图',
			path: "Bar"
		},
		{
			name: 'Line 折线图',
			path: "Line"
		},
		{
			name: 'Area 区域图',
			path: "Area"
		},
		{
			name: 'Scatter 散点图',
			path: "Scatter"
		},
		{
			name: 'Bubble 气泡图',
			path: "Bubble"
		},
		{
			name: 'Mix 混合图',
			path: "Mix"
		},
		{
			name: 'Pie 饼状图',
			path: "Pie"
		},
		{
			name: 'Ring 圆环图',
			path: "Ring"
		},
		{
			name: 'Rose 玫瑰图',
			path: "Rose"
		},
		{
			name: 'Radar 雷达图',
			path: "Radar"
		},
		{
			name: 'Arcbar 进度条',
			path: "Arcbar"
		},
		{
			name: 'Gauge 仪表盘',
			path: "Gauge"
		},
		{
			name: 'Funnel 漏斗图',
			path: "Funnel"
		},
		{
			name: 'Word 词云图',
			path: "Word"
		},
		{
			name: 'Candle K线图',
			path: "Candle"
		}
	]
	@State tabsList: Tab[] = [
		{
			name: $r("app.string.tab_bar_basic"),
			icon: $r("app.media.icon_base")
		},
		{
			name: $r("app.string.tab_bar_extend"),
			icon: $r("app.media.icon_yewu")
		},
		{
			name: $r("app.string.tab_bar_chart"),
			icon: $r("app.media.icon_chart")
		},
		{
			name: $r("app.string.tab_bar_about"),
			icon: $r("app.media.icon_about")
		}
	]
	@State currentTab: number = 0
	@State scrollTop: number = 0
	@State uiVersion: string = ""
	private scrollerForList1: Scroller = new Scroller()
	private scrollerForList2: Scroller = new Scroller()
	private scrollerForList3: Scroller = new Scroller()
	private context = this.getUIContext().getHostContext() as common.UIAbilityContext
	private router = this.getUIContext().getRouter()
	private navPathStack: NavPathStack = new NavPathStack()

	@Builder tabBuilder(index: number){
		Column({space: 5}) {
			Image(this.tabsList[index].icon)
				.width(16)
				.aspectRatio(1)
				.fillColor(this.currentTab == index ? modeColor.primaryColor : modeColor.textColor4)
			Text(this.tabsList[index].name)
				.fontColor(this.currentTab == index ? modeColor.primaryColor : modeColor.textColor4)
				.fontSize(FONT_SIZE.SM)
		}.width(CONTAINER_SIZE.FULL).padding({top: 10, bottom: GlobalStore.bottomBarHeight})
	}
	@Builder listTop(index: number){
		Column({ space: SPACE.MD }) {
			if(index == 2){
				Row({ space: SPACE.XS }) {
					Image($r("app.media.app_icon")).width(32).borderRadius(BORDER_RADIUS.BASE)
					Text("UCharts For HarmonyOS")
						.fontSize(24)
						.fontColor(modeColor.textColor2)
				}.justifyContent(FlexAlign.Center)
				Text(){
					Span("以下为UCharts图表组件，具体配置请参考：")
					Span($r("app.string.ucharts_url"))
						.decoration({ type: TextDecorationType.Underline, color: modeColor.textColor4 })
						.onClick(() => {
							this.viewUrl("ucharts")
						})
				}
					.fontSize(FONT_SIZE.MD)
					.fontColor(modeColor.textColor4)
			}else {
				Row({ space: SPACE.XS }) {
					Image($r("app.media.app_icon")).width(32).borderRadius(BORDER_RADIUS.BASE)
					Text($r("app.string.app_name"))
						.fontSize(32)
						.fontColor(modeColor.textColor2)
				}.justifyContent(FlexAlign.Center)
				Text() {
					if(index == 0){
						Span($r("app.string.tab_bar_basic_desc"))
					}else if(index == 1){
						Span($r("app.string.tab_bar_extend_desc"))
					}
					Span("，")
					Span($r("app.string.tab_view_doc"))
					Span("：")
					Span($r("app.string.app_doc_url"))
						.decoration({ type: TextDecorationType.Underline, color: modeColor.textColor4 })
						.onClick(() => {
							this.viewUrl("doc")
						})
				}
				.fontSize(FONT_SIZE.MD)
				.fontColor(modeColor.textColor4)
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.alignItems(HorizontalAlign.Start)
		.padding({ left: 10, top: GlobalStore.topAvoidHeight })
		.transition(TransitionEffect.OPACITY.animation({ duration: 2000, curve: Curve.Ease }))
	}
	@Builder tabContentBuilder(index: number) {
		if (index == 0) {
			List({ scroller: this.scrollerForList1 }) {
				ListItem() {
					this.listTop(index)
				}
				ForEach(this.baseComponentList, (part: ComponentPart, index: number) => {
					ListItem() {
						ComponentShowContainer({
							title: `${getResourceStr(part.title)}(${part.list.length})`,
							titlePaddingLeft: SPACE.XS
						}) {
							ForEach(part.list, (item: ComponentItem, i: number) => {
								this.componentItem(item, i)
							})
						}
					}
					.transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 1000, curve: Curve.Ease, delay: 500*index }))
				})
			}
			.listStyle()
			.onDidScroll(() => {
				this.getScrollTop()
			})
		}else if (index == 1) {
			List({ scroller: this.scrollerForList2 }) {
				ListItem() {
					this.listTop(index)
				}
				ForEach(this.extendComponentList, (item: ComponentItem, i) => {
					ListItem() {
						this.componentItem(item, i)
					}
				})
			}
			.listStyle()
			.onDidScroll(() => {
				this.getScrollTop()
			})
		}else if (index == 2) {
			List({ scroller: this.scrollerForList3 }){
				ListItem() {
					this.listTop(index)
				}
				ForEach(this.chartsComponentList, (item: ComponentItem, i) => {
					ListItem() {
						this.componentItem(item, i)
					}
				})
				ListItem().height(20)
			}
			.listStyle()
			.onDidScroll(() => {
				this.getScrollTop()
			})
		}else{
			Column() {
				Scroll(){
					Column({ space: SPACE.MD }) {
						Image($r("app.media.app_icon")).width(100).borderRadius(BORDER_RADIUS.BASE)
							.transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 1000, curve: Curve.Ease }))
						Text($r("app.string.app_name"))
							.fontSize(32)
							.fontColor(modeColor.textColor2)
							.transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 1000, curve: Curve.Ease, delay: 100 }))
						Text($r("app.string.ibest_ui_desc"))
							.width("80%")
							.textAlign(TextAlign.Center)
							.fontSize(FONT_SIZE.MD)
							.fontColor(modeColor.textColor4)
							.transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 1000, curve: Curve.Ease, delay: 200 }))
						Column(){
							IBestCellGroup({inset: true}){
								IBestCell({
									title: $r("app.string.app_version"),
									value: `v${getAppVersion()}`
								})
								IBestCell({
									title: $r("app.string.ui_version"),
									value: this.uiVersion ? `v${this.uiVersion}` : ""
								})
								IBestCell({
									title: $r("app.string.ui_doc"),
									isLink: true,
									onCellClick: () => {
										this.viewUrl("doc")
									}
								})
								IBestCell({
									title: $r("app.string.company_official_website"),
									isLink: true,
									onCellClick: () => {
										this.viewUrl("company")
									}
								})
								IBestCell({
									title: $r("app.string.privacy_policy"),
									isLink: true,
									hasBorder: false,
									onCellClick: () => {
										this.router.pushUrl({
											url: "pages/PrivacyPolicy"
										})
									}
								})
							}
						}
						.transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 1000, curve: Curve.Ease, delay: 300 }))
					}.padding({top: 80})
				}
				.layoutWeight(1)
				.align(Alignment.Top)
				Column({ space: SPACE.BASE }){
					Text("皖ICP备16012151号-7A").fontColor(modeColor.primaryColor).fontSize(FONT_SIZE.XS)
					Text($r("app.string.copy_right")).fontSize(FONT_SIZE.XS).textAlign(TextAlign.Center)
				}.padding(SPACE.BASE)
			}
			.width(CONTAINER_SIZE.FULL)
			.height(CONTAINER_SIZE.FULL)
		}
	}
	@Builder componentItem(item: ComponentItem, index: number) {
		Row() {
			Text(item.name)
				.fontSize(FONT_SIZE.MD)
				.fontWeight(FONT_WEIGHT.MEDIUM)
				.textAlign(TextAlign.Start)
				.fontColor($r("app.color.doc_text_color_3"))
				.layoutWeight(1)
			Image($r("app.media.title_back"))
				.width(CONTAINER_SIZE.FOURTEEN)
				.fillColor($r("app.color.doc_text_color_3"))
				.margin({
					right: SPACE.SM
				})
				.rotate({
					angle: 180
				})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FORTY)
		.borderRadius(99)
		.padding({ left: SPACE.LG })
		.margin({ top: SPACE.SM })
		.backgroundColor(modeColor.bg3)
		.clickEffect({level:ClickEffectLevel.LIGHT, scale: 0.9})
		.transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 800, curve: Curve.Ease, delay: 100*index }))
		.onClick(() => {
			RouterUtil.push(item.path, item.name)
		})
	}

	aboutToAppear(): void {
		RouterUtil.navPathStackList.push(this.navPathStack)
		this.checkUpdate()
		this.getUiVersion()
		// setTimeout(() => {
		// 	RouterUtil.push("SectorProgress")
		// }, 100)
	}
	getTitleOpacity(){
		// let scrollY = this.scrollTop < 50 ? this.scrollTop : 50
		return this.scrollTop < 50 ? 0 : 1
	}
	goTop(){
		switch (this.currentTab){
			case 0:
				this.scrollerForList1.scrollTo({xOffset: 0, yOffset: 0, animation: true})
				break
			case 1:
				this.scrollerForList2.scrollTo({xOffset: 0, yOffset: 0, animation: true})
				break
			case 2:
				this.scrollerForList3.scrollTo({xOffset: 0, yOffset: 0, animation: true})
				break
		}
	}
	getScrollTop(){
		switch (this.currentTab){
			case 0:
				this.scrollTop = this.scrollerForList1.currentOffset().yOffset
				break
			case 1:
				this.scrollTop = this.scrollerForList2.currentOffset().yOffset
				break
			case 2:
				this.scrollTop = this.scrollerForList3.currentOffset().yOffset
				break
			case 3:
				this.scrollTop = 0
				break
		}
	}
	viewUrl(type: string){
		if(type == "doc"){
			RouterUtil.push("Doc")
		} else {
			let res = type == 'ucharts' ? $r("app.string.ucharts_url") : $r("app.string.company_url")
			let url = this.context.resourceManager.getStringSync(res)
			let want: Want = {
				action: "ohos.want.action.viewData",
				entities: ["entity.system.browsable"],
				uri: url
			}
			this.context.startAbility(want)
		}
	}
	async getUiVersion(){
		let filePath = this.context.cacheDir + "/BuildProfile.ets"
		try {
			fs.unlinkSync(filePath)
		} catch(err) {}
		const rcpSession = rcp.createSession()
		await rcpSession.downloadToFile("https://gitee.com/ibestservices/ibest-ui/blob/master/library/BuildProfile.ets", { kind: "file", file: filePath })
		rcpSession.close()
		let str = fs.readTextSync(filePath)
		let res = str.match(/'\b\d+\.\d+\.\d+\b'/)
		if(res){
			this.uiVersion = res[0].slice(1, -1)
		}
	}
	// 检查新版本
	checkUpdate(){
		updateManager.checkAppUpdate(this.context).then((checkResult: updateManager.CheckUpdateResult) => {
			if(checkResult.updateAvailable == 1){
				updateManager.showUpdateDialog(this.context)
			}
		})
	}
	build() {
		Navigation(this.navPathStack){
			IBestNavBar({
				title: $r("app.string.app_name"),
				isShowLeft: false,
				isShowStatusBar: true,
				onTitleClick: () => {
					this.goTop()
				}
			}).position({left: 0, top: 0}).zIndex(1).visibility(this.getTitleOpacity() ? Visibility.Visible : Visibility.None)
			Tabs({barPosition: BarPosition.End, index: $$this.currentTab}){
				TabContent(){
					this.tabContentBuilder(0)
				}
				.tabBar(this.tabBuilder(0))
				TabContent(){
					this.tabContentBuilder(1)
				}.tabBar(this.tabBuilder(1))
				TabContent(){
					this.tabContentBuilder(2)
				}.tabBar(this.tabBuilder(2))
				TabContent(){
					this.tabContentBuilder(3)
				}.tabBar(this.tabBuilder(3))
			}
			.width(CONTAINER_SIZE.FULL)
			.barHeight(70)
			.barBackgroundColor(modeColor.bg2)
			.divider({strokeWidth: 1, color: modeColor.borderColor})
			.layoutWeight(1)
			.onChange(() => {
				this.getScrollTop()
			})
		}
		.hideTitleBar(true)
		.mode(NavigationMode.Stack)
		.backgroundColor(modeColor.bg)
	}
}