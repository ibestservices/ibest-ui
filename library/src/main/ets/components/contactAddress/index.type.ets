import { FieldValidateResult, IBestFormValidateResult } from "../form/index.type"

export interface IBestContactAddressFormResult {
	/**
	 * 手机号
	 */
	phone: string
	/**
	 * 邮政编码
	 */
	postalCode?: string
	/**
	 * 省级数据
	 */
	province: string
	/**
	 * 市级数据
	 */
	city: string
	/**
	 * 区县级数据
	 */
	area: string
	/**
	 * 识别后的其他数据，门牌号等
	 */
	detail: string
	/**
	 * 姓名
	 */
	name: string
	/**
	 * 省级区域编码
	 */
	provinceCode: string
	/**
	 * 市级区域编码
	 */
	cityCode: string
	/**
	 * 区县级区域编码
	 */
	areaCode: string
}
export interface CascaderOption {
	text: string
	value: string
	children?: Array<CascaderOption>
}
export interface AreaJsonBasicType {
	code: string
	name: string
}
export interface CityJsonType extends AreaJsonBasicType {
	provinceCode: string
}
export interface DistrictJsonType extends CityJsonType {
	cityCode: string
}
export interface AddressParseResult_ {
	phone: string
	postalCode?: string
	province: Array<AreaJsonBasicType>
	city: Array<CityJsonType>
	area: Array<DistrictJsonType>
	detail: Array<string>
	name: string
	provinceCode: string
	cityCode: string
	areaCode: string
}
export interface AddressParseConfigType {
	debug: boolean
	/**
	 * 匹配名字的最大长度
	 */
	nameMaxLength: number
	/**
	 * 预处理过滤文本中的关键字，可根据情况添加
	 */
	textFilter: Array<string>
}
// 过滤器返回类型
export interface filterResult {
	/**
	 * 过滤后其他内容
	 */
	others: string
	/**
	 * 过滤后的目标内容
	 */
	target: string
}

/**
 * 联系人地址表单控制器
 */
export class IBestContactAddressController {
	/**
	 * 验证整个表单
	 */
	public validateForm: (callBack?: (valid: boolean, field: FieldValidateResult[]) => void) => Promise<IBestFormValidateResult> = () => {
		let res: IBestFormValidateResult = {
			valid: true,
			fields: []
		}
		return Promise.resolve(res)
	}
	/**
	 * 获取所有值
	 */
	public getFormValues: () => IBestContactAddressFormResult = () => {
		return {
			phone: '',
			province: '',
			city: '',
			area: '',
			detail: '',
			name: '',
			provinceCode: '',
			cityCode: '',
			areaCode: ''
		}
	}
	/**
	 * 设置表单数据
	 */
	public setFormValues: (val: IBestContactAddressFormResult) => void = () => {}
	/**
	 * 清除表单数据
	 */
	public cleanFormValues: () => void = () => {}
}