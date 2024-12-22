import {
    IBestButton,
    IBestCell,
    IBestCellGroup,
    IBestIcon,
    IBestNavBar,
    IBestPopup,
    IBestToast
} from '@ibestservices/ibest-ui'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle'

@Extend(Column) function positionColStyle(bd: boolean = false){
	.layoutWeight(1)
	.height(75)
	.justifyContent(FlexAlign.Center)
	.border({width:{left: bd ? 1 : 0}, color: modeColor.borderColor})
	.stateStyles({
		normal:{
			.backgroundColor(modeColor.bg2)
		},
		pressed:{
			.backgroundColor(modeColor.active)
		}
	})
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
	@State popupHeight: number = 150

	@Builder centerBuilder() {
		Column({space: 20}) {
			Text("内容")
				.fontSize(14)
				.fontColor(modeColor.textColor)
			IBestButton({
				text: "切换高度",
				type: "primary",
				onClickBtn: () => {
					this.popupHeight = this.popupHeight == 150 ? 300 : 150
				}
			})
		}
		.width("100%")
		.padding(20)
		.justifyContent(FlexAlign.Center)
	}
	@Builder safeBuilder() {
		Column(){
			Text("内容").fontSize(14)
			Text("内容").fontSize(14)
		}
		.width("100%")
		.height("100%")
		.justifyContent(FlexAlign.SpaceBetween)
		.alignItems(HorizontalAlign.Center)
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
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }) {
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
					ComponentShowContainer({ title: '弹出位置', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							Row(){
								Column({space: 8}){
									IBestIcon({
										name: "arrow-up",
										iconSize: 25
									})
									Text("顶部弹出")
										.fontSize(12)
								}
								.positionColStyle()
								.onClick(() => {
									this.upVisible = true
								})
								Column({space: 8}){
									IBestIcon({
										name: "arrow-down",
										iconSize: 25
									})
									Text("底部弹出")
										.fontSize(12)
								}
								.positionColStyle(true)
								.onClick(() => {
									this.downVisible = true
								})
								Column({space: 8}){
									IBestIcon({
										name: "arrow-left",
										iconSize: 25
									})
									Text("左侧弹出")
										.fontSize(12)
								}
								.positionColStyle(true)
								.onClick(() => {
									this.leftVisible = true
								})
								Column({space: 8}){
									IBestIcon({
										name: "arrow",
										iconSize: 25
									})
									Text("右侧弹出")
										.fontSize(12)
								}
								.positionColStyle(true)
								.onClick(() => {
									this.rightVisible = true
								})
							}
							.width(CONTAINER_SIZE.FULL)
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '显示标题', titlePaddingLeft: SPACE.MD }) {
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
					ComponentShowContainer({ title: '圆角弹窗', titlePaddingLeft: SPACE.MD }) {
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
					ComponentShowContainer({ title: '事件监听', titlePaddingLeft: SPACE.MD }) {
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
					ComponentShowContainer({ title: '安全区域适配', titlePaddingLeft: SPACE.MD }) {
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
				popupWidth: 300,
				popupHeight: this.popupHeight,
				contentBuilder: (): void => this.centerBuilder()
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
				popupWidth: 300,
				cornerRadius: 20,
				isShowHeader: true,
				title: "标题",
				contentBuilder: (): void => this.centerBuilder()
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
				popupWidth: 300,
				cornerRadius: 10,
				contentBuilder: (): void => this.centerBuilder()
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
				contentBuilder: (): void => this.safeBuilder(),
				safeAreaInsetTop: true,
				safeAreaInsetBottom: true
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}