import BuildProfile from '@ibestservices/ibest-ui/BuildProfile'
import { IBestNavBar } from '@ibestservices/ibest-ui'
import router from '@ohos.router'
import { BORDER_RADIUS, CONTAINER_SIZE, FONT_SIZE, FONT_WEIGHT, modeColor, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'
import GlobalStore from '../utils/global'
import { common, Want } from '@kit.AbilityKit'

interface ComponentPart {
	title: string
	list: ComponentItem[]
}
interface ComponentItem {
	name: string,
	path: string
}
@Entry
@Component
struct Index {
	@State componentList: ComponentPart[] = [
		{
			title: '基础组件',
			list: [
				{
					name: 'Button 按钮',
					path: 'pages/Button'
				},
				{
					name: 'Cell 单元格',
					path: 'pages/Cell'
				},
				{
					name: 'Icon 图标',
					path: 'pages/Icon'
				},
				{
					name: 'Popup 弹出层',
					path: 'pages/Popup'
				},
				{
					name: 'Theme 主题',
					path: 'pages/Theme'
				},
				{
					name: 'Toast 轻提示',
					path: 'pages/Toast'
				}
			]
		},
		{
			title: '表单组件',
			list: [
				{
					name: 'Calendar 日历',
					path: 'pages/Calendar'
				},
				{
					name: 'Cascader 级联选择',
					path: 'pages/Cascader'
				},
				{
					name: 'Checkbox 复选框',
					path: 'pages/Checkbox'
				},
				{
					name: 'DatePicker 日期选择',
					path: 'pages/DatePicker'
				},
				{
					name: 'Field 输入框',
					path: 'pages/Field'
				},
				{
					name: 'Form 表单',
					path: 'pages/Form'
				},
				{
					name: 'NumberKeyboard 数字键盘',
					path: 'pages/NumberKeyboard'
				},
				{
					name: 'PasswordInput 密码输入框',
					path: 'pages/PasswordInput'
				},
				{
					name: 'Picker 选择器',
					path: 'pages/Picker'
				},
				{
					name: 'PickerGroup 选择器组',
					path: 'pages/PickerGroup'
				},
				{
					name: 'Radio 单选框',
					path: 'pages/Radio'
				},
				{
					name: 'Rate 评分',
					path: 'pages/Rate'
				},
				{
					name: 'Search 搜索',
					path: 'pages/Search'
				},
				{
					name: 'Slider 滑块',
					path: 'pages/Slider'
				},
				{
					name: 'Signature 签名',
					path: 'pages/Signature'
				},
				{
					name: 'Stepper 步进器',
					path: 'pages/Stepper'
				},
				{
					name: 'Switch 开关',
					path: 'pages/Switch'
				},
				{
					name: 'TimePicker 时间选择',
					path: 'pages/TimePicker'
				},
				{
					name: 'Uploader 文件上传',
					path: 'pages/Uploader'
				}
			]
		},
		{
			title: '反馈组件',
			list: [
				{
					name: "ActionSheet 动作面板",
					path: "pages/ActionSheet"
				},
				{
					name: 'Dialog 弹出框',
					path: 'pages/Dialog'
				},
				{
					name: 'Loading 加载',
					path: 'pages/Loading'
				},
				{
					name: 'Notify 消息通知',
					path: 'pages/Notify'
				},
				{
					name: 'PullRefresh 下拉刷新',
					path: 'pages/PullRefresh'
				},
				{
				  name: 'SwipeCell 滑动单元格',
				  path: 'pages/SwipeCell'
				}
			]
		},
		{
			title: '展示组件',
			list: [
				{
					name: 'Badge 徽标',
					path: 'pages/Badge'
				},
				{
					name: 'CircleProgress 环形进度条',
					path: 'pages/CircleProgress'
				},
				{
					name: 'Collapse 折叠面板',
					path: 'pages/Collapse'
				},
				{
					name: 'CountDown 倒计时',
					path: 'pages/CountDown'
				},
				{
					name: 'Divider 分割线',
					path: 'pages/Divider'
				},
				{
					name: 'Empty 空状态',
					path: 'pages/Empty'
				},
				{
					name: 'ImagePreview 图片预览',
					path: 'pages/ImagePreview'
				},
				{
					name: 'NoticeBar 通知栏',
					path: 'pages/NoticeBar'
				},
				{
					name: 'Popover 气泡弹出框',
					path: 'pages/Popover'
				},
				{
					name: 'Progress 进度条',
					path: 'pages/Progress'
				},
				{
					name: 'Tag 标签',
					path: 'pages/Tag'
				},
				{
					name: 'TextEllipsis 文本省略',
					path: 'pages/TextEllipsis'
				},
				{
					name: 'Watermark 水印',
					path: 'pages/Watermark'
				},
			]
		},
		{
			title: '导航组件',
			list: [
				{
					name: 'NavBar 导航栏',
					path: 'pages/NavBar'
				},
				{
					name: 'SideBar 侧边导航',
					path: 'pages/SideBar'
				},
				{
					name: 'Tab 标签页',
					path: 'pages/Tab'
				}
			]
		},
		{
			title: '业务组件',
			list: [
				{
					name: 'CanvasDrawer 画布绘制',
					path: 'pages/CanvasDrawer'
				}
			]
		}
	]
	@State titleOpacity: number = 0
	private scrollerForList: Scroller = new Scroller()
	private context = getContext(this) as common.UIAbilityContext

	aboutToAppear(): void {
		// setTimeout(() => {
		// 	router.pushUrl({
		// 		url: 'pages/CanvasDrawer',
		// 		params: {
		// 			title: "CanvasDrawer 画布绘制"
		// 		}
		// 	})
		// }, 100)
	}
	viewDoc(){
		let want: Want = {
			action: 'ohos.want.action.viewData',
			entities: ['entity.system.browsable'],
			uri: 'https://ibestui.ibestservices.com/guide/home/'
		}
		this.context.startAbility(want)
	}
	build() {
		Column(){
			IBestNavBar({
				title: "IBest-UI",
				isShowLeft: false,
				isShowStatusBar: true,
				onTitleClick: () => {
					this.scrollerForList.scrollTo({xOffset: 0, yOffset: 0, animation: true})
				}
			}).position({left: 0, top: 0}).zIndex(1).opacity(this.titleOpacity)
			List({scroller: this.scrollerForList}) {
				ListItem() {
					Column({ space: SPACE.MD }) {
						Row({ space: SPACE.XS }) {
							Image($r("app.media.app_icon")).width(32).borderRadius(BORDER_RADIUS.BASE)
							Text(`IBest-UI(v${BuildProfile.HAR_VERSION})`).fontSize(32).fontColor($r("app.color.doc_text_color_2"))
						}
						Text(){
							Span("一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库，")
							Span("点此可查看文档。").onClick(() => {
								this.viewDoc()
							})
						}
							.fontSize(FONT_SIZE.MD)
							.fontColor($r("app.color.doc_text_color_4"))
					}
					.width("100%")
					.alignItems(HorizontalAlign.Start)
					.padding({ left: 10, top: GlobalStore.topAvoidHeight })
				}
				ForEach(this.componentList, (part: ComponentPart) => {
					ListItem() {
						ComponentShowContainer({ title: `${part.title}(${part.list.length})`, titlePaddingLeft: SPACE.XS }) {
							ForEach(part.list, (item: ComponentItem) => {
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
							})
						}
					}
				})
				ListItem() {
					Text("隐私政策")
						.width(CONTAINER_SIZE.FULL)
						.textAlign(TextAlign.Center)
						.fontSize(14)
						.fontColor(modeColor.textColor4)
						.margin({top: SPACE.MD, bottom: SPACE.XL})
						.onClick(() => {
							router.pushUrl({
								url: 'pages/PrivacyPolicy'
							})
						})
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.layoutWeight(1)
			.edgeEffect(EdgeEffect.None)
			.padding({ left: SPACE.MD, right: SPACE.MD })
			.backgroundColor(modeColor.bg)
			.onDidScroll(() => {
				let scrollY = this.scrollerForList.currentOffset().yOffset
				scrollY = scrollY < 50 ? scrollY : 50
				this.titleOpacity = scrollY / 50
			})
		}
	}
}