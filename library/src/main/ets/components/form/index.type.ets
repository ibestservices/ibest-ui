import { IBestStringNumber } from '../../model/Global.type'
import {
	FieldTextAlign,
	IBestFieldValueType,
	LabelPositionType,
	RequireAsteriskPositionType
} from '../field/index.type'
/**
 * 验证规则
 */
export interface IBestFormRuleItem {
	required?: boolean
	message?: ResourceStr
	pattern?: RegExp
	validator?: (value: string) => boolean | string | Promise<boolean | string>
	trigger?: 'blur' | 'change'
	min?: number
	max?: number
}
export type IBestFormRule = Record<string, IBestFormRuleItem[]>

/**
 * 组件名称
 */
export const COMPONENT_NAME = 'FORM'

export enum FORM_EVENT_NAME {
	/**
	 * 发送表单信息
	 */
	SEND_FIELD = 'SEND_FIELD',
	/**
	 * 重置表单项
    */
	RESEND_FORM_ITEM = 'RESEND_FORM_ITEM',
	/**
	 * 验证整个表单
	 */
	VALIDATE = 'VALIDATE',
	/**
	 * 验证某个字段
	 */
	VALIDATE_FIELD = 'VALIDATE_FIELD',
	/**
	 * 重置验证
	 */
	RESET_VALIDATE = 'RESET_VALIDATE',
	/**
	 * 获取所有值
	 */
	GET_VALUES = 'GET_VALUES',
	/**
	 * 删除表单项
     */
	DELETE_FORM_ITEM = 'DELETE_FORM_ITEM'
}
/**
 * SEND_FIELD 回调参数
 */
export interface IBestFormSendFieldCallResult {
	rules: IBestFormRuleItem[]
	labelWidth: IBestStringNumber
	labelPosition: LabelPositionType
	labelAlign: FieldTextAlign
	colon: boolean
	requireAsteriskPosition: RequireAsteriskPositionType
	showMessage: boolean
	disabled: boolean
}
/**
 * 表单验证结果
 */
export interface FieldValidateResult{
	label: string
	name: string
	message: string
}
/**
 * 表单项信息
 */
export interface IBestFieldItem{
	uniId: number
	prop: string
	validate: (rules: IBestFormRuleItem[]) => Promise<FieldValidateResult>
	resetValidation: () => void
	getValue: () => IBestFieldValueType
}
export interface IBestFormValidateResult{
	valid: boolean
	fields: FieldValidateResult[]
}
export interface IBestFieldValidateResult{
	valid: boolean
	field: FieldValidateResult
}
/**
 * 表单控制器
 */
export class IBestFormController {
	/**
	 * 验证整个/某个表单
	 * @param callBack 回调函数
	 */
	public validate: (callBack?: (valid: boolean, field: FieldValidateResult[]) => void) => Promise<IBestFormValidateResult> = () => {
		let res: IBestFormValidateResult = {
			valid: true,
			fields: []
		}
		return Promise.resolve(res)
	}
	/**
	 * 验证某个字段
	 * @param name 表单属性名
	 * @param callBack 回调函数
	 */
	public validateField: (name: string, callBack?: (valid: boolean, field?: FieldValidateResult) => void) => Promise<IBestFieldValidateResult> = () => {
		let res: IBestFieldValidateResult = {
			valid: true,
			field: {
				label: '',
				name: '',
				message: ''
			}
		}
		return Promise.resolve(res)
	}
	/**
	 * 重置校验结果
	 * @param name 表单属性名
	 */
	public resetValidation: (name?: string | string[]) => void = () => {}
	/**
	 * 获取表单当前所有值
	 * @deprecated since 1.15.0
	 * @useinstead getFormValues
	 */
	public getValues: () => Promise<Record<string, IBestFieldValueType>> = () => {
		let res: Record<string, IBestFieldValueType> = {}
		return Promise.resolve(res)
	}
	/**
	 * 获取表单所有值
	 * @since 1.15.0
	 */
	public getFormValues: () => Record<string, IBestFieldValueType> = () => {
		let res: Record<string, IBestFieldValueType> = {}
		return res
	}
}