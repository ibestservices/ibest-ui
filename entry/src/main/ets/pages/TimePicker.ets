import { IBestPickerOption, IBestTimePicker, IBestToast } from '@ibestservices/ibest-ui'
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
import { router } from '@kit.ArkUI'
import { ComponentRouterParams } from '../assets/global.type'

@Entry
@Component
struct TimerPickerPage {
    @State title: string = (router.getParams() as ComponentRouterParams).title || ''
    @State selectValue: string[] = ["10", "18", "18"]
    @State selectValue1: string[] = ["10", "18"]
    @State selectValue2: string[] = ["10", "18", "18"]
    @State selectValue3: string[] = ["10", "18", "18"]
    @State selectValue4: string[] = ["06", "18", "18"]
    filter(type: string, options: IBestPickerOption[]): IBestPickerOption[]{
        if (type === 'hour') {
            return options.filter((option) => Number(option.value) % 6 === 0)
        }
        return options
    }
    build() {
        Column() {
            TitleBar({
                title: this.title
            }).backgroundColor('#FFF')
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SMALL, card: true }) {
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
                    ComponentShowContainer({ title: "选项类型", titlePaddingLeft: SPACE.SMALL, card: true }) {
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
                    ComponentShowContainer({ title: '时间范围', titlePaddingLeft: SPACE.SMALL, card: true }) {
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
                    ComponentShowContainer({ title: "显示单位", titlePaddingLeft: SPACE.SMALL, card: true }) {
                        IBestTimePicker({
                            title: "选择时间",
                            minTime: "08:30:00",
                            maxTime: "18:00:00",
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
                    ComponentShowContainer({ title: "过滤选项", titlePaddingLeft: SPACE.SMALL, card: true }) {
                        IBestTimePicker({
                            title: "选择日期",
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
            }
        }
        .width(CONTAINER_SIZE.FULL)
        .height(CONTAINER_SIZE.FULL)
        .backgroundColor(BACKGROUND_COLOR.BASE)
    }
}