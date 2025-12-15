import { convertDimensionsWidthUnit, getComponentsInfo, getSizeByUnit, sleep } from '../../utils/utils';
import { IBestTabController, IBestTabItem, IBestTabItemType, TabWidthType } from './index.type';
import { getDefaultBaseStyle } from '../../theme-chalk/src';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { debounce } from '../../utils/debounceThrottle'
import { IBestTabColor } from './color';
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type';
import { IBestIcon } from '../../../../../Index';

@Component
export struct IBestTabs{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
    @StorageProp(IBestStorageKey.IS_LANDSCAPE) @Watch("onDidBuild") isLandscape: boolean = false
	/**
	 * 当前激活的tab的name
	 */
	@Link @Watch("currentNameChange") currentName: IBestStringNumber
    /**
     * 样式类型
     */
    @Provide({allowOverride: "type"}) type: 'line' | 'card' = "line"
    /**
     * tab高度
     */
    @Provide({allowOverride: "tabHeight"}) tabHeight: IBestStringNumber = convertDimensionsWidthUnit(35)
    /**
     * tab宽度类型
     */
    @Provide({allowOverride: "tabWidthType"}) tabWidthType: "auto" | "flex" = "flex"
    /**
     * tab列表
     */
    @Provide({ allowOverride: "tabsList" }) @Watch("tabsListChange") tabsList: (IBestTabItemType | IBestTabItem)[] = []
    /**
     * 单个tab内边距
     */
    @Provide({allowOverride: "tabPadding"}) tabPadding: IBestStringNumber = this.baseStyle.spaceXs as string
	/**
	 * 是否显示标记线, 仅type为 `line` 时有效
	 * @since 2.0.9
	 */
	@Prop showActiveLine: boolean = true
    /**
     * 标记线宽度是否固定
     */
    @Prop isTabLineWidthFixed: boolean = false
    /**
     * 标记线宽度, isTabLineWidthFixed 为true时有效
     */
    @Prop tabLineWidth: IBestStringNumber = 0
    /**
     * 标记线高度
     */
    @Prop tabLineHeight: IBestStringNumber = convertDimensionsWidthUnit(2)
	/**
	 * 标记线圆角
	 * @since 2.0.9
     */
	@Prop tabLineRadius: IBestStringNumber = 0
    /**
     * 未激活的tab文字颜色
     */
    @Provide({allowOverride: "inactiveTextColor"}) inactiveTextColor: ResourceColor = IBestTabColor.inactiveTextColor
    /**
     * 激活的tab文字颜色
     */
    @Provide({allowOverride: "activeTextColor"}) activeTextColor: ResourceColor = IBestTabColor.activeTextColor
    /**
     * type 为 `line` 时, 为标记线颜色, type 为 `card` 时, 为标记块背景色
     */
    @Provide({allowOverride: "tabLineColor"}) tabLineColor: ResourceColor = ""
    /**
     * 标记线Y偏移量
     */
    @Provide({allowOverride: "lineOffsetY"}) lineOffsetY: IBestStringNumber = 0
    /**
     * tab区域背景颜色
     */
    @Provide({allowOverride: "tabBgColor"}) tabBgColor: ResourceColor = IBestTabColor.bgColor
    /**
     * 默认字体大小
     * @since 1.15.0
     */
    @Provide({allowOverride: "fontSize"}) fontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 是否显示激活背景, 仅type为`line`时有效
     * @since 2.0.5
     */
    @Provide({allowOverride: "isShowActiveBg"}) isShowActiveBg: boolean = false
    /**
     * 激活背景色, 仅type为`line`时有效
     * @since 2.0.5
     */
    @Provide({allowOverride: "activeBgColor"}) activeBgColor: ResourceColor = ""
    /**
     * 非激活背景色, 仅type为`line`时有效
     * @since 2.0.5
     */
    @Provide({allowOverride: "inactiveBgColor"}) inactiveBgColor: ResourceColor = ""
    /**
     * 选项圆角, 仅type为`line`时有效
     * @since 2.0.5
     */
    @Provide({allowOverride: "radius"}) radius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0
	/**
	 * 激活文字字重
	 * @since 2.0.9
     */
	@Provide({allowOverride: "activeFontWeight"}) activeFontWeight: FontWeight = FontWeight.Normal
	/**
	 * 激活文字大小
	 * @since 2.0.9
     */
	@Provide({allowOverride: "activeFontSize"}) activeFontSize: IBestStringNumber = this.fontSize
    /**
     * 外侧圆角
     * @since 2.1.5
     */
    @Provide({allowOverride: "outerRadius"}) outerRadius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0
	/**
	 * tabContent 内容
	 * @since 2.0.9
	 */
	@BuilderParam tabContentBuilder: CustomBuilder
	/**
     * onChange事件回调
     */
    onChange: (name: IBestStringNumber) => void = () => {}
    /**
     * 点击事件
     * @since 1.17.0
     */
    onTabClick: (name: IBestStringNumber) => void = () => {}
    /**
     * controller 控制器
	 * @deprecated
     */
	private tabController: IBestTabController = new IBestTabController()

