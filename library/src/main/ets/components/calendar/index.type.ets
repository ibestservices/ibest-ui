export type SelectType = "single" | "multiple" | "range"
export type SelectedStyleType = "normal" | "circle"
export interface ConfirmResultType{
    date: Date
    dateStr: string
    lunarMonth?: string
    lunarDay?: string
}