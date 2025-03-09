import { IBestStringNumber } from '../../model/Global.type'

/**
 * 选项列表数据类型
 */
export interface IBestPickerOption{
	text: ResourceStr
	value: IBestStringNumber
	children?: IBestPickerOption[]
}
/**
 * 列表类型
 */
export type ColumnType = "cascade" | "multiple"