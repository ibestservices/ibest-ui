export class DateUtils {
    private _date: Date
    constructor(date: string | number | Date | DateUtils = new Date()) {
        this._date = new Date(date instanceof DateUtils ? date._date : date)
    }
    /**
     * 添加指定年数
     * @param {number} years - 要添加的年数
     */
    add(value: number, unit: 'year' | 'month' | 'day') {
        switch (unit){
            case 'year':
                this._date.setFullYear(this._date.getFullYear() + value)
                break
            case 'month':
                this._date.setMonth(this._date.getMonth() + value)
                break
            case 'day':
                this._date.setDate(this._date.getDate() + value)
                break
        }
        return this
    }
    /**
     * 减去指定年数
     * @param {number} years - 要减去的年数
     */
    subtract(years: number, type: 'year' | 'month' | 'day') {
        return this.add(-years, type)
    }
    /**
     * 添加指定月数
     * @param {number} months - 要添加的月数
     * @returns {DateChain} 返回当前实例以支持链式调用
     */
    addMonths(months: number) {
        const currentMonth = this._date.getMonth()
        this._date.setMonth(currentMonth + months)

        return this
    }
    /**
     * 减去指定月数
     * @param {number} months - 要减去的月数
     * @returns {DateChain} 返回当前实例以支持链式调用
     */
    subtractMonths(months) {
        return this.addMonths(-months)
    }
    /**
     * 添加指定天数
     * @param {number} days - 要添加的天数
     * @returns {DateChain} 返回当前实例以支持链式调用
     */
    addDays(days: number) {
        const currentDate = this._date.getDate()
        this._date.setDate(currentDate + days)

        return this
    }
    /**
     * 减去指定天数
     * @param {number} days - 要减去的天数
     * @returns {DateChain} 返回当前实例以支持链式调用
     */
    subtractDays(days) {
        return this.addDays(-days)
    }
    /**
     * 获取月份天数
     */
    static getDaysInMonth(year: number, month: number) {
        // 创建指定月份的第一天
        const firstDayOfMonth = new Date(year, month - 1, 1);

        // 创建下个月的第一天
        const firstDayOfNextMonth = new Date(year, month, 1);

        // 计算两个日期之间的天数差
        const diffInMs = firstDayOfNextMonth.getTime() - firstDayOfMonth.getTime();
        return diffInMs / (1000 * 60 * 60 * 24);
    }
    /**
     * 设置时间为当天的开始 (00:00:00.000)
     */
    startOfDay() {
        this._date.setHours(0, 0, 0, 0)
        return this
    }
    /**
     * 设置时间为当天的结束 (23:59:59.999)
     */
    endOfDay() {
        this._date.setHours(23, 59, 59, 999)
        return this
    }
    /**
     * 设置时间为月份的开始 (当月第一天 00:00:00.000)
     */
    startOfMonth() {
        this._date.setDate(1)
        this._date.setHours(0, 0, 0, 0)
        return this
    }
    /**
     * 设置时间为月份的结束 (当月最后一天 23:59:59.999)
     */
    endOfMonth() {
        const year = this._date.getFullYear()
        const month = this._date.getMonth()
        const nextMonth = new Date(year, month + 1, 1)
        nextMonth.setMilliseconds(-1)
        this._date = nextMonth
        this._date.setHours(23, 59, 59, 999)
        return this
    }
    /**
     * 获取当前日期的Date对象
     */
    toDate() {
        return new Date(this._date)
    }
    /**
     * 获取时间戳
     */
    valueOf() {
        return this._date.getTime()
    }
    /**
     * 格式化日期
     * @param {string} format - 格式字符串，支持以下占位符：
     *   YYYY - 四位数年份
     *   MM - 两位数月份
     *   M - 一位数日期
     *   DD - 两位数日期
     *   D - 一位数日期
     *   HH - 两位数小时（24小时制）
     *   H - 一位数小时（12小时制）
     *   mm - 两位数分钟
     *   m - 一位数分钟
     *   ss - 两位数秒数
     *   s - 一位数秒数
     * @returns {string} 格式化后的日期字符串
     */
    format(format = 'YYYY-MM-DD') {
        const year = this._date.getFullYear().toString()
        const month = (this._date.getMonth() + 1).toString()
        const day = (this._date.getDate()).toString()
        const hours = (this._date.getHours()).toString()
        const minutes = (this._date.getMinutes()).toString()
        const seconds = (this._date.getSeconds()).toString()
        return format
            .replace('YYYY', year)
            .replace('MM', month.padStart(2, '0'))
            .replace('M', month.toString())
            .replace('DD', day.padStart(2, '0'))
            .replace('D', day)
            .replace('HH', hours.padStart(2, '0'))
            .replace('H', hours)
            .replace('mm', minutes.padStart(2, '0'))
            .replace('m', minutes)
            .replace('ss', seconds.padStart(2, '0'))
            .replace('s', seconds)
    }
    /**
     * 检查是否为闰年
     * @returns {boolean} 是否为闰年
     */
    isLeapYear() {
        const year = this._date.getFullYear()
        return (year % 4 === 0 && year % 100 !== 0) || (year % 400 === 0)
    }
    /**
     * 获取月份天数
     * @returns {number} 当前日期所在月份的天数
     */
    daysInMonth() {
        const year = this._date.getFullYear()
        const month = this._date.getMonth() + 1
        return DateUtils.getDaysInMonth(year, month)
    }
    /**
     * 比较两个日期是否相等
     * @param {Date|DateChain} other - 要比较的日期
     * @returns {boolean} 是否相等
     */
    isSame(other: Date) {
        return this._date.getTime() === other.getTime()
    }
    /**
     * 检查是否在另一个日期之前
     * @param {Date} other - 要比较的日期
     * @returns {boolean} 是否在之前
     */
    isBefore(other: Date | DateUtils | string) {
        let otherDate
        if (other instanceof DateUtils) {
            otherDate = other.toDate()
        } else if (other instanceof Date) {
            otherDate = other
        }else {
            otherDate = new Date(other)
        }
        return this._date.getTime() < otherDate.getTime()
    }
    /**
     * 检查是否在另一个日期之后
     * @param {Date|DateChain} other - 要比较的日期
     * @returns {boolean} 是否在之后
     */
    isAfter(other: Date | DateUtils | string) {
        let otherDate
        if (other instanceof DateUtils) {
            otherDate = other.toDate()
        } else if (other instanceof Date) {
            otherDate = other
        }else {
            otherDate = new Date(other)
        }
        return this._date.getTime() > otherDate.getTime()
    }
    /**
     * 获取当前日期的星期数
     */
    day(){
        return this._date.getDay()
    }
    /**
     * 设置当前日期
     */
    date(value: number){
        this._date.setDate(value)
        return this
    }
    /**
     * 是否有效
     */
    isValid(){
        if (isNaN(this._date.getTime())) {
            return false
        }
        return true
    }
}

function dateUtils(date: string | number | Date | DateUtils = new Date()) {
    return new DateUtils(date)
}

export default dateUtils