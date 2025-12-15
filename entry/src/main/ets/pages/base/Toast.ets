import { IBestCell, IBestCellGroup, IBestToast } from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import { getResourceStr } from '../../utils/utils'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function ToastBuilder(_: string, title: string){
	ToastPage({title})
}

@Entry
@Component
struct ToastPage {
	@State title: string = ''

	showSpinnerLoading() {
		IBestToast.show({
			type: "loading",
			loadingType: "spinner",
			message: $r("app.string.loading"),
			onOpened: () => {
				console.log("toast打开成功")
			}
		})
		setTimeout(() => {
			IBestToast.hide()
		}, 2000)
	}
	// 动态更新提示
	showCountDownLoading() {
		let count = 3
		let toast = IBestToast.show({
			type: "loading",
			message: `${count} ${getResourceStr($r("app.string.second"))}`,
			duration: 0
		})
		let timer = setInterval(() => {
			count--
			if (count) {
				toast.message = `${count} ${getResourceStr($r("app.string.second"))}`
			} else {
				clearInterval(timer)
				IBestToast.hide()
			}
		}, 1000)
	}

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.basic_usage"), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup() {
							Column() {
								IBestCell({
									title: $r("app.string.basic_usage"),
									isLink: true,
									onCellClick: () => {
										IBestToast.show($r("app.string.content"))
									}
								})
								IBestCell({
									title: $r("app.string.custom_tip", $r("app.string.success")),
									isLink: true,
									onCellClick: () => {
										IBestToast.show({
											type: "success",
											message: $r("app.string.content")
										})
									}
								})
								IBestCell({
									title: $r("app.string.custom_tip", $r("app.string.warning")),
									isLink: true,
									onCellClick: () => {
										IBestToast.show({
											type: "warning",
											message: $r("app.string.content")
										})
									}
								})
								IBestCell({
									title: $r("app.string.custom_tip", $r("app.string.fail")),
									isLink: true,
									onCellClick: () => {
										IBestToast.show({
											type: "fail",
											message: $r("app.string.content")
										})
									}
								})
								IBestCell({
									title: $r("app.string.custom_tip", $r("app.string.load")),
									isLink: true,
									hasBorder: false,
									onCellClick: () => {
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
									onCellClick: () => {
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
									onCellClick: () => {
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
									onCellClick: () => {
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
									onCellClick: () => {
										IBestToast.show({
											position: "top",
											offsetY: "20%",
											message: $r("app.string.content")
										})
									}
								})
								IBestCell({
									title: $r("app.string.bottom"),
									isLink: true,
									hasBorder: false,
									onCellClick: () => {
										IBestToast.show({
											position: "bottom",
											offsetY: "-20%",
											message: $r("app.string.content")
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
									onCellClick: () => {
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
									onCellClick: () => {
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
									onCellClick: () => {
										this.showCountDownLoading()
									}
								})
							}
						}
					}
				}
				ListItem().height(50)
			}
			.layoutWeight(1)
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}