	// 唯一id
	@Provide uniId: number = 0
    @Provide isReady: boolean = false
	// tab盒子宽度
	@State tabContentWidth: number = 0
	// tab宽度列表
	@State tabsWidthList: TabWidthType[] = []
	// 标记线位移列表
	@State translateXList: number[] = []
	// 标记块宽度
	@State tabBoxWidth: number = 0
	// 标记线X偏移量
	@State translateX: number = 0
	// 标记块X偏移量
	@State tabBoxTranslateX: number = 0
    @State swiperIndex: number = 0
    @State startTransX: number = 0
    private scroller: Scroller = new Scroller()
    private context: UIContext = this.getUIContext()
    private swiperController: SwiperController = new SwiperController()

	@Builder tabBoxBuilder(showId: boolean = false){
		Stack({alignContent: Alignment.BottomStart}){
			// 标记块
			if(this.isShowActiveBg || this.type == "card"){
				Row()
					.width(this.tabBoxWidth)
					.height(getSizeByUnit(this.tabHeight))
					.backgroundColor(this.getLineColor())
					.borderRadius(this.type == "line" ? getSizeByUnit(this.radius) : 0)
					.translate({ x: this.tabBoxTranslateX })
					.animation({
						duration: this.isReady ? 100 : 0,
						curve: Curve.FastOutSlowIn
					})
			}
			Row(){
				ForEach(this.tabsList, (item: IBestTabItem, index: number) => {
					IBestTab({
						item: item,
						index: index,
						currentName: this.currentName,
						initSize: (): void => this.initSize(),
						onTabClick: (name: IBestStringNumber): void => this.onTabClick(name)
					})
				}, (_: IBestTabItem, index: number) => index+'')
			}
			.width(this.tabWidthType == "flex" ? CONTAINER_SIZE.FULL : "")
			.height(getSizeByUnit(this.tabHeight))
			.borderRadius(this.outerRadius || this.baseStyle.borderRadiusSm)
			.border({ width: this.type == "card" ? 1 : 0, color: this.getLineColor() })
			// 标记线
			if(this.type == "line" && this.showActiveLine){
				Row()
					.width(this.isTabLineWidthFixed ? getSizeByUnit(this.tabLineWidth) : this.tabLineWidth)
					.height(getSizeByUnit(this.tabLineHeight))
					.backgroundColor(this.getLineColor())
					.borderRadius(getSizeByUnit(this.tabLineRadius))
					.translate({ x: this.translateX })
					.animation({
						duration: this.isReady ? 100 : 0,
						curve: Curve.FastOutSlowIn
					})
					.offset({ y: `-${getSizeByUnit(this.lineOffsetY)}` })
					.id(`ibest_tab_line_${this.uniId}`)
			}
		}
		.backgroundColor(this.tabBgColor)
		.id(showId ? `ibest_tabContent_${this.uniId}` : "")
	}

    aboutToAppear(): void {
        this.uniId = this.getUniqueId()
        this.tabController.changeTab = (name: IBestStringNumber): void => this.changeTab(name)
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
        setTimeout(() => {
            this.isReady = true
        }, 100)
    }, 200)
    // 列表变化
    tabsListChange(){
        sleep(20).then(() => {
            this.getTabsWidth()
        })
    }
    // tabName 变化
    async currentNameChange(){
        if(this.tabsWidthList.length != this.tabsList.length){
            this.getTabsWidth()
        }
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
        this.swiperController.changeIndex(index, animated)
    }
    // 切换name
    changeTab(name: IBestStringNumber){
        if(this.tabsList.some((item: IBestTabItem) => item.name == name)){
            this.currentName = name
        }
    }
    // 获取所有tab的宽度
    getTabsWidth(){
        let tabWidthList: TabWidthType[] = []
        let translateXList: number[] = []
        let tabContentInfo = getComponentsInfo(this.context, `ibest_tabContent_${this.uniId}`)
        this.tabsList.forEach((item: IBestTabItem) => {
            let boxInfo = getComponentsInfo(this.context, `ibest_tab_box_${this.uniId}_${item.name}`)
            let textInfo = getComponentsInfo(this.context, `ibest_tab_text_${this.uniId}_${item.name}`)
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
            }
            if(this.isShowActiveBg || this.type == "card"){
                this.tabBoxWidth = tabInfo.boxWidth
                this.startTransX = this.tabBoxTranslateX = tabInfo.boxLocalLeft
            }
        }
    }
	getLineColor(){
		return this.tabLineColor || this.baseStyle.primary
	}
    getTabLineWidth(){
        return getComponentsInfo(this.context, `ibest_tab_line_${this.uniId}`).width
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
    build() {
        Column(){
            if(this.tabWidthType == "auto"){
                Scroll(this.scroller){
					this.tabBoxBuilder()
                }
                .scrollable(ScrollDirection.Horizontal)
                .scrollBar(BarState.Off)
                .align(Alignment.Start)
                .constraintSize({ maxHeight: getSizeByUnit(this.tabHeight) })
                .id(`ibest_tabContent_${this.uniId}`)
            }else{
				this.tabBoxBuilder(true)
            }
            if(this.tabContentBuilder){
                Swiper(this.swiperController){
                    this.tabContentBuilder()
                }
                .width(CONTAINER_SIZE.FULL)
                .indicator(false)
                .loop(false)
                .duration(200)
                .effectMode(EdgeEffect.None)
                .index($$this.swiperIndex)
				.onGestureSwipe((index: number, extraInfo: SwiperAnimationEvent) => {
					let curOffset = extraInfo.currentOffset
					let transX = curOffset > 0 ? this.translateXList[index] - this.translateXList[index-1] : this.translateXList[index+1] - this.translateXList[index]
					let x = - curOffset * transX / this.tabContentWidth
					this.translateX = this.startTransX + x
				})
				.onAnimationStart((index, target, extraInfo) => {
					// 获取速度
					let speed = extraInfo.velocity * -1;
					let transX = extraInfo.currentOffset > 0 ? this.translateXList[index] - this.translateXList[index-1] : this.translateXList[index+1] - this.translateXList[index];
					let x = - extraInfo.currentOffset * transX / this.tabContentWidth
					// 获取剩余时间
					let duration = x / speed;
					if(index != target){
						this.currentName = this.tabsList[target].name
					}
					this.context.animateTo({duration: duration}, () => {
						this.translateX = this.translateXList[target]
					})
				})
            }
        }
        .width(CONTAINER_SIZE.FULL)
        .alignItems(HorizontalAlign.Start)
        .borderRadius(getSizeByUnit(this.outerRadius))
        .clip(true)
    }
}

