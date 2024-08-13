/*
 * 列表项数据类型
 */
export type DatePickerColumnType = "year" | "month" | "day"
/*
 * 选择器事件名称
 */
export enum DATE_PICKER_EVENT_NAME {
	/**
	 * 列表项切换
	 */
	COLUMN_CHANGE = 'COLUMN_CHANGE'
}
/*
 * 获取事件名称
 */
export function getPickerEventName(id: string, eventName: string): string {
	return `IBestDatePicker_${id}_${eventName}`
}
/*
 * datePicker change事件参数
 */
export interface IBestDatePickerResultType {
	date: Date
	dateStr: string
	year: string
	month: string
	day?: string
}