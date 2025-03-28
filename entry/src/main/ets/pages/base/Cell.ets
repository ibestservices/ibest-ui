import router from '@ohos.router';
import { IBestCell, IBestCellGroup, IBestNavBar, IBestTag } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { ComponentRouterParams } from '../../assets/global.type';
@Entry
@Component
struct CellPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State showTag: boolean = true;
	@State inputValue: string = ''
	@Builder StarIcon(width = 16) {
		Image($r('app.media.app_icon')).width(width)
	}
	@Builder Arrow() {
		Image($r('app.media.title_back')).height(14).margin({ left: SPACE.BASE }).rotate({ angle: 180 })
	}
	@Builder Title() {
		Row() {
			Text($r("app.string.title"))
				.fontSize(14)
			IBestTag({ text: $r("app.string.tag") }).margin({
				left: SPACE.BASE
			})
		}
	}
	@Builder InputContain() {
		TextInput({ placeholder: $r("app.string.custom_placeholder", $r("app.string.content")) })
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
							IBestCell({ title: $r("app.string.title"), value: $r("app.string.content") })
							IBestCell({
								title: $r("app.string.title"),
								value: $r("app.string.content"),
								label: $r("app.string.desc"),
								hasBorder: false
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_style", $r("app.string.border")), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup() {
							IBestCell({ title: 'full', value: $r("app.string.content"), borderSizeType: 'full' })
							IBestCell({ title: 'center', value: $r("app.string.content"), borderSizeType: 'center' })
							IBestCell({
								leftIcon: $r("app.media.icon_like_o"),
								title: 'right',
								value: $r("app.string.content"),
								borderSizeType: 'right'
							})
							IBestCell({ title: $r("app.string.title"), value: $r("app.string.content"), hasBorder: false })
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_style", $r("app.string.card")), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({ title: $r("app.string.title"), value: $r("app.string.content") })
							IBestCell({
								title: $r("app.string.title"),
								value: $r("app.string.content"),
								label: $r("app.string.desc"),
								hasBorder: false
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.group"), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup({ title: $r("app.string.custom_group", 1) }) {
							IBestCell({
								title: $r("app.string.title"),
								value: $r("app.string.content"),
								label: $r("app.string.desc"),
								hasBorder: false
							})
						}
						IBestCellGroup({ title: $r("app.string.custom_group", 2) }) {
							IBestCell({
								title: $r("app.string.title"),
								value: $r("app.string.content"),
								label: $r("app.string.desc"),
								hasBorder: false
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.custom_size", $r("app.string.custom")), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup() {
							IBestCell({
								title: $r("app.string.title"),
								value: $r("app.string.content"),
								label: $r("app.string.desc"),
								hasBorder: false,
								cellSize: 'large'
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.icon"), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup() {
							IBestCell({
								title: $r("app.string.title"),
								value: $r("app.string.content"),
								leftIcon: $r("app.media.icon_like")
							})
							IBestCell({
								title: $r("app.string.title"),
								value: $r("app.string.content"),
								iconBuilder: () => this.StarIcon()
							})
							IBestCell({
								title: $r("app.string.title"),
								value: $r("app.string.content"),
								rightIcon: $r("app.media.ibest_icon_star"),
								rightIconColor: '#FF0000',
								hasBorder: false
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.arrow"), titlePaddingLeft: SPACE.XS }) {
						IBestCellGroup() {
							IBestCell({ title: $r("app.string.title"), value: $r("app.string.content"), isLink: true })
							IBestCell({
								title: $r("app.string.title"),
								value: $r("app.string.content"),
								isLink: true,
								arrowDirection: 'bottom'
							})
							IBestCell({
								title: $r("app.string.title"),
								value: $r("app.string.content"),
								isLink: true,
								arrowDirection: 'left'
							})
							IBestCell({
								title: $r("app.string.title"),
								value: $r("app.string.content"),
								isLink: true,
								arrowDirection: 'top',
								hasBorder: false
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.disabled"), titlePaddingLeft: SPACE.XS }) {
						IBestCell({
							title: $r("app.string.title"),
							value: $r("app.string.content"),
							hasBorder: false,
							disabled: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.required"), titlePaddingLeft: SPACE.XS }) {
						IBestCell({
							title: $r("app.string.title"),
							value: $r("app.string.content"),
							center: true,
							required: true,
							hasBorder: false,
							valueBuilder: (): void => this.InputContain()
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.position"), titlePaddingLeft: SPACE.XS }) {
						IBestCell({
							title: $r("app.string.title"),
							label: $r("app.string.desc"),
							leftContentWidth: 100,
							value: $r("app.string.long_text"),
							center: true,
							iconBuilder: () => this.StarIcon(),
							isLink: true
						})
						IBestCell({
							title: $r("app.string.title"),
							label: $r("app.string.desc"),
							value: $r("app.string.long_text"),
							hasBorder: false,
							iconBuilder: () => this.StarIcon(),
							isLink: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: $r("app.string.slot"), titlePaddingLeft: SPACE.XS }) {
						IBestCell({
							title: $r("app.string.title"),
							value: $r("app.string.long_text"),
							iconBuilder: () => this.StarIcon(),
							rightIconBuilder: this.Arrow,
							clickable: true
						})
						IBestCell({
							titleBuilder: this.Title,
							value: $r("app.string.content"),
							rightIconBuilder: this.Arrow,
							clickable: true
						})
						IBestCell({
							title: $r("app.string.title"),
							iconBuilder: () => this.StarIcon(),
							hasBorder: false,
							rightIconBuilder: this.Arrow,
							clickable: true
						})
					}
				}
			}
			.layoutWeight(1)
			.padding({ bottom: SPACE.MD })
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}