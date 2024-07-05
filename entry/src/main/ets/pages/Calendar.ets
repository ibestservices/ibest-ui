import {IBestCalendar} from "@ibestservices/ibest-ui"
import { ConfirmResultType } from '@ibestservices/ibest-ui/src/main/ets/components/calendar/index.type'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'
import TitleBar from '../components/TitleBar'

@Entry
@Component
struct CalendarPage {
    @State title: string = (router.getParams() as ComponentRouterParams).title || ''

    onConfirm(value: ConfirmResultType | ConfirmResultType[]): void {
        console.log("已选日期", JSON.stringify(value))
    }
    build() {
        Column(){
            TitleBar({
                title: this.title
            }).backgroundColor('#FFF')
            IBestCalendar({
                isShowLunar: true,
                weekFirstDay: "日",
                selectedStyleType: "normal",
                selectType: "range",
                selectedColor: "#ed4040",
                defaultSelectedDate: ["2024-07-01"],
                onConfirm: (value: ConfirmResultType | ConfirmResultType[]): void => this.onConfirm(value)
            })
        }
    }
}