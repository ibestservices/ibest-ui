import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit, measureTextSize } from '../../utils/utils'
import { IBestTextEllipsisColor } from './color'
@Component
export struct IBestTextEllipsis{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 显示文本
     */
    @Prop @Watch("formatText") text: string = ""
    /**
     * 文字大小
     */
    @Prop textFontSize: number | string = this.baseStyle.fontSizeMd as string
    /**
     * 文字颜色
     */
    @Prop textColor: ResourceColor = IBestTextEllipsisColor.textColor
    /**
     * 行高
     */
    @Prop lineHeight: number | string = convertDimensionsWidthUnit(20)
    /**
     * 展示的行数
     */
    @Prop @Watch("formatText") rows: number = 1
    /**
     * 是否显示操作
     */
    @Prop showAction: boolean = false
    /**
     * 展开操作文案
     */
    @Prop expandText: string = "展开"
    /**
     * 收起操作文案
     */
    @Prop collapseText: string = "收起"
    /**
     * 省略号内容
     */
    @Prop omitContent: string = "…"
    /**
     * 操作文字颜色
     */
    @Prop actionColor: ResourceColor = this.baseStyle.primary
    /**
     * 省略位置
     */
    @Prop @Watch("formatText") omitPosition: "start" | "middle" | "end" = "end"

    @State uniId: number = 0
    @State showText: string = ""
    @State isExpand: boolean = false
    @State textWidth: number = 0
    @State textHeight: number = 0
    @State maxLineHeight: number = 0
    private uiContext = this.getUIContext()

    @Builder OmitContent(){
        Span(this.omitContent)
            .fontColor(this.textColor)
            .fontSize(getSizeByUnit(this.textFontSize, true))
    }

    aboutToAppear(): void {
        this.uniId = this.getUniqueId()
        this.formatText()
    }
    formatText(){
        setTimeout(() => {
            this.textWidth = getComponentsInfo(this.uiContext, `ibest_text_${this.uniId}`).width
            this.textHeight = this.measureText(this.text)
            this.maxLineHeight = this.measureText(this.text, this.rows)
            if(this.textHeight > this.maxLineHeight){
                this.getTextByWidth()
            }else {
                this.showText = this.text
            }
        }, 0)
    }
    getTextByWidth(){
        let clipText = this.text
        let textHeight = this.textHeight
        let centerIndex = Math.floor(clipText.length / 2)
        let leftStr = clipText.slice(0, centerIndex)
        let rightStr = clipText.slice(centerIndex)
        while (textHeight > this.maxLineHeight) {
            switch (this.omitPosition){
                case "start":
                    clipText = clipText.substring(1)
                    textHeight = this.measureText(this.omitContent + clipText + (this.showAction ? this.expandText : ""))
                    break
                case "middle":
                    leftStr = leftStr.substring(0, leftStr.length - 1)
                    rightStr = rightStr.substring(1)
                    textHeight = this.measureText(leftStr + this.omitContent + rightStr + (this.showAction ? this.expandText : ""))
                    break
                case "end":
                    clipText = clipText.substring(0, clipText.length - 1)
                    textHeight = this.measureText(clipText + (this.textHeight > this.maxLineHeight ? this.omitContent : "") + (this.showAction ? this.expandText : ""))
                    break
            }
        }
        this.showText = this.omitPosition == 'middle' ? leftStr + this.omitContent + rightStr : clipText
    }
    measureText(text: string, rows?: number): number{
        return measureTextSize(this.uiContext, {
            textContent: text,
            constraintWidth: this.textWidth,
            fontSize: getSizeByUnit(this.textFontSize, true),
            lineHeight: getSizeByUnit(this.lineHeight),
            maxLines: rows
        }).height
    }

    build() {
        Text(){
            if(this.textHeight > this.maxLineHeight && !this.isExpand && this.omitPosition == "start"){
                this.OmitContent()
            }
            Span(this.isExpand ? this.text : this.showText)
                .fontColor(this.textColor)
                .fontSize(getSizeByUnit(this.textFontSize, true))
            if(this.textHeight > this.maxLineHeight && !this.isExpand && this.omitPosition == "end"){
                this.OmitContent()
            }
            if(this.showAction){
                Span(this.isExpand ? this.collapseText : this.expandText)
                    .fontColor(this.actionColor)
                    .fontSize(getSizeByUnit(this.textFontSize, true))
                    .onClick(() => {
                        this.isExpand = !this.isExpand
                    })
            }
        }
        .width(CONTAINER_SIZE.FULL)
        .lineHeight(getSizeByUnit(this.lineHeight))
        .id(`ibest_text_${this.uniId}`)
    }
}