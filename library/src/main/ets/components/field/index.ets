import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { colorData } from '../../theme-chalk/src/color'
import { GRAY_COLOR } from '../../theme-chalk/src/color.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { FieldValidateResult, FORM_EVENT_NAME, getFormEventName, IBestFormRuleItem } from '../form/index.type'
import type { IBestFieldType, ClearTriggerType, FieldTextAlign, IBestFieldValueType } from './index.type'
import { emitter } from '../../assets/ets/EventEmitter'
import { runRuleValidator, runSyncRule } from './utils'
@Component
export struct IBestField{
    /*
     * form id 用于验证
     */
    @Prop formId: string = ""
    /*
     * 表单绑定属性名
     */
    @Prop prop: string = ""
    /*
     * 验证规则
     */
    rules: IBestFormRuleItem[] = []
    /*
     * 组件绑定的值
     */
    @Link @Watch("valueChange") value: IBestFieldValueType
    /*
     * 文本内容
     */
    @Provide label: string = ""
    /*
     * 是否在label后加冒号
     */
    @Provide colon: boolean = false
    /*
     * 文本宽度
     */
    @Provide labelWidth: number = 160
    /*
     * 文本位置
     */
    @Provide labelPosition: 'left' | 'top' = "left"
    /*
     * 文本对齐方式
     */
    @Provide labelAlign: FieldTextAlign = "left"
    /*
     * 输入框占位提示文字
     */
    @Provide placeholder: string = ""
    /*
     * 输入框类型
     */
    @Provide type: IBestFieldType = "normal"
    /*
     * 输入框自适应高度
     */
    @Provide autosize: boolean = false
    /*
     * 自适应高度时默认行数
     */
    @Provide rows: number = 1
    /*
     * 最大输入字符数
     */
    @Provide maxlength: number = -1
    /*
     * 是否显示字数统计
     */
    @Provide showWordLimit: boolean = false
    /*
     * 输入框文字对齐方式
     */
    @Provide inputAlign: FieldTextAlign = "left"
    /*
     * 是否必填
     */
    @Provide required: boolean = false
    /*
     * 是否禁用
     */
    @Provide disabled: boolean = false
    /*
     * 是否只读
     */
    @Provide readOnly: boolean = false
    /*
     * 是否开启点击反馈
     */
    @Provide clickable: boolean = false
    /*
     * 是否展示右侧箭头并开启点击反馈
     */
    @Provide isLink: boolean = false
    /*
     * 左侧图标
     */
    @Provide leftIcon: string | Resource = ""
    /*
     * 左侧图标颜色
     */
    @Provide leftIconColor: string = ""
    /*
     * 右侧图标
     */
    @Provide rightIcon: string | Resource = ""
    /*
     * 右侧图标颜色
     */
    @Provide rightIconColor: string = GRAY_COLOR.GRAY_6
    /*
     * 底部线条
     */
    @Provide hasBorder: boolean = true
    /*
     * 是否启用清除图标，点击清除图标后会清空输入框
     */
    @Provide clearable: boolean = false
    /*
     * 自定义清除图标
     */
    @Provide clearIcon: string | Resource = ""
    /*
     * 显示清除图标的时机
     */
    @Provide clearTrigger: ClearTriggerType = 'focus'
    /*
     * 验证状态
     */
    @Provide status: 'passed' | 'failed' | 'unvalidated' = 'unvalidated'
    /*
     * 验证信息
     */
    @Provide validateMessage: string = ""
    /*
     * 右侧按钮builder
     */
    @BuilderParam buttonBuilder: (() => void) | null
    /*
     * 自定义右侧内容
     */
    @BuilderParam customRightContent: (() => void) | null
    /*
     * 执行格式化函数触发时机
     */
    @Provide formatTrigger: 'onChange' | 'onBlur' = 'onChange'
    /*
     * 格式化函数
     */
    formatter: (value: string) => string = (value: string) => value
    /*
     * value变化回调函数
     */
    onChange: (value: IBestFieldValueType) => void = () => {}
    /*
     * 点击清除按钮时触发
     */
    onClear: () => void = () => {}
    /*
     * 点击组件触发
     */
    onFieldClick: () => void = () => {}
    /*
     * 输入框获得焦点时触发
     */
    onFieldFocus: () => void = () => {}
    /*
     * 输入框失去焦点时触发
     */
    onFieldBlur: () => void = () => {}
    /*
     * 左侧图标点击时触发
     */
    onLeftIconClick: () => void = () => {}
    /*
     * 右侧图标点击时触发
     */
    onRightIconClick: () => void = () => {}

