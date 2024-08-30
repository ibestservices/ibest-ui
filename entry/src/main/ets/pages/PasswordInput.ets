import { IBestPasswordInput } from '@ibestservices/ibest-ui'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import TitleBar from '../components/TitleBar'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'

@Entry
@Component
struct PasswordInputPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
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
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基本用法' }) {
						IBestPasswordInput({
							value: $value,
							numberKeyboardConfig:{
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
							space: 20
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