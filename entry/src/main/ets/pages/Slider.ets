import { IBestSlider, IBestSliderValue, IBestToast } from '@ibestservices/ibest-ui'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import TitleBar from '../components/TitleBar'
import { BACKGROUND_COLOR, COLOR_BLUE, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'

@Entry
@Component
struct SliderPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State value: number = 30
	@State value1: [number, number] = [20, 60]
	@State value2: number = 30
	@State value3: number = 30
	@State value4: number = 30
	@State value5: number = 30
	@State value6: number = 30
	@State value7: [number, number] = [20, 60]

	@Builder customBtn(){
		Text(this.value5.toString())
			.padding({ left: "10lpx", right: "lpx" })
			.height("36lpx")
			.borderRadius(9999)
			.padding({ left: 10, right: 10 })
			.backgroundColor(COLOR_BLUE.TEXT)
			.fontColor(COLOR_BLUE.DEFAULT)
			.fontSize("24lpx")
	}

	build() {
		Column(){
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						Column({ space: 20 }){
							IBestSlider({
								value: $value,
								onChange: (val) => {
									console.log(val.toString())
									IBestToast.show(val.toString())
								}
							})
							IBestSlider({
								value: $value,
								reverse: true,
								onChange: (val) => {
									console.log(val.toString())
									IBestToast.show(val.toString())
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '双滑块' }) {
						Column({ space: 20 }){
							IBestSlider({
								value: $value1,
								onChange: (val) => {
									console.log(val.toString())
									IBestToast.show(val.toString())
								}
							})
							IBestSlider({
								value: $value1,
								reverse: true,
								onChange: (val) => {
									console.log(val.toString())
									IBestToast.show(val.toString())
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '指定选择范围' }) {
						IBestSlider({
							value: $value2,
							min: -50,
							max: 50,
							onChange: (val) => {
								IBestToast.show(val.toString())
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '指定步长' }) {
						IBestSlider({
							value: $value3,
							step: 5,
							onChange: (val) => {
								IBestToast.show(val.toString())
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式' }) {
						IBestSlider({
							value: $value4,
							barHeight: 8,
							activeColor: "#ee0a24",
							onChange: (val) => {
								IBestToast.show(val.toString())
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义按钮' }) {
						IBestSlider({
							value: $value5,
							customButton: (): void => this.customBtn(),
							onChange: (val) => {
								IBestToast.show(val.toString())
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '垂直方向' }) {
						Row({ space: 80 }){
							Row({ space: 30 }){
								IBestSlider({
									value: $value6,
									vertical: true,
									onChange: (val) => {
										console.log(val.toString())
										IBestToast.show(val.toString())
									}
								})
								IBestSlider({
									value: $value6,
									vertical: true,
									reverse: true,
									onChange: (val) => {
										console.log(val.toString())
										IBestToast.show(val.toString())
									}
								})
							}
							Row({ space: 30 }){
								IBestSlider({
									value: $value7,
									vertical: true,
									onChange: (val) => {
										console.log(val.toString())
										IBestToast.show(val.toString())
									}
								})
								IBestSlider({
									value: $value7,
									vertical: true,
									reverse: true,
									onChange: (val) => {
										console.log(val.toString())
										IBestToast.show(val.toString())
									}
								})
							}
						}
						.width(CONTAINER_SIZE.FULL)
						.height(300)
						.justifyContent(FlexAlign.Center)
					}
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.layoutWeight(1)
			.padding({
				left: SPACE.MEDIA,
				right: SPACE.MEDIA,
				bottom: SPACE.MEDIA
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(BACKGROUND_COLOR.BASE)
	}
}