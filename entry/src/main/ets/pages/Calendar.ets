import {IBestCalendar, IBestCalendarDialog, IBestCell, IBestCellGroup} from "@ibestservices/ibest-ui"
import { ConfirmResultType } from '@ibestservices/ibest-ui/src/main/ets/components/calendar/index.type'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
@Entry
@Component
struct CalendarPage {
    @State title: string = (router.getParams() as ComponentRouterParams).title || ''
    @State singleVisible: boolean = false
    @State selectDate: string = ""
    @State multipleVisible: boolean = false
    @State multipleDateRange: string = ""
    @State rangeVisible: boolean = false
    @State rangeDateRange: string = ''
    onSingleConfirm(value: ConfirmResultType | ConfirmResultType[]): void {
        console.log("onConfirm", value)
        this.selectDate = (value as ConfirmResultType).dateStr
    }
    onMultipleConfirm(value: ConfirmResultType | ConfirmResultType[]): void {
        this.multipleDateRange = (value as  ConfirmResultType[]).map(item => item.dateStr).join(",")
    }
    onRangeConfirm(value: ConfirmResultType | ConfirmResultType[]): void {
        this.rangeDateRange = (value as  ConfirmResultType[])[0].dateStr + " - " + (value as  ConfirmResultType[])[1]
            .dateStr
    }
    build() {
        Column(){
            TitleBar({
                title: this.title
            }).backgroundColor('#FFF')
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SMALL }) {
                        IBestCellGroup() {
                            Column() {
                                IBestCell({
                                    title: '选择单个日期',
                                    value: this.selectDate || "请选择日期",
                                    onClickCell: () => {
                                        this.singleVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '选择多个日期',
                                    value: this.multipleDateRange || "请选择日期",
                                    onClickCell: () => {
                                        this.multipleVisible = true
                                    }
                                })
                                IBestCell({
                                    title: '选择日期区间',
                                    hasBorder: false,
                                    value: this.rangeDateRange || "请选择日期",
                                    onClickCell: () => {
                                        this.rangeVisible = true
                                    }
                                })
                            }
                        }
                    }
                }
            }
            .layoutWeight(1)
            // IBestCalendar({
            //     isShowLunar: true,
            //     weekFirstDay: "日",
            //     selectedStyleType: "normal",
            //     selectType: "range",
            //     selectedColor: "#ed4040",
            //     onConfirm: (value: ConfirmResultType | ConfirmResultType[]): void => this.onConfirm(value)
            // })
            // 弹框展示
            IBestCalendarDialog({
                visible: $singleVisible,
                onConfirm: (value): void => this.onSingleConfirm(value)
            })
            IBestCalendarDialog({
                visible: $multipleVisible,
                selectType: "multiple",
                type: "danger",
                selectedStyleType: "circle",
                onConfirm: (value): void => this.onMultipleConfirm(value)
            })
            IBestCalendarDialog({
                visible: $rangeVisible,
                selectType: "range",
                selectedColor: "#58DB6B",
                onConfirm: (value): void => this.onRangeConfirm(value)
            })
        }
       . width(CONTAINER_SIZE.FULL)
        .height(CONTAINER_SIZE.FULL)
        .backgroundColor(BACKGROUND_COLOR.BASE)
    }
}