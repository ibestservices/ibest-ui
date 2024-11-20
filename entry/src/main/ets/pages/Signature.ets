import router from '@ohos.router';
import { IBestButton, IBestSignature, IBestSignatureController } from '@ibestservices/ibest-ui'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { ComponentRouterParams } from '../assets/global.type';

class params {
	url: string = ''
}

@Entry
@Component
struct SignaturePage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State imgUrl: string = ""
	@State imgUrl1: string = ""
	@State imgUrl2: string = ""
	@State imgUrl3: string = ""
	private controller: IBestSignatureController = new IBestSignatureController()

	@Builder imgUrlView($$: params) {
		Image($$.url)
			.margin({ top: 20 })
	}
	build() {
		Column() {
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						IBestSignature({
							onConfirm: (url: string) => {
								this.imgUrl = url
							}
						})
						if(this.imgUrl){
							this.imgUrlView({url: this.imgUrl})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式' }) {
						IBestSignature({
							penColor: "#ff0000",
							lineWidth: 5,
							bgColor: "#eee",
							onConfirm: (url: string) => {
								this.imgUrl1 = url
							}
						})
						if(this.imgUrl1){
							this.imgUrlView({url: this.imgUrl1})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义宽高' }) {
						IBestSignature({
							boardWidth: 200,
							boardHeight: 100,
							onConfirm: (url: string) => {
								this.imgUrl2 = url
							}
						})
						if(this.imgUrl2){
							this.imgUrlView({url: this.imgUrl2})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: 'controller 控制器' }) {
						IBestSignature({
							controller: this.controller,
							isShowFooter: false,
							onConfirm: (url: string) => {
								this.imgUrl3 = url
							}
						})
						if(this.imgUrl3){
							this.imgUrlView({url: this.imgUrl3})
						}
						Row({ space: 10 }){
							IBestButton({
								text: '清空',
								onClickBtn: () => {
									this.controller.clear()
								}
							})
							IBestButton({
								text: '确认',
								type: 'primary',
								onClickBtn: () => {
									this.controller.confirm()
								}
							})
						}.margin({ top: 10 })
					}
				}
			}
			.layoutWeight(1)
			.padding({
				left: SPACE.BASE,
				right: SPACE.BASE
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(BACKGROUND_COLOR.BASE)
	}
}