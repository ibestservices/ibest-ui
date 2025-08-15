import { IBestStringNumber } from '../../model/Global.type'
import { COLOR_TYPE, ColorType } from '../../theme-chalk/src/color.type'
import { convertDimensionsWidthUnit } from '../../utils/utils'
import { IBestPopup } from '../popup'
import { IBestCalendar } from './index'
import {
    IBestCalendarConfirmResult,
    IBestCalendarDayItem,
    SelectedStyleType,
    SelectType,
    WeekDayType
} from './index.type'

@Component
export struct IBestCalendarDialog {
    /**
     * 已选日期
     */
    @State selectedDate: IBestCalendarConfirmResult[] = []
    /**
     * 底部偏移
     */
    @Prop offsetY: number = 0
    /**
     * 是否为模态窗口
     */
    @Prop isModal: boolean = true
    /**
     * 弹框圆角半径
     */
    @Prop cornerRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = convertDimensionsWidthUnit(10)
    /**
     * 弹框展示状态
     */
    @Link visible: boolean
    /**
     * 默认选中日期
     */
    @Prop defaultSelectedDate: string[] = []
    /**
     * 单项宽度
     */
    @Prop itemWidth: IBestStringNumber = convertDimensionsWidthUnit(50)
    /**
     * 每周第一天是周几
     */
    @Prop weekFirstDay: WeekDayType = 1
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
     * 自定义选中背景颜色
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
	@Prop confirmBtnText: ResourceStr = $r("app.string.ibest_text_confirm")
	/**
	 * 打卡模式
	 * @since 2.0.1
	 */
	@Provide({allowOverride: "clock"}) clock: boolean = false
	/**
	 * 打卡成功提示
	 * @since 2.0.1
	 */
	@Provide({allowOverride: "clockSuccessText"}) clockSuccessText: ResourceStr = $r("app.string.ibest_calendar_clocked")
	/**
	 * 是否显示未打卡
	 * @since 2.0.1
	 */
	@Provide({allowOverride: "isShowUnClock"}) isShowUnClock: boolean = true
	/**
	 * 未打卡提示
	 * @since 2.0.1
	 */
	@Provide({allowOverride: "unClockText"}) unClockText: ResourceStr = $r("app.string.ibest_calendar_unclock")
	/**
	 * 是否显示其他月份日期
	 * @since 2.1.3
	 */
	@Prop showOtherMonthDate: boolean = true
	/**
	 * 自定义日期项插槽
	 * @since 2.0.9
	 */
	@BuilderParam dayItemBuilder: ($$: IBestCalendarDayItem) => void
    /**
     * 选择回调
     */
    onConfirm: (value: IBestCalendarConfirmResult[]) => void = () => {}

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
			showOtherMonthDate: this.showOtherMonthDate,
            confirmBtnColor: this.confirmBtnColor,
            confirmBtnText: this.confirmBtnText,
			clock: this.clock,
			clockSuccessText: this.clockSuccessText,
			isShowUnClock: this.isShowUnClock,
			unClockText: this.unClockText,
			dayItemBuilder: this.dayItemBuilder,
            onConfirm: (value): void => this.onGetCalendarResult(value)
        })
    }

    /**
     * 获取日历选择结果 触发onConfirm回调函数 并关闭弹框
     */
    onGetCalendarResult(value: IBestCalendarConfirmResult[]) {
        if(value.length){
            this.selectedDate = value
            this.onConfirm(this.selectedDate)
            this.visible = false
        }
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