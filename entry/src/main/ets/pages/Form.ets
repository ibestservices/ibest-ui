import {
	CalendarConfirmResultType,
	IBestButton,
	IBestCalendarDialog,
	IBestCascader,
	IBestCascaderOption,
	IBestCellGroup,
	IBestCheckbox,
	IBestCheckboxGroup,
	IBestField,
	IBestForm,
	IBestFormController,
	IBestFormRule,
	IBestRadio, IBestRadioGroup,
	IBestStepper,
	IBestSwitch,
	IBestToast} from '@ibestservices/ibest-ui'
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
import { LengthMetrics, router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'

@Entry
@Component
struct FieldPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State name: string = ""
	@State phone: string = ""
	private formId1: string = 'form1'
	private rules1: IBestFormRule = {
		"name": [
			{ required: true, message: '请输入姓名' },
			{ min: 3, max: 10, message: '姓名长度在3-10个字符之间' }
		],
		"phone": [
			{ required: true, message: '请输入手机号' }
		]
	}
	private controller1: IBestFormController = new IBestFormController()

	@State value1: string = "123"
	@State value2: string = ""
	@State value3: string = "abc"
	@State value4: string = ""
	private formId2: string = 'form2'
	private pattern = /\d{6}/
	// 校验函数返回 true 表示校验通过，false 表示不通过
	private validator = (val: string) => /1\d{10}/.test(val)
	// 校验函数可以直接返回一段错误提示
	private validatorMessage = (val: string) => `${val} 不合法，请重新输入`
	// 校验函数可以返回 Promise，实现异步校验
	private asyncValidator(val: string): Promise<boolean> {
		return new Promise((resolve) => {
			IBestToast.show({
				type: "loading",
				message: '校验中...'
			})
			setTimeout(() => {
				IBestToast.hide()
				resolve(val === '1234')
			}, 1000)
		})
	}
	private rules2: IBestFormRule = {
		"value1": [
			{ pattern: this.pattern, message: '请输入正确的内容' }
		],
		"value2": [
			{ validator: this.validator, message: "请输入正确内容" }
		],
		"value3": [
			{ validator: this.validatorMessage }
		],
		"value4": [
			{ validator: this.asyncValidator, message: "请输入正确内容" }
		]
	}
	private controller2: IBestFormController = new IBestFormController()

	@State value5: boolean = false
	@State value6: boolean = false
	@State value7: string[] = []
	@State value8: string = ""
	@State value9: number = 1
	@State value10: string = ""
	@State visible: boolean = false
	@State value11: string = ''
	@State visible1: boolean = false
	private formId3: string = 'form3'
	private rules3: IBestFormRule = {
		"value7": [
			{ required: true, message: '请选择至少一项' }
		],
		"value8": [
			{ required: true, message: "请选择" }
		],
		"value10": [
			{ required: true, message: "请选择城市" }
		],
		"value11": [
			{ required: true, message: "请选择日期" }
		]
	}
	private controller3: IBestFormController = new IBestFormController()
	@State options: IBestCascaderOption[] = [
		{
			text: "江苏省",
			value: "320000",
			children: [
				{
					text: "南京市",
					value: "320100",
					children: [
						{
							text: "秦淮区",
							value: "320104"
						},
						{
							text: "雨花台区",
							value: "320114"
						}
					]
				},
				{
					text: "苏州市",
					value: "320500",
					children: [
						{
							text: "姑苏区",
							value: "320508"
						},
						{
							text: "昆山市",
							value: "320583"
						}
					]
				}
			]
		},
		{
			text: "安徽省",
			value: "340000",
			children: [
				{
					text: "合肥市",
					value: "340100",
					children: [
						{
							text: "蜀山区",
							value: "340104"
						},
						{
							text: "合肥高新技术产业开发区",
							value: "340171"
						}
					]
				},
				{
					text: "黄山市",
					value: "341000",
					children: [
						{
							text: "屯溪区",
							value: "341002"
						},
						{
							text: "黄山区",
							value: "341003"
						}
					]
				}
			]
		}
	]

	@Builder switchContent() {
		IBestSwitch({
			value: this.value5,
			onChange: value => {
				this.value5 = value
			}
		})
	}
	@Builder checkboxContent() {
		IBestCheckbox({
			value: this.value6,
			shape: "square",
			name: "value6",
			onChange: value => {
				this.value6 = value
			}
		})
	}
	@Builder checkboxGroupContent() {
		IBestCheckboxGroup({
			group: "group1",
			onChange: checkboxNames => {
				if(checkboxNames.length){
					this.value7 = checkboxNames
				}
			}
		})
		Flex({space: { main: new LengthMetrics(20)}}) {
			IBestCheckbox({
				group: "group1",
				shape: "square",
				label: "复选框1",
				name: "checkbox1"
			})
			IBestCheckbox({
				group: "group1",
				shape: "square",
				label: "复选框2",
				name: "checkbox2"
			})
		}
	}
	@Builder radioContent() {
		IBestRadioGroup({
			group: "group1",
			onChange: radioName => {
				this.value8 = radioName
			}
		})
		Flex({space: { main: new LengthMetrics(20)}}){
			IBestRadio({
				group: "group1",
				label: "单选框1",
				name: "radio1"
			})
			IBestRadio({
				group: "group1",
				label: "单选框2",
				name: "radio2"
			})
		}
	}
	@Builder stepperContent(){
		IBestStepper({
			defaultValue: 1,
			min: 1,
			max: 99,
			step: 1,
			onChange: value => {
				console.log("", value)
				this.value9 = Number(value)
			}
		})
	}

	build() {
		Column() {
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SMALL }) {
						IBestForm({
							formId: this.formId1,
							rules: this.rules1,
							controller: this.controller1
						}){
							IBestCellGroup({inset: true}) {
								IBestField({
									formId: this.formId1,
									prop: 'name',
									value: $name,
									label: "姓名",
									placeholder: "请输入姓名"
								})
								IBestField({
									formId: this.formId1,
									prop: 'phone',
									value: $phone,
									label: "手机号",
									placeholder: "请输入手机号",
									hasBorder: false
								})
								IBestButton({
									text: "提交",
									type: 'primary',
									buttonSize: 'large',
									onClickBtn: () => {
										this.controller1.validate((valid, fields) => {
											if (valid) {
												IBestToast.show("验证成功")
											} else {
												let names: string[] = fields.map(item => item.name)
												IBestToast.show({
													message: `${names.join(',')}验证失败`,
													wordBreak: "break-all"
												})
											}
										})
									}
								})
									.margin({ top: SPACE.TWENTY })
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '校验规则', titlePaddingLeft: SPACE.SMALL }) {
						IBestForm({
							formId: this.formId2,
							rules: this.rules2,
							controller: this.controller2
						}){
							IBestCellGroup({inset: true}) {
								IBestField({
									formId: this.formId2,
									prop: 'value1',
									value: $value1,
									label: "正则校验",
									placeholder: "正则校验"
								})
								IBestField({
									formId: this.formId2,
									prop: 'value2',
									value: $value2,
									label: "函数校验",
									placeholder: "返回true/false"
								})
								IBestField({
									formId: this.formId2,
									prop: 'value3',
									value: $value3,
									label: "函数校验",
									placeholder: "返回验证信息"
								})
								IBestField({
									formId: this.formId2,
									prop: 'value4',
									value: $value4,
									label: "异步校验",
									placeholder: "异步函数校验",
									hasBorder: false
								})
								IBestButton({
									text: "提交",
									type: 'primary',
									buttonSize: 'large',
									onClickBtn: () => {
										this.controller2.validate((valid, fields) => {
											if (valid) {
												IBestToast.show("验证成功")
											}
										})
									}
								})
									.margin({ top: SPACE.TWENTY })
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义表单项类型', titlePaddingLeft: SPACE.SMALL }) {
						IBestForm({
							formId: this.formId3,
							rules: this.rules3,
							controller: this.controller3
						}){
							IBestCellGroup({inset: true}) {
								IBestField({
									formId: this.formId3,
									prop: 'value5',
									value: $value5,
									label: "开关",
									customRightContent: (): void => this.switchContent()
								})
								IBestField({
									formId: this.formId3,
									prop: 'value6',
									value: $value6,
									label: "复选框",
									customRightContent: (): void => this.checkboxContent()
								})
								IBestField({
									formId: this.formId3,
									prop: 'value7',
									value: $value7,
									label: "复选框组",
									customRightContent: (): void => this.checkboxGroupContent()
								})
								IBestField({
									formId: this.formId3,
									prop: 'value8',
									value: $value8,
									label: "单选框",
									customRightContent: (): void => this.radioContent()
								})
								IBestField({
									formId: this.formId3,
									prop: 'value9',
									value: $value9,
									label: "步进器",
									customRightContent: (): void => this.stepperContent()
								})
								IBestField({
									formId: this.formId3,
									prop: 'value10',
									value: this.value10,
									label: "选择城市",
									isLink: true,
									onFieldClick: () => {
										this.visible = true
									}
								})
								IBestField({
									formId: this.formId3,
									prop: 'value11',
									value: this.value11,
									label: "日历",
									isLink: true,
									onFieldClick: () => {
										this.visible1 = true
									}
								})
								IBestButton({
									text: "提交",
									type: 'primary',
									buttonSize: 'large',
									onClickBtn: () => {
										this.controller3.validate((valid, fields) => {
											if (valid) {
												IBestToast.show("验证成功")
											}
										})
									}
								})
									.margin({ top: SPACE.TWENTY })
							}
						}
					}
				}
			}
			.layoutWeight(1)
			.padding({bottom: SPACE.MEDIA})
			// 选择城市
			IBestCascader({
				visible: this.visible,
				options: this.options,
				onConfirm: (value: IBestCascaderOption[]) => {
					this.value10 = value.map(item => item.text).join(',')
				}
			})
			// 日历
			IBestCalendarDialog({
				visible: $visible1,
				onConfirm: (value: Array<CalendarConfirmResultType>): void => {
					this.value11 = value[0].dateStr
				}
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(BACKGROUND_COLOR.BASE)
	}
}