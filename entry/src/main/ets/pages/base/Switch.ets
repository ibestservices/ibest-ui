import { IBestDialogUtil, IBestSwitch } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function SwitchBuilder(_: string, title: string){
	SwitchPage({title})
}

@Entry
@Component
struct SwitchPage {
	@State title: string = ''
	@State value: boolean = false
	@State value1: boolean = true
	@State value2: boolean = false
	@State stringValue: string = 'off'
	@State numberValue: number = 1
	@State value3: boolean = true
	@State value4: boolean = false
	@State value5: boolean = true
	@State value6: boolean = false
	@State value7: boolean = true
	@State value8: boolean = true

	@State arrowDirection: 'left' | 'right' = 'left';
	@Builder Arrow() {
		Row() {
			Image($r('app.media.title_back'))
				.width(CONTAINER_SIZE.FOURTEEN)
				.fillColor(this.arrowDirection === 'left' ? '#db3131' : '#e2e3e7')
				.rotate({
					angle: this.arrowDirection === 'left' ? 0 : -180
				}).animation({
				duration: 200,
			})
		}
	}
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						IBestSwitch({
							value: $value
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义尺寸' }) {
						IBestSwitch({
							value: $value1,
							switchSize: 20,
							componentWidth: 60
						}).margin({
							bottom: SPACE.SM
						})
						IBestSwitch({
							value: $value1,
							componentPadding: 4
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '文字图标' }) {
						IBestSwitch({
							value: $value2,
							inactiveText: "OFF",
							activeText: "ON",
							componentWidth: 70
						}).margin({
							bottom: SPACE.SM
						})
						IBestSwitch({
							value: $value2,
							inactiveIcon: $r("app.media.icon_dark"),
							activeIcon: $r("app.media.icon_light"),
							activeTextColor: "#f0ff86"
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '扩展value类型' }) {
						Row({space: SPACE.SM}){
							Text("string")
							IBestSwitch({
								value: $stringValue,
								inactiveValue: "off",
								activeValue: "on"
							})
							Text(this.stringValue)
						}
						.margin({
							bottom: SPACE.SM
						})
						Row({space: SPACE.SM}){
							Text("number")
							IBestSwitch({
								value: $numberValue,
								inactiveValue: 0,
								activeValue: 1
							})
							Text(this.numberValue.toString())
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用状态' }) {
						IBestSwitch({
							value: $value3,
							disabled: true
						}).margin({
							bottom: SPACE.SM
						})
						IBestSwitch({
							value: $value4,
							disabled: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '加载状态' }) {
						IBestSwitch({
							value: $value5,
							loading: true,
						}).margin({
							bottom: SPACE.SM
						})
						IBestSwitch({
							value: $value6,
							loading: true,
							activeColor: '#07c160'
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义按钮' }) {
						IBestSwitch({
							value: $value7,
							activeColor: '#db3131',
							nodeBuilder: () => this.Arrow(),
							onChange: (value) => {
								this.arrowDirection = value ? 'left' : 'right'
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '异步控制' }) {
						IBestSwitch({
							value: $value8,
							onBeforeChange: () => {
								return new Promise((resolve, reject) => {
									IBestDialogUtil.open({
										title: "提示",
										message: "确定更改状态?",
										showCancelButton: true,
										onConfirm: () => {
											resolve(true)
										},
										onCancel: () => {
											reject(false)
										}
									})
								})
							}
						})
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