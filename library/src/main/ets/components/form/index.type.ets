import { emitter } from '../../assets/ets/EventEmitter'
import { IBestFieldValueType } from '../field/index.type'
/*
 * 验证规则
 */
export interface IBestFormRuleItem {
	required?: boolean
	message?: string
	pattern?: RegExp
	validator?: (value: IBestFieldValueType) => boolean | string | Promise<boolean | string>
	trigger?: 'blur' | 'change'
	min?: number
	max?: number
}
export type IBestFormRule = Record<string, IBestFormRuleItem[]>


export enum FORM_EVENT_NAME {
	/**
	 * 发送表单信息
	 */
	SEND_FIELD = 'SEND_FIELD',
	/**
	 * 验证整个表单
	 */
	VALIDATE = 'VALIDATE',
	/*
	 * 验证某个字段
	 */
	VALIDATE_FIELD = 'VALIDATE_FIELD',
	/**
	 * 重置
	 */
	RESET_VALIDATE = 'RESET_VALIDATE',
	/*
	 * 获取所有值
	 */
	GET_VALUES = 'GET_VALUES'
}
/*
 * 获取事件名称
 */
export function getFormEventName(formId: string, eventName: string): string {
	return `IBestForm_${formId}_${eventName}`
}
/*
 * 表单验证结果
 */
export interface FieldValidateResult{
	name: string
	message: string
}
/*
 * 表单项信息
 */
export interface IBestFieldItem{
	prop: string
	validate: (rules: IBestFormRuleItem[]) => Promise<FieldValidateResult>
	resetValidation: () => void
	getValue: () => IBestFieldValueType
}
/*
 * 表单控制器
 */
export class IBestFormController {
	formId: string = ""
	/*
	 * 验证整个/某个表单
	 */
	public validate: (callBack: (valid: boolean, field?: FieldValidateResult[]) => void) => void = () => {}
	/*
	 * 验证某个字段
	 */
	public validateField: (name: string, callBack: (valid: boolean, field?: FieldValidateResult[]) => void) => void = () => {}
	/*
	 * 重置校验结果
	 */
	public resetValidation: (name?: string | string[]) => void = () => {}
	/*
	 * 获取表单当前所有值
	 */
	public getValues: () => Promise<Record<string, IBestFieldValueType>> = () => {
		let res: Record<string, IBestFieldValueType> = {}
		return Promise.resolve(res)
	}

	constructor() {
		this.validate = (callBack: (valid: boolean, field?: FieldValidateResult[]) => void) => {
			emitter.emit(getFormEventName(this.formId, FORM_EVENT_NAME.VALIDATE), callBack)
		}
		this.validateField = (name: string, callBack: (valid: boolean, field?: FieldValidateResult[]) => void) => {
			emitter.emit(getFormEventName(this.formId, FORM_EVENT_NAME.VALIDATE_FIELD), name, callBack)
		}
		this.resetValidation = (name?: string | string[]) => {
			emitter.emit(getFormEventName(this.formId, FORM_EVENT_NAME.RESET_VALIDATE), name)
		}
		this.getValues = () => {
			return new Promise<Record<string, IBestFieldValueType>>((resolve) => {
				emitter.emit(getFormEventName(this.formId, FORM_EVENT_NAME.GET_VALUES), (values: Record<string,
				IBestFieldValueType>) => {
					resolve(values)
				})
			})
		}
	}
}