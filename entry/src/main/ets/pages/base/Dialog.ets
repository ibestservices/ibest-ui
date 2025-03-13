import router from '@ohos.router';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import {
	IBestButton,
	IBestCell,
	IBestCellGroup,
	IBestDialog,
	IBestDialogUtil,
	IBestNavBar
} from '@ibestservices/ibest-ui';
import { ComponentRouterParams } from '../../assets/global.type';
export interface TextData {
	title: string,
	code: string,
	life: string
	program: string
}
const textData: TextData = {
	title: '提示',
	code: '代码是写出来给人看的，附带能在机器上运行。',
	life: '生命远不止连轴转和忙到极限，人类的体验远比这辽阔、丰富得多。',
	program: '如果解决方法是丑陋的，那就肯定还有更好的解决方法，只是还没有发现而已。'
}

@Entry
@Component
struct DialogPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State inputValue: string = ''
	@State formInputError: boolean = false
	@State dialogVisible: boolean = false
	@State dialogWidth: number | string = "90%"
	@Builder formInputContain() {
		Column({ space: SPACE.MD }) {
			IBestButton({
				type: 'primary',
				text: "切换宽度",
				onClickBtn: () => {
					this.dialogWidth = this.dialogWidth === "90%" ? "80%" : "90%"
				}
			})
			TextInput({ placeholder: '请输入' })
				.fontSize(14)
				.placeholderFont({ size: 14 })
				.onChange((value) => {
					this.inputValue = value
					this.formInputError = false
				})
			if (this.formInputError) {
				Text('不能为空')
					.width(CONTAINER_SIZE.FULL)
					.textAlign(TextAlign.Start)
					.fontColor(Color.Red)
					.fontSize(12)
			}
		}.padding(SPACE.MD)
	}
	@Builder customComponentContent() {
		Column() {
			Text(textData.program)
		}
		.padding(20)
	}
	@Builder imageBgBuilder() {
		Column() {
			Text(textData.life)
				.fontColor(modeColor.white)
		}
		.height(200)
		.padding(20)
		.justifyContent(FlexAlign.Center)
	}
	build() {
		Column() {
			IBestNavBar({
				title: this.title,
				isShowStatusBar: true,
				onLeftClick: () => {
					router.back()
				}
			})
			// 使用组件
			IBestDialog({
				visible: $dialogVisible,
				title: textData.title,
				dialogWidth: this.dialogWidth,
				showCancelButton: true,
				defaultBuilder: (): void => this.formInputContain(),
				beforeClose: (action) => {
					if (action === 'cancel') {
						return true
					}
					const valueLength = this.inputValue.trim().length;
					this.formInputError = !valueLength;
					return !this.formInputError
				}
			})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '提示弹窗',
								isLink: true,
								onClickCell: () => {
									IBestDialogUtil.open({
										title: textData.title,
										message: textData.code
									})
								}
							})
							IBestCell({
								title: '提示弹窗（无标题）',
								isLink: true,
								onClickCell: () => {
									IBestDialogUtil.open({
										message: textData.life
									})
								}
							})
							IBestCell({
								title: '确认弹窗',
								isLink: true,
								hasBorder: false,
								onClickCell: () => {
									IBestDialogUtil.open({
										title: textData.title,
										message: textData.life,
										showCancelButton: true
									})
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '圆角按钮样式', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '提示弹窗',
								isLink: true,
								onClickCell: () => {
									IBestDialogUtil.open({
										title: textData.title,
										message: textData.life,
										theme: "round-button"
									})
								}
							})
							IBestCell({
								title: '确认弹窗(无标题)',
								isLink: true,
								onClickCell: () => {
									IBestDialogUtil.open({
										message: textData.life,
										showCancelButton: true,
										theme: "round-button"
									})
								}
							})
							IBestCell({
								title: '按钮带间距确认弹窗',
								isLink: true,
								hasBorder: false,
								onClickCell: () => {
									IBestDialogUtil.open({
										message: textData.life,
										showCancelButton: true,
										theme: "round-button",
										buttonSpace: 20
									})
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '背景图片', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '背景图片',
								isLink: true,
								hasBorder: false,
								onClickCell: () => {
									IBestDialogUtil.open({
										bgImage: "https://img0.baidu.com/it/u=3217812679,2585737758&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500",
										showConfirmButton: false,
										defaultBuilder: () => this.imageBgBuilder(),
										closeOnClickOverlay: true,
										closeOnBackPress: true
									})
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '异步关闭', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '异步关闭',
								isLink: true,
								hasBorder: false,
								onClickCell: () => {
									IBestDialogUtil.open({
										title: textData.title,
										message: textData.life,
										showCancelButton: true,
										beforeClose: (action) => {
											if (action == "confirm") {
												return new Promise(resolve => {
													IBestDialogUtil.open({
														title: "提示",
														message: "确认关闭？",
														showCancelButton: true,
														onConfirm: () => {
															resolve(true)
														},
														onCancel: () => {
															resolve(false)
														}
													})
												})
											}
											return true
										}
									})
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '使用插槽', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '使用插槽',
								isLink: true,
								hasBorder: false,
								onClickCell: () => {
									IBestDialogUtil.open({
										title: textData.title,
										message: textData.life,
										showCancelButton: true,
										defaultBuilder: (): void => this.customComponentContent()
									})
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '使用组件', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '使用组件',
								isLink: true,
								hasBorder: false,
								onClickCell: () => {
									this.dialogVisible = true
								}
							})
						}
					}
				}
			}.layoutWeight(1)
		}.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}