import { IBestButton, IBestDialogUtil, IBestSegmented, IBestSegmentedItem, IBestSegmentedOption, IBestToast } from '@ibestservices/ibest-ui'
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
    @State options: string[] = []
    @State value1: string = "选项1"
    @State longOptions: string[] = ['选项1', '选项2', '选项3', '选项4', '选项5', '选项6', '选项7', '选项8', '选项9', '选项10']

    @State value2: string = "1"
    @State options1: IBestSegmentedItem[] = [
        new IBestSegmentedItem({ label: "选项1", value: "1", icon: "like-o" }),
        new IBestSegmentedItem({ label: "选项2", value: "2", icon: "star-o", disabled: true }),
        new IBestSegmentedItem({ label: "选项3", value: "3", icon: "fire-o", iconPosition: "right" })
    ]
    @State options2: IBestSegmentedOption[] = [
        new IBestSegmentedItem({ value: "1", icon: "like-o" }),
        new IBestSegmentedItem({ value: "2", icon: "star-o", disabled: true }),
        new IBestSegmentedItem({ value: "3", icon: "fire-o" })
    ]

    @State value3: string = '选项1'
    @State options3: string[] = ['选项1', '选项2', '选项3']

    @State value4: string = '选项1'
    @State options4: string[] = ['选项1', '选项2', '选项3']

    aboutToAppear() {
        setTimeout(() => {
            this.options = ['选项1', '选项2', '选项3', '选项4']
        }, 1000)
    }

    build() {
        NavDestination(){
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', space: SPACE.SM }) {
                        IBestSegmented({
                            value: $value,
                            options: this.options
                        })
                        IBestSegmented({
                            value: $value1,
                            options: this.longOptions,
                            widthType: 'auto'
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '胶囊形状', space: SPACE.SM }) {
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
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义数据', space: SPACE.SM }) {
                        IBestSegmented({
                            value: $value2,
                            options: this.options1
                        })
                        IBestSegmented({
                            value: $value2,
                            options: this.options2,
                            widthType: 'auto'
                        })
                        IBestButton({
                            type: 'primary',
                            text: "切换禁用",
                            onBtnClick: () => {
                                this.options1[1].disabled = !this.options1[1].disabled
                                this.options2[1].disabled = !this.options2[1].disabled
                            }
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '动态选项', space: SPACE.SM }) {
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