import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { colorData } from '../../theme-chalk/src/color'
import { GRAY_COLOR } from '../../theme-chalk/src/color.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { FieldValidateResult, FORM_EVENT_NAME, getFormEventName, IBestFormRuleItem,
    IBestFormSendFieldCallResult } from '../form/index.type'
import type { IBestFieldType, ClearTriggerType, FieldTextAlign, IBestFieldValueType,
    RequireAsteriskPositionType,
    LabelPositionType,
    FormatTriggerType} from './index.type'
import { emitter } from '../../assets/ets/EventEmitter'
import { runRuleValidator, runSyncRule } from './utils'

@Component
export struct IBestField{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
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
    @Provide colon?: boolean = undefined
    /*
     * 文本宽度
     */
    @Provide labelWidth: number = 0
    /*
     * 文本位置
     */
    @Provide labelPosition: LabelPositionType = ''
    /*
     * 文本对齐方式
     */
    @Provide labelAlign: FieldTextAlign = ''
    /*
     * 输入框占位提示文字
     */
    @Provide placeholder: string = ""
    /*
     * 输入框类型
     */
    @Provide type: IBestFieldType = "normal"
    /*
     * 小数点位数
     */
    @Provide decimalLength: number = -1
    /*
     * 是否显示密码框末尾图标
     */
    @Provide showPasswordIcon: boolean = true
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
     * 是否必填, 仅控制*显隐
     */
    @Provide required?: boolean = undefined
    /*
     * 星号的位置
     */
    @Provide requireAsteriskPosition: RequireAsteriskPositionType = ''
    /*
     * 是否禁用
     */
    @Provide disabled?: boolean = undefined
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
     * 是否显示验证信息
     */
    @Provide showMessage?: boolean = undefined
    /*
     * 验证信息
     */
    @Provide validateMessage: string = ""
    /*
     * 右侧按钮builder
     */
    @BuilderParam buttonBuilder?: () => void
    /*
     * 自定义右侧内容
     */
    @BuilderParam customRightContent?: () => void
    /*
     * 执行格式化函数触发时机
     */
    @Provide formatTrigger: FormatTriggerType = 'onchange'
    /*
     * 格式化函数
     */
    formatter?: ((value: string) => string) | undefined
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

    @Styles fieldStyles(){
        .width(CONTAINER_SIZE.FULL)
        .backgroundColor(this.baseStyle.default)
        .padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
        .stateStyles({
            normal: {
                .backgroundColor(this.baseStyle.default)
            },
            pressed: {
                .backgroundColor((this.clickable || this.isLink) ? GRAY_COLOR.GRAY_2 : this.baseStyle.default)
            }
        })
        .enabled(!this.disabled)
        .opacity(this.disabled ? 0.6 : 1)
        .onClick(() => {
            this.onFieldClick()
        })
    }
    @Styles fieldContentStyles(){
        .padding({ top: '20lpx', bottom: '20lpx' })
        .border({
            width: { bottom: this.hasBorder ? '2lpx' : 0 },
            color: GRAY_COLOR.GRAY_3
        })
    }

