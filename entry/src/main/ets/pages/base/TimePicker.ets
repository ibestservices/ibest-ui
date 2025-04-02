import { IBestPickerOption, IBestTimePicker, IBestToast } from '@ibestservices/ibest-ui'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import CustomNavBar from '../../components/CustomNavBar'
@Builder
export function TimePickerBuilder(_: string, title: string) {
	TimePickerPage({title})
}
@Entry
@Component
struct TimePickerPage {
    @State title: string = ''
    @State selectValue: string[] = ["10", "18", "18"]
    @State selectValue1: string[] = ["10", "18"]
    @State selectValue2: string[] = []
    @State selectValue3: string[] = ["10", "18", "18"]
    @State selectValue4: string[] = ["06", "18", "18"]
    filter(type: string, options: IBestPickerOption[]): IBestPickerOption[]{
        if (type === 'hour') {
            return options.filter((option) => Number(option.value) % 6 === 0)
        }
        return options
    }
    build() {
		NavDestination() {
			CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SM, card: true }) {
                        IBestTimePicker({
                            title: "选择时间",
                            value: $selectValue,
                            onConfirm: (value: string[]) => {
                                IBestToast.show(value.join(":"))
                            },
                            onChange: (value: string[]) => {
                                IBestToast.show(value.join(":"))
                            }
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: "选项类型", titlePaddingLeft: SPACE.SM, card: true }) {
                        IBestTimePicker({
                            title: "选择时分",
                            listType: ["hour", "minute"],
                            value: $selectValue1,
                            onConfirm: (value: string[]) => {
                                IBestToast.show(value.join(":"))
                            },
                            onChange: (value: string[]) => {
                                IBestToast.show(value.join(":"))
                            }
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '时间范围', titlePaddingLeft: SPACE.SM, card: true }) {
                        IBestTimePicker({
                            title: "选择时间",
                            minTime: "08:30:00",
                            maxTime: "18:00:00",
                            value: $selectValue2,
                            onConfirm: (value: string[]) => {
                                IBestToast.show(value.join(":"))
                            },
                            onChange: (value: string[]) => {
                                IBestToast.show(value.join(":"))
                            }
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: "显示单位", titlePaddingLeft: SPACE.SM, card: true }) {
                        IBestTimePicker({
                            title: "选择时间",
                            showUnit: true,
                            value: $selectValue3,
                            onConfirm: (value: string[]) => {
                                IBestToast.show(value.join(":"))
                            },
                            onChange: (value: string[]) => {
                                IBestToast.show(value.join(":"))
                            }
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: "过滤选项", titlePaddingLeft: SPACE.SM, card: true }) {
                        IBestTimePicker({
                            title: "选择时间",
                            filter: this.filter,
                            value: $selectValue4,
                            onConfirm: (value: string[]) => {
                                IBestToast.show(value.join(":"))
                            },
                            onChange: (value: string[]) => {
                                IBestToast.show(value.join(":"))
                            }
                        })
                    }
                }
				ListItem().height(50)
            }
            .layoutWeight(1)
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg)
    }
}