    onDidBuild(): void {
        if(this.formId && this.prop){
            emitter.emit(getFormEventName(this.formId, FORM_EVENT_NAME.SEND_FIELD), {
                prop: this.prop,
                validate: (rules: IBestFormRuleItem[]):Promise<void | FieldValidateResult> => this.validate(rules),
                getValue: (): IBestFieldValueType => this.value,
                resetValidation: (): void => this.resetValidation()
            }, (rules: IBestFormRuleItem[]): void => this.saveRule(rules))
        }
    }
    aboutToDisappear(): void {
        if(this.formId && this.prop) {
            emitter.off(getFormEventName(this.formId, FORM_EVENT_NAME.VALIDATE_FIELD), () => {})
            emitter.off(getFormEventName(this.formId, FORM_EVENT_NAME.RESET_VALIDATE), () => {})
        }
    }
    // 保存规则,并展示必填星号
    saveRule(rules: IBestFormRuleItem[]){
        this.rules = this.rules.length ? this.rules : rules
        this.required = this.rules.some((item: IBestFormRuleItem) => item.required)
    }
    // 重置验证
    resetValidation(){
        this.status = 'unvalidated'
        this.validateMessage = ""
    }
    // 验证
    validate(rules: IBestFormRuleItem[]): Promise<FieldValidateResult | void> {
        return new Promise<FieldValidateResult | void>((resolve) => {
            this.resetValidation()
            if (rules) {
                let value = this.value
                this.runRules(value, rules).then(() => {
                    if (this.status === 'failed') {
                        resolve({
                            name: this.prop,
                            message: this.validateMessage
                        })
                    } else {
                        this.status = 'passed'
                        resolve()
                    }
                })
            } else {
                resolve()
            }
        })
    }
    // 执行规则
    async runRules(value: IBestFieldValueType, rules: IBestFormRuleItem[]){
        for (let rule of rules) {
            if (!runSyncRule(value, rule)) {
                this.status = 'failed'
                this.validateMessage = rule.message || ''
                return
            }
            if (rule.validator) {
                await runRuleValidator(value, rule).then(result => {
                    if (result && typeof result === 'string') {
                        this.status = 'failed'
                        this.validateMessage = result
                        return
                    } else if (result === false) {
                        this.status = 'failed'
                        this.validateMessage = rule.message || ""
                        return
                    }
                })
            }
        }
    }
    // 通过trigger 判断rules中是否有可触发项
    getFilteredRule(trigger: 'blur' | 'change') {
        return this.rules.filter((rule) => {
            if (!rule.trigger) return true
            return rule.trigger === trigger
        })
    }
    // value  change变化 执行验证
    valueChange(){
        this.sendValidate("change")
    }
    // 失焦执行
    handleBlur(){
        this.onFieldBlur()
        this.sendValidate("blur")
    }
    // 发送单个验证
    sendValidate(trigger: 'blur' | 'change'){
        if(this.formId && this.prop){
            let rules: IBestFormRuleItem[] = this.getFilteredRule(trigger)
            if(rules.length) {
                emitter.emit(getFormEventName(this.formId, FORM_EVENT_NAME.VALIDATE_FIELD), this.prop, (valid: boolean,
                    field: FieldValidateResult): void => this.handleValidateFieldCallBack(valid, field))
            }
        }
    }
    // 处理验证结果
    handleValidateFieldCallBack(valid: boolean,res: FieldValidateResult){
        // console.log("handleValidateFieldCallBack", valid, JSON.stringify(res), this.prop, this.value)
    }

