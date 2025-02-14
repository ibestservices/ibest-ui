import router from '@ohos.router';
import { IBestButton, IBestNavBar, IBestToast } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { ComponentRouterParams } from '../../assets/global.type';
import { LengthMetrics } from '@ohos.arkui.node';
@Entry
@Component
struct ButtonPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@Builder
	Arrow() {
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
					ComponentShowContainer({ title: '按钮类型' }) {
						Flex({
							wrap: FlexWrap.Wrap,
							space: { main: LengthMetrics.vp(SPACE.SM), cross: LengthMetrics.vp(SPACE.SM) }
						}) {
							IBestButton({
								text: '主要按钮',
								type: 'primary'
							})
							IBestButton({
								text: '成功按钮',
								type: 'success'
							})
							IBestButton({
								text: '默认按钮',
								type: 'default'
							})
							IBestButton({
								text: '危险按钮',
								type: 'danger'
							})
							IBestButton({
								text: '警告按钮',
								type: 'warning'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '朴素按钮' }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								text: '朴素按钮',
								type: 'primary',
								plain: true
							})
							IBestButton({
								text: '朴素按钮',
								plain: true,
								type: 'success'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '细边框' }) {
						IBestButton({
							text: '朴素按钮',
							type: 'primary',
							plain: true,
							hairline: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用状态' }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								text: '禁用状态',
								type: 'primary',
								disabled: true
							})
							IBestButton({
								text: '禁用状态',
								type: 'success',
								disabled: true
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '加载状态' }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								loading: true,
								type: 'primary',
							})
							IBestButton({
								text: '加载状态',
								loadingText: '加载中...',
								type: 'success',
								loading: true
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '按钮形状' }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								text: '方形按钮',
								type: 'primary',
								square: true
							})
							IBestButton({
								text: '圆形按钮',
								type: 'success',
								round: true
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '图标按钮' }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								type: 'primary',
								icon: 'plus'
							})
							IBestButton({
								text: '按钮',
								type: 'primary',
								iconPosition: 'right',
								icon: $r('app.media.ibest_icon_star')
							})
							IBestButton({
								plain: true,
								text: '按钮',
								type: 'default',
								iconBuilder: this.Arrow
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '按钮尺寸' }) {
						Flex({
							wrap: FlexWrap.Wrap,
							alignItems: ItemAlign.Center,
							space: { main: LengthMetrics.vp(SPACE.SM), cross: LengthMetrics.vp(SPACE.SM) }
						}) {
							IBestButton({
								text: '大号按钮',
								type: 'primary',
								buttonSize: 'large'
							})
							IBestButton({
								type: 'primary',
								text: '普通按钮',
							})
							IBestButton({
								text: '小型按钮',
								type: 'primary',
								buttonSize: 'small'
							})
							IBestButton({
								text: '迷你按钮',
								type: 'primary',
								buttonSize: 'mini'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式' }) {
						Row({ space: SPACE.SM }) {
							IBestButton({
								text: '颜色',
								color: "#7232dd"
							})
							IBestButton({
								text: '字体色',
								fontColor: "#7232dd"
							})
							IBestButton({
								text: '边框',
								btnBorderColor: "red"
							})
							IBestButton({
								type: "primary",
								text: '圆角',
								btnBorderRadius: 16
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义大小' }) {
						IBestButton({
							text: '自定义大小按钮',
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