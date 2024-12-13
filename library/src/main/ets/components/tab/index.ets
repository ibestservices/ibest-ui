import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit, sleep } from '../../utils/utils';
import { IBestTabController, IBestTabItem, TabWidthType } from './index.type';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { mediaquery } from '@kit.ArkUI';
import { debounce } from '../../utils/DebounceThrottle';

let listener = mediaquery.matchMediaSync('(orientation: landscape)')

@Component
export struct IBestTabs{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
    /**
     * 唯一id
     */
    @Provide uniId: string = ""
    /**
     * 样式类型
     */
    @Provide({allowOverride: "type"}) type: 'line' | 'card' = "line"
    /**
     * tab高度
     */
    @Provide({allowOverride: "tabHeight"}) tabHeight: number | string = convertDimensionsWidthUnit(35)
    /**
     * tab宽度类型
     */
    @Provide({allowOverride: "tabWidthType"}) tabWidthType: "auto" | "flex" = "flex"
    /**
     * tab列表
     */
    @Provide({ allowOverride: "tabsList" }) @Watch("tabsListChange") tabsList: IBestTabItem[] = []
    /**
     * 单个tab内边距
     */
    @Provide({allowOverride: "tabPadding"}) tabPadding: number | string = this.baseStyle.spaceXs
    /**
     * tab盒子宽度
     */
    @State tabContentWidth: number = 0
    /**
     * tab宽度列表
     */
    @State tabsWidthList: TabWidthType[] = []
    /**
     * 标记线位移列表
     */
    @State translateXList: number[] = []
    /**
     * 当前激活的tab的name
     */
    @Link @Watch("currentNameChange") currentName: string
    /**
     * 标记线宽度是否固定
     */
    @Prop isTabLineWidthFixed: boolean = false
    /**
     * 标记线宽度
     */
    @Provide({allowOverride: "tabLineWidth"}) tabLineWidth: number = 0
    /**
     * 标记线高度
     */
    @Provide({allowOverride: "tabLineHeight"}) tabLineHeight: number | string = convertDimensionsWidthUnit(2)
    /**
     * 标记块宽度
     */
    @State tabBoxWidth: number = 0
    /**
     * 标记线X偏移量
     */
    @State translateX: number = typeof this.tabPadding == "number" ? this.tabPadding : parseFloat(this.tabPadding)
    /**
     * 标记块X偏移量
     */
    @State tabBoxTranslateX: number = 0
    /**
     * 未激活的tab文字颜色
     */
    @Provide({allowOverride: "inactiveTextColor"}) inactiveTextColor: ResourceColor = GRAY_COLOR.GRAY_7
    /**
     * 激活的tab文字颜色
     */
    @Provide({allowOverride: "activeTextColor"}) activeTextColor: ResourceColor = GRAY_COLOR.GRAY_8
    /**
     * 标记线颜色
     */
    @Provide({allowOverride: "tabLineColor"}) tabLineColor: ResourceColor = this.baseStyle.primary
    /**
     * 标记线Y偏移量
     */
    @Provide({allowOverride: "lineOffsetY"}) lineOffsetY: number | string = 0
    /**
     * tab区域背景颜色
     */
    @Provide({allowOverride: "tabBgColor"}) tabBgColor: ResourceColor  = this.baseStyle.default
    /**
     * 字体大小
     * @since 1.15.0
     */
    @Provide({allowOverride: "fontSize"}) fontSize: number | string = this.baseStyle.fontSizeMd
    /**
     * onChange事件回调
     */
    onChange: (name: string) => void = () => {}
    /**
     * 点击事件
     * @since 1.17.0
     */
    onTabClick: (name: string) => void = () => {}
    /**
     * tabContent 内容列表
     */
    // @BuilderParam tabContent?: CustomBuilder
    /**
     * controller 控制器
     */
    tabController: IBestTabController = new IBestTabController()
    private scroller: Scroller = new Scroller()
    private context: UIContext = this.getUIContext()
    private swiperController: SwiperController = new SwiperController()
    @State swiperIndex: number = 0
    @State startTransX: number = 0
    @State startX: number = 0
    @State touchOffsetX: number = 0
    @State startTime: number = 0


