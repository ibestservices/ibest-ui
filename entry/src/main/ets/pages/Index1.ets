import { IBestCell, IBestCellGroup, IBestIcon } from '@ibestservices/ibest-ui'
import { BORDER_RADIUS, CONTAINER_SIZE, FONT_SIZE, FONT_WEIGHT, modeColor, SPACE } from '../assets/styles/BaseStyle'
import GlobalStore from '../utils/global'
import { common, Want, bundleManager } from '@kit.AbilityKit'
import { getAppVersion } from '../utils/utils'
import { rcp } from '@kit.RemoteCommunicationKit'
import fs from '@ohos.file.fs'
import { commentManager, updateManager } from '@kit.AppGalleryKit'
import RouterUtil from '../utils/routerUtil'
import { hdsMaterial,
	HdsNavDestination,
	HdsNavigation,
	HdsTabs,
	ScrollEffectType
} from '@kit.UIDesignKit'

interface ComponentPart {
	title: Resource
	list: ComponentItem[]
	color: string
	desc: Resource
	linear: [ResourceColor, number][]
}
interface ComponentItem {
	name: ResourceStr
	desc?: Resource
	path: string
}
interface Tab {
	name: ResourceStr
	icon: Resource
}

@Extend(List) function listStyle(){
	.width(CONTAINER_SIZE.FULL)
	.height(CONTAINER_SIZE.FULL)
	.padding({ left: SPACE.MD, right: SPACE.MD })
}

