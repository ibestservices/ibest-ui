import { IBestSearch, IBestToast } from '@ibestservices/ibest-ui'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import TitleBar from '../components/TitleBar'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'

@Entry
@Component
struct SearchPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State value: string = ''
	@Builder customBtn(){
		Text("自定义按钮")
			.height("100%")
			.padding({ left: 10, right: 10 })
			.backgroundColor("#eee")
	}

	build() {
		Column(){
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						IBestSearch({
							value: $value,
							placeholder: "请输入关键词",
							autoFocus: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '圆角' }) {
						IBestSearch({
							value: $value,
							radius: 12
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用' }) {
						IBestSearch({
							value: $value,
							disabled: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义背景色' }) {
						IBestSearch({
							value: $value,
							isRound: true,
							outBgColor: "#4fc08d",
							innerBgColor: "#F29C73"
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '事件监听' }) {
						IBestSearch({
							value: $value,
							showRightButton: true,
							clearable: true,
							onRightButtonClick: () => {
								IBestToast.show("rightIconClick")
							},
							onClear: () => {
								IBestToast.show("clear")
							},
							onSearch: () => {
								IBestToast.show(`search: ${this.value}`)
							},
							onInput: (value: string) => {
								console.log(`输入的值为: ${value}`)
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义按钮' }) {
						Column({ space: 20 }){
							IBestSearch({
								value: $value,
								label: "地址",
								showRightButton: true,
								rightButtonText: "搜索"
							})
							IBestSearch({
								value: $value,
								label: "地址",
								customRightButton: (): void => this.customBtn()
							})
						}
					}
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.layoutWeight(1)
			.padding({
				left: SPACE.BASE,
				right: SPACE.BASE,
				bottom: SPACE.BASE
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(BACKGROUND_COLOR.BASE)
	}
}