    build() {
        if(this.labelPosition == "left"){
            Row(){
                Row(){
                    Label()
                    Content({
                        value: $value,
                        buttonBuilder: this.buttonBuilder,
                        customRightContent: this.customRightContent,
                        formatter: (value: string): string => this.formatter(value),
                        onChange: (value: IBestFieldValueType): void => this.onChange(value),
                        onClear: (): void => this.onClear(),
                        onFieldClick: (): void => this.onFieldClick(),
                        onFieldFocus: (): void => this.onFieldFocus(),
                        onFieldBlur: (): void => this.handleBlur(),
                        onRightIconClick: (): void => this.onRightIconClick()
                    })
                }
                .padding({ top: '20lpx', bottom: '20lpx' })
                .alignItems((this.showWordLimit || this.autosize || this.validateMessage) ? VerticalAlign.Top : VerticalAlign.Center)
                .border({
                    width: { bottom: this.hasBorder ? '2lpx' : 0 },
                    color: GRAY_COLOR.GRAY_3
                })
                .opacity(this.disabled ? 0.5 : 1)
            }
            .width(CONTAINER_SIZE.FULL)
            .backgroundColor('#fff')
            .padding({ left: '32lpx', right: '32lpx' })
            .stateStyles({
                normal: {
                    .backgroundColor('#fff')
                },
                pressed: {
                    .backgroundColor((this.clickable || this.isLink) ? '#f2f3f5' : '#fff')
                }
            })
            .onClick(() => {
                this.onFieldClick()
            })
        }else{
            Column(){
                Column(){
                    Label()
                    Content({
                        value: $value,
                        buttonBuilder: this.buttonBuilder,
                        customRightContent: this.customRightContent,
                        formatter: (value: string): string => this.formatter(value),
                        onChange: (value: IBestFieldValueType): void => this.onChange(value),
                        onClear: (): void => this.onClear(),
                        onFieldClick: (): void => this.onFieldClick(),
                        onFieldFocus: (): void => this.onFieldFocus(),
                        onFieldBlur: (): void => this.onFieldBlur(),
                        onRightIconClick: (): void => this.onRightIconClick()
                    })
                }
                .padding({ top: '20lpx', bottom: '20lpx' })
                .alignItems(HorizontalAlign.Start)
                .border({
                    width: { bottom: this.hasBorder ? '2lpx' : 0 },
                    color: GRAY_COLOR.GRAY_3
                })
                .opacity(this.disabled ? 0.5 : 1)
            }
            .width(CONTAINER_SIZE.FULL)
            .alignItems(HorizontalAlign.Start)
            .backgroundColor('#fff')
            .padding({ left: '32lpx', right: '32lpx' })
            .stateStyles({
                normal: {
                    .backgroundColor('#fff')
                },
                pressed: {
                    .backgroundColor((this.clickable || this.isLink) ? '#f2f3f5' : '#fff')
                }
            })
            .onClick(() => {
                this.onFieldClick()
            })
        }
    }
}

@Component
struct Label{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
    @Consume label: string
    @Consume colon: string
    @Consume labelPosition: 'left' | 'top'
    @Consume labelAlign: FieldTextAlign
    @Consume labelWidth: number
    @Consume autosize: boolean
    @Consume required: boolean
    @Consume leftIcon: string | Resource
    @Consume leftIconColor: string
    onLeftIconClick: () => void = () => {}
    build() {
        Row(){
            if(this.leftIcon){
                Image(this.leftIcon)
                    .width("28lpx")
                    .fillColor(this.leftIconColor)
                    .aspectRatio(1)
                    .margin({right: "8lpx"})
                    .onClick(() => {
                        this.onLeftIconClick()
                    })
            }
            if(this.required){
                Text("*")
                    .margin({
                        right: this.baseStyle.spaceMini
                    })
                    .fontSize(this.baseStyle.fontSizeSm)
                    .fontColor(this.baseStyle.danger)
            }
            Text(this.label + (this.colon ? ":" : ""))
                .fontSize("28lpx")
                .layoutWeight(1)
                .constraintSize({ minHeight: "40lpx" })
                .lineHeight("40lpx")
                .textAlign(this.labelAlign == "left" ? TextAlign.Start : this.labelAlign == "center" ? TextAlign.Center : TextAlign.End)
        }
        .width(this.labelPosition == "left" ? `${this.labelWidth}lpx` : CONTAINER_SIZE.FULL)
        .margin({right: "24lpx"})
        .alignItems(VerticalAlign.Center)
    }
}


@Component
struct Content{
    @Link value: IBestFieldValueType
    @State isFocus: boolean = false
    @Consume type: IBestFieldType
    @Consume autosize: boolean
    @Consume labelPosition: 'left' | 'top'
    @Consume rows: number
    @Consume maxlength: number
    @Consume showWordLimit: boolean
    @Consume inputAlign: FieldTextAlign
    @Consume rightIcon: string | Resource
    @Consume rightIconColor: string
    @Consume placeholder: string
    @Consume disabled: boolean
    @Consume readOnly: boolean
    @Consume clearable: boolean
    @Consume clickable: boolean
    @Consume isLink: boolean
    @Consume clearIcon: string | Resource
    @Consume clearTrigger: ClearTriggerType
    @Consume validateMessage: string
    @BuilderParam buttonBuilder: (() => void) | null
    @BuilderParam customRightContent: (() => void) | null
    @Consume formatTrigger: 'onChange' | 'onBlur'
    formatter: (value: string) => string = (value: string) => value
    onChange: (value: IBestFieldValueType) => void = () => {}
    onClear: () => void = () => {}
    onFieldClick: () => void = () => {}
    onFieldFocus: () => void = () => {}
    onFieldBlur: () => void = () => {}
    onRightIconClick: () => void = () => {}

