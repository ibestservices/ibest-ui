import { IBestButton, IBestSignature, IBestSignatureController } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function SignatureBuilder(_: string, title: string){
	SignaturePage({title})
}

@Entry
@Component
struct SignaturePage {
	@State title: string = ''
	@State imgUrl: PixelMap | null = null
	@State imgUrl1: PixelMap | null = null
	@State imgUrl2: PixelMap | null = null
	@State imgUrl3: PixelMap | null = null
	private controller: IBestSignatureController = new IBestSignatureController()

	@Builder imgUrlView(url: PixelMap) {
		Image(url)
			.margin({ top: 20 })
	}
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						IBestSignature({
							onConfirm: (pixelMap: PixelMap) => {
								this.imgUrl = pixelMap
							},
							onClear: () => {
								this.imgUrl = null
							}
						})
						if(this.imgUrl){
							this.imgUrlView(this.imgUrl)
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式' }) {
						IBestSignature({
							penColor: "#ff0000",
							lineWidth: 5,
							bgColor: "#eee",
							onConfirm: (pixelMap: PixelMap) => {
								this.imgUrl1 = pixelMap
							},
							onClear: () => {
								this.imgUrl1 = null
							}
						})
						if(this.imgUrl1){
							this.imgUrlView(this.imgUrl1)
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义宽高' }) {
						IBestSignature({
							boardWidth: 260,
							boardHeight: 150,
							onConfirm: (pixelMap: PixelMap) => {
								this.imgUrl2 = pixelMap
							},
							onClear: () => {
								this.imgUrl2 = null
							}
						})
						if(this.imgUrl2){
							this.imgUrlView(this.imgUrl2)
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: 'controller 控制器' }) {
						IBestSignature({
							controller: this.controller,
							isShowFooter: false,
							onConfirm: (pixelMap: PixelMap) => {
								this.imgUrl3 = pixelMap
							},
							onClear: () => {
								this.imgUrl3 = null
							}
						})
						if(this.imgUrl3){
							this.imgUrlView(this.imgUrl3)
						}
						Row({ space: 10 }){
							IBestButton({
								text: '清空',
								onBtnClick: () => {
									this.controller.clear()
								}
							})
							IBestButton({
								text: '确认',
								type: 'primary',
								onBtnClick: () => {
									this.controller.confirm()
								}
							})
						}.margin({ top: 10 })
					}
				}
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}