    aboutToAppear(): void {
        this.uniId = this.getUniqueId().toString()
        this.tabController.changeTab = (name: string): void => this.changeTab(name)

        listener.on('change', (): void => this.initSize())
    }
    aboutToDisappear(): void {
        listener.off('change', (): void => this.initSize())
    }

    onDidBuild(): void {
        this.initSize()
    }
    initSize: () => void = debounce(() => {
        let index = this.tabsList.findIndex((item: IBestTabItem) => item.name == this.currentName)
        this.getTabsWidth()
        this.getAndSetLineWidth(index)
        this.scrollCenter()
        this.swiperChange(index, false)
    }, 50)
    // 列表变化
    tabsListChange(){
        sleep(20).then(() => {
            this.getTabsWidth()
        })
    }
    // tabName 变化
    async currentNameChange(){
        if(this.tabsWidthList.length){
            let index = this.tabsList.findIndex((item: IBestTabItem) => item.name == this.currentName)
            // 获取并改变tabLine的宽度
            this.getAndSetLineWidth(index)
            // 触发回调函数
            this.onChange(this.currentName)
            this.scrollCenter()
            await sleep(20)
            // 切换swiper的index
            this.swiperChange(index, true)
        }
    }
    // 切换swiper
    swiperChange(index: number, animated: boolean){
        // this.swiperController.changeIndex(index, animated)
    }
    // 切换name
    changeTab(name: string){
        if(this.tabsList.some((item: IBestTabItem) => item.name == name)){
            this.currentName = name
        }
    }
    // 获取所有tab的宽度
    getTabsWidth(){
        let tabWidthList: TabWidthType[] = []
        let translateXList: number[] = []
        let tabContentInfo = getComponentsInfo(this.context, `tabContent_${this.uniId}`)
        this.tabsList.forEach((item: IBestTabItem) => {
            let boxInfo = getComponentsInfo(this.context, `ibestTab_${this.uniId}_box_${item.name}`)
            let textInfo = getComponentsInfo(this.context, `ibestTab_${this.uniId}_text_${item.name}`)
            let tabLineWidth = this.isTabLineWidthFixed ? this.getTabLineWidth() : textInfo.width
            tabWidthList.push({
                boxWidth: boxInfo.width,
                boxLocalLeft: boxInfo.localLeft,
                textWidth: textInfo.width
            })
            translateXList.push(boxInfo.localLeft + (boxInfo.width - tabLineWidth) / 2)
        })
        this.tabsWidthList = tabWidthList
        this.tabContentWidth = tabContentInfo.width
        this.translateXList = translateXList
    }
    // 获取并改变line宽度 位置
    getAndSetLineWidth(index: number){
        if(index > -1) {
            let tabInfo = this.tabsWidthList[index]
            if (this.type == "line") {
                if (!this.isTabLineWidthFixed) {
                    this.tabLineWidth = tabInfo.textWidth
                }
                this.startTransX = this.translateX = this.translateXList[index]
            } else {
                this.tabBoxWidth = tabInfo.boxWidth
                this.startTransX = this.tabBoxTranslateX = tabInfo.boxLocalLeft
            }
        }
    }
    getTabLineWidth(){
        return typeof this.tabLineWidth == "number" ? this.tabLineWidth : parseFloat(this.tabLineWidth)
    }
    // 滚动居中
    scrollCenter(animate: boolean = true){
        if(this.tabWidthType == "auto"){
            this.scroller.scrollTo({
                xOffset: getSizeByUnit((this.type == "line" ? this.translateX : this.tabBoxTranslateX) - this.tabContentWidth/2 + this.tabBoxWidth/2),
                yOffset: 0,
                animation: animate ? {
                    duration: animate ? 100 : 0,
                    curve: Curve.FastOutSlowIn
                } : false
            })
        }
    }
    // 触摸
    onFingerTouch(event: TouchEvent){
        switch (event.type){
            case TouchType.Down:
                this.startX = event.touches[0].x
                this.startTime = Date.now()
                break
            case TouchType.Move:
                let newOffset = event.touches[0].x - this.startX
                this.touchOffsetX = newOffset
                break
            case TouchType.Up:  // TODO 滑动较快时 会触发swiper change 暂不知条件
                // let time = (Date.now() - this.startTime) / 1000
                // let speed = Math.abs(this.touchOffsetX / time)
                // console.log("滑动距离", Math.abs(this.touchOffsetX), "时间 s", time, "速度 vp/s", speed)
                if(Math.abs(this.touchOffsetX) >= this.tabContentWidth/2){
                    let index = this.touchOffsetX > 0 ? this.swiperIndex - 1 : this.swiperIndex + 1
                    this.currentName = this.tabsList[index].name
                }else{
                    // console.log("未触发", Math.abs(this.touchOffsetX))
                    this.translateX = this.tabBoxTranslateX = this.startTransX
                }
                this.touchOffsetX = 0
                break
        }
    }
    build() {
        Column({ space: convertDimensionsWidthUnit(15) }){
            if(this.tabWidthType == "auto"){
                Scroll(this.scroller){
                    IBestTabBox({
                        currentName: $currentName,
                        translateX: this.translateX,
                        tabBoxWidth: this.tabBoxWidth,
                        tabBoxTranslateX: this.tabBoxTranslateX,
                        initSize: (): void => this.initSize(),
                        onTabClick: (name: string): void => this.onTabClick(name)
                    })
                }
                .scrollable(ScrollDirection.Horizontal)
                .scrollBar(BarState.Off)
                .align(Alignment.Start)
                .constraintSize({ maxHeight: getSizeByUnit(this.tabHeight) })
                .id(`tabContent_${this.uniId}`)
            }else{
                IBestTabBox({
                    currentName: $currentName,
                    translateX: this.translateX,
                    tabBoxWidth: this.tabBoxWidth,
                    tabBoxTranslateX: this.tabBoxTranslateX,
                    initSize: (): void => this.initSize(),
                    onTabClick: (name: string): void => this.onTabClick(name)
                }).id(`tabContent_${this.uniId}`)
            }
            // if(this.tabContent){
            //     Swiper(this.swiperController){
            //         this.tabContent()
            //     }
            //     .width(CONTAINER_SIZE.FULL)
            //     .indicator(false)
            //     .loop(false)
            //     .duration(200)
            //     .effectMode(EdgeEffect.None)
            //     .index($$this.swiperIndex)
            //     .monopolizeEvents(true)
            //     .onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
            //         let curOffset = extraInfo.currentOffset
            //         let transX = curOffset > 0 ? this.translateXList[index] - this.translateXList[index-1] : this.translateXList[index+1] - this.translateXList[index]
            //         let x = - curOffset*transX/this.tabContentWidth
            //         this.translateX = this.startTransX + x
            //     })
            //     .onTouch((event: TouchEvent) => {
            //         this.onFingerTouch(event)
            //     })
            //     .onChange((index: number) => {
            //         this.currentName = this.tabsList[index].name
            //     })
            // }
        }
        .width(CONTAINER_SIZE.FULL)
        .alignItems(HorizontalAlign.Start)
    }
}

