export type SelectType = "single" | "multiple" | "range"

export type SelectedStyleType = "normal" | "circle"

export type WeekDayType = "一" | "二" | "三" | "四" | "五" | "六" | "日"

export interface CalendarConfirmResultType{
    date: Date
    dateStr: string
    lunarMonth?: string
    lunarDay?: string
}