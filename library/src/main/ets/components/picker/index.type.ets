/*
 * 选项列表类型
 */
export interface IBestPickerOption{
	text: string
	value: string
	children?: IBestPickerOption[]
}