import {
    IBestButton,
    IBestCellGroup,
    IBestField,
    IBestNavBar,
    IBestRadio,
    IBestRadioGroup,
    IBestToast
} from '@ibestservices/ibest-ui';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import { router } from '@kit.ArkUI';
import { ComponentRouterParams } from '../../assets/global.type';

@Entry
@Component
struct FieldPage {
    @State title: string = (router.getParams() as ComponentRouterParams).title || ''
    @State value: string = ''
    @State value1: string = ''
    @State value2: string = ''
    @State value3: string = ''
    @State value4: string = ''
    @State value5: string = '输入框只读'
    @State value6: string = '输入框已禁用'
    @State value7: string = ''
    @State value8: string = '一蓑烟雨任平生'
    @State value9: string = ''
    @State value10: string = ''
    @State count: number = 60
    @State timer: number = 0
    @State value11: string = ''
    @State value12: string = ''
    @State value13: string = ''
    @State value14: string = ''
    @State value15: string = ''
    @State value16: string = ''
    @State value17: string = ''
    @State value18: string = ''
    @State value19: string = ''
    @State value20: string = ''
    @State value21: string = ''
    @State value22: string = ''
    @State value23: string = ''
    @State value24: string = ''

    @Builder sendCodeButton() {
        IBestButton({
            text: this.count == 60 ? '发送验证码' : `重新发送(${this.count})`,
            type: 'primary',
            buttonSize: 'mini',
            onClickBtn: () => {
                this.sendCode()
            }
        })
    }
    @Builder radioContent() {
        IBestRadioGroup({
            active: $value22,
            group: 'group1',
            placeDirection: Axis.Horizontal
        }){
            IBestRadio({
                label: '单选框1',
                name: '1',
                group: 'group1'
            })
            IBestRadio({
                label: '单选框2',
                name: '2',
                group: 'group1'
            })
        }
    }

    sendCode() {
        if (this.count < 60) {
            return
        }
        this.count = 60
        this.timer = setInterval(() => {
            if (this.count > 0) {
                this.count--
            } else {
                clearInterval(this.timer)
                this.timer = 0
                this.count = 60
            }
        }, 1000)
    }
    formatValue(value: string){
        return value.replace(/\d/g, '')
    }
    build() {
        Column() {
            IBestNavBar({
                title: this.title,
                isShowStatusBar: true,
                onLeftClick: () => {
                    router.back()
                }
            })
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }) {
                        IBestField({
                            value: $value,
                            label: "文本",
                            placeholder: "请输入文本",
                            hasBorder: false
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义类型' }) {
                        // 密码
                        IBestField({
                            value: $value1,
                            label: "密码",
                            placeholder: "请输入密码",
                            type: "password"
                        })
                        // 手机号
                        IBestField({
                            value: $value2,
                            label: "手机号",
                            placeholder: "请输入手机号",
                            type: "phone"
                        })
                        // 整数数字
                        IBestField({
                            value: $value3,
                            label: "整数",
                            placeholder: "请输入整数",
                            type: "number"
                        })
                        // 范围
                        IBestField({
                            value: $value21,
                            label: "范围",
                            placeholder: "请输入整数, 最小5, 最大10",
                            type: "number",
                            min: 5,
                            max: 10
                        })
                        // 小数
                        IBestField({
                            value: $value4,
                            label: "小数",
                            hasBorder: false,
                            placeholder: "请输入小数",
                            type: "decimal",
                            decimalLength: 2
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '禁用输入框' }) {
                        IBestField({
                            value: $value5,
                            label: "文本",
                            readOnly: true
                        })
                        IBestField({
                            value: $value6,
                            label: "文本",
                            hasBorder: false,
                            disabled: true
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '前后缀' }) {
                        IBestField({
                            value: $value23,
                            label: "网址",
                            prefix: "https://",
                            suffix: ".com",
                            hasBorder: false
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '显示图标' }) {
                        IBestField({
                            value: $value7,
                            label: "文本",
                            placeholder: "请输入文本",
                            leftIcon: "https://ibestui.ibestservices.com/favicon.ico",
                            rightIcon: $r("app.media.arrow_right")
                        })
                        IBestField({
                            value: $value8,
                            label: "文本",
                            placeholder: "请输入文本",
                            hasBorder: false,
                            clearable: true
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '点击反馈' }) {
                        IBestField({
                            value: $value9,
                            label: "地区",
                            placeholder: "点击选择地区",
                            hasBorder: false,
                            isLink: true,
                            onFieldClick: () => {
                                IBestToast.show("点击")
                            }
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '必填星号' }) {
                        IBestField({
                            value: $value10,
                            label: "文本",
                            placeholder: "请输入文本",
                            hasBorder: false,
                            radius: 6,
                            required: true
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '插入按钮' }) {
                        IBestField({
                            value: $value11,
                            label: "短信验证码",
                            placeholder: "请输入验证码",
                            hasBorder: false,
                            buttonBuilder: (): void => this.sendCodeButton()
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '格式化输入内容' }) {
                        IBestField({
                            value: $value12,
                            label: "文本",
                            placeholder: "在输入时执行格式化",
                            formatter: (value: string): string => this.formatValue(value)
                        })
                        IBestField({
                            value: $value13,
                            label: "文本",
                            placeholder: "在失焦时执行格式化",
                            hasBorder: false,
                            formatter: (value: string): string => this.formatValue(value),
                            formatTrigger: "onblur"
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '高度自适应' }) {
                        IBestField({
                            value: $value14,
                            label: "留言",
                            placeholder: "请输入留言",
                            hasBorder: false,
                            autosize: true,
                            rows: 3
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '显示字数统计' }) {
                        IBestField({
                            value: $value15,
                            label: "文本",
                            placeholder: "请输入文本",
                            maxlength: 30,
                            clearable: true,
                            showWordLimit: true
                        })
                        IBestField({
                            value: $value16,
                            label: "文本",
                            placeholder: "请输入文本",
                            hasBorder: false,
                            autosize: true,
                            rows: 3,
                            clearable: true,
                            maxlength: 100,
                            showWordLimit: true
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '输入框内容对齐' }) {
                        IBestField({
                            value: $value17,
                            label: "文本",
                            placeholder: "输入框内容右对齐",
                            hasBorder: false,
                            inputAlign: "right"
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '输入框文本位置' }) {
                        IBestField({
                            value: $value18,
                            label: "文本",
                            placeholder: "顶部对齐",
                            labelPosition: "top"
                        })
                        IBestField({
                            value: $value18,
                            label: "文本",
                            placeholder: "左对齐",
                            labelAlign: "left"
                        })
                        IBestField({
                            value: $value19,
                            label: "文本",
                            placeholder: "居中对齐",
                            labelAlign: "center"
                        })
                        IBestField({
                            value: $value20,
                            label: "文本",
                            placeholder: "右对齐",
                            labelAlign: "right",
                            hasBorder: false
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义右侧区域内容' }) {
                        IBestField({
                            value: $value22,
                            label: "文本",
                            hasBorder: false,
                            customRightContent: (): void => this.radioContent()
                        })
                    }
                }
            }
            .layoutWeight(1)
            .padding({left: SPACE.SM, right: SPACE.SM})
        }
        .width(CONTAINER_SIZE.FULL)
        .height(CONTAINER_SIZE.FULL)
        .backgroundColor(modeColor.bg)
    }
}