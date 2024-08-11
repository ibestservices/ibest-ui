/*
 * 列表显示类型
 */
export type TimePickerColumnType = "hour" | "minute" | "second"

/*
 * 选择器事件名称
 */
export enum TIME_PICKER_EVENT_NAME {
    /**
     * 列表项切换
     */
    COLUMN_CHANGE = 'COLUMN_CHANGE'
}
/*
 * 获取事件名称
 */
export function getPickerEventName(id: string, eventName: string): string {
    return `IBestTIMEPicker_${id}_${eventName}`
}