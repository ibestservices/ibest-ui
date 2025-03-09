import router from '@ohos.router';
import { IBestButton, IBestNavBar, IBestToast, IBestWatermark } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { ComponentRouterParams } from '../../assets/global.type';
@Entry
@Component
struct WatermarkPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@Builder
	content() {
		Column({space: SPACE.SM}) {
			Text($r("app.string.app_desc"))
			IBestButton({
				type: "primary",
				text: "打开弹框",
				onClickBtn: () => {
					IBestToast.show("点击了按钮")
				}
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(200)
		.padding(20)
		.justifyContent(FlexAlign.Center)
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
					ComponentShowContainer({ title: '文字水印', titlePaddingLeft: SPACE.XS }) {
						IBestWatermark({
							text: 'IBest-UI',
							gapX: 40,
							gapY: 40
						}) {
							this.content()
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '图片水印', titlePaddingLeft: SPACE.XS }) {
						Column({space: SPACE.SM}){
							IBestWatermark({
								imageUrl: $r("app.media.app_icon"),
								waterMarkWidth: 40,
								waterMarkHeight: 40,
								gapX: 40,
								gapY: 40,
								rotateDeg: 0
							}) {
								this.content()
							}
							IBestWatermark({
								imageUrl: 'https://fastly.jsdelivr.net/npm/@vant/assets/logo.png',
								waterMarkWidth: 40,
								waterMarkHeight: 40,
								gapX: 40,
								gapY: 40,
								rotateDeg: 30
							}) {
								this.content()
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义间隔', titlePaddingLeft: SPACE.XS }) {
						IBestWatermark({
							text: $r("app.string.app_name"),
							gapX: 80,
							gapY: 80
						}) {
							this.content()
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义倾斜角度', titlePaddingLeft: SPACE.XS }) {
						IBestWatermark({
							text: $r("app.string.app_name"),
							fontSize: 14,
							gapX: 20,
							gapY: 20,
							rotateDeg: 0
						}) {
							this.content()
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义层级', titlePaddingLeft: SPACE.XS }) {
						IBestWatermark({
							text: $r("app.string.app_name"),
							gapX: 40,
							gapY: 40,
							waterMarkZIndex: 1
						}) {
							this.content()
						}
					}
				}
			}
			.layoutWeight(1)
			.padding({ bottom: SPACE.SM })
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}