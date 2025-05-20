/**
 * 扩展键类型
 */
export type IBestNumberExtraKeyType = '' | 'delete' | 'extra' | 'close'
/**
 * 基础键数据类型
 */
export interface IBestNumberKeyboardType {
	text?: ResourceStr
	type?: IBestNumberExtraKeyType
	fullWidth?: boolean
}