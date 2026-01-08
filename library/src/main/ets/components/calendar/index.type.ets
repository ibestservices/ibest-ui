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
    date: Date = new Date()
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

class BasicDataSource implements IDataSource {
    private listeners: DataChangeListener[] = []
    private originDataArray: IBestCalendarDay[][] = []
    public totalCount(): number {
        return this.originDataArray.length
    }
    public getData(index: number): IBestCalendarDay[] {
        return this.originDataArray[index]
    }
    registerDataChangeListener(listener: DataChangeListener): void {
        if (this.listeners.indexOf(listener) < 0) {
            this.listeners.push(listener)
        }
    }
    unregisterDataChangeListener(listener: DataChangeListener): void {
        const pos = this.listeners.indexOf(listener)
        if (pos >= 0) {
            this.listeners.splice(pos, 1)
        }
    }
    notifyDataReload(): void {
        this.listeners.forEach(listener => {
            listener.onDataReloaded()
        })
    }
    notifyDataAdd(index: number): void {
        this.listeners.forEach(listener => {
            listener.onDataAdd(index)
        })
    }
}

export class IBestCalendarDataSource extends BasicDataSource {
    private list: IBestCalendarDay[][] = []
    public totalCount(): number {
        return this.list.length
    }
    public setList(list: IBestCalendarDay[][]){
        this.list = list
        this.notifyDataReload()
    }
    public getAllList(){
        return this.list
    }
    public getData(index: number): IBestCalendarDay[] {
        return this.list[index]
    }
    public unshiftData(data: IBestCalendarDay[]){
        this.list.unshift(data)
        this.notifyDataAdd(0)
    }
    public pushData(data: IBestCalendarDay[]): void {
        this.list.push(data)
        this.notifyDataAdd(this.list.length - 1)
    }
}