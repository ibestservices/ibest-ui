/**
 * 组件名称
 */
export const COMPONENT_NAME = "DATETIMEPICKER"
/**
 * 选择器事件名称
 */
export enum DATE_TIME_PICKER_EVENT_NAME {
	/**
	 * 列表项切换
	 */
	COLUMN_CHANGE = 'COLUMN_CHANGE'
}

export interface IBestDateTimePickerResult {
	year: string
	month: string
	day: string
	hour: string
	minute: string
	second: string
}