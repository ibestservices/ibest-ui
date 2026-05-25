import { IBestPasswordInput } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import BasePage from '../../components/BasePage'
import ComponentShowContainer from '../../components/ComponentShowContainer'

@Builder
export function PasswordInputBuilder(_: string, title: string){
	PasswordInputPage({title})
}

@Entry
@Component
struct PasswordInputPage {
	@State title: string = ''
	@State value: string = '123'
	@State value1: string = '123'
	@State value2: string = '123'
	@State value3: string = '123'
	@State @Watch("valueChange") value4: string = '123'
	@State errorTip: string = ''
	@State value5: string = '123'
	valueChange(){
		if (this.value4.length === 6 && this.value4 !== '123456') {
			this.errorTip = '密码错误';
		} else {
			this.errorTip = ''
		}
	}

	build() {
		Column(){
			BasePage({ title: this.title, bgColor: modeColor.bg }) {
				List() {
					ListItem().height(84)
					ListItem() {
						ComponentShowContainer({ title: '基础用法' }) {
							IBestPasswordInput({
								value: $value,
								numberKeyboardConfig: {
									extraKey: ".",
									styleType: "custom"
								}
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '自定义长度' }) {
							IBestPasswordInput({
								value: $value1,
								inputLength: 4
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '格子间距' }) {
							IBestPasswordInput({
								value: $value2,
								space: 12
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '明文展示' }) {
							IBestPasswordInput({
								value: $value3,
								isHidden: false
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '自定义样式', space: SPACE.SM }) {
							IBestPasswordInput({
								value: $value3,
								bdColor: '#3d8af2',
								cellTextColor: '#3d8af2'
							})
							IBestPasswordInput({
								value: $value3,
								space: 12,
								cellBgColor: "#1c1c1e",
								cellTextColor: "#fff",
								highlightType: "shadow"
							})
							IBestPasswordInput({
								value: $value3,
								space: 12,
								bdWidth: { bottom: 1 },
								bdColor: "#999",
								cellBgColor: Color.Transparent,
								radius: 0
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '提示信息' }) {
							IBestPasswordInput({
								value: $value4,
								tip: "密码为6位数字",
								errorTip: this.errorTip
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '使用系统键盘' }) {
							IBestPasswordInput({
								value: $value5,
								useSystemKeyboard: true
							})
						}
					}

					ListItem().height(50)
				}
				.padding({ left: SPACE.SM, right: SPACE.SM })
			}
		}
	}
}