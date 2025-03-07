import router from '@ohos.router';
import { IBestButton, IBestNavBar } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { ComponentRouterParams } from '../../assets/global.type';
import { LengthMetrics } from '@ohos.arkui.node';
@Entry
@Component
struct ButtonPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@Builder Arrow() {
		Image($r('app.media.title_back'))
			.width(CONTAINER_SIZE.SIXTEEN)
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
					ComponentShowContainer({ title: $r("app.string.custom_type", $r("app.string.button")) }) {
						Flex({
							wrap: FlexWrap.Wrap,
							space: { main: LengthMetrics.vp(SPACE.SM), cross: LengthMetrics.vp(SPACE.SM) }
						}) {
							IBestButton({
								text: $r("app.string.custom_button", $r("app.string.primary")),
								type: 'primary'
							})
							IBestButton({
								text: $r("app.string.custom_button", $r("app.string.success")),
								type: 'success'
							})
							IBestButton({
								text: $r("app.string.custom_button", $r("app.string.default")),
								type: 'default'
							})
							IBestButton({
								text: $r("app.string.custom_button", $r("app.string.danger")),
								type: 'danger'
							})
							IBestButton({
								text: $r("app.string.custom_button", $r("app.string.warning")),
								type: 'warning'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_button", $r("app.string.plain")) }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								text: $r("app.string.custom_button", $r("app.string.plain")),
								type: 'primary',
								plain: true
							})
							IBestButton({
								text: $r("app.string.custom_button", $r("app.string.plain")),
								plain: true,
								type: 'success'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.thin_border") }) {
						IBestButton({
							text: $r("app.string.custom_button", $r("app.string.plain")),
							type: 'primary',
							plain: true,
							hairline: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_status", $r("app.string.disabled")) }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								text: $r("app.string.disabled"),
								type: 'primary',
								disabled: true
							})
							IBestButton({
								text: $r("app.string.disabled"),
								type: 'success',
								disabled: true
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_status", $r("app.string.loading")) }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								loading: true,
								type: 'primary',
							})
							IBestButton({
								loadingText: $r("app.string.loading"),
								type: 'success',
								loading: true
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_shape", $r("app.string.button")) }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								text: $r("app.string.custom_button", $r("app.string.square")),
								type: 'primary',
								square: true
							})
							IBestButton({
								text: $r("app.string.custom_button", $r("app.string.circle")),
								type: 'success',
								round: true
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_button", $r("app.string.icon")) }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								type: 'primary',
								icon: 'plus'
							})
							IBestButton({
								text: $r("app.string.button"),
								type: 'primary',
								iconPosition: 'right',
								icon: $r('app.media.ibest_icon_star')
							})
							IBestButton({
								plain: true,
								text: $r("app.string.button"),
								type: 'default',
								iconBuilder: this.Arrow
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_size", $r("app.string.button")) }) {
						Flex({
							wrap: FlexWrap.Wrap,
							alignItems: ItemAlign.Center,
							space: { main: LengthMetrics.vp(SPACE.SM), cross: LengthMetrics.vp(SPACE.SM) }
						}) {
							IBestButton({
								text: $r("app.string.large"),
								type: 'primary',
								buttonSize: 'large'
							})
							IBestButton({
								type: 'primary',
								text: $r("app.string.normal"),
							})
							IBestButton({
								text: $r("app.string.small"),
								type: 'primary',
								buttonSize: 'small'
							})
							IBestButton({
								text: $r("app.string.mini"),
								type: 'primary',
								buttonSize: 'mini'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_style", $r("app.string.custom")) }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								text: $r("app.string.color"),
								color: "#7232dd"
							})
							IBestButton({
								text: $r("app.string.custom_color", $r("app.string.font")),
								fontColor: "#7232dd"
							})
							IBestButton({
								text: $r("app.string.border"),
								btnBorderColor: "red"
							})
							IBestButton({
								type: "primary",
								text: $r("app.string.radius"),
								btnBorderRadius: 16
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_size", $r("app.string.custom")) }) {
						IBestButton({
							text: $r("app.string.custom_size", $r("app.string.custom")),
							btnWidth: 150,
							btnHeight: 40,
							btnFontSize: 16
						})
					}
				}
			}
			.layoutWeight(1)
			.padding({
				left: SPACE.SM,
				right: SPACE.SM,
				bottom: SPACE.SM
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}