/**
 * 扩展键类型
 */
export type ExtraKeyType = '' | 'delete' | 'extra' | 'close'
/**
 * 基础键数据类型
 */
export interface KeyboardType {
	text?: string
	type?: ExtraKeyType
	fullWidth?: boolean
}