import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit } from '../../utils/utils'

@Component
export struct IBestTextEllipsis{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 显示文本
     */
    @Prop text: string = ""
    /**
     * 文字大小
     */
    @Prop textFontSize: number | string = convertDimensionsWidthUnit(14, true)
    /**
     * 文字颜色
     */
    @Prop textColor: ResourceColor = GRAY_COLOR.GRAY_8
    /**
     * 行高
     */
    @Prop lineHeight: number | string = convertDimensionsWidthUnit(20)
    /**
     * 展示的行数
     */
    @Prop rows: number = 1
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
    @Prop omitPosition: "start" | "middle" | "end" = "end"

    @State uniId: number = 0
    @State showText: string = ""
    @State isExpand: boolean = false
    @State contentWidth: number = 0
    @State textWidth: number = 0
    private uiContext = this.getUIContext()
    private measureUtils = this.uiContext.getMeasureUtils()
    omitWidth: number = 0
    expandWidth: number = 0

    aboutToAppear(): void {
        this.uniId = this.getUniqueId()
        this.formatText()
    }
    formatText(){
        setTimeout(() => {
            this.contentWidth = getComponentsInfo(this.uiContext, `ibest_text_${this.uniId}`).width
            this.textWidth = this.measureText(this.text)
            this.omitWidth = this.measureText(this.omitContent)
            this.expandWidth = this.measureText(this.expandText)
            this.getTextByWidth()
        }, 0)
    }
    getTextByWidth(){
        let textArr = this.text.split("")
        let showArr: string[] = []
        for (let i = 0; i < this.rows; i++) {
            showArr.push(this.getStr("", textArr, i))
        }
        this.showText = showArr.join("")
    }
    getStr(str: string, textArr: string[], i: number): string{
        if(!textArr.length){
            return str
        }
        const isLast = i == this.rows-1
        const curWidth = this.measureText(str)
        const nextWordWidth = this.measureText(textArr[0])
        const fullWidth = this.contentWidth - (isLast ? this.omitWidth : 0) - (isLast && this.showAction ? this.expandWidth : 0)
        if(isLast){
            console.log("width", curWidth, curWidth + nextWordWidth, fullWidth)
        }
        if(curWidth < fullWidth && curWidth + nextWordWidth < fullWidth - 10){
            str += textArr.shift()
            return this.getStr(str, textArr, i)
        }else {
            console.log("str", str)
            return str
        }
    }
    measureText(text: string): number{
        return px2vp(this.measureUtils.measureTextSize({
            textContent: text,
            fontSize: getSizeByUnit(this.textFontSize, true),
            maxLines: this.rows
        }).width as number)
    }

    build() {
        Text(){
            Span(this.isExpand ? this.text : this.showText)
                .fontColor(this.textColor)
                .fontSize(getSizeByUnit(this.textFontSize, true))
            if(this.textWidth > this.contentWidth && !this.isExpand){
                Span(this.omitContent)
                    .fontColor(this.textColor)
                    .fontSize(getSizeByUnit(this.textFontSize, true))
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