@Entry
@Component
struct Index {
	@State baseComponentList: ComponentPart[] = [
		{
			title: $r("app.string.basic_component"),
			color: "#6366F1",
			linear: [["#818CF8", 0], ["#4F46E5", 1]],
			desc: $r("app.string.basic_component_desc"),
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
			color: "#10B981",
			linear: [["#34D399", 0], ["#059669", 1]],
			desc: $r("app.string.form_component_desc"),
			list: [
				{
					name: $r("app.string.component_calendar"),
					path: "Calendar"
				},
				{
					name: $r("app.string.component_caliper"),
					path: "Caliper"
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
					name: $r("app.string.component_signature"),
					path: "Signature"
				},
				{
					name: $r("app.string.component_slider"),
					path: "Slider"
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
				},
				{
					name: $r("app.string.component_weekPicker"),
					path: "WeekPicker"
				}
			]
		},
		{
			title: $r("app.string.action_component"),
			color: "#F59E0B",
			linear: [["#FBBF24", 0], ["#D97706", 1]],
			desc: $r("app.string.action_component_desc"),
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
                    name: $r("app.string.component_floatBubble"),
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
			color: "#8B5CF6",
			linear: [["#A78BFA", 0], ["#7C3AED", 1]],
			desc: $r("app.string.display_component_desc"),
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
					name: $r("app.string.component_card"),
					path: "Card"
				},
				{
					name: $r("app.string.component_circleProgress"),
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
					name: $r("app.string.component_highLight"),
					path: "Highlight"
				},
				{
					name: $r("app.string.component_imagePreview"),
					path: "ImagePreview"
				},
				{
					name: $r("app.string.component_mosaic"),
					path: "Mosaic"
				},
				{
					name: $r("app.string.component_noticeBar"),
					path: "NoticeBar"
				},
				{
					name: $r("app.string.component_popover"),
					path: "Popover"
				},
				{
					name: $r("app.string.component_price"),
					path: "Price"
				},
				{
					name: $r("app.string.component_progress"),
					path: "Progress"
				},
				{
					name: $r("app.string.component_readMore"),
					path: "ReadMore"
				},
				{
					name: $r("app.string.component_rollingText"),
					path: "RollingText"
				},
				{
					name: $r("app.string.component_sectorProgress"),
					path: "SectorProgress"
				},
				{
					name: $r("app.string.component_segmented"),
					path: "Segmented"
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
					name: $r("app.string.component_textEllipsis"),
					path: "TextEllipsis"
				},
				{
					name: $r("app.string.component_tree"),
					path: "Tree"
				},
				{
					name: $r("app.string.component_watermark"),
					path: "Watermark"
				}
			]
		},
		{
			title: $r("app.string.navigation_component"),
			color: "#EC4899",
			linear: [["#F472B6", 0], ["#DB2777", 1]],
			desc: $r("app.string.navigation_component_desc"),
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
				},
				{
					name: $r("app.string.component_tabBar"),
					path: "TabBar"
				}
			]
		}
	]
	@State extendComponentList: ComponentItem[] = [
		{
			name: $r("app.string.component_canvasDrawer"),
			desc: $r("app.string.component_canvasDrawer_desc"),
			path: "CanvasDrawer"
		},
		{
			name: $r("app.string.component_colorPicker"),
			desc: $r("app.string.component_colorPicker_desc"),
			path: "ColorPicker"
		},
		{
			name: $r("app.string.component_contactAddress"),
			desc: $r("app.string.component_contactAddress_desc"),
			path: "ContactAddress"
		},
		{
			name: $r("app.string.component_gridAlbum"),
			desc: $r("app.string.component_gridAlbum_desc"),
			path: "GridAlbum"
		},
		{
			name: $r("app.string.component_imageCropper"),
			desc: $r("app.string.component_imageCropper_desc"),
			path: "ImageCropper"
		},
		{
			name: $r("app.string.component_inputTag"),
			desc: $r("app.string.component_inputTag_desc"),
			path: "InputTag"
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
	@State uiVersion: string = ""
	@State curExpandIndex: number = 0
	@State curExpandIndex1: number = 0
	private scrollerForList1: Scroller = new Scroller()
	private scrollerForList2: Scroller = new Scroller()
	private scrollerForList3: Scroller = new Scroller()
	private context = this.getUIContext().getHostContext() as common.UIAbilityContext
	private navPathStack: NavPathStack = new NavPathStack()
	private timer: number = 0

	@Builder tabBuilder(index: number){
		Column({space: 5}) {
			Image(this.tabsList[index].icon)
				.width(16)
				.aspectRatio(1)
				.fillColor(this.currentTab == index ? modeColor.primaryColor : modeColor.textColor2)
			Text(this.tabsList[index].name)
				.fontColor(this.currentTab == index ? modeColor.primaryColor : modeColor.textColor2)
				.fontSize(FONT_SIZE.SM)
		}.width(CONTAINER_SIZE.FULL).padding({top: 5, bottom: 5})
	}
	@Builder listTop(index: number){
		Column({ space: SPACE.MD }) {
			if(index == 2){
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
		.padding({ top: GlobalStore.topAvoidHeight + 54 })
		.transition(TransitionEffect.OPACITY.animation({ duration: 2000, curve: Curve.Ease }))
	}
	@Builder tabContentBuilder(index: number) {
		HdsNavDestination() {
			if (index == 0) {
				List({ scroller: this.scrollerForList1, space: SPACE.MD }) {
					ListItem() {
						this.listTop(index)
					}
					ForEach(this.baseComponentList, (part: ComponentPart, index: number) => {
						ListItem() {
							Column(){
								Column({space: SPACE.MD}){
									Text(part.title)
										.fontColor(modeColor.white)
										.fontSize(20)
									Text(part.desc)
										.fontColor("#f2f3f5")
										.fontSize(14)
								}
								.width(CONTAINER_SIZE.FULL)
								.height(110)
								.alignItems(HorizontalAlign.Start)
								.linearGradient({ angle: -45, colors: part.linear })
								.padding(SPACE.MD)
								.onClick(() => {
									this.curExpandIndex = index
									this.scrollerForList1.scrollToIndex(index, true)
								})
								Column(){
									ForEach(part.list, (item: ComponentItem, i: number) => {
										this.componentItem(item, i, true, 0)
									})
								}
								.backgroundColor(modeColor.bg3)
								.visibility(this.curExpandIndex == index ? Visibility.Visible : Visibility.None)
								.animation({duration: 350})
							}
							.borderRadius(30)
							.clip(true)
						}
						.transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 1000, curve: Curve.Ease, delay: 350 * index }))
					})
					ListItem().height(80)
				}
				.listStyle()
			} else if (index == 1) {
				List({ scroller: this.scrollerForList2, space: SPACE.MD }) {
					ListItem() {
						this.listTop(index)
					}
					ForEach(this.extendComponentList, (item: ComponentItem, i) => {
						ListItem() {
							Column(){
								Column(){
									Text(item.name)
										.fontSize(this.curExpandIndex1 == i ? 20 : '')
										.fontColor(this.curExpandIndex1 == i ? modeColor.white : '')
										.animation({duration: 350})
								}
								.width(CONTAINER_SIZE.FULL)
								.height(this.curExpandIndex1 == i ? 60 : 40)
								.justifyContent(FlexAlign.Center)
								.alignItems(HorizontalAlign.Start)
								.padding({left: SPACE.MD, right: SPACE.MD})
								.border({width: {top: this.curExpandIndex1 == i ? 1 : 0}, color: modeColor.borderColor})
								.linearGradient(this.curExpandIndex1 == i ? { angle: 90, colors: [["#1989fa", 0], ["#4DAFFF", 1]] } : undefined)
								.animation({duration: 350})
								.onClick(() => {
									this.curExpandIndex1 = i
								})
								Row({space: SPACE.MD}){
									Text(item.desc)
										.layoutWeight(1)
									IBestIcon({
										name: "arrow",
										iconSize: 14
									})
								}
								.width(CONTAINER_SIZE.FULL)
								.padding(SPACE.MD)
								.clickEffect({level:ClickEffectLevel.LIGHT, scale: 0.9})
								.visibility(this.curExpandIndex1 == i ? Visibility.Visible : Visibility.None)
								.animation({duration: 350})
								.onClick(() => {
									RouterUtil.push(item.path, item.name)
								})
							}
							.backgroundColor(modeColor.bg3)
							.borderRadius(30)
							.clip(true)
						}
						.transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 1000, curve: Curve.Ease, delay: 350 * i }))
					})
					ListItem().height(80)
				}
				.listStyle()
			} else if (index == 2) {
				List({ scroller: this.scrollerForList3, space: SPACE.SM }) {
					ListItem() {
						this.listTop(index)
					}
					ForEach(this.chartsComponentList, (item: ComponentItem, i) => {
						ListItem() {
							this.componentItem(item, i)
						}
						.transition(TransitionEffect.move(TransitionEdge.BOTTOM)
							.animation({ duration: 1000, curve: Curve.Ease, delay: 250 * i }))
					})
					ListItem().height(80)
				}
				.listStyle()
			} else {
				Column() {
					Scroll() {
						Column({ space: SPACE.MD }) {
							Image($r("app.media.app_icon")).width(50).borderRadius(BORDER_RADIUS.BASE)
								.transition(TransitionEffect.move(TransitionEdge.BOTTOM)
									.animation({ duration: 1000, curve: Curve.Ease }))
							Text($r("app.string.app_name"))
								.fontSize(28)
								.fontColor(modeColor.textColor2)
								.transition(TransitionEffect.move(TransitionEdge.BOTTOM)
									.animation({ duration: 1000, curve: Curve.Ease, delay: 100 }))
							Text($r("app.string.ibest_ui_desc"))
								.width("80%")
								.textAlign(TextAlign.Center)
								.fontSize(FONT_SIZE.MD)
								.fontColor(modeColor.textColor4)
								.transition(TransitionEffect.move(TransitionEdge.BOTTOM)
									.animation({ duration: 1000, curve: Curve.Ease, delay: 200 }))
							Column() {
								IBestCellGroup({ inset: true }) {
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
										onCellClick: () => {
											RouterUtil.push("PrivacyPolicy")
										}
									})
									IBestCell({
										title: "五星鼓励一下~",
										isLink: true,
										hasBorder: false,
										onCellClick: () => {
											this.viewAppStoreDetail()
										}
									})
								}
							}
							.transition(TransitionEffect.move(TransitionEdge.BOTTOM)
								.animation({ duration: 1000, curve: Curve.Ease, delay: 300 }))
						}.padding({ top: 80 })
					}
					.layoutWeight(1)
					Column({ space: SPACE.BASE }) {
						Text("皖ICP备16012151号-7A").fontColor(modeColor.primaryColor).fontSize(FONT_SIZE.XS)
						Text($r("app.string.copy_right")).fontSize(FONT_SIZE.XS).textAlign(TextAlign.Center)
					}
					.height(36)
					.transition(TransitionEffect.move(TransitionEdge.BOTTOM).animation({ duration: 1500, curve: Curve.Ease }))
					Column().height(90)
				}
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
			}
		}
		.titleBar({
			content: {
				title: {
					mainTitle: this.currentTab == 0 ? "基础组件" : this.currentTab == 1 ? "扩展组件" : this.currentTab == 2 ? "UCharts For HarmonyOS" : "关于"
				}
			},
			style: {
				scrollEffectOpts: {
					scrollEffectType: ScrollEffectType.IMMERSIVE_GRADIENT_BLUR,
				},
				originalStyle: {
					backgroundStyle: {
						backgroundColor: Color.Transparent
					},
					contentStyle: {
						titleStyle: {
							mainTitleColor: "#000"
						}
					}
				},
				scrollEffectStyle: {
					backgroundStyle: {
						backgroundColor: "#99000000"
					},
					contentStyle: {
						titleStyle: {
							mainTitleColor: "#fff"
						}
					}
				},
				systemMaterialEffect: {
					materialType: hdsMaterial.MaterialType.IMMERSIVE,
					materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
				}
			},
			avoidLayoutSafeArea: true
		})
		.hideBackButton(true)
		.backgroundColor(modeColor.bg)
	}
	@Builder componentItem(item: ComponentItem, index: number, bd: boolean = false, radius: number = 99) {
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
				.margin({ right: SPACE.SM })
				.rotate({ angle: 180 })
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FORTY)
		.borderRadius(radius)
		.padding({ left: SPACE.MD })
		.backgroundColor(modeColor.bg3)
		.clickEffect({level:ClickEffectLevel.LIGHT, scale: 0.9})
		.border({width: {top: index > 0 && bd ? 1 : 0}, color: modeColor.borderColor})
		.onClick(() => {
			RouterUtil.push(item.path, item.name)
		})
	}

	aboutToAppear(): void {
		console.log("组件总数", this.baseComponentList.reduce((pre, cur) => pre + cur.list.length, 0) + this.extendComponentList.length)
		RouterUtil.navPathStackList.push(this.navPathStack)
		this.checkUpdate()
		this.getUiVersion()
		this.showCommentDialog()
		// setTimeout(() => {
		//     RouterUtil.push("DatePicker")
		// }, 100)
	}
	aboutToDisappear(): void {
		clearInterval(this.timer)
		this.timer = 0
	}
	viewUrl(type: string){
		if(type == "doc"){
			RouterUtil.push("Doc")
		} else {
			let res = type == 'ucharts' ? $r("app.string.ucharts_url") : $r("app.string.company_url")
			let url = this.context.resourceManager.getStringSync(res.id)
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
	// 提示评论
	showCommentDialog(){
		let count = 0
		this.timer = setInterval(() => {
			count++
			if(count > 120){
				clearInterval(this.timer)
				commentManager.showCommentDialog(this.context).then(()=>{
					console.log("succeeded in showing commentDialog.");
				}).catch((error: BusinessError<Object>) => {
					console.log(`showCommentDialog failed, Code: ${error.code}, message: ${error.message}`);
				})
			}
		}, 1000)
	}
	// 跳转应用市场详情
	viewAppStoreDetail(){
		let bundleName = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).name
		let link = 'https://appgallery.huawei.com/app/detail?id=' + bundleName + '&action=write-review'
		this.context.openLink(link, { appLinkingOnly: false })
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
		HdsNavigation(this.navPathStack) {
			HdsTabs(){
				TabContent(){
					this.tabContentBuilder(0)
				}.tabBar(this.tabBuilder(0))
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
			.scrollable(false)
			.barPosition(BarPosition.End)
			.barOverlap(true)
			.barBackgroundBlurStyle(BlurStyle.Thin)
			.barFloatingStyle({
				barBottomMargin: 28,
				thermoCtrl: true,
				systemMaterialEffect: {
					materialType: hdsMaterial.MaterialType.IMMERSIVE,
					materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
				}
			})
			.animationDuration(0)
			.onTabBarClick(index => {
				this.currentTab = index
			})
		}
		.mode(NavigationMode.Stack)
		.ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
	}
}