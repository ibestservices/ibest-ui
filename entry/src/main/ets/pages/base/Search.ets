import { IBestSearch, IBestToast } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function SearchBuilder(_: string, title: string){
	SearchPage({title})
}

@Entry
@Component
struct SearchPage {
	@State title: string = ''
	@State value: string = ''
	@Builder customBtn(){
		Text("自定义按钮")
			.height("100%")
			.padding({ left: 10, right: 10 })
			.backgroundColor(modeColor.bg2)
	}

	build() {
		NavDestination(){
			CustomNavBar({title: this.title})
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
							placeholder: "请输入关键词",
							radius: 6
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用' }) {
						IBestSearch({
							value: $value,
							placeholder: "请输入关键词",
							disabled: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义背景色' }) {
						IBestSearch({
							value: $value,
							placeholder: "请输入关键词",
							isRound: true,
							outBgColor: "#4fc08d",
							innerBgColor: "#F29C73",
							textColor: "#ed4040"
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '事件监听' }) {
						IBestSearch({
							value: $value,
							placeholder: "请输入关键词",
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
								placeholder: "请输入关键词",
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
				ListItem().height(50)
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}