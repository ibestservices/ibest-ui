import { getComponentsInfo } from '../../assets/ets/utils'
import { IBestTabItem, IBestTabController, TabWidthType } from './index.type'
import { emitter } from '../../assets/ets/EventEmitter'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { IBestUIBaseStyleObjType, IbestUIBaseStyleValue } from '../../theme-chalk/src/index.type';
import { fontSizeData } from '../../theme-chalk/src/font';
import { borderRadiusData } from '../../theme-chalk/src/border';
import { spaceData } from '../../theme-chalk/src/space';

@Component
export struct IBestTabs{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
    /*
     * 唯一id
     */
    @Provide uniId: string = this.getUniId()
    /*
     * 样式类型
     */
    @Provide type: 'line' | 'card' = "line"
    /*
     * tab高度
     */
    @Provide tabHeight: number = 70
    /*
     * tab宽度类型
     */
    @Provide tabWidthType: "auto" | "flex" = "flex"
    /*
     * tab列表
     */
    @Provide tabsList: IBestTabItem[] = []
    /*
     * 单个tab内边距，单位lpx
     */
    @Provide tabPadding: number = 10
    /*
     * tab盒子宽度
     */
    @State tabContentWidth: number = 0
    /*
     * tab宽度列表
     */
    @State tabsWidthList: TabWidthType[] = []
    /*
     * 当前激活的tab的name
     */
    @Provide @Watch("currentNameChange") currentName: string = ""
    /*
     * 标记线宽度是否固定
     */
    @Prop isTabLineWidthFixed: boolean = false
    /*
     * 标记线宽度，单位lpx
     */
    @Provide tabLineWidth: number = 0
    /*
     * 标记线高度，单位lpx
     */
    @Provide tabLineHeight: number = 4
    /*
     * 标记块宽度
     */
    @State tabBoxWidth: number = 0
    /*
     * 标记线X偏移量
     */
    @State translateX: number = this.tabPadding
    /*
     * 标记块X偏移量
     */
    @State tabBoxTranslateX: number = 0
    /*
     * 未激活的tab文字颜色
     */
    @Provide inactiveTextColor: string = "#666"
    /*
     * 激活的tab文字颜色
     */
    @Provide activeTextColor: string = "#333"
    /*
     * 标记线颜色
     */
    @Provide tabLineColor: string | IbestUIBaseStyleValue = this.baseStyle.primary
    /*
     * 标记线Y偏移量
     */
    @Provide lineOffsetY: number = 0
    /*
     * tab区域背景颜色
     */
    @Provide tabBgColor: string = "#fff"
    /*
     * controller 控制器
     */
    private tabController: IBestTabController | null = null
    private scroller: Scroller = new Scroller()
    @State context: UIContext = this.getUIContext()
    /*
     * onChange事件回调
     */
    onChange: ((name: string) => void) | null = null

    aboutToAppear(): void {
        if(this.tabController){
            this.tabController.uniId = this.uniId
        }
        emitter.on(`nameChange_${this.uniId}`, (name: string) => {
            if(this.tabsList.some((item: IBestTabItem) => item.name == name)){
                this.currentName = name
            }
        })
    }
    aboutToDisappear(): void {
        emitter.off(`nameChange_${this.uniId}`, () => {})
    }

