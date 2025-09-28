import {
    IBestButton,
    IBestDialogUtil, IBestRate, IBestSegmented, IBestSegmentedOption, IBestToast } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function SegmentedBuilder(_: string, title: string){
    SegmentedPage({title})
}

@Entry
@Component
struct SegmentedPage {
    @State title: string = ''
    @State value: string = "选项1"
    private options: string[] = ['选项1', '选项2', '选项3', '选项4']
    @State value1: string = "选项1"
    private longOptions: string[] = ['选项1', '选项2', '选项3', '选项4', '选项5', '选项6', '选项7', '选项8', '选项9', '选项10']

    @State value2: string = "1"
    private options1: IBestSegmentedOption[] = [
        { label: "选项1", value: "1", icon: "like-o" },
        { label: "选项2", value: "2", icon: "star-o", disabled: true },
        { label: "选项3", value: "3", icon: "fire-o", iconPosition: "right" }
    ]
    private options2: IBestSegmentedOption[] = [
        { value: "1", icon: "like-o" },
        { value: "2", icon: "star-o", disabled: true },
        { value: "3", icon: "fire-o" }
    ]

    @State value3: string = '选项1'
    @State options3: string[] = ['选项1', '选项2', '选项3']

    @State value4: string = '选项1'
    private options4: string[] = ['选项1', '选项2', '选项3']

    build() {
        NavDestination(){
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }) {
                        Column({space: SPACE.SM}){
                            IBestSegmented({
                                value: $value,
                                options: this.options
                            })
                            IBestSegmented({
                                value: $value1,
                                options: this.longOptions,
                                widthType: 'auto'
                            })
                        }.alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '胶囊形状' }) {
                        Column({space: SPACE.SM}){
                            IBestSegmented({
                                value: $value,
                                options: this.options,
                                round: true
                            })
                            IBestSegmented({
                                value: $value1,
                                options: this.longOptions,
                                widthType: 'auto',
                                round: true
                            })
                        }.alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义数据' }) {
                        Column({space: SPACE.SM}){
                            IBestSegmented({
                                value: $value2,
                                options: this.options1
                            })
                            IBestSegmented({
                                value: $value2,
                                options: this.options2,
                                widthType: 'auto'
                            })
                        }.alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '动态选项' }) {
                        Column({space: SPACE.SM}){
                            IBestSegmented({
                                value: $value3,
                                options: this.options3
                            })
                            IBestButton({
                                type: 'primary',
                                text: "切换选项",
                                onBtnClick: () => {
                                    this.options3 = this.options3.length == 3 ? ['选项1', '选项2', '选项3', '选项4'] : ['选项1', '选项2', '选项3']
                                }
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '事件监听' }) {
                        IBestSegmented({
                            value: $value,
                            options: this.options,
                            onChange: (value: string | number) => {
                                IBestToast.show(value.toString())
                            }
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '异步切换' }) {
                        IBestSegmented({
                            value: $value4,
                            options: this.options4,
                            beforeChange: (value: string | number) => {
                                return new Promise((resolve, reject) => {
                                    IBestDialogUtil.open({
                                        title: "提示",
                                        message: `点击选项为${value}, 确定要切换吗?`,
                                        showCancelButton: true,
                                        onConfirm: () => {
                                            resolve(true)
                                        },
                                        onCancel: () => {
                                            reject(false)
                                        }
                                    })
                                })
                            }
                        })
                    }
                }
                ListItem().height(50)
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg2)
    }
}