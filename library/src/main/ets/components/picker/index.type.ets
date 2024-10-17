/**
 * 选项列表数据类型
 */
export interface IBestPickerOption{
	text: string
	value: string
	children?: IBestPickerOption[]
}
/**
 * 列表类型
 */
export type ColumnType = "cascade" | "multiple"