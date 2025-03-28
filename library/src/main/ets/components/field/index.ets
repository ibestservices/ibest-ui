import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import {
    COMPONENT_NAME,
    FieldValidateResult,
    FORM_EVENT_NAME,
    IBestFormRuleItem,
    IBestFormSendFieldCallResult
} from '../form/index.type'
import type {
    ClearTriggerType,
    FieldTextAlign,
    FormatTriggerType,
    IBestFieldType,
    IBestFieldValueType,
    LabelPositionType,
    RequireAsteriskPositionType
} from './index.type'
import { emitter } from '../../utils/EventEmitter'
import { runRuleValidator, runSyncRule } from './utils'
import { clamp, convertDimensionsWidthUnit, getEventName, getResourceStr, getSizeByUnit } from '../../utils/utils'
import { IBestFieldColor } from './color'
import { IBestIcon } from '../icon'
import { IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestField{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
    @State uniId: number = 0
    /**
     * form id 用于验证
     */
    @Prop formId: IBestStringNumber = ""
    /**
     * 表单绑定属性名
     */
    @Prop prop: string = ""
    /**
     * 验证规则
     */
    @Prop @Watch("rulesChange") rules: IBestFormRuleItem[]
    /**
     * 组件绑定的值
     */
    @Link @Watch("valueChange") value: IBestFieldValueType
    /**
     * 左侧文本内容
     */
    @Provide({allowOverride: "label"}) label: ResourceStr = ""
    /**
     * 是否在label后加冒号
     */
    @Provide({allowOverride: "colon"}) colon?: boolean = undefined
    /**
     * 文本宽度
     */
    @Provide({allowOverride: "labelWidth"}) labelWidth: IBestStringNumber = 0
    /**
     * 文本位置
     */
    @Provide({allowOverride: "labelPosition"}) labelPosition: LabelPositionType = ''
    /**
     * 文本对齐方式
     */
    @Provide({allowOverride: "labelAlign"}) labelAlign: FieldTextAlign = ''
    /**
     * 输入框占位提示文字
     */
    @Provide({allowOverride: "placeholder"}) placeholder: ResourceStr = ""
    /**
     * 占位文字颜色
     * @since 2.0.1
     */
    @Provide({allowOverride: "placeholderColor"}) placeholderColor: ResourceColor = IBestFieldColor.placeholderColor
    /**
     * 输入框类型
     */
    @Provide({allowOverride: "type"}) type: IBestFieldType = "normal"
    /**
     * 小数点位数
     */
    @Provide({allowOverride: "decimalLength"}) decimalLength: number = -1
    /**
     * 是否显示密码框末尾图标
     */
    @Provide({allowOverride: "showPasswordIcon"}) showPasswordIcon: boolean = true
    /**
     * 输入框自适应高度
     */
    @Provide({allowOverride: "autosize"}) autosize: boolean = false
    /**
     * 自适应高度时默认行数
     */
    @Provide({allowOverride: "rows"}) rows: number = 1
    /**
     * 最大输入字符数
     */
    @Provide({allowOverride: "maxlength"}) maxlength: number = -1
    /**
     * 是否显示字数统计
     */
    @Provide({allowOverride: "showWordLimit"}) showWordLimit: boolean = false
    /**
     * 输入框文字对齐方式
     */
    @Provide({allowOverride: "inputAlign"}) inputAlign: FieldTextAlign = "left"
    /**
     * 是否必填, 仅控制*显隐
     */
    @Provide({allowOverride: "required"}) required?: boolean = undefined
    /**
     * 星号的位置
     */
    @Provide({allowOverride: "requireAsteriskPosition"}) requireAsteriskPosition: RequireAsteriskPositionType = ''
    /**
     * 是否禁用
     */
    @Provide({allowOverride: "disabled"}) disabled?: boolean = undefined
    /**
     * 是否只读
     */
    @Provide({allowOverride: "readOnly"}) readOnly: boolean = false
    /**
     * 是否开启点击反馈
     */
    @Provide({allowOverride: "clickable"}) clickable: boolean = false
    /**
     * 是否展示右侧箭头并开启点击反馈
     */
    @Provide({allowOverride: "isLink"}) isLink: boolean = false
    /**
     * 左侧图标
     */
    @Provide({allowOverride: "leftIcon"}) leftIcon: ResourceStr = ""
    /**
     * 左侧图标颜色
     */
    @Provide({allowOverride: "leftIconColor"}) leftIconColor: ResourceColor = IBestFieldColor.labelColor
    /**
     * 右侧图标
     */
    @Provide({allowOverride: "rightIcon"}) rightIcon: ResourceStr = ""
    /**
     * 右侧图标颜色
     */
    @Provide({allowOverride: "rightIconColor"}) rightIconColor: ResourceColor = IBestFieldColor.rightIconColor
    /**
     * 底部线条
     */
    @Prop hasBorder: boolean = true
    /**
     * 是否启用清除图标，点击清除图标后会清空输入框
     */
    @Provide({allowOverride: "clearable"}) clearable: boolean = false
    /**
     * 自定义清除图标
     */
    @Provide({allowOverride: "clearIcon"}) clearIcon: ResourceStr = ""
    /**
     * 显示清除图标的时机
     */
    @Provide({allowOverride: "clearTrigger"}) clearTrigger: ClearTriggerType = 'focus'
    /**
     * 验证状态
     */
    @Provide status: 'passed' | 'failed' | 'unvalidated' = 'unvalidated'
    /**
     * 是否显示验证信息
     */
    @Provide({allowOverride: "showMessage"}) showMessage?: boolean = undefined
    /**
     * 验证信息
     */
    @Provide({allowOverride: "validateMessage"}) validateMessage: ResourceStr = ""
    /**
     * 执行格式化函数触发时机
     */
    @Provide({allowOverride: "formatTrigger"}) formatTrigger: FormatTriggerType = 'onchange'
    /**
     * label字体大小
     * @since 1.19.0
     */
    @Provide({allowOverride: "labelFontSize"}) labelFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * label字体颜色
     * @since 1.19.0
     */
    @Provide({allowOverride: "labelColor"}) labelColor: ResourceColor = IBestFieldColor.labelColor
    /**
     * 左侧图标大小
     * @since 1.19.0
     */
    @Provide({allowOverride: "leftIconSize"}) leftIconSize: IBestStringNumber = convertDimensionsWidthUnit(18)
    /**
     * 右侧图标大小
     * @since 1.19.0
     */
    @Provide({allowOverride: "rightIconSize"}) rightIconSize: IBestStringNumber = convertDimensionsWidthUnit(18)
    /**
     * 是否显示label
     * @since 2.0.0
     */
    @Prop showLabel: boolean = true
    /**
     * 背景色
     * @since 2.0.1
     */
    @Prop bgColor: ResourceColor = IBestFieldColor.bg2
    /**
     * 输入框文字大小
     * @since 2.0.4
     */
    @Provide({allowOverride: "inputFontSize"}) inputFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 光标颜色
     * @since 2.0.5
     */
    @Provide({allowOverride: "caretColor"}) caretColor: ResourceColor = ""
    /**
     * 最小值, type 为 number、decimal 有效
     * @since 2.0.5
     */
    @Provide({allowOverride: "min"}) min: number = -1
    /**
     * 最大值, type 为 number、decimal 有效
     * @since 2.0.5
     */
    @Provide({allowOverride: "max"}) max: number = -1
    /**
     * 垂直方向对齐方式, 仅labelPosition为left时有效
     * @since 2.0.6
     */
    @Prop verticalAlign: "top" | "center"
    /**
     * 外部圆角
     * @since 2.0.6
     */
    @Provide({allowOverride: "radius"}) radius: IBestStringNumber = 0
    /**
     * 前缀内容
     * @since 2.0.7
     */
    @Provide({allowOverride: "prefix"}) prefix: ResourceStr = ""
    /**
     * 前缀内容颜色
     * @since 2.0.7
     */
    @Provide({allowOverride: "prefixFontColor"}) prefixFontColor: ResourceColor = IBestFieldColor.prefixFontColor
    /**
     * 后缀内容
     * @since 2.0.7
     */
    @Provide({allowOverride: "suffix"}) suffix: ResourceStr = ""
    /**
     * 后缀内容颜色
     * @since 2.0.7
     */
    @Provide({allowOverride: "suffixFontColor"}) suffixFontColor: ResourceColor = IBestFieldColor.suffixFontColor
    /**
     * 右侧按钮builder
     */
    @BuilderParam buttonBuilder?: CustomBuilder
    /**
     * 自定义右侧内容
     */
    @BuilderParam customRightContent?: CustomBuilder
    /**
     * 格式化函数
     */
    formatter?: (value: string) => string
    /**
     * value变化回调函数
     */
    onChange: (value: IBestFieldValueType) => void = () => {}
    /**
     * 点击清除按钮时触发
     */
    onClear: () => void = () => {}
    /**
     * 点击组件触发
     */
    onFieldClick: () => void = () => {}
    /**
     * 输入框获得焦点时触发
     */
    onFieldFocus: () => void = () => {}
    /**
     * 输入框失去焦点时触发
     */
    onFieldBlur: () => void = () => {}
    /**
     * 左侧图标点击时触发
     */
    onLeftIconClick: () => void = () => {}
    /**
     * 右侧图标点击时触发
     */
    onRightIconClick: () => void = () => {}
    private uiContext = this.getUIContext()
    private context = getContext(this)
    @Builder focusText(){
        Text()
            .focusable(true)
            .position({left: 0, top: 0})
            .zIndex(-10)
            .id(`ibest_field_${this.uniId}`)
    }
    @Styles ibestFieldStyle(){
        .width(CONTAINER_SIZE.FULL)
        .padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
        .stateStyles({
            normal: {
                .backgroundColor(this.bgColor)
            },
            pressed: {
                .backgroundColor((this.clickable || this.isLink) ? IBestFieldColor.activeColor : IBestFieldColor.bg2)
            }
        })
        .borderRadius(getSizeByUnit(this.radius))
        .enabled(!this.disabled)
        .opacity(this.disabled ? 0.6 : 1)
        .clip(true)
        .onTouch(event => {
            if(event.type == TouchType.Up){
                this.onFieldClick()
                if((this.disabled || this.readOnly || this.isLink) && !this.customRightContent){
                    this.uiContext.getFocusController().requestFocus(`ibest_field_${this.uniId}`)
                }
            }
        })
    }
    @Styles ibestFieldContentStyle(){
        .padding({ top: convertDimensionsWidthUnit(10), bottom: convertDimensionsWidthUnit(10) })
        .border({
            width: { bottom: this.hasBorder ? 1 : 0 },
            color: IBestFieldColor.borderColor
        })
    }

    aboutToAppear(): void {
        this.uniId = this.getUniqueId()
        this.formatValue()
        if(this.formId && this.prop){
            emitter.on(getEventName(COMPONENT_NAME, FORM_EVENT_NAME.RESEND_FORM_ITEM, this.formId), this.uniId, (): void => this.sendFormItemData())
            this.sendFormItemData()
        }else{
            this.init()
        }
    }
    aboutToDisappear(): void {
        if(this.formId && this.prop) {
            emitter.off(getEventName(COMPONENT_NAME, FORM_EVENT_NAME.RESEND_FORM_ITEM, this.formId), this.uniId)
            emitter.emit(getEventName(COMPONENT_NAME, FORM_EVENT_NAME.DELETE_FORM_ITEM, this.formId), this.uniId)
            emitter.emit(getEventName(COMPONENT_NAME, FORM_EVENT_NAME.RESEND_FORM_ITEM, this.formId))
        }
    }
    rulesChange(){
        this.required = this.rules?.length > 0 && this.rules.some((item: IBestFormRuleItem) => item.required)
        if(!this.required){
            this.resetValidation()
        }
    }
    formatValue(){
        if(typeof this.value == "number"){
            this.value = this.value.toString()
        }
        if(this.value === undefined || this.value === null){
            this.value = ""
        }
    }
    // 发送表单子项信息
    sendFormItemData(){
        emitter.emit(getEventName(COMPONENT_NAME, FORM_EVENT_NAME.SEND_FIELD, this.formId), {
            uniId: this.uniId,
            prop: this.prop,
            validate: (rules: IBestFormRuleItem[]):Promise<void | FieldValidateResult> => this.validate(rules),
            getValue: (): IBestFieldValueType => this.value,
            resetValidation: (): void => this.resetValidation()
        }, (result: IBestFormSendFieldCallResult): void => this.init(result))
    }
    // 初始化参数
    init(results?: IBestFormSendFieldCallResult){
        if(results){
            this.rules = this.rules || (results?.rules || [])
        }
        this.required = typeof this.required != "undefined" ? this.required : this.rules?.length > 0 && this.rules.some((item: IBestFormRuleItem) => item.required)
        this.labelWidth = this.labelWidth || results?.labelWidth || convertDimensionsWidthUnit(80)
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
    // 获取label
    getLabel(){
        return typeof this.label == 'string' ? this.label : this.context.resourceManager.getStringSync(this.label)
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
                            label: this.getLabel(),
                            name: this.prop,
                            message: getResourceStr(this.validateMessage)
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
        return this.rules ? this.rules.filter((rule) => {
            if (!rule.trigger) return true
            return rule.trigger === trigger
        }) : []
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
                emitter.emit(getEventName(COMPONENT_NAME, FORM_EVENT_NAME.VALIDATE_FIELD, this.formId), this.prop)
            }
        }
    }
    getVerticalAlign(){
        if(this.verticalAlign){
            return this.verticalAlign == 'top' ? VerticalAlign.Top : VerticalAlign.Center
        }else{
            return (this.showWordLimit || this.autosize || this.validateMessage) ? VerticalAlign.Top : VerticalAlign.Center
        }
    }

    build() {
        if(this.labelPosition == "left"){
            Row(){
                Row(){
                    if(this.showLabel){
                        Label({
                            onLeftIconClick: (): void => this.onLeftIconClick()
                        })
                    }
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
                .alignItems(this.getVerticalAlign())
                .ibestFieldContentStyle()
                this.focusText()
            }
            .ibestFieldStyle()
        }else{
            Column(){
                Column(){
                    if(this.showLabel){
                        Label({
                            onLeftIconClick: (): void => this.onLeftIconClick()
                        })
                    }
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
                .ibestFieldContentStyle()
                this.focusText()
            }
            .alignItems(HorizontalAlign.Start)
            .ibestFieldStyle()
        }
    }
}

@Component
struct Label{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
    @Consume label: ResourceStr
    @Consume labelFontSize: IBestStringNumber
    @Consume labelColor: ResourceColor
    @Consume colon: boolean
    @Consume labelPosition: LabelPositionType
    @Consume labelAlign: FieldTextAlign
    @Consume labelWidth: IBestStringNumber
    @Consume requireAsteriskPosition: string
    @Consume leftIcon: ResourceStr
    @Consume leftIconColor: ResourceColor
    @Consume leftIconSize: IBestStringNumber
    onLeftIconClick: () => void = () => {}
    build() {
        Row(){
            if(this.leftIcon){
                Image(this.leftIcon)
                    .width(getSizeByUnit(this.leftIconSize))
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
            Text(){
                Span(this.label)
                if(this.colon){
                    Span(":")
                }
            }
                .fontSize(getSizeByUnit(this.labelFontSize, true))
                .fontColor(this.labelColor)
                .constraintSize({ minHeight: convertDimensionsWidthUnit(20) })
                .lineHeight(this.baseStyle.lineHeightMd)
            if(this.requireAsteriskPosition == "right"){
                Asterisk()
            }
        }
        .width(this.labelPosition == "left" ? getSizeByUnit(this.labelWidth) : CONTAINER_SIZE.FULL)
        .margin({right: this.baseStyle.spaceSm})
        .alignItems(VerticalAlign.Center)
        .justifyContent(this.labelAlign == "left" ? FlexAlign.Start : this.labelAlign == "center" ? FlexAlign.Center : FlexAlign.End)
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
    @Consume inputFontSize: IBestStringNumber
    @Consume inputAlign: FieldTextAlign
    @Consume rightIcon: ResourceStr
    @Consume rightIconColor: ResourceColor
    @Consume rightIconSize: IBestStringNumber
    @Consume placeholder: string
    @Consume placeholderColor: ResourceColor
    @Consume disabled: boolean
    @Consume readOnly: boolean
    @Consume clearable: boolean
    @Consume isLink: boolean
    @Consume clearIcon: ResourceStr
    @Consume clearTrigger: ClearTriggerType
    @Consume showMessage: boolean
    @Consume validateMessage: string
    @Consume caretColor: ResourceColor
    @Consume min: number
    @Consume max: number
    @Consume prefix: ResourceStr
    @Consume prefixFontColor: ResourceColor
    @Consume suffix: ResourceStr
    @Consume suffixFontColor: ResourceColor
    @BuilderParam buttonBuilder?: CustomBuilder
    @BuilderParam customRightContent?: CustomBuilder
    @Consume formatTrigger: FormatTriggerType
    formatter?: (value: string) => string
    onChange: (value: IBestFieldValueType) => void = () => {}
    onClear: () => void = () => {}
    onFieldClick: () => void = () => {}
    onFieldFocus: () => void = () => {}
    onFieldBlur: () => void = () => {}
    onRightIconClick: () => void = () => {}

    @Styles ibestFieldInputStyle(){
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
        if(this.type == "number" || this.type == "decimal"){
            if(trigger == 'onblur' && value !== '' && (this.min > -1 || this.max > -1)){
                const validValue = clamp(Number(value), this.min > -1 ? this.min : -Infinity, this.max > -1 ? this.max : Infinity)
                this.value = value = validValue.toString()
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
    }
    build() {
        Column(){
            Row() {
                // 前缀
                if(this.prefix){
                    Text(this.prefix)
                        .fontSize(getSizeByUnit(this.inputFontSize, true))
                        .fontColor(this.prefixFontColor)
                        .margin({right: this.baseStyle.spaceBase})
                }
                if (this.customRightContent) {
                    this.customRightContent()
                } else {
                    if (this.autosize) {
                        TextArea({ text: $$this.value, placeholder: this.placeholder })
                            .ibestFieldInputStyle()
                            .caretColor(this.caretColor)
                            .fontSize(getSizeByUnit(this.inputFontSize, true))
                            .fontColor(IBestFieldColor.inputColor)
                            .placeholderFont({
                                size: getSizeByUnit(this.inputFontSize, true)
                            })
                            .placeholderColor(this.placeholderColor)
                            .constraintSize({ minHeight: convertDimensionsWidthUnit(this.rows * 20) })
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
                            .ibestFieldInputStyle()
                            .caretColor(this.caretColor)
                            .fontSize(getSizeByUnit(this.inputFontSize, true))
                            .fontColor(IBestFieldColor.inputColor)
                            .placeholderFont({
                                size: getSizeByUnit(this.inputFontSize, true)
                            })
                            .placeholderColor(this.placeholderColor)
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
                        IBestIcon({
                            name: 'clear',
                            iconSize: this.rightIconSize
                        })
                            .onClick(() => {
                                this.value = ''
                                this.onClear()
                            })
                            .margin({ left: this.baseStyle.spaceBase })
                    }
                }
                // 按钮
                if(this.buttonBuilder){
                    this.buttonBuilder()
                }
                // 右侧图标
                if(this.rightIcon){
                    Image(this.rightIcon)
                        .width(getSizeByUnit(this.rightIconSize))
                        .aspectRatio(1)
                        .fillColor(this.rightIconColor)
                        .margin({left: this.baseStyle.spaceBase})
                        .onClick(() => {
                            this.onRightIconClick()
                        })
                }
                // 后缀
                if(this.suffix){
                    Text(this.suffix)
                        .fontSize(getSizeByUnit(this.inputFontSize, true))
                        .fontColor(this.suffixFontColor)
                        .margin({left: this.baseStyle.spaceBase})
                }
                // link箭头
                if(this.isLink){
                    IBestIcon({
                        name: "arrow",
                        iconSize: this.rightIconSize,
                        color: this.rightIconColor
                    })
                        .onClick(() => {
                            this.onFieldClick()
                        })
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
                    .fontColor(this.baseStyle.danger)
                    .margin({top: this.baseStyle.spaceBase})
            }
        }
        .width(this.labelPosition == "top" ? CONTAINER_SIZE.FULL : "auto")
        .layoutWeight(this.labelPosition == "top" ? 0 : 1)
        .alignItems(HorizontalAlign.Start)
    }
}