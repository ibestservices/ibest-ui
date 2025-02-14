import { IBestCell, IBestCellGroup, IBestNavBar } from '@ibestservices/ibest-ui'
import router from '@ohos.router'
import { BORDER_RADIUS, CONTAINER_SIZE, FONT_SIZE, FONT_WEIGHT, modeColor, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'
import GlobalStore from '../utils/global'
import { common, Want } from '@kit.AbilityKit'
import { getAppVersion } from '../utils/utils'
import { rcp } from '@kit.RemoteCommunicationKit'
import fs from '@ohos.file.fs'

interface ComponentPart {
	title: string
	list: ComponentItem[]
}
interface ComponentItem {
	name: string,
	path: string
}
interface Tab {
	name: string
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
			title: '基础组件',
			list: [
				{
					name: 'Button 按钮',
					path: 'pages/base/Button'
				},
				{
					name: 'Cell 单元格',
					path: 'pages/base/Cell'
				},
				{
					name: 'Icon 图标',
					path: 'pages/base/Icon'
				},
				{
					name: 'Popup 弹出层',
					path: 'pages/base/Popup'
				},
				{
					name: 'Theme 主题',
					path: 'pages/base/Theme'
				},
				{
					name: 'Toast 轻提示',
					path: 'pages/base/Toast'
				}
			]
		},
		{
			title: '表单组件',
			list: [
				{
					name: 'Calendar 日历',
					path: 'pages/base/Calendar'
				},
				{
					name: 'Cascader 级联选择',
					path: 'pages/base/Cascader'
				},
				{
					name: 'Checkbox 复选框',
					path: 'pages/base/Checkbox'
				},
				{
					name: 'DatePicker 日期选择',
					path: 'pages/base/DatePicker'
				},
				{
					name: 'Field 输入框',
					path: 'pages/base/Field'
				},
				{
					name: 'Form 表单',
					path: 'pages/base/Form'
				},
				{
					name: 'NumberKeyboard 数字键盘',
					path: 'pages/base/NumberKeyboard'
				},
				{
					name: 'PasswordInput 密码输入框',
					path: 'pages/base/PasswordInput'
				},
				{
					name: 'Picker 选择器',
					path: 'pages/base/Picker'
				},
				{
					name: 'PickerGroup 选择器组',
					path: 'pages/base/PickerGroup'
				},
				{
					name: 'Radio 单选框',
					path: 'pages/base/Radio'
				},
				{
					name: 'Rate 评分',
					path: 'pages/base/Rate'
				},
				{
					name: 'Search 搜索',
					path: 'pages/base/Search'
				},
				{
					name: 'Slider 滑块',
					path: 'pages/base/Slider'
				},
				{
					name: 'Signature 签名',
					path: 'pages/base/Signature'
				},
				{
					name: 'Stepper 步进器',
					path: 'pages/base/Stepper'
				},
				{
					name: 'Switch 开关',
					path: 'pages/base/Switch'
				},
				{
					name: 'TimePicker 时间选择',
					path: 'pages/base/TimePicker'
				},
				{
					name: 'Uploader 文件上传',
					path: 'pages/base/Uploader'
				}
			]
		},
		{
			title: '反馈组件',
			list: [
				{
					name: "ActionSheet 动作面板",
					path: "pages/base/ActionSheet"
				},
				{
					name: 'Dialog 弹出框',
					path: 'pages/base/Dialog'
				},
				{
					name: 'Loading 加载',
					path: 'pages/base/Loading'
				},
				{
					name: 'Notify 消息通知',
					path: 'pages/base/Notify'
				},
				{
					name: 'PullRefresh 下拉刷新',
					path: 'pages/base/PullRefresh'
				},
				{
				  name: 'SwipeCell 滑动单元格',
				  path: 'pages/base/SwipeCell'
				}
			]
		},
		{
			title: '展示组件',
			list: [
				{
					name: 'Badge 徽标',
					path: 'pages/base/Badge'
				},
				{
					name: 'CircleProgress 环形进度条',
					path: 'pages/base/CircleProgress'
				},
				{
					name: 'Collapse 折叠面板',
					path: 'pages/base/Collapse'
				},
				{
					name: 'CountDown 倒计时',
					path: 'pages/base/CountDown'
				},
				{
					name: 'Divider 分割线',
					path: 'pages/base/Divider'
				},
				{
					name: 'Empty 空状态',
					path: 'pages/base/Empty'
				},
				{
					name: 'ImagePreview 图片预览',
					path: 'pages/base/ImagePreview'
				},
				{
					name: 'NoticeBar 通知栏',
					path: 'pages/base/NoticeBar'
				},
				{
					name: 'Popover 气泡弹出框',
					path: 'pages/base/Popover'
				},
				{
					name: 'Progress 进度条',
					path: 'pages/base/Progress'
				},
				{
					name: 'Tag 标签',
					path: 'pages/base/Tag'
				},
				{
					name: 'TextEllipsis 文本省略',
					path: 'pages/base/TextEllipsis'
				},
				{
					name: 'Watermark 水印',
					path: 'pages/base/Watermark'
				},
			]
		},
		{
			title: '导航组件',
			list: [
				{
					name: 'NavBar 导航栏',
					path: 'pages/base/NavBar'
				},
				{
					name: 'SideBar 侧边导航',
					path: 'pages/base/SideBar'
				},
				{
					name: 'Tab 标签页',
					path: 'pages/base/Tab'
				}
			]
		}
	]
	@State extendComponentList: ComponentItem[] = [
		{
			name: 'CanvasDrawer 画布绘制',
			path: 'pages/extend/CanvasDrawer'
		}
	]
	private tabsList: Tab[] = [
		{
			name: '基础组件',
			icon: $r("app.media.icon_base")
		},
		{
			name: '扩展组件',
			icon: $r("app.media.icon_yewu")
		},
		{
			name: '关于',
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
					Span("以下为IBest-UI基础组件，文档详见：")
				}else if(index == 1){
					Span("以下为IBest-UI扩展业务组件，持续更新中...，文档详见：")
				}
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
							title: `${part.title}(${part.list.length})`,
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
					Text("一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库")
						.width("80%")
						.textAlign(TextAlign.Center)
						.fontSize(FONT_SIZE.MD)
						.fontColor(modeColor.textColor4)
					IBestCellGroup({inset: true}){
						IBestCell({
							title: "应用版本",
							value: `v${getAppVersion()}`
						})
						IBestCell({
							title: "组件库版本",
							value: this.uiVersion ? `v${this.uiVersion}` : ""
						})
						IBestCell({
							title: "组件库文档",
							isLink: true,
							onClickCell: () => {
								this.viewUrl("doc")
							}
						})
						IBestCell({
							title: "公司官网",
							isLink: true,
							onClickCell: () => {
								this.viewUrl("company")
							}
						})
						IBestCell({
							title: "隐私政策",
							isLink: true,
							hasBorder: false,
							onClickCell: () => {
								router.pushUrl({
									url: 'pages/PrivacyPolicy'
								})
							}
						})
					}
				}
				Column({ space: SPACE.BASE }){
					Text("皖ICP备16012151号-7A").fontColor(modeColor.primaryColor).fontSize(FONT_SIZE.XS)
					Text("版权所有 © 2025-2026 安徽百得思维信息科技有限公司保留一切权利").fontSize(FONT_SIZE.XS)
				}
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
			Image($r('app.media.title_back'))
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
		this.getUiVersion()
		// setTimeout(() => {
		// 	router.pushUrl({
		// 		url: 'pages/base/CanvasDrawer',
		// 		params: {
		// 			title: "CanvasDrawer 画布绘制"
		// 		}
		// 	})
		// }, 100)
	}
	getTitleOpacity(){
		let scrollY = this.scrollTop < 50 ? this.scrollTop : 50
		return scrollY / 50
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
				action: 'ohos.want.action.viewData',
				entities: ['entity.system.browsable'],
				uri: url
			}
			this.context.startAbility(want)
		}
	}
	async getUiVersion(){
		let filePath = getContext(this).cacheDir + '/BuildProfile.ets'
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