import { emitter } from '../../assets/ets/EventEmitter'
import { IBestFieldValueType } from '../field/index.type'
import {
	FieldValidateResult,
	FORM_EVENT_NAME,
	getFormEventName,
	IBestFormController,
	IBestFormRule,
	IBestFieldItem,
	IBestFormRuleItem
} from './index.type'

@Component
export struct IBestForm {
	/*
     * form id 用于验证
     */
	@Prop formId: string = ""
	@State formItems: IBestFieldItem[] = []
	rules: IBestFormRule = {}

	@Prop space: number = 20
	@BuilderParam defaultBuilder: () => void
	controller: IBestFormController | null = null
	aboutToAppear(): void {
		if(this.controller){
			this.controller.formId = this.formId
			// 初始化收集表单项信息
			emitter.on(getFormEventName(this.formId, FORM_EVENT_NAME.SEND_FIELD), (data: IBestFieldItem, callBack: (rule: IBestFormRuleItem[]) => void) => {
				if(this.formItems.findIndex((item: IBestFieldItem) => item.prop === data.prop) == -1){
					this.formItems.push(data)
				}
				callBack(this.rules[data.prop])
			})
			// 监听表单验证
			emitter.on(getFormEventName(this.formId, FORM_EVENT_NAME.VALIDATE), (callBack: (valid: boolean, field?: FieldValidateResult[]) => void) => {
				this.validateForm(callBack)
			})
			// 监听单个表单验证
			emitter.on(getFormEventName(this.formId, FORM_EVENT_NAME.VALIDATE_FIELD), (prop: string, callBack: (valid: boolean, field?: FieldValidateResult) => void) => {
				this.validateField(prop, callBack)
			})
			// 监听重置表单验证
			emitter.on(getFormEventName(this.formId, FORM_EVENT_NAME.RESET_VALIDATE), (prop?: string | string[]) => {
				this.resetValidation(prop)
			})
			// 获取表单结果
			emitter.on(getFormEventName(this.formId, FORM_EVENT_NAME.GET_VALUES), (callBack: (result: Record<string, IBestFieldValueType>) => void) => {
				this.getValues(callBack)
			})
		}
	}
	// 验证表单
	validateForm(callBack: (valid: boolean, field?: FieldValidateResult[]) => void) {
		Promise.all(this.formItems.map((item: IBestFieldItem) => item.validate(this.rules[item.prop]))).then((errors) => {
			errors = errors.filter(Boolean)
			if (errors.length) {
				callBack(false, errors)
			} else {
				callBack(true, [])
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
	getValues(callBack: (result: Record<string, IBestFieldValueType>) => void){
		let result: Record<string, IBestFieldValueType> = {}
		this.formItems.forEach((item: IBestFieldItem) => {
			result[item.prop] = item.getValue()
		})
		callBack(result)
	}
	build() {
		Column({ space: this.space + 'lpx' }){
			this.defaultBuilder()
		}
		.width('100%')
		.alignItems(HorizontalAlign.Start)
	}
}