@Component
struct IBestTab{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @Consume uniId: number
    @Consume type: 'line' | 'card'
    @Consume tabWidthType: "auto" | "flex"
    @ObjectLink @Watch("itemChange") item: IBestTabItem
    @Prop index: number
    @Link currentName: IBestStringNumber
    @Consume tabPadding: number
    @Consume inactiveTextColor: ResourceColor
    @Consume activeTextColor: ResourceColor
    @Consume tabLineColor: ResourceColor
    @Consume fontSize: number
    @Consume isShowActiveBg: boolean
    @Consume activeBgColor: ResourceColor
    @Consume inactiveBgColor: ResourceColor
    @Consume radius: Length | BorderRadiuses | LocalizedBorderRadiuses
	@Consume activeFontWeight: FontWeight
	@Consume activeFontSize: IBestStringNumber
    initSize: () => void = () => {}
    onTabClick: (name: IBestStringNumber) => void = () => {}
    itemChange(){
        this.initSize()
    }
	getIsActive(){
		return this.currentName == this.item.name
	}
    getLineColor(){
        return this.tabLineColor || this.baseStyle.primary
    }
    getFontColor(){
        return this.getIsActive() ? this.type == "card" ? "#fff" : this.activeTextColor : this.type == "card" ? this.getLineColor() : this.inactiveTextColor
    }
    build() {
        Row() {
            Row({space: this.baseStyle.spaceBase}){
                if(this.item.icon && (!this.item.iconPosition || this.item.iconPosition == "left")) {
                    IBestIcon({
                        name: this.item.icon,
                        iconSize: this.fontSize,
                        color: this.getFontColor()
                    })
                }
                Text(){
                    Span(this.item.label)
                    if(typeof this.item.number !== "undefined"){
                        Span(`(${this.item.number})`)
                    }
                }
                .height(CONTAINER_SIZE.FULL)
                .fontSize(getSizeByUnit(this.getIsActive() ? this.activeFontSize : this.fontSize, true))
                .fontColor(this.getFontColor())
                .maxLines(1)
                .textOverflow({overflow: TextOverflow.Ellipsis})
				.fontWeight(this.getIsActive() ? this.activeFontWeight : FontWeight.Normal)
                if(this.item.icon && this.item.iconPosition == "right") {
                    IBestIcon({
                        name: this.item.icon,
                        iconSize: this.fontSize,
                        color: this.getFontColor()
                    })
                }
            }
            .id(`ibest_tab_text_${this.uniId}_${this.item.name}`)
        }
        .backgroundColor(this.type == "line" && this.isShowActiveBg ? this.getIsActive() ? this.activeBgColor : this.inactiveBgColor : "")
        .justifyContent(FlexAlign.Center)
        .padding({left: getSizeByUnit(this.tabPadding), right: getSizeByUnit(this.tabPadding)})
        .layoutWeight(this.tabWidthType == "flex" ? 1 : 0)
        .borderRadius(this.type == "line" ? getSizeByUnit(this.radius) : 0)
        .border({ width: { left: this.type == "card" && this.index > 0 ? 1 : 0 }, color: this.getLineColor() })
        .clip(true)
        .enabled(!this.item.isDisable)
        .opacity(this.item.isDisable ? 0.3 : 1)
        .id(`ibest_tab_box_${this.uniId}_${this.item.name}`)
        .onClick(() => {
            this.currentName = this.item.name
            this.onTabClick(this.item.name)
        })
    }
}