    @Styles inputStyle(){
        .layoutWeight(1)
        .padding(0)
        .borderRadius(0)
        .backgroundColor("transparent")
        .enabled(!(this.disabled || this.readOnly))
        .onClick(() => {
            this.onFieldClick()
        })
    }
    // 获取输入框类型
    getInputType(): InputType{
        switch(this.type){
            case "normal":
                return InputType.Normal
            case "password":
                return InputType.NEW_PASSWORD
            case "email":
                return InputType.Email
            case "number":
                return InputType.Number
            case "phone":
                return InputType.PhoneNumber
            case "username":
                return InputType.USER_NAME
            case "number-password":
                return InputType.NUMBER_PASSWORD
            case "decimal":
                return InputType.NUMBER_DECIMAL
        }
    }
    build() {
        Column(){
            Row() {
                if (this.customRightContent) {
                    this.customRightContent()
                } else {
                    if (this.autosize) {
                        TextArea({ text: $$this.value, placeholder: this.placeholder })
                            .inputStyle()
                            .constraintSize({ minHeight: `${this.rows * 40}lpx` })
                            .lineHeight("40lpx")
                            .maxLength(this.maxlength)
                            // .showCounter(this.showWordLimit, {
                            //     thresholdPercentage: 1,
                            //     highlightBorder: false
                            // })
                            .enableAutoFill(false)
                            .onChange((value: string) => {
                                if (this.formatTrigger == 'onChange') {
                                    this.value = this.formatter(value)
                                }
                                this.onChange(this.value)
                            })
                            .onFocus(() => {
                                this.isFocus = true
                                this.onFieldFocus()
                            })
                            .onBlur(() => {
                                this.isFocus = false
                                this.onFieldBlur()
                                if (this.formatTrigger == 'onBlur' && typeof this.value == "string") {
                                    this.value = this.formatter(this.value)
                                }
                            })
                    } else {
                        TextInput({ text: $$this.value, placeholder: this.placeholder })
                            .inputStyle()
                            .height("40lpx")
                            .lineHeight("40lpx")
                            .textAlign(this.inputAlign == 'center' ? TextAlign.Center :
                                this.inputAlign == 'right' ? TextAlign.End : TextAlign.Start)
                            .maxLength(this.maxlength)
                            // .showCounter(this.showWordLimit, {
                            //     thresholdPercentage: 1,
                            //     highlightBorder: false
                            // })
                            .selectionMenuHidden(true)
                            .enableAutoFill(false)
                            .type(this.getInputType())
                            .onChange((value: string) => {
                                if (this.formatTrigger == 'onChange') {
                                    this.value = this.formatter(value)
                                }
                                this.onChange(this.value)
                            })
                            .onFocus(() => {
                                this.isFocus = true
                                this.onFieldFocus()
                            })
                            .onBlur(() => {
                                this.isFocus = false
                                this.onFieldBlur()
                                if (this.formatTrigger == 'onBlur' && typeof this.value == "string") {
                                    this.value = this.formatter(this.value)
                                }
                            })
                    }
                    // 清除图标
                    if (this.clearable && this.value && (this.clearTrigger == 'always' || this.isFocus)) {
                        Image($r("app.media.icon_clear"))
                            .width("40lpx")
                            .aspectRatio(1)
                            .margin({ left: "8lpx" })
                            .onClick(() => {
                                this.value = ''
                                this.onClear()
                            })
                    }
                }
                // 按钮
                if(this.buttonBuilder){
                    this.buttonBuilder()
                }
                // 右侧图标
                if(this.rightIcon){
                    Image(this.rightIcon)
                        .width("28lpx")
                        .aspectRatio(1)
                        .fillColor(this.rightIconColor)
                        .margin({left: "8lpx"})
                        .onClick(() => {
                            this.onRightIconClick()
                        })
                }
                // link箭头
                if(this.isLink){
                    Image($r("app.media.arrow_right"))
                        .width("28lpx")
                        .aspectRatio(1)
                        .fillColor(this.rightIconColor)
                        .margin({left: "8lpx"})
                }
            }
            .width(CONTAINER_SIZE.FULL)
            // 限制字数, 官方的showCounter属性在TextInput上正常, 在TextArea上有问题,输入文字后才会显示下面字数
            if(typeof this.value == "string" && this.maxlength && this.showWordLimit){
                Text(this.value.length + "/" + this.maxlength)
                    .width(CONTAINER_SIZE.FULL)
                    .textAlign(TextAlign.End)
                    .fontSize("20lpx")
                    .fontColor(GRAY_COLOR.GRAY_5)
                    .margin({top: "8lpx"})
            }
            // 验证信息
            if(this.validateMessage){
                Text(this.validateMessage)
                    .fontSize("24lpx")
                    .fontColor(colorData.danger)
            }
        }
        .width(this.labelPosition == "top" ? CONTAINER_SIZE.FULL : "auto")
        .layoutWeight(this.labelPosition == "top" ? 0 : 1)
        .alignItems(HorizontalAlign.Start)
    }
}