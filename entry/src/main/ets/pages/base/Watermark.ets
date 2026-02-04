import { IBestButton, IBestToast, IBestWatermark } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function WatermarkBuilder(_: string, title: string){
	WatermarkPage({title})
}

@Entry
@Component
struct WatermarkPage {
	@State title: string = ''
	@Builder content() {
		Column({space: SPACE.SM}) {
			Text($r("app.string.app_desc"))
			IBestButton({
				type: "primary",
				text: "打开弹框",
				onBtnClick: () => {
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
		NavDestination() {
			CustomNavBar({title: this.title})
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
					ComponentShowContainer({ title: '图片水印', titlePaddingLeft: SPACE.XS, space: SPACE.SM }) {
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
				ListItem().height(50)
			}
			.layoutWeight(1)
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}