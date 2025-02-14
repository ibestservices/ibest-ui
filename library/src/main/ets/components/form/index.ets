import { emitter } from '../../utils/EventEmitter'
import { convertDimensionsWidthUnit, getSizeByUnit, getEventName } from '../../utils/utils'
import { FieldTextAlign, IBestFieldValueType,
	LabelPositionType,
	RequireAsteriskPositionType } from '../field/index.type'
import {
	FieldValidateResult,
	FORM_EVENT_NAME,
	IBestFormController,
	IBestFormRule,
	IBestFieldItem,
	IBestFormSendFieldCallResult,
	COMPONENT_NAME
} from './index.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'

@Component
export struct IBestForm {
	/**
     * form id 用于验证
     */
	@Prop formId: string = ""
	/**
	 * 表单子项信息
	 */
	@State formItems: IBestFieldItem[] = []
	/**
	 * 表单验证规则
	 */
	rules: IBestFormRule = {}
	/**
	 * 表单项间距
  	 */
	@Prop space: number | string = convertDimensionsWidthUnit(10)
	/**
     * 文本宽度
     */
	@Prop labelWidth: number | string = convertDimensionsWidthUnit(80)
	/**
     * 文本位置
     */
	@Prop labelPosition: LabelPositionType = "left"
	/**
     * 文本对齐方式
     */
	@Prop labelAlign: FieldTextAlign = "left"
	/**
	 * 是否显示文本后冒号
	 */
	@Prop colon: boolean = false
	/**
     * 星号的位置
     */
	@Prop requireAsteriskPosition: RequireAsteriskPositionType = 'left'
	/**
     * 是否显示验证信息
     */
	@Prop showMessage: boolean = true
	/**
     * 是否禁用
     */
	@Prop disabled: boolean = false
	/**
	 * 表单内容
	 */
	@BuilderParam defaultBuilder?: CustomBuilder
	/**
	 * 表单控制器
	 */
	controller: IBestFormController | null = null
	aboutToAppear(): void {
		if(this.controller){
			this.controller.validate = (callBack?: (valid: boolean, field: FieldValidateResult[]) => void): void => this.validateForm(callBack)
			this.controller.validateField = (name: string, callBack?: (valid: boolean, field?: FieldValidateResult) => void): void => this.validateField(name, callBack)
			this.controller.resetValidation = (name?: string | string[]): void => this.resetValidation(name)
			this.controller.getValues = (): Promise<Record<string, IBestFieldValueType>> => this.getValues()
			this.controller.getFormValues = (): Record<string, IBestFieldValueType> => this.getFormValues()
		}
		if(this.formId){
			// 初始化收集表单项信息
			emitter.on(getEventName(COMPONENT_NAME, this.formId, FORM_EVENT_NAME.SEND_FIELD), (data: IBestFieldItem, callBack: (result: IBestFormSendFieldCallResult) => void): void => this.init(data, callBack))
			// 验证单个表单
			emitter.on(getEventName(COMPONENT_NAME, this.formId, FORM_EVENT_NAME.VALIDATE_FIELD), (name: string): void => this.validateField(name))
			// 删除表单项
			emitter.on(getEventName(COMPONENT_NAME, this.formId, FORM_EVENT_NAME.DELETE_FORM_ITEM), (uniId: number): void => this.deleteField(uniId))
		}
	}
	aboutToDisappear(): void {
		if(this.formId){
			emitter.off(getEventName(COMPONENT_NAME, this.formId, FORM_EVENT_NAME.SEND_FIELD), (data: IBestFieldItem, callBack: (result: IBestFormSendFieldCallResult) => void): void => this.init(data, callBack))
			emitter.off(getEventName(COMPONENT_NAME, this.formId, FORM_EVENT_NAME.VALIDATE_FIELD), (name: string): void => this.validateField(name))
		}
	}
	// 初始化
	init(data: IBestFieldItem, callBack: (result: IBestFormSendFieldCallResult) => void){
		let standardProp = data.prop.split(".")[0]
		let index = this.formItems.findIndex((item: IBestFieldItem) => item.prop === data.prop)
		if(index == -1){
			this.formItems.push(data)
		}else{
			this.formItems[index] = data
		}
		callBack({
			rules: this.rules[standardProp],
			labelWidth: this.labelWidth,
			labelPosition: this.labelPosition,
			labelAlign: this.labelAlign,
			colon: this.colon,
			requireAsteriskPosition: this.requireAsteriskPosition,
			showMessage: this.showMessage,
			disabled: this.disabled
		})
	}
	// 删除表单项
	deleteField(uniId: number){
		this.formItems = this.formItems.filter((item: IBestFieldItem) => item.uniId !== uniId)
	}
	// 验证表单
	validateForm(callBack?: (valid: boolean, field: FieldValidateResult[]) => void) {
		Promise.all(this.formItems.map((item: IBestFieldItem) => item.validate(this.rules[item.prop.split(".")[0]]))).then((errors) => {
			errors = errors.filter(Boolean)
			if (errors.length) {
				callBack!(false, errors)
			} else {
				callBack!(true, [])
			}
		})
	}
	// 验证单个表单
	validateField(prop: string, callBack?: (valid: boolean, field?: FieldValidateResult) => void) {
		const item = this.formItems.find((item: IBestFieldItem) => item.prop === prop)
		if (item) {
			item.validate(this.rules[prop]).then((res: FieldValidateResult) => {
				callBack && callBack(res === undefined, res)
			})
		}
	}
	// 重置表单
	resetValidation(prop?: string | string[]) {
		let names = prop ? (Array.isArray(prop) ? prop : [prop]) : this.formItems.map((item: IBestFieldItem) => item.prop)
		names.forEach((name: string) => {
			const item = this.formItems.find((item: IBestFieldItem) => item.prop === name)
			if (item) {
				item.resetValidation()
			}
		})
	}
	// 获取表单值
	getValues(){
		let result: Record<string, IBestFieldValueType> = {}
		this.formItems.forEach((item: IBestFieldItem) => {
			result[item.prop] = item.getValue()
		})
		return Promise.resolve(result)
	}
	// 获取表单值
	getFormValues(){
		let result: Record<string, IBestFieldValueType> = {}
		this.formItems.forEach((item: IBestFieldItem) => {
			result[item.prop] = item.getValue()
		})
		return result
	}
	build() {
		Column({ space: getSizeByUnit(this.space) }){
			if(this.defaultBuilder){
				this.defaultBuilder()
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.alignItems(HorizontalAlign.Start)
	}
}