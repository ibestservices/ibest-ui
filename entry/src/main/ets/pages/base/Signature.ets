import router from '@ohos.router';
import { IBestButton, IBestNavBar, IBestSignature, IBestSignatureController } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { ComponentRouterParams } from '../../assets/global.type';

class params {
	url: PixelMap | null = null
}

@Entry
@Component
struct SignaturePage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
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
			.padding({
				left: SPACE.SM,
				right: SPACE.SM
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}