/**
 * 列表显示类型
 */
export type TimePickerColumnType = "hour" | "minute" | "second"

/**
 * 组件名称
 */
export const COMPONENT_NAME = "TIMEPICKER"
/**
 * 选择器事件名称
 */
export enum TIME_PICKER_EVENT_NAME {
    /**
     * 列表项切换
     */
    COLUMN_CHANGE = 'COLUMN_CHANGE'
}