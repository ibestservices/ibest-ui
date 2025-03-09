import {
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
	IBestNavBar,
	IBestPicker,
	IBestPickerOption,
	IBestPopup,
	IBestRadio,
	IBestRadioGroup,
	IBestStepper,
	IBestSwitch,
	IBestToast,
	IBestUploader,
	IBestUploaderFile
} from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { CONTAINER_SIZE, FONT_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../../assets/global.type'
import { generateId } from '../../utils/utils'

@Observed
class Subject {
	id: string = ""
	type: string = ""
	name: string = ""
	score: number = 0
	constructor() {
		this.id = generateId()
	}
}


@Entry
@Component
struct FieldPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State name: string = ""
	@State phone: string = ""
	private formId1: string = 'form1'
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
	@State selectValue: string[] = []
	@State visible: boolean = false
	@State value11: string = ''
	@State visible1: boolean = false
	@State value12: IBestUploaderFile[] = []

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
		],
		"value12": [
			{ required: true, message: "请上传图片" }
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

	private formId4: string = 'form4'
	@State sex: string = ""
	@State info1: string = ""
	@State info2: string = ""
	@State list: Subject[] = []
	private rules4: IBestFormRule = {
		"sex": [
			{ required: true, message: "请选择是否" }
		],
		"info1": [
			{ required: true, message: "请输入男生信息" }
		],
		"info2": [
			{ required: true, message: "请输入女生信息" }
		],
		"type": [
			{ required: true, message: "请选择学科类型" }
		],
		"score": [
			{ required: true, message: "请输入分数" }
		]
	}
	private controller4: IBestFormController = new IBestFormController()

	@Builder switchContent() {
		IBestSwitch({
			value: $value5
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
			activeList: $value7,
			placeDirection: Axis.Horizontal
		}){
			IBestCheckbox({
				group: "group1",
				shape: "square",
				label: "复选框1",
				name: "1"
			})
			IBestCheckbox({
				group: "group1",
				shape: "square",
				label: "复选框2",
				name: "2"
			})
		}
	}
	@Builder radioContent() {
		IBestRadioGroup({
			active: $value8,
			group: "group1",
			placeDirection: Axis.Horizontal
		}){
			IBestRadio({
				group: "group1",
				label: "单选框1",
				name: "1"
			})
			IBestRadio({
				group: "group1",
				label: "单选框2",
				name: "2"
			})
		}
	}
	@Builder radioContent1() {
		IBestRadioGroup({
			active: $sex,
			group: "group2",
			placeDirection: Axis.Horizontal
		}){
			IBestRadio({
				group: "group2",
				label: "男",
				name: "1"
			})
			IBestRadio({
				group: "group2",
				label: "女",
				name: "2"
			})
		}
	}
	@Builder stepperContent(){
		IBestStepper({
			value: $value9,
			min: 1,
			max: 99,
			step: 1
		})
	}
	@Builder uploadImg(){
		IBestUploader({
			fileList: $value12,
			max: 2
		})
	}

	deleteContent(index: number){
		this.list.splice(index, 1)
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
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }) {
						IBestForm({
							formId: this.formId1,
							controller: this.controller1
						}){
							IBestCellGroup({hasBorder: false}) {
								IBestField({
									formId: this.formId1,
									prop: 'name',
									value: $name,
									label: "姓名",
									placeholder: "请输入姓名",
									rules:[
										{ required: true, message: '请输入姓名' },
										{ min: 3, max: 10, message: '姓名长度在3-10个字符之间' }
									]
								})
								IBestField({
									formId: this.formId1,
									prop: 'phone',
									value: $phone,
									label: "手机号",
									placeholder: "请输入手机号",
									hasBorder: false,
									rules: [
										{ required: true, message: '请输入手机号' }
									]
								})
							}
							IBestButton({
								text: "验证姓名",
								type: 'primary',
								buttonSize: 'large',
								onClickBtn: () => {
									this.controller1.validateField("name").then(res => {
										if(res.valid){
											IBestToast.show("验证成功")
										} else {
											IBestToast.show({
												message: `${res.field.label}验证失败`
											})
										}
									})
								}
							})
							IBestButton({
								text: "提交",
								type: 'primary',
								buttonSize: 'large',
								onClickBtn: () => {
									this.controller1.validate().then(res => {
										if(res.valid){
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
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义校验规则', titlePaddingLeft: SPACE.MD }) {
						IBestForm({
							formId: this.formId2,
							rules: this.rules2,
							controller: this.controller2
						}){
							IBestCellGroup({hasBorder: false}) {
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
							}
							IBestButton({
								text: "提交",
								type: 'primary',
								buttonSize: 'large',
								onClickBtn: () => {
									this.controller2.validate((valid) => {
										if (valid) {
											IBestToast.show("验证成功")
										}
									})
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义表单项类型', titlePaddingLeft: SPACE.MD }) {
						IBestForm({
							formId: this.formId3,
							rules: this.rules3,
							controller: this.controller3
						}){
							IBestCellGroup({hasBorder: false}) {
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
									rules: this.value5 ? [{required: true, message: '请选择'}] : [],
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
									placeholder: "请选择城市",
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
									placeholder: "请选择日期",
									isLink: true,
									onFieldClick: () => {
										this.visible1 = true
									}
								})
								IBestField({
									formId: this.formId3,
									prop: 'value12',
									value: $value12,
									label: "上传图片",
									hasBorder: false,
									customRightContent: (): void => this.uploadImg()
								})
							}
							IBestButton({
								text: "提交",
								type: 'primary',
								buttonSize: 'large',
								onClickBtn: () => {
									this.controller3.validate((valid) => {
										if (valid) {
											IBestToast.show("验证成功")
										}
									})
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '动态表单验证', titlePaddingLeft: SPACE.MD }) {
						IBestForm({
							formId: this.formId4,
							rules: this.rules4,
							controller: this.controller4
						}){
							IBestCellGroup({hasBorder: false}){
								IBestField({
									formId: this.formId4,
									prop: 'sex',
									value: $sex,
									label: "性别",
									hasBorder: this.sex != '',
									customRightContent: (): void => this.radioContent1()
								})
								if(this.sex == '1'){
									IBestField({
										formId: this.formId4,
										prop: 'info1',
										value: $info1,
										label: "男生信息",
										placeholder: "请输入男生信息",
										hasBorder: false
									})
								}else if(this.sex == '2'){
									IBestField({
										formId: this.formId4,
										prop: 'info2',
										value: $info2,
										label: "女生信息",
										placeholder: "请输入女生信息",
										hasBorder: false
									})
								}
								ForEach(this.list, (item: Subject, index) => {
									subjectItem({
										item: item,
										index: index,
										formId: this.formId4,
										delete: (): void => this.deleteContent(index)
									})
								}, (item: Subject) => item.id)
							}
							IBestButton({
								text: "添加内容",
								type: "primary",
								buttonSize: 'large',
								onClickBtn: () => {
									this.list.push(new Subject())
								}
							})
							IBestButton({
								text: "提交",
								type: 'primary',
								buttonSize: 'large',
								onClickBtn: () => {
									this.controller4.validate((valid) => {
										if (valid) {
											IBestToast.show("验证成功")
										}
									})
								}
							})
						}
					}
				}
			}
			.layoutWeight(1)
			.padding({ left: SPACE.MD, right: SPACE.MD })
			// 选择城市
			IBestCascader({
				visible: this.visible,
				options: this.options,
				value: $selectValue,
				onConfirm: value => {
					this.value10 = value.map(item => item.text).join(',')
				}
			})
			// 日历
			IBestCalendarDialog({
				visible: $visible1,
				onConfirm: value => {
					this.value11 = value[0].dateStr
				}
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}

@Component
struct subjectItem{
	@ObjectLink item: Subject
	@Prop index: number
	@Prop formId: string
	@State @Watch("typeChange") type: string = ""
	@State @Watch("nameChange") name: string = ""
	@State visible: boolean = false
	@State @Watch("scoreChange") score: string = ""
	private options: IBestPickerOption[] = [
		{ text: '语文', value: '1' },
		{ text: '数学', value: '2' },
		{ text: '英语', value: '3' },
		{ text: '物理', value: '4' },
		{ text: '化学', value: '5' },
		{ text: '生物', value: '6' }
	]
	delete: (index: number) => void = () => {}
	@Builder pickerBuilder(){
		IBestPicker({
			options: this.options,
			title: "请选择学科",
			visibleItemCount: 5,
			value: $type,
			onConfirm: (selectedValues, selectTexts) => {
				this.visible = false
				this.name = selectTexts.join('-')
			},
			onCancel: () => {
				this.visible = false
			}
		})
	}
	aboutToAppear(): void {
		let item = this.item
		if(item.type){
			this.type = item.type
		}
		if(item.name){
			this.name = item.name
		}
		if(item.score){
			this.score = item.score.toString()
		}
	}
	typeChange(){
		this.item.type = this.type
	}
	nameChange(){
		this.item.name = this.name
	}
	scoreChange(){
		this.item.score = Number(this.score)
	}

	build() {
		IBestCellGroup({title: `学科${this.index+1}`, hasBorder: false}){
			Text("删除")
				.fontColor(modeColor.textColor4)
				.fontSize(FONT_SIZE.SM)
				.position({right: 0, top: 17})
				.onClick(() => {
					this.delete(this.index)
				})
			IBestField({
				formId: this.formId,
				prop: `type.${this.index}`,
				label: '学科',
				value: this.name,
				placeholder: "请选择学科",
				isLink: true,
				onFieldClick: () => {
					this.visible = true
				}
			})
			IBestField({
				formId: this.formId,
				prop: `score.${this.index}`,
				label: "分数",
				value: $score,
				type: "number",
				placeholder: "请输入分数",
				hasBorder: false
			})
			IBestPopup({
				visible: $visible,
				popupAlign: "bottom",
				contentBuilder: (): void => this.pickerBuilder()
			})
		}
	}
}