    onDidBuild(): void {
        setTimeout(() => {
            this.getTabsWidth()
            this.getAndSetLineWidth()
        }, 0)
    }
    getUniId(): string{
        return Math.random().toString(36).slice(-7)
    }
    // tabName 变化
    currentNameChange(){
        // 获取并改变tabLine的宽度
        this.getAndSetLineWidth()
        // 触发回调函数
        this.onChange && this.onChange(this.currentName)
    }
    // 获取所有tab的宽度
    getTabsWidth(){
        let tabWidthList: TabWidthType[] = []
        let tabContentInfo = getComponentsInfo(this.context, `tabContent_${this.uniId}`)
        this.tabsList.forEach((item: IBestTabItem) => {
            let boxInfo = getComponentsInfo(this.context, `ibestTab_${this.uniId}_box_${item.name}`)
            let textInfo = getComponentsInfo(this.context, `ibestTab_${this.uniId}_text_${item.name}`)
            tabWidthList.push({
                boxWidth: boxInfo.width,
                boxLocalLeft: boxInfo.localLeft,
                textWidth: textInfo.width
            })
        })
        this.tabsWidthList = tabWidthList
        this.tabContentWidth = tabContentInfo.width
    }
    // 获取并改变line宽度 位置
    getAndSetLineWidth(){
        let index = this.tabsList.findIndex((item: IBestTabItem) => item.name == this.currentName)
        if(index > -1){
            let tabInfo = this.tabsWidthList[index]
            if(this.type == "line"){
                if(!this.isTabLineWidthFixed){
                    this.tabLineWidth = tabInfo.textWidth
                }
                this.translateX = tabInfo.boxLocalLeft + (tabInfo.boxWidth - this.tabLineWidth) / 2
            }else{
                this.tabBoxWidth = tabInfo.boxWidth
                this.tabBoxTranslateX = tabInfo.boxLocalLeft
            }
            if(this.tabWidthType == "auto"){
                this.scroller.scrollTo({
                    xOffset: ((this.type == "line" ? this.translateX : this.tabBoxTranslateX) - this.tabContentWidth/2 + this.tabBoxWidth/2) + "lpx",
                    yOffset: 0,
                    animation: {
                        duration: 100,
                        curve: Curve.FastOutSlowIn
                    }
                })
            }
        }
    }
    build() {
        if(this.tabWidthType == "auto"){
            Scroll(this.scroller){
                IBestTabContent({
                    translateX: this.translateX,
                    tabBoxWidth: this.tabBoxWidth,
                    tabBoxTranslateX: this.tabBoxTranslateX
                })
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
            .align(Alignment.Start)
            .id(`tabContent_${this.uniId}`)
        }else{
            IBestTabContent({
                translateX: this.translateX,
                tabBoxWidth: this.tabBoxWidth,
                tabBoxTranslateX: this.tabBoxTranslateX
            }).id(`tabContent_${this.uniId}`)
        }
    }
}

@Component
struct IBestTabContent{
    @Consume currentName: string
    @Consume type: 'line' | 'card'
    @Consume tabWidthType: "auto" | "flex"
    @Consume tabHeight: number
    @Consume tabsList: IBestTabItem[]
    @Consume tabBgColor: string
    @Consume tabLineWidth: number
    @Consume tabLineHeight: string
    @Consume tabLineColor: string
    @Consume lineOffsetY: number
    @Prop translateX: number
    @Prop tabBoxTranslateX: number
    @Prop tabBoxWidth: number
    build() {
        Stack({alignContent: Alignment.BottomStart}){
            // 标记线
            Row()
                .width(`${this.tabLineWidth}lpx`)
                .height(`${this.tabLineHeight}lpx`)
                .backgroundColor(this.tabLineColor)
                .translate({ x: this.translateX + "lpx" })
                .animation({
                    duration: 100,
                    curve: Curve.FastOutSlowIn
                })
                .offset({ y: `-${this.lineOffsetY}lpx` })
                .visibility(this.type == "line" ? Visibility.Visible : Visibility.None)
            // 标记块
            Row()
                .width(`${this.tabBoxWidth + 2}lpx`)
                .height(`${this.tabHeight}lpx`)
                .backgroundColor(this.tabLineColor)
                .translate({ x: this.tabBoxTranslateX + "lpx" })
                .animation({
                    duration: 100,
                    curve: Curve.FastOutSlowIn
                })
                .visibility(this.type == "card" ? Visibility.Visible : Visibility.None)
            Row(){
                ForEach(this.tabsList, (item: IBestTabItem, index: number) => {
                    IBestTab({ item: item, index: index })
                }, (item: string, index: number) => index+'')
            }
            .width(this.tabWidthType == "flex" ? "100%" : "")
            .height(this.tabHeight + "lpx")
            .borderRadius(borderRadiusData.borderRadiusSm)
            .border({ width: this.type == "card" ? "2lpx" : 0, color: this.tabLineColor })
        }
        .width(this.tabWidthType == "flex" ? "100%" : "")
        .backgroundColor(this.tabBgColor)
    }
}

@Component
struct IBestTab{
    @Consume uniId: string
    @Consume type: 'line' | 'card'
    @Consume tabWidthType: "auto" | "flex"
    @ObjectLink item: IBestTabItem
    @Prop index: number
    @Consume currentName: string
    @Consume tabPadding: number
    @Consume inactiveTextColor: number
    @Consume activeTextColor: number
    @Consume tabLineColor: number

    build() {
        Row() {
            Text(){
                if (this.item.icon) {
                    ImageSpan(this.item.icon)
                        .width(fontSizeData.fontSizeSm)
                        .aspectRatio(1)
                        .verticalAlign(ImageSpanAlignment.CENTER)
                        .margin({right: spaceData.spaceBase})
                }
                Span(this.item.label)
                if(typeof this.item.number !== "undefined"){
                    Span(`(${this.item.number})`)
                }
            }
            .height("100%")
            .fontSize(fontSizeData.fontSizeSm)
            .fontColor(this.currentName == this.item.name ? this.type == "card" ? "#fff" : this.activeTextColor :
                this.type == "card" ? this.tabLineColor : this.inactiveTextColor)
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .id(`ibestTab_${this.uniId}_text_${this.item.name}`)
        }
        .justifyContent(FlexAlign.Center)
        .padding({left: this.tabPadding + "lpx", right: this.tabPadding + "lpx"})
        .layoutWeight(this.tabWidthType == "flex" ? 1 : 0)
        .border({ width: { left: this.type == "card" && this.index > 0 ? "2lpx" : 0 }, color: this.tabLineColor })
        .enabled(!this.item.isDisable)
        .opacity(this.item.isDisable ? 0.3 : 1)
        .id(`ibestTab_${this.uniId}_box_${this.item.name}`)
        .onClick(() => {
            this.currentName = this.item.name
        })
    }
}