@Component
struct IBestTabBox{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @Link currentName: string
    @Consume type: 'line' | 'card'
    @Consume tabWidthType: "auto" | "flex"
    @Consume tabHeight: number | string
    @Consume tabsList: IBestTabItem[]
    @Consume tabBgColor: ResourceColor
    @Consume tabLineWidth: number
    @Consume tabLineHeight: number | string
    @Consume tabLineColor: ResourceColor
    @Consume lineOffsetY: number | string
    @Prop translateX: number
    @Prop tabBoxTranslateX: number
    @Prop tabBoxWidth: number
    initSize: () => void = () => () => {}
    onTabClick: (name: string) => void = () => {}
    build() {
        Stack({alignContent: Alignment.BottomStart}){
            // 标记线
            if(this.type == "line"){
                Row()
                    .width(this.tabLineWidth)
                    .height(getSizeByUnit(this.tabLineHeight))
                    .backgroundColor(this.tabLineColor)
                    .translate({ x: this.translateX })
                    .animation({
                        duration: 100,
                        curve: Curve.FastOutSlowIn
                    })
                    .offset({ y: `-${getSizeByUnit(this.lineOffsetY)}` })
            }
            // 标记块
            if(this.type == "card"){
                Row()
                    .width(this.tabBoxWidth + 2)
                    .height(getSizeByUnit(this.tabHeight))
                    .backgroundColor(this.tabLineColor)
                    .translate({ x: this.tabBoxTranslateX })
                    .animation({
                        duration: 100,
                        curve: Curve.FastOutSlowIn
                    })
            }
            Row(){
                ForEach(this.tabsList, (item: IBestTabItem, index: number) => {
                    IBestTab({
                        item: item,
                        index: index,
                        currentName: $currentName,
                        initSize: this.initSize,
                        onTabClick: this.onTabClick
                    })
                }, (item: string, index: number) => index+'')
            }
            .width(this.tabWidthType == "flex" ? "100%" : "")
            .height(getSizeByUnit(this.tabHeight))
            .borderRadius(this.baseStyle.borderRadiusSm)
            .border({ width: this.type == "card" ? 1 : 0, color: this.tabLineColor })
        }
        .backgroundColor(this.tabBgColor)
    }
}

