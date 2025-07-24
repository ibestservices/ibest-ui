/**
 * 组件名称
 */
export const COMPONENT_NAME = "DATEPICKER"
/**
 * 列表项数据类型
 */
export type DatePickerColumnType = "year" | "month" | "day"
/**
 * 选择器事件名称
 */
export enum DATE_PICKER_EVENT_NAME {
	/**
	 * 列表项切换
	 */
	COLUMN_CHANGE = 'COLUMN_CHANGE'
}
/**
 * datePicker change事件参数
 * @deprecated since 2.0.8
 * @useinstead IBestDatePickerResult
 */
export interface IBestDatePickerResultType {
	date: Date
	dateStr: string
	year: string
	month: string
	day?: string
}
export interface IBestDatePickerResult {
	date: Date
	dateStr: string
	year: string
	month: string
	day?: string
	lunarMonth?: string
	lunarDay?: string
}