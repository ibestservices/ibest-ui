import { IBestCell, IBestCellGroup, IBestNavBar } from '@ibestservices/ibest-ui'
import router from '@ohos.router'
import { BORDER_RADIUS, CONTAINER_SIZE, FONT_SIZE, FONT_WEIGHT, modeColor, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'
import GlobalStore from '../utils/global'
import { common, Want } from '@kit.AbilityKit'
import { getAppVersion } from '../utils/utils'
import { rcp } from '@kit.RemoteCommunicationKit'
import fs from '@ohos.file.fs'
import { updateManager } from '@kit.StoreKit'

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
					path: "pages/base/Button"
				},
				{
					name: $r("app.string.component_cell"),
					path: "pages/base/Cell"
				},
				{
					name: $r("app.string.component_icon"),
					path: "pages/base/Icon"
				},
				{
					name: $r("app.string.component_popup"),
					path: "pages/base/Popup"
				},
				{
					name: $r("app.string.component_theme"),
					path: "pages/base/Theme"
				},
				{
					name: $r("app.string.component_toast"),
					path: "pages/base/Toast"
				}
			]
		},
		{
			title: $r("app.string.form_component"),
			list: [
				{
					name: $r("app.string.component_calendar"),
					path: "pages/base/Calendar"
				},
				{
					name: $r("app.string.component_cascader"),
					path: "pages/base/Cascader"
				},
				{
					name: $r("app.string.component_checkbox"),
					path: "pages/base/Checkbox"
				},
				{
					name: $r("app.string.component_datePicker"),
					path: "pages/base/DatePicker"
				},
				{
					name: $r("app.string.component_field"),
					path: "pages/base/Field"
				},
				{
					name: $r("app.string.component_form"),
					path: "pages/base/Form"
				},
				{
					name: $r("app.string.component_numberKeyboard"),
					path: "pages/base/NumberKeyboard"
				},
				{
					name: $r("app.string.component_passwordInput"),
					path: "pages/base/PasswordInput"
				},
				{
					name: $r("app.string.component_picker"),
					path: "pages/base/Picker"
				},
				{
					name: $r("app.string.component_pickerGroup"),
					path: "pages/base/PickerGroup"
				},
				{
					name: $r("app.string.component_radio"),
					path: "pages/base/Radio"
				},
				{
					name: $r("app.string.component_rate"),
					path: "pages/base/Rate"
				},
				{
					name: $r("app.string.component_search"),
					path: "pages/base/Search"
				},
				{
					name: $r("app.string.component_slider"),
					path: "pages/base/Slider"
				},
				{
					name: $r("app.string.component_signature"),
					path: "pages/base/Signature"
				},
				{
					name: $r("app.string.component_stepper"),
					path: "pages/base/Stepper"
				},
				{
					name: $r("app.string.component_switch"),
					path: "pages/base/Switch"
				},
				{
					name: $r("app.string.component_timePicker"),
					path: "pages/base/TimePicker"
				},
				{
					name: $r("app.string.component_uploader"),
					path: "pages/base/Uploader"
				}
			]
		},
		{
			title: $r("app.string.action_component"),
			list: [
				{
					name: $r("app.string.component_actionSheet"),
					path: "pages/base/ActionSheet"
				},
				{
					name: $r("app.string.component_dialog"),
					path: "pages/base/Dialog"
				},
				{
					name: $r("app.string.component_loading"),
					path: "pages/base/Loading"
				},
				{
					name: $r("app.string.component_notify"),
					path: "pages/base/Notify"
				},
				{
					name: $r("app.string.component_pullRefresh"),
					path: "pages/base/PullRefresh"
				},
				{
				  name: $r("app.string.component_swipeCell"),
				  path: "pages/base/SwipeCell"
				}
			]
		},
		{
			title: $r("app.string.display_component"),
			list: [
				{
					name: $r("app.string.component_badge"),
					path: "pages/base/Badge"
				},
				{
					name: $r("app.string.component_circleprogress"),
					path: "pages/base/CircleProgress"
				},
				{
					name: $r("app.string.component_collapse"),
					path: "pages/base/Collapse"
				},
				{
					name: $r("app.string.component_countdown"),
					path: "pages/base/CountDown"
				},
				{
					name: $r("app.string.component_divider"),
					path: "pages/base/Divider"
				},
				{
					name: $r("app.string.component_empty"),
					path: "pages/base/Empty"
				},
				{
					name: $r("app.string.component_highlight"),
					path: "pages/base/Highlight"
				},
				{
					name: $r("app.string.component_imagepreview"),
					path: "pages/base/ImagePreview"
				},
				{
					name: $r("app.string.component_noticebar"),
					path: "pages/base/NoticeBar"
				},
				{
					name: $r("app.string.component_popover"),
					path: "pages/base/Popover"
				},
				{
					name: $r("app.string.component_progress"),
					path: "pages/base/Progress"
				},
				{
					name: $r("app.string.component_table"),
					path: "pages/base/Table"
				},
				{
					name: $r("app.string.component_tag"),
					path: "pages/base/Tag"
				},
				{
					name: $r("app.string.component_textellipsis"),
					path: "pages/base/TextEllipsis"
				},
				{
					name: $r("app.string.component_watermark"),
					path: "pages/base/Watermark"
				}
			]
		},
		{
			title: $r("app.string.navigation_component"),
			list: [
				{
					name: $r("app.string.component_navBar"),
					path: "pages/base/NavBar"
				},
				{
					name: $r("app.string.component_sideBar"),
					path: "pages/base/SideBar"
				},
				{
					name: $r("app.string.component_tab"),
					path: "pages/base/Tab"
				}
			]
		}
	]
	@State extendComponentList: ComponentItem[] = [
		{
			name: $r("app.string.component_canvasDrawer"),
			path: "pages/extend/CanvasDrawer"
		},
		{
			name: $r("app.string.component_imageCropper"),
			path: "pages/extend/ImageCropper"
		}
	]
	private tabsList: Tab[] = [
		{
			name: $r("app.string.tab_bar_basic"),
			icon: $r("app.media.icon_base")
		},
		{
			name: $r("app.string.tab_bar_extend"),
			icon: $r("app.media.icon_yewu")
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
	private context = getContext(this) as common.UIAbilityContext

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
			Row({ space: SPACE.XS }) {
				Image($r("app.media.app_icon")).width(32).borderRadius(BORDER_RADIUS.BASE)
				Text("IBest-UI")
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
		.width(CONTAINER_SIZE.FULL)
		.alignItems(HorizontalAlign.Start)
		.padding({ left: 10, top: GlobalStore.topAvoidHeight })
	}
	@Builder tabContentBuilder(index: number) {
		if (index == 0) {
			List({ scroller: this.scrollerForList1 }) {
				ListItem() {
					this.listTop(index)
				}
				ForEach(this.baseComponentList, (part: ComponentPart) => {
					ListItem() {
						ComponentShowContainer({
							title: `${this.getResourceStr(part.title)}(${part.list.length})`,
							titlePaddingLeft: SPACE.XS
						}) {
							ForEach(part.list, (item: ComponentItem) => {
								this.componentItem(item)
							})
						}
					}
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
				ForEach(this.extendComponentList, (item: ComponentItem) => {
					ListItem() {
						this.componentItem(item)
					}
				})
			}
			.listStyle()
			.onDidScroll(() => {
				this.getScrollTop()
			})
		}else{
			Column() {
				Column({ space: SPACE.MD }) {
					Image($r("app.media.app_icon")).width(100).borderRadius(BORDER_RADIUS.BASE)
					Text("IBest-UI")
						.fontSize(32)
						.fontColor(modeColor.textColor2)
					Text($r("app.string.ibest_ui_desc"))
						.width("80%")
						.textAlign(TextAlign.Center)
						.fontSize(FONT_SIZE.MD)
						.fontColor(modeColor.textColor4)
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
							onClickCell: () => {
								this.viewUrl("doc")
							}
						})
						IBestCell({
							title: $r("app.string.company_official_website"),
							isLink: true,
							onClickCell: () => {
								this.viewUrl("company")
							}
						})
						IBestCell({
							title: $r("app.string.privacy_policy"),
							isLink: true,
							hasBorder: false,
							onClickCell: () => {
								router.pushUrl({
									url: "pages/PrivacyPolicy"
								})
							}
						})
					}
				}
				Column({ space: SPACE.BASE }){
					Text("皖ICP备16012151号-7A").fontColor(modeColor.primaryColor).fontSize(FONT_SIZE.XS)
					Text($r("app.string.copy_right")).fontSize(FONT_SIZE.XS).textAlign(TextAlign.Center)
				}.padding({left: SPACE.BASE, right: SPACE.BASE})
			}
			.width(CONTAINER_SIZE.FULL)
			.height(CONTAINER_SIZE.FULL)
			.justifyContent(FlexAlign.SpaceBetween)
			.padding({ top: 80, bottom: SPACE.MD })
		}
	}
	@Builder componentItem(item: ComponentItem) {
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
		.margin({
			top: SPACE.SM
		})
		.backgroundColor(modeColor.bg3)
		.stateStyles({
			normal: {
				.scale({
					x: 1,
					y: 1
				})
			},
			pressed: {
				.scale({
					x: .98,
					y: .98
				})
			}
		})
		.animation({
			duration: 200
		})
		.onClick(() => {
			router.pushUrl({
				url: item.path,
				params: {
					title: item.name
				}
			})
		})
	}

	aboutToAppear(): void {
		this.checkUpdate()
		this.getUiVersion()
		// setTimeout(() => {
		// 	router.pushUrl({
		// 		url: "pages/base/Table",
		// 		params: {
		// 			title: "Table"
		// 		}
		// 	})
		// }, 100)
	}
	// 获取Resource内容
	getResourceStr(res: Resource){
		return this.context.resourceManager.getStringSync(res)
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
				this.scrollTop = 0
				break
		}
	}
	viewUrl(type: string){
		if(type == "doc"){
			router.pushUrl({
				url: "pages/Doc"
			})
		}else{
			let url = this.context.resourceManager.getStringSync($r("app.string.company_url"))
			let want: Want = {
				action: "ohos.want.action.viewData",
				entities: ["entity.system.browsable"],
				uri: url
			}
			this.context.startAbility(want)
		}
	}
	async getUiVersion(){
		let filePath = getContext(this).cacheDir + "/BuildProfile.ets"
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
		Column(){
			IBestNavBar({
				title: "IBest-UI",
				isShowLeft: false,
				isShowStatusBar: true,
				onTitleClick: () => {
					this.goTop()
				}
			}).position({left: 0, top: 0}).zIndex(1).opacity(this.getTitleOpacity())
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
		.backgroundColor(modeColor.bg)
	}
}