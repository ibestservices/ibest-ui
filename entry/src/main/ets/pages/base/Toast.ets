import { IBestCell, IBestCellGroup, IBestNavBar, IBestToast } from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../../assets/global.type'
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle'
import { common } from '@kit.AbilityKit'
@Entry
@Component
struct ToastPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	private context = getContext() as common.UIAbilityContext
	showSpinnerLoading() {
		IBestToast.show({
			type: "loading",
			loadingType: "spinner",
			message: $r("app.string.loading"),
			onOpened: () => {
				// 可在此处延时关闭toast
				console.log("toast打开成功")
			}
		})
		setTimeout(() => {
			// 也可在此处关闭toast
			IBestToast.hide()
		}, 2000)
	}
	// 动态更新提示
	showCountDownLoading() {
		let count = 3
		let toast = IBestToast.show({
			type: "loading",
			message: `${count} ${this.getResourceStr($r("app.string.second"))}`,
			duration: 0
		})
		let timer = setInterval(() => {
			count--
			if (count) {
				toast.message = `${count} ${this.getResourceStr($r("app.string.second"))}`
			} else {
				clearInterval(timer)
				IBestToast.hide()
			}
		}, 1000)
	}
	getResourceStr(res: Resource){
		return this.context.resourceManager.getStringSync(res)
	}
	build() {
		Column() {
			IBestNavBar({
				title: this.title,
				isShowStatusBar: true,
				onLeftClick: () => {
					router.back()
				}
			})
			List() {
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.basic_usage"), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup() {
							Column() {
								IBestCell({
									title: $r("app.string.basic_usage"),
									isLink: true,
									onClickCell: () => {
										IBestToast.show(this.getResourceStr($r("app.string.content")))
									}
								})
								IBestCell({
									title: $r("app.string.custom_tip", $r("app.string.success")),
									isLink: true,
									onClickCell: () => {
										IBestToast.show({
											type: "success",
											message: this.getResourceStr($r("app.string.content"))
										})
									}
								})
								IBestCell({
									title: $r("app.string.custom_tip", $r("app.string.warning")),
									isLink: true,
									onClickCell: () => {
										IBestToast.show({
											type: "warning",
											message: this.getResourceStr($r("app.string.content"))
										})
									}
								})
								IBestCell({
									title: $r("app.string.custom_tip", $r("app.string.fail")),
									isLink: true,
									onClickCell: () => {
										IBestToast.show({
											type: "fail",
											message: this.getResourceStr($r("app.string.content"))
										})
									}
								})
								IBestCell({
									title: $r("app.string.custom_tip", $r("app.string.load")),
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										IBestToast.showLoading()
										setTimeout(() => {
											IBestToast.hide()
										}, 1500)
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_custom", $r("app.string.icon")), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup() {
							Column() {
								IBestCell({
									title: $r("app.string.custom_custom", $r("app.string.icon")),
									isLink: true,
									onClickCell: () => {
										IBestToast.show({
											icon: $r("app.media.app_icon"),
											message: $r("app.string.app_name"),
											iconWidth: 50
										})
									}
								})
								IBestCell({
									title: $r("app.string.custom_custom", $r("app.string.image")),
									isLink: true,
									onClickCell: () => {
										IBestToast.show({
											icon: "https://ibestui.ibestservices.com/favicon.ico",
											message: $r("app.string.app_name")
										})
									}
								})
								IBestCell({
									title: $r("app.string.custom_custom", $r("app.string.load_icon_type")),
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.showSpinnerLoading()
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.position"), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup() {
							Column() {
								IBestCell({
									title: $r("app.string.top"),
									isLink: true,
									onClickCell: () => {
										IBestToast.show({
											position: "top",
											offsetY: "20%",
											message: this.getResourceStr($r("app.string.content"))
										})
									}
								})
								IBestCell({
									title: $r("app.string.bottom"),
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										IBestToast.show({
											position: "bottom",
											offsetY: "-20%",
											message: this.getResourceStr($r("app.string.content"))
										})
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.break_type"), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup() {
							Column() {
								IBestCell({
									title: $r("app.string.truncation_word"),
									isLink: true,
									onClickCell: () => {
										IBestToast.show({
											wordBreak: "break-all",
											message: "This message will contain a incomprehensibilities long word."
										})
									}
								})
								IBestCell({
									title: $r("app.string.not_truncation_word"),
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										IBestToast.show({
											wordBreak: "break-word",
											message: "This message will contain a incomprehensibilities long word."
										})
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_dynamics", $r("app.string.update")), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup() {
							Column() {
								IBestCell({
									title: $r("app.string.custom_dynamics", $r("app.string.update")),
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.showCountDownLoading()
									}
								})
							}
						}
					}
				}
			}.layoutWeight(1)
			.padding({ bottom: SPACE.SM })
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}