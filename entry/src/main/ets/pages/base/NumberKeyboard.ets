import router from '@ohos.router';
import { IBestCell, IBestCellGroup, IBestNavBar, IBestNumberKeyboard } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import { ComponentRouterParams } from '../../assets/global.type';

@Entry
@Component
struct NumberKeyboardPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State visible: boolean = false
	@State value: string = ''
	@State visible1: boolean = false
	@State value1: string = ''
	@State visible2: boolean = false
	@State value2: string = ''
	@State visible3: boolean = false
	@State value3: string = ''
	@State visible4: boolean = false
	@State value4: string = ''
	@State visible5: boolean = false
	@State value5: string = ''
	@State visible6: boolean = false
	@State value6: string = ''
	build() {
		Column() {
			IBestNavBar({
				title: this.title,
				isShowStatusBar: true,
				onLeftClick: () => {
					router.back()
				}
			})
			List() {
				ListItem() {
					IBestCellGroup({ inset: true }) {
						IBestCell({
							title: '默认键盘',
							value: this.value,
							clickable: true,
							onClickCell: () => {
								this.visible = true
							}
						})
						IBestCell({
							title: '带右侧栏的键盘',
							value: this.value1,
							clickable: true,
							onClickCell: () => {
								this.visible1 = true
							}
						})
						IBestCell({
							title: '身份证号键盘',
							value: this.value2,
							clickable: true,
							onClickCell: () => {
								this.visible2 = true
							}
						})
						IBestCell({
							title: '带标题的键盘',
							value: this.value3,
							clickable: true,
							onClickCell: () => {
								this.visible3 = true
							}
						})
						IBestCell({
							title: '配置多个按键的键盘',
							value: this.value4,
							clickable: true,
							onClickCell: () => {
								this.visible4 = true
							}
						})
						IBestCell({
							title: '配置随机数字的键盘',
							value: this.value5,
							clickable: true,
							onClickCell: () => {
								this.visible5 = true
							}
						})
						IBestCell({
							title: '最大长度',
							value: this.value6 || "点此输入",
							clickable: true,
							hasBorder: false,
							onClickCell: () => {
								this.visible6 = true
							}
						})
					}
				}
			}
			.layoutWeight(1)
			.padding({ top: SPACE.SM, bottom: SPACE.SM })
			IBestNumberKeyboard({
				visible: $visible,
				value: $value,
				onInput: (value: string) => {
					console.log('输入：' + value)
				},
				onDelete: () => {
					console.log('删除')
				},
				onClose: () => {
					console.log("关闭")
				}
			})
			IBestNumberKeyboard({
				visible: $visible1,
				value: $value1,
				styleType: "custom",
				extraKey: ".",
				closeBtnText: "完成"
			})
			IBestNumberKeyboard({
				visible: $visible2,
				value: $value2,
				extraKey: "X"
			})
			IBestNumberKeyboard({
				visible: $visible3,
				value: $value3,
				title: "键盘标题",
				extraKey: "."
			})
			IBestNumberKeyboard({
				visible: $visible4,
				value: $value4,
				deleteButtonText: "删除",
				styleType: "custom",
				extraKey: ['00', '.'],
				closeBtnText: "确定"
			})
			IBestNumberKeyboard({
				visible: $visible5,
				value: $value5,
				isRandomKeyOrder: true
			})
			IBestNumberKeyboard({
				visible: $visible6,
				value: $value6,
				maxLength: 6
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}