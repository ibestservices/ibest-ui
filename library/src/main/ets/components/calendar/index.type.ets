import dayjs, { Dayjs } from '@hview/dayjs'

export type SelectType = "single" | "multiple" | "range"

export type SelectedStyleType = "normal" | "circle"

export type WeekDayType = 1 | 2 | 3 | 4 | 5 | 6 | 0

/**
 * 日历选择结果
 * @deprecated since 2.0.7
 * @useinstead IBestCalendarConfirmResult
 */
export interface CalendarConfirmResultType{
    date: Date
    dateStr: string
    lunarMonth?: string
    lunarDay?: string
}
/**
 * 日历选择结果
 */
export interface IBestCalendarConfirmResult{
    date: Date
    dateStr: string
    lunarMonth?: string
    lunarDay?: string
}

export class IBestCalendarDayItem{
    date: Dayjs = dayjs()
    dateStr: string = ""
    year: string = ""
    month: string = ""
    day: string = ""
    weekNum: number = 0
    lunarMonth: string = ""
    lunarDay: string = ""
    isCurMonthDay: boolean = false
    isSelected: boolean = false
    isDisabled?: boolean = false
    isClock?: boolean = false
}
@Observed
export class IBestCalendarDay extends IBestCalendarDayItem{
    constructor(value?: IBestCalendarDayItem){
        super()
        if(value){
            this.date = value.date
            this.dateStr = value.dateStr
            this.weekNum = value.weekNum
            this.lunarMonth = value.lunarMonth
            this.lunarDay = value.lunarDay
            this.year = value.year
            this.month = value.month
            this.day = value.day
            this.isCurMonthDay = value.isCurMonthDay
            this.isSelected = value.isSelected
            this.isDisabled = value.isDisabled
            this.isClock = value.isClock
        }
    }
}

export interface HeaderItemType{
    text: ResourceStr
    key: number
}