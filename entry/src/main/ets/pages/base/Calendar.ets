import {
	IBestButton,
	IBestCalendar,
	IBestCalendarConfirmResult,
	IBestCalendarDayItem,
	IBestCalendarDialog,
	IBestCell,
	IBestCellGroup
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
    @State selectDate: string = "请选择日期"
    @State multipleVisible: boolean = false
    @State multipleDateRange: string = "请选择日期"
    @State rangeVisible: boolean = false
    @State rangeDateRange: string = "请选择日期"
    @State customColorVisible: boolean = false
    @State customColorDate: string = "请选择日期"
    @State customRangeVisible: boolean = false
    @State customRangeDate: string = "请选择日期"
    @State lunarVisible: boolean = false
    @State lunarDate: string = "请选择日期"
    @State customWeekVisible: boolean = false
    @State customWeekDate: string = "请选择日期"
    @State rangeNumVisible: boolean = false
    @State rangeNumDate: string = "请选择日期"
    @State waterBgVisible: boolean = false
    @State waterBgDate: string = "请选择日期"

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

    onDialogConfirm(type: string, value: IBestCalendarConfirmResult[]): void {
        switch (type){
            case "selectDate":
                this.selectDate = value[0].dateStr
                break
            case "multipleDateRange":
                this.multipleDateRange = value.map(item => item.dateStr).join(",")
                break
            case "rangeDateRange":
                this.rangeDateRange = value[0].dateStr + " - " + value[value.length-1].dateStr
                break
            case "customColorDate":
                this.customColorDate = value.map(item => item.dateStr).join(",")
                break
            case "lunarDate":
                this.lunarDate = value[0].dateStr
                break
            case "customRangeDate":
                this.customRangeDate = value.map(item => item.dateStr).join(",")
                break
            case "rangeNumDate":
                this.rangeNumDate = value[0].dateStr + " - " + value[value.length-1].dateStr
                break
            case "customWeekDate":
                this.customWeekDate = value[0].dateStr
                break
            case "waterBgDate":
                this.waterBgDate = value[0].dateStr
                break
        }
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
                                    onCellClick: () => {
                                        this.singleVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '选择多个日期',
                                    value: this.multipleDateRange,
                                    onCellClick: () => {
                                        this.multipleVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '选择日期区间',
                                    hasBorder: false,
                                    value: this.rangeDateRange,
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
                                    value: this.customColorDate,
                                    onCellClick: () => {
                                        this.customColorVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '显示农历',
                                    value: this.lunarDate,
                                    onCellClick: () => {
                                        this.lunarVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '自定义日期范围',
                                    value: this.customRangeDate,
                                    onCellClick: () => {
                                        this.customRangeVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '日期区间最大范围',
                                    value: this.rangeNumDate,
                                    onCellClick: () => {
                                        this.rangeNumVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '自定义周起始日期',
                                    value: this.customWeekDate,
                                    onCellClick: () => {
                                        this.customWeekVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '显示月份背景水印',
                                    value: this.waterBgDate,
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
                            isShowLunar: true,
                            selectType: "multiple",
                            isShowMark: true,
                            defaultSelectedDate: this.defaultSelectedDate,
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
                                defaultSelectedDate: this.clockDate
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
                type: "danger",
                onConfirm: (value): void => this.onDialogConfirm("selectDate", value)
            })
            // 多选
            IBestCalendarDialog({
                visible: $multipleVisible,
                selectType: "multiple",
                onConfirm: (value): void => this.onDialogConfirm("multipleDateRange", value)
            })
            // 区间选
            IBestCalendarDialog({
                visible: $rangeVisible,
                selectType: "range",
                onConfirm: (value): void => this.onDialogConfirm("rangeDateRange", value)
            })
            // 自定义颜色
            IBestCalendarDialog({
                visible: $customColorVisible,
                selectType: "multiple",
                selectedColor: "#58DB6B",
                onConfirm: (value): void => this.onDialogConfirm("customColorDate", value)
            })
            // 显示农历
            IBestCalendarDialog({
                visible: $lunarVisible,
                isShowLunar: true,
                cornerRadius: 20,
                onConfirm: (value): void => this.onDialogConfirm("lunarDate", value)
            })
            // 自定义日期范围
            IBestCalendarDialog({
                visible: $customRangeVisible,
                selectType: "multiple",
                selectedStyleType: "circle",
                minDate: new Date('1991-01-01'),
                maxDate: new Date(),
                confirmBtnColor: "#ed4040",
                onConfirm: (value): void => this.onDialogConfirm("customRangeDate", value)
            })
            // 日期区间最大范围
            IBestCalendarDialog({
                visible: $rangeNumVisible,
                type: "danger",
                selectType: "range",
                maxRange: 7,
                onConfirm: (value): void => this.onDialogConfirm("rangeNumDate", value)
            })
            // 自定义周起始日期
            IBestCalendarDialog({
                visible: $customWeekVisible,
                weekFirstDay: 0,
                onConfirm: (value): void => this.onDialogConfirm("customWeekDate", value)
            })
            // 显示月份背景水印
            IBestCalendarDialog({
                visible: $waterBgVisible,
                isShowMark: true,
                onConfirm: (value): void => this.onDialogConfirm("waterBgDate", value)
            })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg)
    }
}