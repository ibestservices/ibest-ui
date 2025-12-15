import { IBestButton } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { LengthMetrics } from '@ohos.arkui.node';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function ButtonBuilder(_: string, title: string){
	ButtonPage({title})
}

@Entry
@Component
struct ButtonPage {
	@State title: string = ''
	@Builder Arrow() {
		Image($r('app.media.title_back'))
			.width(CONTAINER_SIZE.SIXTEEN)
	}
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
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
					ComponentShowContainer({ title: $r("app.string.loading") }) {
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
								type: 'primary',
								text: $r("app.string.button"),
								iconPosition: 'top',
								icon: $r("app.media.app_icon")
							})
							IBestButton({
								type: 'primary',
								text: $r("app.string.button"),
								iconPosition: 'bottom',
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
						Flex({
							wrap: FlexWrap.Wrap,
							alignItems: ItemAlign.Center,
							space: { main: LengthMetrics.vp(SPACE.SM), cross: LengthMetrics.vp(SPACE.SM) }
						}) {
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
								btnBorder: {
									width: 2,
									color: "red",
									style: BorderStyle.Dashed,
									radius: 16
								}
							})
							IBestButton({
								type: "primary",
								text: $r("app.string.radius"),
								btnBorderRadius: 16
							})
							IBestButton({
								type: "primary",
								text: $r("app.string.padding"),
								btnPadding: 5
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
				ListItem().height(50)
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}