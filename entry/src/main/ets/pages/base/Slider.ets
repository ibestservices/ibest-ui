import { IBestSlider, IBestToast } from '@ibestservices/ibest-ui'
import { COLOR_BLUE, CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function SliderBuilder(_: string, title: string){
	SliderPage({title})
}

@Entry
@Component
struct SliderPage {
	@State title: string = ''
	@State value: number = 30
	@State value1: [number, number] = [20, 60]
	@State value2: number = 30
	@State value3: number = 30
	@State value4: number = 30
	@State value5: number = 30
	@State value6: number = 30
	@State value7: number = 30
	@State value8: [number, number] = [20, 60]

	@Builder customBtn(){
		Text(this.value6.toString())
			.height(18)
			.borderRadius(9999)
			.padding({ left: 10, right: 10 })
			.backgroundColor(COLOR_BLUE.TEXT)
			.fontColor(COLOR_BLUE.DEFAULT)
			.fontSize(12)
	}

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', space: SPACE.MD }) {
						IBestSlider({
							value: $value,
							onChange: (val) => {
								IBestToast.show(val.toString())
							}
						})
						IBestSlider({
							value: $value,
							reverse: true,
							onChange: (val) => {
								IBestToast.show(val.toString())
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '双滑块', space: SPACE.MD }) {
						IBestSlider({
							value: $value1,
							onChange: (val) => {
								IBestToast.show(val.toString())
							}
						})
						IBestSlider({
							value: $value1,
							reverse: true,
							onChange: (val) => {
								IBestToast.show(val.toString())
							}
						})
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
					ComponentShowContainer({ title: '禁用' }) {
						IBestSlider({
							value: $value3,
							disabled: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '指定步长' }) {
						IBestSlider({
							value: $value4,
							step: 10,
							ticks: true,
							onChange: (val) => {
								IBestToast.show(val.toString())
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式' }) {
						IBestSlider({
							value: $value5,
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
							value: $value6,
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
									value: $value7,
									vertical: true,
									onChange: (val) => {
										IBestToast.show(val.toString())
									}
								})
								IBestSlider({
									value: $value7,
									vertical: true,
									reverse: true,
									onChange: (val) => {
										IBestToast.show(val.toString())
									}
								})
							}
							Row({ space: 30 }){
								IBestSlider({
									value: $value8,
									vertical: true,
									onChange: (val) => {
										IBestToast.show(val.toString())
									}
								})
								IBestSlider({
									value: $value8,
									vertical: true,
									reverse: true,
									onChange: (val) => {
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
				ListItem().height(50)
			}
			.layoutWeight(1)
			.padding({ left: SPACE.XS, right: SPACE.XS })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}