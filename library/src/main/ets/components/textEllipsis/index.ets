import { IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import {
	convertDimensionsWidthUnit,
	getComponentsInfo,
	getResourceStr,
	getSizeByUnit,
	measureTextSize
} from '../../utils/utils'
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
    @Prop @Watch("formatText") text: ResourceStr = ""
    /**
     * 文字大小
     */
    @Prop textFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 文字颜色
     */
    @Prop textColor: ResourceColor = IBestTextEllipsisColor.textColor
	/**
	 * 文字字重
	 * @since 2.1.3
     */
	@Prop textFontWeight: IBestStringNumber | FontWeight = FontWeight.Normal
    /**
     * 行高
     */
    @Prop lineHeight: IBestStringNumber = convertDimensionsWidthUnit(20)
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
    @Prop expandText: ResourceStr = $r("app.string.ibest_text_expand")
    /**
     * 收起操作文案
     */
    @Prop collapseText: ResourceStr = $r("app.string.ibest_text_collapse")
    /**
     * 省略号内容
     */
    @Prop omitContent: ResourceStr = "…"
    /**
     * 操作文字颜色
     */
    @Prop actionColor: ResourceColor = this.baseStyle.primary
	/**
	 * 操作文字字重
	 * @since 2.1.3
     */
	@Prop actionFontWeight: IBestStringNumber | FontWeight = FontWeight.Normal
    /**
     * 省略位置
     */
    @Prop @Watch("formatText") omitPosition: "start" | "middle" | "end" = "end"
	/**
	 * 操作点击事件
	 * @since 2.0.9
     */
	onActionClick: (isExpand: boolean) => void = () => {}

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
			.fontWeight(this.textFontWeight)
    }

    aboutToAppear(): void {
        this.uniId = this.getUniqueId()
        this.formatText()
    }
    getTextString(){
        return getResourceStr(this.text)
    }
    getOmitText(){
        return getResourceStr(this.omitContent)
    }
    getExpandText(){
        return getResourceStr(this.expandText)
    }
    formatText(){
        setTimeout(() => {
            this.textWidth = getComponentsInfo(this.uiContext, `ibest_text_ellipsis_${this.uniId}`).width
            this.textHeight = this.measureText(this.getTextString())
            this.maxLineHeight = this.measureText(this.getTextString(), this.rows)
            if(this.textHeight > this.maxLineHeight){
                this.getTextByWidth()
            }else {
                this.showText = this.getTextString()
            }
        }, 0)
    }
    getTextByWidth(){
        let clipText = this.getTextString()
        let textHeight = this.textHeight
        let centerIndex = Math.floor(clipText.length / 2)
        let leftStr = clipText.slice(0, centerIndex)
        let rightStr = clipText.slice(centerIndex)
        let omitText = this.getOmitText()
        let expandText = this.getExpandText()
        while (textHeight > this.maxLineHeight) {
            switch (this.omitPosition){
                case "start":
                    clipText = clipText.substring(1)
                    textHeight = this.measureText(omitText + clipText + (this.showAction ? expandText : ""))
                    break
                case "middle":
                    leftStr = leftStr.substring(0, leftStr.length - 1)
                    rightStr = rightStr.substring(1)
                    textHeight = this.measureText(leftStr + omitText + rightStr + (this.showAction ? expandText : ""))
                    break
                case "end":
                    clipText = clipText.substring(0, clipText.length - 1)
                    textHeight = this.measureText(clipText + (this.textHeight > this.maxLineHeight ? omitText : "") + (this.showAction ? expandText : ""))
                    break
            }
        }
        this.showText = this.omitPosition == 'middle' ? leftStr + omitText + rightStr : clipText
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
				.fontWeight(this.textFontWeight)
            if(this.textHeight > this.maxLineHeight && !this.isExpand && this.omitPosition == "end"){
                this.OmitContent()
            }
            if(this.showAction && this.textHeight > this.maxLineHeight){
                Span(this.isExpand ? this.collapseText : this.expandText)
                    .fontColor(this.actionColor)
                    .fontSize(getSizeByUnit(this.textFontSize, true))
					.fontWeight(this.actionFontWeight)
                    .onClick(() => {
                        this.isExpand = !this.isExpand
						this.onActionClick(this.isExpand)
                    })
            }
        }
        .width(CONTAINER_SIZE.FULL)
        .lineHeight(getSizeByUnit(this.lineHeight))
        .id(`ibest_text_ellipsis_${this.uniId}`)
        .visibility(this.showText ? Visibility.Visible : Visibility.Hidden)
    }
}