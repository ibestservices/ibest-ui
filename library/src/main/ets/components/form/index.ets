import { emitter } from '../../assets/ets/EventEmitter'
import { FieldTextAlign, IBestFieldValueType,
	LabelPositionType,
	RequireAsteriskPositionType } from '../field/index.type'
import {
	FieldValidateResult,
	FORM_EVENT_NAME,
	getFormEventName,
	IBestFormController,
	IBestFormRule,
	IBestFieldItem,
	IBestFormSendFieldCallResult
} from './index.type'

@Component
export struct IBestForm {
	/*
     * form id 用于验证
     */
	@Prop formId: string = ""
	/*
	 * 表单子项信息
	 */
	@State formItems: IBestFieldItem[] = []
	/*
	 * 表单验证规则
	 */
	rules: IBestFormRule = {}
	/*
	 * 表单项间距
  	 */
	@Prop space: number = 20
	/*
     * 文本宽度
     */
	@Provide labelWidth: number = 160
	/*
     * 文本位置
     */
	@Provide labelPosition: LabelPositionType = "left"
	/*
     * 文本对齐方式
     */
	@Provide labelAlign: FieldTextAlign = "left"
	/*
	 * 是否显示文本后冒号
	 */
	@Provide colon: boolean = false
	/*
     * 星号的位置
     */
	@Provide requireAsteriskPosition: RequireAsteriskPositionType = 'left'
	/*
     * 是否显示验证信息
     */
	@Provide showMessage: boolean = true
	/*
     * 是否禁用
     */
	@Provide disabled: boolean = false
	/*
	 * 表单内容
	 */
	@BuilderParam defaultBuilder: () => void
	/*
	 * 表单控制器
	 */
	controller: IBestFormController | null = null
	aboutToAppear(): void {
		if(this.controller){
			this.controller.formId = this.formId
			// 初始化收集表单项信息
			emitter.on(getFormEventName(this.formId, FORM_EVENT_NAME.SEND_FIELD), (data: IBestFieldItem, callBack: (result: IBestFormSendFieldCallResult) => void) => {
				if(this.formItems.findIndex((item: IBestFieldItem) => item.prop === data.prop) == -1){
					this.formItems.push(data)
				}
				callBack({
					rules: this.rules[data.prop],
					labelWidth: this.labelWidth,
					labelPosition: this.labelPosition,
					labelAlign: this.labelAlign,
					colon: this.colon,
					requireAsteriskPosition: this.requireAsteriskPosition,
					showMessage: this.showMessage,
					disabled: this.disabled
				})
			})
			// 监听表单验证
			emitter.on(getFormEventName(this.formId, FORM_EVENT_NAME.VALIDATE), (callBack?: (valid: boolean, field: FieldValidateResult[]) => void) => {
				this.validateForm(callBack)
			})
			// 监听单个表单验证
			emitter.on(getFormEventName(this.formId, FORM_EVENT_NAME.VALIDATE_FIELD), (prop: string, callBack?: (valid: boolean, field?: FieldValidateResult) => void) => {
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
	validateForm(callBack?: (valid: boolean, field: FieldValidateResult[]) => void) {
		Promise.all(this.formItems.map((item: IBestFieldItem) => item.validate(this.rules[item.prop]))).then((errors) => {
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