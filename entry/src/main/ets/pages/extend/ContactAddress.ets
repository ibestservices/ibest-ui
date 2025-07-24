import {
	IBestButton,
	IBestContactAddressController,
	IBestContactAddress,
	IBestDialogUtil,
	IBestDivider,
	IBestField,
	IBestStepper,
	IBestSwitch,
	IBestToast
} from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import CustomNavBar from '../../components/CustomNavBar';
import { getRandomColor } from '../../utils/utils';
import { pasteboard } from '@kit.BasicServicesKit';

@Builder
export function ContactAddressBuilder(_: string, title: string) {
	ContactAddressPage({ title })
}

@Entry
@Component
struct ContactAddressPage {
	@State title: string = ''
	@State showInputBox: boolean = true
	@State labelColor: string = '#5d5d5d'
	@State inputFontSize: number = 14
	@State hasBorder: boolean = true
	@State identifyPlaceholder: string = "请粘贴或输入文本，点击“识别”自动识别姓名、电话和地址"
	@State identifyTagText: string = "张先生，15900000000，浙江省杭州市西湖区某小区"
	@State identifyTagBgColor: string = '#1989fa'
	controller: IBestContactAddressController = new IBestContactAddressController()
	private labelWidth: number = 120
	private testList: Array<string> = [
		"杨俊斌15915800000深圳市龙华区龙胜新村B区162栋510000",
		"杨俊斌15915800000深圳市龙华区龙胜新村B区162栋402510000",
		"广东省珠海市香洲区盘山路28号 陈景勇 13593464918",
		"马云 河北省石家庄新华区中华北大街68号鹿城商务中心6号楼1413室",
		"收货人:李节霁 | 手机:151-8023-1234 | 地址:浙江省金华市婺城区西关街道",
		"雁塔区高新四路710061 刘国良"
	]

	@Builder showInputBoxBuilder() {
		IBestSwitch({
			value: $showInputBox
		})
	}
	@Builder labelColorChangeBuilder() {
		IBestButton({
			text: "切换颜色",
			type: "primary",
			plain: true,
			buttonSize: "mini",
			onBtnClick: () => {
				this.labelColor = getRandomColor()
			}
		})
	}
	@Builder tagColorChangeBuilder() {
		IBestButton({
			text: "切换颜色",
			type: "primary",
			plain: true,
			buttonSize: "mini",
			onBtnClick: () => {
				this.identifyTagBgColor = getRandomColor()
			}
		})
	}
	@Builder stepperBuilder() {
		IBestStepper({
			value: $inputFontSize,
			min: 10,
			max: 20,
			step: 1
		})
	}
	@Builder showHasBorderBuilder() {
		IBestSwitch({
			value: $hasBorder
		})
	}
	build() {
		NavDestination() {
			CustomNavBar({ title: this.title })
			List() {
				ListItem() {
					IBestContactAddress({
						controller: this.controller,
						showIdentifyInputBox: this.showInputBox,
						labelColor: this.labelColor,
						inputFontSize: this.inputFontSize,
						hasBorder: this.hasBorder,
						identifyPlaceholder: this.identifyPlaceholder,
						identifyTagText: this.identifyTagText,
						identifyTagBgColor: this.identifyTagBgColor
					})
				}
				ListItem().height(15)
				ListItem() {
					IBestDivider({ text: "操作表单", hairline: false, lineColor: Color.Red })
				}
				ListItem().height(10)
				ListItem() {
					Row({ space: 5 }) {
						IBestButton({
							text: "验证表单",
							type: "primary",
							buttonSize: "small",
							onBtnClick: () => {
								this.controller.validateForm().then(res => {
									if (res.valid) {
										IBestToast.show("验证成功")
									} else {
										let labels: string[] = res.fields.map(item => item.label)
										IBestToast.show({
											message: `${labels.join(',')}验证失败`
										})
									}
								})
							}
						})
						IBestButton({
							text: "获取数据",
							type: "primary",
							buttonSize: "small",
							onBtnClick: () => {
								IBestDialogUtil.open({
									message: JSON.stringify(this.controller.getFormValues(), null, 2),
									messageTextAlign: "left"
								})
							}
						})
						IBestButton({
							text: "清空表单",
							type: "primary",
							buttonSize: "small",
							onBtnClick: () => {
								this.controller.cleanFormValues()
							}
						})
						IBestButton({
							text: "随机数据",
							type: "primary",
							buttonSize: "small",
							onBtnClick: () => {
								let getRandomItem: (arr: string[]) => string = (arr: string[]) => {
									const randomIndex = Math.floor(Math.random() * arr.length)
									return arr[randomIndex]
								}
								const text = getRandomItem(this.testList)
								IBestDialogUtil.open({
									message: text,
									messageTextAlign: "left",
									confirmButtonText: "复制",
									onConfirm: () => {
										const pasteData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text)
										const systemPasteboard = pasteboard.getSystemPasteboard()
										systemPasteboard.setData(pasteData)
										IBestToast.show("复制成功")
									}
								})
							}
						})
					}
				}
				ListItem().height(10)
				ListItem() {
					IBestDivider({ text: "测试属性", hairline: false, lineColor: Color.Red })
				}
				ListItem().height(10)
				ListItem() {
					Column(){
						IBestField({
							value: this.showInputBox,
							label: "识别输入框",
							labelWidth: this.labelWidth,
							customRightContent: () => this.showInputBoxBuilder()
						})
						IBestField({
							value: this.identifyPlaceholder,
							label: "识别框占位提示",
							labelWidth: this.labelWidth,
							autosize: true,
							disabled: !this.showInputBox
						})
						IBestField({
							value: this.identifyTagText,
							label: "识别框顶部提示",
							labelWidth: this.labelWidth,
							autosize: true,
							disabled: !this.showInputBox
						})
						IBestField({
							value: this.identifyTagBgColor,
							label: "识别框主题颜色",
							labelWidth: this.labelWidth,
							buttonBuilder: () => this.tagColorChangeBuilder(),
							disabled: !this.showInputBox,
						})
						IBestField({
							value: this.labelColor,
							label: "左侧字体颜色",
							labelWidth: this.labelWidth,
							buttonBuilder: () => this.labelColorChangeBuilder()
						})
						IBestField({
							value: this.inputFontSize,
							label: "输入框文字大小",
							labelWidth: this.labelWidth,
							customRightContent: () => this.stepperBuilder()
						})
						IBestField({
							value: this.hasBorder,
							label: "表单分隔线",
							labelWidth: this.labelWidth,
							customRightContent: () => this.showHasBorderBuilder(),
							hasBorder: false
						})
					}
				}
				ListItem().height(50)
			}
			.layoutWeight(1)
			.padding(SPACE.MD)
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}