    aboutToAppear(): void {
        if(this.formId && this.prop){
            emitter.emit(getFormEventName(this.formId, FORM_EVENT_NAME.SEND_FIELD), {
                prop: this.prop,
                validate: (rules: IBestFormRuleItem[]):Promise<void | FieldValidateResult> => this.validate(rules),
                getValue: (): IBestFieldValueType => this.value,
                resetValidation: (): void => this.resetValidation()
            }, (result: IBestFormSendFieldCallResult): void => this.init(result))
        }else{
            this.init()
        }
    }
    aboutToDisappear(): void {
        if(this.formId && this.prop) {
            emitter.off(getFormEventName(this.formId, FORM_EVENT_NAME.VALIDATE_FIELD), () => {})
        }
    }
    // 初始化参数
    init(results?: IBestFormSendFieldCallResult){
        this.rules = this.rules.length ? this.rules : (results?.rules || [])
        this.required = typeof this.required != "undefined" ? this.required : this.rules.length > 0 && this.rules.some((item: IBestFormRuleItem) => item.required)
        this.labelWidth = this.labelWidth || results?.labelWidth || 160
        this.labelPosition = this.labelPosition || results?.labelPosition || 'left'
        this.labelAlign = this.labelAlign || results?.labelAlign || 'left'
        this.colon = typeof this.colon != "undefined" ? this.colon : results ? results.colon : false
        this.requireAsteriskPosition = this.requireAsteriskPosition || results?.requireAsteriskPosition || 'left'
        this.showMessage = typeof this.showMessage != "undefined" ? this.showMessage : results ? results.showMessage : true
        this.disabled = typeof this.disabled != "undefined" ? this.disabled : results ? results.disabled : false
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
            rules = rules || this.rules
            if (rules.length) {
                let value = this.value
                this.runRules(value, rules).then(() => {
                    if (this.status === 'failed') {
                        resolve({
                            label: this.label,
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
            if (rule.validator && typeof value === 'string') {
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
                        formatter: this.formatter,
                        onChange: (value: IBestFieldValueType): void => this.onChange(value),
                        onClear: (): void => this.onClear(),
                        onFieldClick: (): void => this.onFieldClick(),
                        onFieldFocus: (): void => this.onFieldFocus(),
                        onFieldBlur: (): void => this.handleBlur(),
                        onRightIconClick: (): void => this.onRightIconClick()
                    })
                }
                .alignItems((this.showWordLimit || this.autosize || this.validateMessage) ? VerticalAlign.Top : VerticalAlign.Center)
                .fieldContentStyles()
            }
            .fieldStyles()
        }else{
            Column(){
                Column(){
                    Label()
                    Content({
                        value: $value,
                        buttonBuilder: this.buttonBuilder,
                        customRightContent: this.customRightContent,
                        formatter: this.formatter,
                        onChange: (value: IBestFieldValueType): void => this.onChange(value),
                        onClear: (): void => this.onClear(),
                        onFieldClick: (): void => this.onFieldClick(),
                        onFieldFocus: (): void => this.onFieldFocus(),
                        onFieldBlur: (): void => this.onFieldBlur(),
                        onRightIconClick: (): void => this.onRightIconClick()
                    })
                }
                .alignItems(HorizontalAlign.Start)
                .fieldContentStyles()
            }
            .alignItems(HorizontalAlign.Start)
            .fieldStyles()
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
    @Consume requireAsteriskPosition: string
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
                    .margin({right: this.baseStyle.spaceBase})
                    .onClick(() => {
                        this.onLeftIconClick()
                    })
            }
            if(this.requireAsteriskPosition == "left"){
                Asterisk()
            }
            Text(this.label + (this.colon ? ":" : ""))
                .fontSize(this.baseStyle.fontSizeMd)
                .layoutWeight(1)
                .constraintSize({ minHeight: "40lpx" })
                .lineHeight(this.baseStyle.lineHeightMd)
                .textAlign(this.labelAlign == "left" ? TextAlign.Start : this.labelAlign == "center" ? TextAlign.Center : TextAlign.End)
            if(this.requireAsteriskPosition == "right"){
                Asterisk()
            }
        }
        .width(this.labelPosition == "left" ? `${this.labelWidth}lpx` : CONTAINER_SIZE.FULL)
        .margin({right: this.baseStyle.spaceSm})
        .alignItems(VerticalAlign.Center)
    }
}

@Component
struct Asterisk{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
    @Consume required: boolean
    @Consume requireAsteriskPosition: string
    build() {
        Text("*")
            .margin({
                left: this.requireAsteriskPosition == "right" ? this.baseStyle.spaceMini : 0,
                right: this.requireAsteriskPosition == "left" ? this.baseStyle.spaceMini : 0
            })
            .fontSize(this.baseStyle.fontSizeSm)
            .fontColor(this.baseStyle.danger)
            .visibility(this.required ? Visibility.Visible : Visibility.None)
    }
}

@Component
struct Content{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
    @Link value: IBestFieldValueType
    @State isFocus: boolean = false
    @Consume type: IBestFieldType
    @Consume decimalLength: number
    @Consume showPasswordIcon: boolean
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
    @Consume isLink: boolean
    @Consume clearIcon: string | Resource
    @Consume clearTrigger: ClearTriggerType
    @Consume showMessage: boolean
    @Consume validateMessage: string
    @BuilderParam buttonBuilder?: () => void
    @BuilderParam customRightContent?: () => void
    @Consume formatTrigger: FormatTriggerType
    formatter?: (value: string) => string
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
        .focusable(!(this.disabled || this.readOnly || this.isLink))
        .onClick(() => {
            this.onFieldClick()
        })
    }
    // 获取输入框类型
    getInputType(): InputType{
        switch(this.type){
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
            default:
                return InputType.Normal
        }
    }
    // 获取textarea类型
    getTextAreaType(): TextAreaType{
        switch(this.type){
            case "number":
                return TextAreaType.NUMBER
            case "phone":
                return TextAreaType.PHONE_NUMBER
            case "email":
                return TextAreaType.EMAIL
            case "decimal":
                return TextAreaType.NUMBER_DECIMAL
            default:
                return TextAreaType.NORMAL
        }
    }
    // 格式化值
    formatValue(value: string, trigger: string) {
        if (this.formatter && this.formatTrigger == trigger) {
            this.value = this.formatter(value)
        }
        if(this.type == "decimal" && this.decimalLength > 0){
            let index = value.indexOf(".")
            if(index > -1){
                let decimal = value.substring(index + 1)
                if(decimal.length > this.decimalLength){
                    this.value = Number(value).toFixed(this.decimalLength)
                }
            }
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
                            .fontSize(this.baseStyle.fontSizeMd)
                            .placeholderFont({
                                size: this.baseStyle.fontSizeMd
                            })
                            .constraintSize({ minHeight: `${this.rows * 40}lpx` })
                            .lineHeight(this.baseStyle.lineHeightMd)
                            .maxLength(this.maxlength)
                            // .showCounter(this.showWordLimit, {
                            //     thresholdPercentage: 1,
                            //     highlightBorder: false
                            // })
                            .enableAutoFill(false)
                            .type(this.getTextAreaType())
                            .onChange((value: string) => {
                                this.formatValue(value, "onchange")
                                this.onChange(this.value)
                            })
                            .onFocus(() => {
                                this.isFocus = true
                                this.onFieldFocus()
                            })
                            .onBlur(() => {
                                this.isFocus = false
                                this.onFieldBlur()
                                if (this.formatTrigger == 'onblur' && typeof this.value == "string") {
                                    this.formatValue(this.value, "onblur")
                                }
                            })
                    } else {
                        TextInput({ text: $$this.value, placeholder: this.placeholder })
                            .inputStyle()
                            .fontSize(this.baseStyle.fontSizeMd)
                            .placeholderFont({
                                size: this.baseStyle.fontSizeMd
                            })
                            .showPasswordIcon(this.showPasswordIcon)
                            .height(this.baseStyle.lineHeightMd)
                            .lineHeight(this.baseStyle.lineHeightMd)
                            .textAlign(this.inputAlign == 'center' ? TextAlign.Center :
                                this.inputAlign == 'right' ? TextAlign.End : TextAlign.Start)
                            .maxLength(this.maxlength)
                            // .showCounter(this.showWordLimit, {
                            //     thresholdPercentage: 1,
                            //     highlightBorder: false
                            // })
                            .selectionMenuHidden(true)
                            .type(this.getInputType())
                            .onChange((value: string) => {
                                this.formatValue(value, "onchange")
                                this.onChange(this.value)
                            })
                            .onFocus(() => {
                                this.isFocus = true
                                this.onFieldFocus()
                            })
                            .onBlur(() => {
                                this.isFocus = false
                                this.onFieldBlur()
                                if (typeof this.value == "string") {
                                    this.formatValue(this.value, "onblur")
                                }
                            })
                    }
                    // 清除图标
                    if (this.clearable && this.value && (this.clearTrigger == 'always' || this.isFocus)) {
                        Image($r("app.media.icon_clear"))
                            .width("40lpx")
                            .aspectRatio(1)
                            .margin({ left: this.baseStyle.spaceBase })
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
                        .margin({left: this.baseStyle.spaceBase})
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
                        .margin({left: this.baseStyle.spaceBase})
                }
            }
            .width(CONTAINER_SIZE.FULL)
            // 限制字数, 官方的showCounter属性在TextInput上正常, 在TextArea上有问题,输入内容后才会显示下面字数
            if(typeof this.value == "string" && this.maxlength > 0 && this.showWordLimit){
                Text(this.value.length + "/" + this.maxlength)
                    .width(CONTAINER_SIZE.FULL)
                    .textAlign(TextAlign.End)
                    .fontSize(this.baseStyle.fontSizeXs)
                    .fontColor(GRAY_COLOR.GRAY_5)
                    .margin({top: this.baseStyle.spaceBase})
            }
            // 验证信息
            if(this.showMessage && this.validateMessage){
                Text(this.validateMessage)
                    .fontSize(this.baseStyle.fontSizeSm)
                    .fontColor(colorData.danger)
                    .margin({top: this.baseStyle.spaceBase})
            }
        }
        .width(this.labelPosition == "top" ? CONTAINER_SIZE.FULL : "auto")
        .layoutWeight(this.labelPosition == "top" ? 0 : 1)
        .alignItems(HorizontalAlign.Start)
    }
}