@Component
struct IBestTab{
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @Consume uniId: string
    @Consume type: 'line' | 'card'
    @Consume tabWidthType: "auto" | "flex"
    @ObjectLink @Watch("itemChange") item: IBestTabItem
    @Prop index: number
    @Link currentName: string
    @Consume tabPadding: number
    @Consume inactiveTextColor: ResourceColor
    @Consume activeTextColor: ResourceColor
    @Consume tabLineColor: ResourceColor
    @Consume fontSize: number
    initSize: () => void = () => {}
    onTabClick: (name: string) => void = () => {}
    itemChange(){
        this.initSize()
    }
    build() {
        Row() {
            Text(){
                if (this.item.icon) {
                    ImageSpan(this.item.icon)
                        .width(getSizeByUnit(this.fontSize))
                        .aspectRatio(1)
                        .verticalAlign(ImageSpanAlignment.CENTER)
                        .margin({right: this.baseStyle.spaceBase})
                }
                Span(this.item.label)
                if(typeof this.item.number !== "undefined"){
                    Span(`(${this.item.number})`)
                }
            }
            .height(CONTAINER_SIZE.FULL)
            .fontSize(getSizeByUnit(this.fontSize, true))
            .fontColor(this.currentName == this.item.name ? this.type == "card" ? "#fff" : this.activeTextColor :
                this.type == "card" ? this.tabLineColor : this.inactiveTextColor)
            .maxLines(1)
            .textOverflow({overflow: TextOverflow.Ellipsis})
            .id(`ibestTab_${this.uniId}_text_${this.item.name}`)
        }
        .justifyContent(FlexAlign.Center)
        .padding({left: getSizeByUnit(this.tabPadding), right: getSizeByUnit(this.tabPadding)})
        .layoutWeight(this.tabWidthType == "flex" ? 1 : 0)
        .border({ width: { left: this.type == "card" && this.index > 0 ? 1 : 0 }, color: this.tabLineColor })
        .enabled(!this.item.isDisable)
        .opacity(this.item.isDisable ? 0.3 : 1)
        .id(`ibestTab_${this.uniId}_box_${this.item.name}`)
        .onClick(() => {
            this.currentName = this.item.name
            this.onTabClick(this.item.name)
        })
    }
}
