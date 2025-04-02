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
	@State value3: boolean = true
	@State value4: boolean = false
	@State value5: boolean = true
	@State value6: boolean = true
	@State value7: boolean = true

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
					ComponentShowContainer({ title: '禁用状态' }) {
						IBestSwitch({
							value: $value1,
							disabled: true
						}).margin({
							bottom: SPACE.SM
						})
						IBestSwitch({
							value: $value2,
							disabled: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '加载状态' }) {
						IBestSwitch({
							value: $value3,
							loading: true,
						}).margin({
							bottom: SPACE.SM
						})
						IBestSwitch({
							value: $value4,
							loading: true,
							activeColor: '#07c160'
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义大小' }) {
						IBestSwitch({
							value: $value5,
							switchSize: 20
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义按钮' }) {
						IBestSwitch({
							value: $value6,
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
							value: $value7,
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
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}