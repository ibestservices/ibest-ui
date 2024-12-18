import { IBestNavBar, IBestRate, IBestToast } from '@ibestservices/ibest-ui'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'

@Entry
@Component
struct RatePage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State value: number = 3
	@State value1: number = 3
	@State value2: number = 3
	@State value3: number = 3.5
	@State value4: number = 3
	@State value5: number = 3
	@State value6: number = 3
	@State value7: number = 3
	@State value8: number = 3.3
	@State value9: number = 3

	build() {
		Column(){
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
						IBestRate({
							value: $value
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义图标' }) {
						IBestRate({
							value: $value1,
							activeIcon: $r("app.media.icon_like_o"),
							inactiveIcon: $r("app.media.icon_like")
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式' }) {
						IBestRate({
							value: $value2,
							iconSize: 40,
							space: 10,
							activeColor: '#ffd21e',
							inactiveIcon: $r("app.media.ibest_icon_star_o"),
							inactiveColor: '#eee'
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '半星' }) {
						IBestRate({
							value: $value3,
							allowHalf: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义数量' }) {
						IBestRate({
							value: $value4,
							count: 6
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '可清空' }) {
						IBestRate({
							value: $value5,
							clearable: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用状态' }) {
						IBestRate({
							value: $value6,
							disabled: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '只读状态' }) {
						IBestRate({
							value: $value7,
							readOnly: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '只读状态小数显示' }) {
						IBestRate({
							value: $value8,
							readOnly: true,
							allowHalf: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '监听 change 事件' }) {
						IBestRate({
							value: $value9,
							onChange: (value: number) => {
								IBestToast.show(`${value}`)
							}
						})
					}
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.layoutWeight(1)
			.padding({
				left: SPACE.SM,
				right: SPACE.SM,
				bottom: SPACE.SM
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg2)
	}
}