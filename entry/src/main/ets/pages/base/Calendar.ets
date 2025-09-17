import {
	IBestButton,
	IBestCalendar,
	IBestCalendarConfirmResult,
	IBestCalendarDayItem,
	IBestCalendarDialog,
	IBestCell,
	IBestCellGroup,
    IBestToast
} from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import dayjs from '@hview/dayjs'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function CalendarBuilder(_: string, title: string){
	CalendarPage({title})
}

@Entry
@Component
struct CalendarPage {
    @State title: string = ''
    @State singleVisible: boolean = false
    @State selectDate: string = ""
    @State multipleVisible: boolean = false
    @State multipleDateRange: string[] = []
    @State rangeVisible: boolean = false
    @State rangeDateRange: string[] = []
    @State customColorVisible: boolean = false
    @State customColorDate: string[] = []
    @State customRangeVisible: boolean = false
    @State customRangeDate: string[] = []
    @State lunarVisible: boolean = false
    @State lunarDate: string = ""
    @State customWeekVisible: boolean = false
    @State customWeekDate: string = ""
    @State rangeNumVisible: boolean = false
    @State rangeNumDate: string[] = []
    @State waterBgVisible: boolean = false
    @State waterBgDate: string = ""

    @State clockDate: string[] = [dayjs().startOf("month").format('YYYY-MM-DD')]

    @State defaultSelectedDate: string[] = [dayjs().format('YYYY-MM-DD')]

	@Builder itemBuilder($$: IBestCalendarDayItem){
		Column({space: 6}){
			Text($$.day)
				.fontSize(12)
				.fontColor($$.isSelected ? "#1989fa" : "#333")
			Text($$.lunarDay)
				.fontSize(12)
				.fontColor($$.isSelected ? "#1989fa" : "#333")
		}
		.width(50)
		.aspectRatio(1)
		.justifyContent(FlexAlign.Center)
		.backgroundImage($$.isSelected ? "https://img95.699pic.com/xsj/0w/ev/jl.jpg%21/fh/300" : "")
		.backgroundImageSize(ImageSize.FILL)
		.backgroundImagePosition(Alignment.Center)
	}

    build() {
		NavDestination(){
			CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.XS }) {
                        IBestCellGroup() {
                            Column() {
                                IBestCell({
                                    title: '选择单个日期',
                                    value: this.selectDate,
                                    isLink: true,
                                    onCellClick: () => {
                                        this.singleVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '选择多个日期',
                                    value: this.multipleDateRange.join(","),
                                    isLink: true,
                                    onCellClick: () => {
                                        this.multipleVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '选择日期区间',
                                    hasBorder: false,
                                    value: this.rangeDateRange.length ? this.rangeDateRange[0] + " - " + this.rangeDateRange[this.rangeDateRange.length-1] : "",
                                    isLink: true,
                                    onCellClick: () => {
                                        this.rangeVisible = true
                                    }
                                })
                            }
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义日历', titlePaddingLeft: SPACE.XS }) {
                        IBestCellGroup() {
                            Column() {
                                IBestCell({
                                    title: '自定义颜色',
                                    value: this.customColorDate.join(","),
                                    isLink: true,
                                    onCellClick: () => {
                                        this.customColorVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '显示农历',
                                    value: this.lunarDate,
                                    isLink: true,
                                    onCellClick: () => {
                                        this.lunarVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '自定义日期范围',
                                    value: this.customRangeDate.join(","),
                                    isLink: true,
                                    onCellClick: () => {
                                        this.customRangeVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '日期区间最大范围',
                                    value: this.rangeNumDate.length ? this.rangeNumDate[0] + " - " + this.rangeNumDate[this.rangeNumDate.length-1] : "",
                                    isLink: true,
                                    onCellClick: () => {
                                        this.rangeNumVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '自定义周起始日期',
                                    value: this.customWeekDate,
                                    isLink: true,
                                    onCellClick: () => {
                                        this.customWeekVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '显示月份背景水印',
                                    value: this.waterBgDate,
                                    isLink: true,
                                    hasBorder: false,
                                    onCellClick: () => {
                                        this.waterBgVisible = true
                                    }
                                })
                            }
                        }
                    }
                }
                ListItem(){
                    ComponentShowContainer({ title: '平铺展示', titlePaddingLeft: SPACE.XS }) {
                        IBestCalendar({
                            value: $defaultSelectedDate,
                            isShowLunar: true,
                            selectType: "multiple",
                            isShowMark: true,
							dayItemBuilder: this.itemBuilder
                        })
                    }
                }
                ListItem(){
                    ComponentShowContainer({ title: '打卡模式', titlePaddingLeft: SPACE.XS }) {
                        Column({space: SPACE.MD}){
                            IBestButton({
                                type: "primary",
                                text: "打卡",
                                onBtnClick: () => {
                                    this.clockDate.push(dayjs(this.clockDate[this.clockDate.length-1]).add(1, 'day').format("YYYY-MM-DD"))
                                }
                            })
                            IBestCalendar({
                                clock: true,
                                value: $clockDate
                            })
                        }
                    }
                }
				ListItem().height(50)
            }
            .layoutWeight(1)
            // 弹框展示
            // 单选
            IBestCalendarDialog({
                visible: $singleVisible,
                value: $selectDate,
                type: "danger",
                onConfirm: (value: IBestCalendarConfirmResult[]) => {
                    IBestToast.show(value[0].dateStr)
                }
            })
            // 多选
            IBestCalendarDialog({
                visible: $multipleVisible,
                value: $multipleDateRange,
                selectType: "multiple"
            })
            // 区间选
            IBestCalendarDialog({
                visible: $rangeVisible,
                value: $rangeDateRange,
                selectType: "range"
            })
            // 自定义颜色
            IBestCalendarDialog({
                visible: $customColorVisible,
                value: $customColorDate,
                selectType: "multiple",
                selectedColor: "#58DB6B"
            })
            // 显示农历
            IBestCalendarDialog({
                visible: $lunarVisible,
                value: $lunarDate,
                isShowLunar: true,
                cornerRadius: 20
            })
            // 自定义日期范围
            IBestCalendarDialog({
                visible: $customRangeVisible,
                value: $customRangeDate,
                selectType: "multiple",
                selectedStyleType: "circle",
                minDate: new Date('1991-01-01'),
                maxDate: new Date(),
                confirmBtnColor: "#ed4040"
            })
            // 日期区间最大范围
            IBestCalendarDialog({
                visible: $rangeNumVisible,
                value: $rangeNumDate,
                type: "danger",
                selectType: "range",
                maxRange: 7
            })
            // 自定义周起始日期
            IBestCalendarDialog({
                visible: $customWeekVisible,
                value: $customWeekDate,
                weekFirstDay: 0
            })
            // 显示月份背景水印
            IBestCalendarDialog({
                visible: $waterBgVisible,
                value: $waterBgDate,
                isShowMark: true
            })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg)
    }
}