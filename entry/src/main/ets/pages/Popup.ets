import { IBestCell, IBestCellGroup, IBestPopup, IBestToast } from "@ibestservices/ibest-ui"
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { BACKGROUND_COLOR, CONTAINER_SIZE, FONT_SIZE, SPACE } from '../assets/styles/BaseStyle'

@Extend(Column) function positionColStyle(bd: boolean = false){
	.layoutWeight(1)
	.height("150lpx")
	.justifyContent(FlexAlign.Center)
	.border({width:{left: bd ? 1 : 0}, color: "#ebedf0"})
}
@Extend(Image) function positionImageStyle(){
	.width("50lpx")
	.aspectRatio(1)
	.fillColor("#333")
}

@Entry
@Component
struct PopupPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State baseVisible: boolean = false
	@State upVisible: boolean = false
	@State downVisible: boolean = false
	@State leftVisible: boolean = false
	@State rightVisible: boolean = false
	@State showHeaderVisible: boolean = false
	@State cusCloseIconVisible: boolean = false
	@State centerCornerVisible: boolean = false
	@State bottomCornerVisible: boolean = false
	@State eventVisible: boolean = false
	@State safeAreaVisible: boolean = false

	@Builder centerBuilder() {
		Row() {
			Text("内容")
		}
		.width("100%")
		.aspectRatio(1)
		.justifyContent(FlexAlign.Center)
	}
	@Builder safeBuilder() {
		Column(){
			Text("内容")
			Text("内容")
		}
		.width("100%")
		.height("100%")
		.justifyContent(FlexAlign.SpaceBetween)
		.alignItems(HorizontalAlign.Center)
	}

	build() {
		Column(){
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SMALL }) {
						IBestCellGroup({ inset: true }) {
							Column() {
								IBestCell({
									title: '展示弹出层',
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.baseVisible = true
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '弹出位置', titlePaddingLeft: SPACE.SMALL }) {
						IBestCellGroup({ inset: true }) {
							Row(){
								Column(){
									Image($r("app.media.arrow_up"))
										.positionImageStyle()
									Text("顶部弹出")
										.margin({top: "16lpx"})
										.fontSize(FONT_SIZE.MINI)
								}
								.positionColStyle()
								.onClick(() => {
									this.upVisible = true
								})
								Column(){
									Image($r("app.media.arrow_down"))
										.positionImageStyle()
									Text("底部弹出")
										.margin({top: "16lpx"})
										.fontSize(FONT_SIZE.MINI)
								}
								.positionColStyle(true)
								.onClick(() => {
									this.downVisible = true
								})
								Column(){
									Image($r("app.media.arrow_left"))
										.positionImageStyle()
									Text("左侧弹出")
										.margin({top: "16lpx"})
										.fontSize(FONT_SIZE.MINI)
								}
								.positionColStyle(true)
								.onClick(() => {
									this.leftVisible = true
								})
								Column(){
									Image($r("app.media.arrow_right"))
										.positionImageStyle()
									Text("右侧弹出")
										.margin({top: "16lpx"})
										.fontSize(FONT_SIZE.MINI)
								}
								.positionColStyle(true)
								.onClick(() => {
									this.rightVisible = true
								})
							}
							.width(CONTAINER_SIZE.FULL)
							.backgroundColor("#fff")
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '显示标题', titlePaddingLeft: SPACE.SMALL }) {
						IBestCellGroup({ inset: true }) {
							Column() {
								IBestCell({
									title: '显示标题',
									isLink: true,
									onClickCell: () => {
										this.showHeaderVisible = true
									}
								})
								IBestCell({
									title: '自定义关闭图标',
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.cusCloseIconVisible = true
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '圆角弹窗', titlePaddingLeft: SPACE.SMALL }) {
						IBestCellGroup({ inset: true }) {
							Column() {
								IBestCell({
									title: '圆角弹窗(居中)',
									isLink: true,
									onClickCell: () => {
										this.centerCornerVisible = true
									}
								})
								IBestCell({
									title: '圆角弹窗(底部)',
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.bottomCornerVisible = true
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '事件监听', titlePaddingLeft: SPACE.SMALL }) {
						IBestCellGroup({ inset: true }) {
							Column() {
								IBestCell({
									title: '监听显示事件',
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.eventVisible = true
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '安全区域适配', titlePaddingLeft: SPACE.SMALL }) {
						IBestCellGroup({ inset: true }) {
							Column() {
								IBestCell({
									title: '安全区域适配',
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.safeAreaVisible = true
									}
								})
							}
						}
					}
				}
			}
			.layoutWeight(1)
			// 基础展示
			IBestPopup({
				visible: $baseVisible,
				popupWidth: 500,
				contentBuilder: this.centerBuilder
			})
			// 弹框位置
			IBestPopup({
				visible: $upVisible,
				popupAlign: "top"
			})
			IBestPopup({
				visible: $downVisible,
				popupAlign: "bottom"
			})
			IBestPopup({
				visible: $leftVisible,
				popupAlign: "left"
			})
			IBestPopup({
				visible: $rightVisible,
				popupAlign: "right"
			})
			// 关闭图标
			IBestPopup({
				visible: $showHeaderVisible,
				popupWidth: 500,
				cornerRadius: 20,
				isShowHeader: true,
				title: "标题",
				contentBuilder: this.centerBuilder
			})
			IBestPopup({
				visible: $cusCloseIconVisible,
				popupAlign: "bottom",
				isShowHeader: true,
				title: "标题",
				closeIcon: "https://ibestui.ibestservices.com/favicon.ico"
			})
			// 圆角弹窗
			IBestPopup({
				visible: $centerCornerVisible,
				popupWidth: 500,
				cornerRadius: 10,
				contentBuilder: this.centerBuilder
			})
			IBestPopup({
				visible: $bottomCornerVisible,
				popupAlign: "bottom",
				cornerRadius: 30
			})
			// 事件监听
			IBestPopup({
				visible: $eventVisible,
				popupAlign: "bottom",
				onOpen: () => {
					IBestToast.show("open")
				},
				onClose: () => {
					IBestToast.show("close")
				}
			})
			// 安全区域适配
			IBestPopup({
				visible: $safeAreaVisible,
				popupAlign: "left",
				contentBuilder: this.safeBuilder,
				safeAreaInsetTop: true,
				safeAreaInsetBottom: true
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(BACKGROUND_COLOR.BASE)
	}
}