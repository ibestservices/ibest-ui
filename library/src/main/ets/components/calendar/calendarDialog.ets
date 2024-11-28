import { COLOR_TYPE, ColorType } from '../../theme-chalk/src/color.type'
import { convertDimensionsWidthUnit } from '../../utils/utils'
import { IBestPopup } from '../popup'
import { IBestCalendar } from './index'
import { CalendarConfirmResultType, SelectedStyleType, SelectType, WeekDayType } from './index.type'

@Component
export struct IBestCalendarDialog {
    /**
     * 已选日期
     */
    @State selectedDate: Array<CalendarConfirmResultType> = []
    /**
     * 底部偏移
     */
    @Prop offsetY: number = 0
    /**
     * 是否为模态窗口
     */
    @Prop isModal: boolean = true
    /**
     * 背板的圆角半径
     */
    @Prop cornerRadius: number | string = convertDimensionsWidthUnit(10)
    /**
     * 弹框展示状态
     */
    @Link visible: boolean
    /**
     * 默认选中日期
     */
    @Prop defaultSelectedDate: Array<string> = []
    /**
     * 单项宽度
     */
    @Prop itemWidth: number | string = convertDimensionsWidthUnit(50)
    /**
     * 每周第一天是周几
     */
    @Prop weekFirstDay: WeekDayType = "一"
    /**
     * 是否显示农历
     */
    @Prop isShowLunar: boolean = false
    /**
     * 选择类型
     */
    @Prop selectType: SelectType = "single"
    /**
     * 选中样式
     */
    @Prop selectedStyleType: SelectedStyleType = "normal"
    /**
     * 选中主题颜色
     */
    @Prop type: ColorType = COLOR_TYPE.PRIMARY
    /**
     * 自定义选中颜色
     */
    @Prop selectedColor: string = ""
    /**
     * 日期区间最多可选天数 默认无限制
     */
    @Prop maxRange: number = -1
    /**
     * 最小日期
     */
    @Prop minDate: Date
    /**
     * 最大日期
     */
    @Prop maxDate: Date
    /**
     * 是否显示月份背景水印
     */
    @Prop isShowMark: boolean = false
    /**
     * 是否显示头部
     */
    @Prop isShowHeader: boolean = true
    /**
     * 确认按钮颜色，默认type主题色
     */
    @Prop confirmBtnColor: ResourceColor = ""
    /**
     * 确认按钮文案
     */
    @Prop confirmBtnText: string = "确认"
    /**
     * 选择回调
     */
    onConfirm: (value: Array<CalendarConfirmResultType>) => void = () => {}

    @Builder baseBuilder() {
        IBestCalendar({
            defaultSelectedDate: this.selectedDate.length ? this.selectedDate.map(item => item.dateStr) : this.defaultSelectedDate,
            itemWidth: this.itemWidth,
            isShowLunar: this.isShowLunar,
            selectType: this.selectType,
            selectedStyleType: this.selectedStyleType,
            type: this.type,
            weekFirstDay: this.weekFirstDay,
            minDate: this.minDate,
            maxDate: this.maxDate,
            maxRange: this.maxRange,
            selectedColor: this.selectedColor,
            isShowMark: this.isShowMark,
            isShowConfirmBtn: this.selectType != "single",
            isShowHeader: this.isShowHeader,
            confirmBtnColor: this.confirmBtnColor,
            confirmBtnText: this.confirmBtnText,
            onConfirm: (value): void => this.onGetCalendarResult(value)
        })
    }

    /**
     * 获取日历选择结果 触发onConfirm回调函数 并关闭弹框
     */
    onGetCalendarResult(value: Array<CalendarConfirmResultType>) {
        this.selectedDate = value
        this.onConfirm(this.selectedDate)
        this.visible = false
    }
    build() {
        IBestPopup({
            visible: $visible,
            offsetY: this.offsetY,
            isModal: this.isModal,
            cornerRadius: this.cornerRadius,
            popupAlign: "bottom",
            popupHeight: "auto",
            safeAreaInsetBottom: true,
            contentBuilder: ():void => this.baseBuilder()
        })
    }
}