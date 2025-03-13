import {
    IBestButton,
    IBestCalendar,
    IBestCalendarConfirmResult,
    IBestCalendarDialog,
    IBestCell,
    IBestCellGroup,
    IBestNavBar,
    SelectType
} from '@ibestservices/ibest-ui'
import { router } from '@kit.ArkUI'
import promptAction from '@ohos.promptAction'
import { ComponentRouterParams } from '../../assets/global.type'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle'
import dayjs from '@hview/dayjs'
@Entry
@Component
struct CalendarPage {
    @State title: string = (router.getParams() as ComponentRouterParams).title || ''
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
    @State tileSelectType: SelectType = "multiple"

    @State clockDate: string[] = [dayjs().startOf("month").format('YYYY-MM-DD')]

    @State defaultSelectedDate: string[] = [dayjs().format('YYYY-MM-DD')]

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
        Column(){
            IBestNavBar({
                title: this.title,
                isShowStatusBar: true,
                onLeftClick: () => {
                    router.back()
                }
            })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.XS }) {
                        IBestCellGroup() {
                            Column() {
                                IBestCell({
                                    title: '选择单个日期',
                                    value: this.selectDate,
                                    onClickCell: () => {
                                        this.singleVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '选择多个日期',
                                    value: this.multipleDateRange,
                                    onClickCell: () => {
                                        this.multipleVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '选择日期区间',
                                    hasBorder: false,
                                    value: this.rangeDateRange,
                                    onClickCell: () => {
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
                                    onClickCell: () => {
                                        this.customColorVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '显示农历',
                                    value: this.lunarDate,
                                    onClickCell: () => {
                                        this.lunarVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '自定义日期范围',
                                    value: this.customRangeDate,
                                    onClickCell: () => {
                                        this.customRangeVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '日期区间最大范围',
                                    value: this.rangeNumDate,
                                    onClickCell: () => {
                                        this.rangeNumVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '自定义周起始日期',
                                    value: this.customWeekDate,
                                    onClickCell: () => {
                                        this.customWeekVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '显示月份背景水印',
                                    value: this.waterBgDate,
                                    hasBorder: false,
                                    onClickCell: () => {
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
                            weekFirstDay: 0,
                            selectType: this.tileSelectType,
                            selectedColor: "#ed4040",
                            isShowMark: true,
                            defaultSelectedDate: this.defaultSelectedDate,
                            onConfirm: value => {
                                let text = value.length > 1 && this.tileSelectType === "range" ? `${value[0].dateStr}
                                ~ ${value[value.length-1].dateStr}` : value.map(item => item.dateStr).join(",")
                                promptAction.showDialog({
                                    message: `当前日期${value.length > 1 && this.tileSelectType === "range" ? '区间' : ''}为：${text}`,
                                    alignment: DialogAlignment.Center
                                })
                            }
                        })
                    }
                }
                ListItem(){
                    ComponentShowContainer({ title: '打卡模式', titlePaddingLeft: SPACE.XS }) {
                        Column({space: SPACE.MD}){
                            IBestButton({
                                type: "primary",
                                text: "打卡",
                                onClickBtn: () => {
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
                minDate: new Date(),
                maxDate: new Date("2099-12-13"),
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
        .width(CONTAINER_SIZE.FULL)
        .height(CONTAINER_SIZE.FULL)
        .backgroundColor(modeColor.bg)
    }
}