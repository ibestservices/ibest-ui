import { IBestWeekPicker, IBestToast, IBestPickerOption } from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import CustomNavBar from '../../components/CustomNavBar'
@Builder
export function WeekPickerBuilder(_: string, title: string) {
    WeekPickerPage({title})
}
@Entry
@Component
struct WeekPickerPage {
    @State title: string = ''
    @State selectValue: number = 2
    @State selectValue1: string = '5'
    @State options: IBestPickerOption[] = [
        { text: "星期一", value: '1' },
        { text: "星期二", value: '2' },
        { text: "星期三", value: '3' },
        { text: "星期四", value: '4' },
        { text: "星期五", value: '5' },
        { text: "星期六", value: '6' },
        { text: "星期日", value: '7' }
    ]

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }) {
                        IBestWeekPicker({
                            title: "选择周",
                            value: $selectValue,
                            onConfirm: (value, text) => {
                                IBestToast.show(value.toString() + " " + text)
                            },
                            onChange: (value, text) => {
                                IBestToast.show(value.toString() + " " + text)
                            }
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: "自定义选项" }) {
                        IBestWeekPicker({
                            title: "选择星期",
                            value: $selectValue1,
                            options: this.options,
                            onConfirm: (value, text) => {
                                IBestToast.show(value.toString() + " " + text)
                            },
                            onChange: (value, text) => {
                                IBestToast.show(value.toString() + " " + text)
                            }
                        })
                    }
                }
                ListItem().height(50)
            }
            .layoutWeight(1)
            .padding({left: SPACE.SM, right: SPACE.SM})
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg)
    }
}