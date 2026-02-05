import { generateId, getEventName, getResourceStr, getSizeByUnit } from '../../utils/utils'
import { AnyType } from '../../model/AnyType'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import ibestEmitter from '../../utils/eventEmitter'
import { IBestTableColor } from './color'
import { COMPONENT_NAME, IBestCellPosition, IBestTableColumnData, IBestTableColumnInfo, TABLE_EVENT_NAME } from './index.type'

@Extend(Scroll) function ibestTableFixScrollStyle(position: string){
    .scrollBar(BarState.Off)
    .edgeEffect(EdgeEffect.None)
    .position(position == 'left' ? {left: 0, top: 0} : {right: 0, top: 0})
}

@Component
export struct IBestTable {
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 表格id
     */
    @Prop @Require tableId: IBestStringNumber
    /**
     * 表格数据
     */
    @ObjectLink data: AnyType[]
    /**
     * 斑马纹
     */
    @Provide({allowOverride: "stripe"}) stripe: boolean = false
    /**
     * 是否显示纵向边框
     */
    @Provide({allowOverride: 'showBorder'}) showBorder: boolean = false
    /**
     * 高度
     */
    @Prop fixHeight: IBestStringNumber = ""
    /**
     * 最大高度
     */
    @Prop maxHeight: IBestStringNumber
    /**
     * 表头背景色
     */
    @Provide({allowOverride: 'headerBgColor'}) headerBgColor: ResourceColor = IBestTableColor.headerBgColor
    /**
     * 表头文字颜色
     */
    @Provide({allowOverride: 'headerTextColor'}) headerTextColor: ResourceColor = IBestTableColor.headerTextColor
    /**
     * 表头文字大小
     */
    @Provide({allowOverride: 'headerFontSize'}) headerFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 边框色
     */
    @Provide({allowOverride: 'bdColor'}) bdColor: ResourceColor = IBestTableColor.borderColor
    /**
     * 单元格背景颜色
     */
    @Provide({allowOverride: 'cellBgColor'}) cellBgColor: ResourceColor = IBestTableColor.cellBgColor
    /**
     * 斑马纹背景色
     */
    @Provide({allowOverride: 'stripeBgColor'}) stripeBgColor: ResourceColor = IBestTableColor.cellStripeColor
    /**
     * 单元格文字颜色
     */
    @Provide({allowOverride: 'cellTextColor'}) cellTextColor: ResourceColor = IBestTableColor.cellTextColor
    /**
     * 单元格文字大小
     */
    @Provide({allowOverride: 'cellFontSize'}) cellFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
    /**
     * 单元格内边距
     */
    @Provide({allowOverride: 'cellPadding'}) cellPadding: Length | Padding | LocalizedPadding = { left: this.baseStyle.spaceX, right: this.baseStyle.spaceX, bottom: this.baseStyle.spaceXs, top: this.baseStyle.spaceXs }
    /**
     * 是否显示合计
     */
    @Prop showSummary: boolean = false
    /**
     * 显示摘要行第一列的文本
     */
    @Provide({allowOverride: 'sumText'}) sumText: ResourceStr = $r("app.string.ibest_text_sum")
    /**
     * 滚动条状态
     * @since 2.2.6
     */
    @Prop scrollBarState: BarState = BarState.Auto
    /**
     * 自定义合计函数
     */
    summaryMethod?: (data: AnyType[], column: IBestTableColumnData) => IBestStringNumber[]
    /**
     * 合并行列计算方法
     * @since 2.2.5
     */
    spanMethod: (row: AnyType, column: IBestTableColumnData, rowIndex: number, columnIndex: number) => number[] = () => [1,1]
    /**
     * 默认插槽
     */
    @BuilderParam defaultBuilder: CustomBuilder

    @State uniId: number = 0
    @State columnList: IBestTableColumnInfo[] = []
    @State leftFixedColumnList: IBestTableColumnInfo[] = []
    @State rightFixedColumnList: IBestTableColumnInfo[] = []
    @Provide rowHeightList: number[] = Array(this.data.length).fill(0)
    @Provide columnWidthList: number[] = []
    @State headerHeight: number = 0
    @State footerHeight: number = 0
    private headerScroller: Scroller = new Scroller()
    private headerScrollSource: ScrollSource = -1
    private bodyHorizontalScroller: Scroller = new Scroller()
    private bodyHorScrollSource: ScrollSource = -1
    private bodyVerticalScroller: Scroller = new Scroller()
    private bodyVerScrollSource: ScrollSource = -1
    private leftFixedBodyScroller: Scroller = new Scroller()
    private leftFixedBodyScrollSource: ScrollSource = -1
    private rightFixedBodyScroller: Scroller = new Scroller()
    private rightFixedBodyScrollSource: ScrollSource = -1
    private footerScroller: Scroller = new Scroller()
    private footerScrollSource: ScrollSource = -1
    private scrollSourceList: ScrollSource[] = [ScrollSource.DRAG, ScrollSource.FLING, ScrollSource.OTHER_USER_INPUT, ScrollSource.SCROLL_BAR, ScrollSource.SCROLL_BAR_FLING]
    private scrollSourceList1: ScrollSource[] = [-1, ScrollSource.SCROLLER, ScrollSource.SCROLLER_ANIMATION]
    private timer: number = -1

    @Builder headerBuilder(position: IBestCellPosition){
		HeaderCellRow({
			cellPosition: position,
            columnList: this.getColumnList(position),
            isMultiLevelHeader: this.getIsMultiLevelHeader(),
            headerHeight: this.headerHeight,
            isFirstLevel: true
		})
    }
    @Builder bodyBuilder(position: IBestCellPosition){
        Column(){
            ForEach(this.data, (item: AnyType, index: number) => {
                BodyCellRow({
                    cellPosition: position,
                    item,
                    rowIndex: index,
                    columnList: this.getColumnList(position),
                    isMultiLevelHeader: this.getIsMultiLevelHeader(),
                    isFirstLevel: true,
                    spanMethod: this.spanMethod
                })
            }, (_: AnyType, index: number) => `${generateId()}_${index}`)
        }
        .alignItems(HorizontalAlign.Start)
    }
    @Builder footerBuilder(position: IBestCellPosition){
        FooterCellRow({
            data: this.data,
            cellPosition: position,
            columnList: this.getColumnList(position),
            isMultiLevelHeader: this.getIsMultiLevelHeader(),
            summaryMethod: this.summaryMethod
        })
    }
    @Styles ibestTableFixBodyStyle(){
        .height(this.fixHeight ? CONTAINER_SIZE.FULL : '')
        .constraintSize({maxHeight: this.maxHeight ? `calc(${getSizeByUnit(this.maxHeight)} - ${this.headerHeight}vp - ${this.footerHeight}vp)` : undefined})
        .align(Alignment.Start)
    }

    aboutToAppear() {
        this.uniId = this.getUniqueId()
        ibestEmitter.on(getEventName(COMPONENT_NAME, TABLE_EVENT_NAME.SEND_COLUMN_ITEM, this.tableId), this.uniId, (column: IBestTableColumnInfo): void => this.getColumn(column))
        ibestEmitter.on(getEventName(COMPONENT_NAME, TABLE_EVENT_NAME.COLUMN_ITEM_CHANGE, this.tableId), this.uniId, (column: IBestTableColumnInfo): void => this.updateColumn(column))
    }
    aboutToDisappear(): void {
        ibestEmitter.off(getEventName(COMPONENT_NAME, TABLE_EVENT_NAME.SEND_COLUMN_ITEM, this.tableId), this.uniId)
		ibestEmitter.off(getEventName(COMPONENT_NAME, TABLE_EVENT_NAME.COLUMN_ITEM_CHANGE, this.tableId), this.uniId)
    }
    getColumn(column: IBestTableColumnInfo){
        if(column.parentProp){
            this.insertDataByProp(this.columnList, column)
        }else {
            this.columnList.push(new IBestTableColumnInfo(column))
        }
        clearTimeout(this.timer)
        this.timer = setTimeout(() => {
            this.leftFixedColumnList = this.columnList.filter(e => (typeof e.fixed == 'boolean' && e.fixed || e.fixed == 'left') && !column.parentProp)
            this.rightFixedColumnList = this.columnList.filter(e => typeof e.fixed == 'string' && e.fixed == 'right' && !column.parentProp)
            this.columnWidthList = Array(this.columnList.length).fill(0)
        }, 0)
    }
    insertDataByProp(list: IBestTableColumnInfo[], data: IBestTableColumnInfo) {
        let targetData: IBestTableColumnInfo | null = null
        const findNodes = (node: IBestTableColumnInfo) => {
            if (node.prop === data.parentProp) {
                targetData = node
            }
            if(targetData){
                return true
            }
            if (node.children && node.children.length) {
                for (let i = 0; i < node.children.length; i++) {
                    if (findNodes(node.children[i])) {
                        return true
                    }
                }
            }
            return false
        }
        for (let i = 0; i < list.length; i++) {
            if (findNodes(list[i])) {
                break
            }
        }
        if (!targetData) {
            console.error(`未找到prop为${data.parentProp}的列`)
            return data
        }
        (targetData as IBestTableColumnInfo).children!.push(new IBestTableColumnInfo(data))
        return data
    }
    updateColumn(column: IBestTableColumnInfo){
        let item = this.columnList.find(e => e.prop == column.prop)
        if(item){
            item.show = column.show
        }
        if(this.leftFixedColumnList){
            let leftItem = this.leftFixedColumnList.find(e => e.prop == column.prop)
            if(leftItem){
                leftItem.show = column.show
            }
        }
        if(this.rightFixedColumnList){
            let rightItem = this.rightFixedColumnList.find(e => e.prop == column.prop)
            if(rightItem){
                rightItem.show = column.show
            }
        }
    }
    getColumnList(position: IBestCellPosition){
        return position == 'left' ? this.leftFixedColumnList : position == 'right' ? this.rightFixedColumnList : this.columnList
    }
    getBodyShow(){
        return this.columnWidthList.length && this.columnWidthList.every(e => e > 0) && this.rowHeightList.every(e => e > 0)
    }
    getIsMultiLevelHeader(){
        return this.columnList.some(e => e.children.length)
    }
    setScrollSource(cellType: 'header' | 'left-body' | 'body-ver' | 'body-hor' | 'right-body' | 'footer', scrollSource: ScrollSource){
        switch (cellType){
            case 'header':
                this.headerScrollSource = scrollSource
                break
            case 'left-body':
                this.leftFixedBodyScrollSource = scrollSource
                break
            case 'body-ver':
                this.bodyVerScrollSource = scrollSource
                break
            case 'body-hor':
                this.bodyHorScrollSource = scrollSource
                break
            case 'right-body':
                this.rightFixedBodyScrollSource = scrollSource
                break
            case 'footer':
                this.footerScrollSource = scrollSource
                break
        }
    }
    onDidScroll(cellType: 'header' | 'left-body' | 'body-ver' | 'body-hor' | 'right-body' | 'footer', offset: number){
        switch (cellType){
            case 'header':
                if(this.scrollSourceList.includes(this.headerScrollSource)){
                    if(this.scrollSourceList1.includes(this.bodyHorScrollSource)){
                        this.bodyHorizontalScroller.scrollBy(offset, 0)
                    }
                    if(this.showSummary && this.scrollSourceList1.includes(this.footerScrollSource)) {
                        this.footerScroller.scrollBy(offset, 0)
                    }
                }
                break
            case 'left-body':
                if(this.scrollSourceList.includes(this.leftFixedBodyScrollSource)){
                    if(this.scrollSourceList1.includes(this.bodyVerScrollSource)){
                        this.bodyVerticalScroller.scrollBy(0, offset)
                    }
                    if(this.rightFixedColumnList.length && this.scrollSourceList1.includes(this.rightFixedBodyScrollSource)){
                        this.rightFixedBodyScroller.scrollBy(0, offset)
                    }
                }
                break
            case 'body-ver':
                if(this.scrollSourceList.includes(this.bodyVerScrollSource)) {
                    if(this.leftFixedColumnList.length && this.scrollSourceList1.includes(this.leftFixedBodyScrollSource)) {
                        this.leftFixedBodyScroller.scrollBy(0, offset)
                    }
                    if(this.rightFixedColumnList.length && this.scrollSourceList1.includes(this.rightFixedBodyScrollSource)) {
                        this.rightFixedBodyScroller.scrollBy(0, offset)
                    }
                }
                break
            case 'body-hor':
                if(this.scrollSourceList.includes(this.bodyHorScrollSource)) {
                    if(this.scrollSourceList1.includes(this.headerScrollSource)){
                        this.headerScroller.scrollBy(offset, 0)
                    }
                    if(this.showSummary && this.scrollSourceList1.includes(this.footerScrollSource)) {
                        this.footerScroller.scrollBy(offset, 0)
                    }
                }
                break
            case 'right-body':
                if(this.scrollSourceList.includes(this.rightFixedBodyScrollSource)) {
                    if(this.leftFixedColumnList.length && this.scrollSourceList1.includes(this.leftFixedBodyScrollSource)) {
                        this.leftFixedBodyScroller.scrollBy(0, offset)
                    }
                    if(this.scrollSourceList1.includes(this.bodyVerScrollSource)){
                        this.bodyVerticalScroller.scrollBy(0, offset)
                    }
                }
                break
            case 'footer':
                if(this.scrollSourceList.includes(this.footerScrollSource)){
                    if(this.scrollSourceList1.includes(this.headerScrollSource)){
                        this.headerScroller.scrollBy(offset, 0)
                    }
                    if(this.scrollSourceList1.includes(this.bodyHorScrollSource)){
                        this.bodyHorizontalScroller.scrollBy(offset, 0)
                    }
                }
                break
        }
    }

    build() {
        Column(){
            Row(){
                Scroll(this.headerScroller){
					this.headerBuilder('body')
                }
                .width(CONTAINER_SIZE.FULL)
                .align(Alignment.Start)
                .scrollable(ScrollDirection.Horizontal)
                .scrollBar(BarState.Off)
                .edgeEffect(EdgeEffect.None)
                .onWillScroll((_: number, _yOffset: number, _scrollState: ScrollState, scrollSource: ScrollSource) => {
                    this.setScrollSource('header', scrollSource)
                })
                .onDidScroll((xOffset: number) => {
                    this.onDidScroll('header', xOffset)
                })
                .onScrollStop(() => {
                    this.setScrollSource('header', -1)
                })
                if(this.leftFixedColumnList.length){
					this.headerBuilder('left')
                }
                if(this.rightFixedColumnList.length){
					this.headerBuilder('right')
                }
            }
            .width(CONTAINER_SIZE.FULL)
            .onAreaChange((_: Area, newValue: Area) => {
                this.headerHeight = newValue.height as number
            })
            if(this.columnWidthList.length){
                Row(){
                    Scroll(this.bodyVerticalScroller){
                        Scroll(this.bodyHorizontalScroller){
                            this.bodyBuilder('body')
                        }
                        .width(CONTAINER_SIZE.FULL)
                        .align(Alignment.Start)
                        .scrollBar(this.scrollBarState)
                        .scrollable(ScrollDirection.Horizontal)
                        .edgeEffect(EdgeEffect.None)
                        .nestedScroll({
                            scrollForward: NestedScrollMode.SELF_FIRST,
                            scrollBackward: NestedScrollMode.SELF_FIRST
                        })
                        .onWillScroll((_: number, _yOffset: number, _scrollState: ScrollState, scrollSource: ScrollSource) => {
                            this.setScrollSource('body-hor', scrollSource)
                        })
                        .onDidScroll((xOffset: number) => {
                            this.onDidScroll('body-hor', xOffset)
                        })
                        .onScrollStop(() => {
                            this.setScrollSource('body-hor', -1)
                        })
                    }
                    .ibestTableFixBodyStyle()
                    .scrollBar(this.scrollBarState)
                    .scrollable(this.fixHeight || this.maxHeight ? ScrollDirection.Vertical : ScrollDirection.None)
                    .edgeEffect(EdgeEffect.None)
                    .nestedScroll({
                        scrollForward: NestedScrollMode.SELF_FIRST,
                        scrollBackward: NestedScrollMode.SELF_FIRST
                    })
                    .onWillScroll((_: number, _yOffset: number, _scrollState: ScrollState, scrollSource: ScrollSource) => {
                        this.setScrollSource('body-ver', scrollSource)
                    })
                    .onDidScroll((_xOffset: number, yOffset: number) => {
                        this.onDidScroll('body-ver', yOffset)
                    })
                    .onScrollStop(() => {
                        this.setScrollSource('body-ver', -1)
                    })
                    if(this.leftFixedColumnList.length){
                        Scroll(this.leftFixedBodyScroller){
                            this.bodyBuilder('left')
                        }
                        .ibestTableFixBodyStyle()
                        .ibestTableFixScrollStyle('left')
                        .onWillScroll((_: number, _yOffset: number, _scrollState: ScrollState, scrollSource: ScrollSource) => {
                            this.setScrollSource('left-body', scrollSource)
                        })
                        .onDidScroll((_xOffset: number, yOffset: number) => {
                            this.onDidScroll('left-body', yOffset)
                        })
                        .onScrollStop(() => {
                            this.setScrollSource('left-body', -1)
                        })
                    }
                    if(this.rightFixedColumnList.length){
                        Scroll(this.rightFixedBodyScroller) {
                            this.bodyBuilder('right')
                        }
                        .ibestTableFixBodyStyle()
                        .ibestTableFixScrollStyle('right')
                        .onWillScroll((_: number, _yOffset: number, _scrollState: ScrollState, scrollSource: ScrollSource) => {
                            this.setScrollSource('right-body', scrollSource)
                        })
                        .onDidScroll((_xOffset: number, yOffset: number) => {
                            this.onDidScroll('right-body', yOffset)
                        })
                        .onScrollStop(() => {
                            this.setScrollSource('right-body', -1)
                        })
                    }
                }
                .width(CONTAINER_SIZE.FULL)
                .layoutWeight(this.fixHeight ? 1 : undefined)
                .visibility(this.getBodyShow() ? Visibility.Visible : Visibility.Hidden)
                .animation({duration: this.baseStyle.animationDuration as number})
                if(this.showSummary){
                    Row(){
                        Scroll(this.footerScroller){
                            this.footerBuilder('body')
                        }
                        .width(CONTAINER_SIZE.FULL)
                        .align(Alignment.Start)
                        .scrollable(ScrollDirection.Horizontal)
                        .scrollBar(BarState.Off)
                        .edgeEffect(EdgeEffect.None)
                        .onWillScroll((_: number, _yOffset: number, _scrollState: ScrollState, scrollSource: ScrollSource) => {
                            this.setScrollSource('footer', scrollSource)
                        })
                        .onDidScroll((xOffset: number) => {
                            this.onDidScroll('footer', xOffset)
                        })
                        .onScrollStop(() => {
                            this.setScrollSource('footer', -1)
                        })
                        if(this.leftFixedColumnList.length){
                            this.footerBuilder('left')
                        }
                        if(this.rightFixedColumnList.length){
                            this.footerBuilder('right')
                        }
                    }
                    .width(CONTAINER_SIZE.FULL)
                    .visibility(this.getBodyShow() ? Visibility.Visible : Visibility.Hidden)
                    .animation({duration: this.baseStyle.animationDuration as number})
                    .onAreaChange((_: Area, newValue: Area) => {
                        this.footerHeight = newValue.height as number
                    })
                }
            }
            if(this.defaultBuilder){
                this.defaultBuilder()
            }
        }
        .width(CONTAINER_SIZE.FULL)
        .height(getSizeByUnit(this.fixHeight))
        .border({
            width: {
                left: this.showBorder || this.getIsMultiLevelHeader() ? 1 : 0,
                top: 1
            },
            color: this.bdColor
        })
        .constraintSize({maxHeight: getSizeByUnit(this.maxHeight)})
    }
}

@Component
struct HeaderCellRow{
	@Prop @Require cellPosition: IBestCellPosition
    @ObjectLink columnList: IBestTableColumnInfo[]
    @Prop @Require isMultiLevelHeader: boolean = false
    @Prop headerHeight: number = 0
    @Prop isFirstLevel: boolean = false
	@Consume bdColor: ResourceColor
	@Consume headerBgColor: ResourceColor

	@State rowHeight: number = 0

	build() {
        Row(){
            ForEach(this.columnList, (column: IBestTableColumnInfo, index: number) => {
                TableCell({
                    cellType: 'header',
                    pos: this.cellPosition,
                    column: column,
                    columnIndex: index,
                    isMultiLevelHeader: this.isMultiLevelHeader,
                    rowHeight: this.rowHeight,
                    headerBuilder: column.headerBuilder,
                    cellBuilder: column.cellBuilder
                })
            })
        }
        .height(this.headerHeight || "auto")
        .backgroundColor(this.headerBgColor)
        .position(!this.isFirstLevel || this.cellPosition == 'body' ? undefined : this.cellPosition == 'left' ? {left: 0, top: 0} : {right: 0, top: 0})
        .onAreaChange((oldValue: Area, newValue: Area) => {
            if(newValue.height != oldValue.height){
                this.rowHeight = newValue.height as number
            }
        })
	}
}

@Component
struct BodyCellRow{
	@Prop @Require cellPosition: IBestCellPosition
	@Require item: AnyType
	@Prop @Require rowIndex: number
    @Prop columnIndex: number
    @ObjectLink columnList: IBestTableColumnInfo[]
    @Prop @Require isMultiLevelHeader: boolean = false
    @Prop isFirstLevel: boolean = false
    @Consume rowHeightList: number[]
	@Consume bdColor: ResourceColor
	@Consume stripe: boolean
	@Consume stripeBgColor: ResourceColor
	@Consume cellBgColor: ResourceColor
    spanMethod: (row: AnyType, column: IBestTableColumnData, rowIndex: number, columnIndex: number) => number[] = () => [1,1]

    @State rowHeight: number = 0

	build() {
		Row(){
			ForEach(this.columnList, (column: IBestTableColumnInfo, index: number) => {
				TableCell({
					cellType: 'body',
					pos: this.cellPosition,
					item: this.item,
					rowIndex: this.rowIndex,
					column: column,
					columnIndex: this.columnIndex ?? index,
                    isMultiLevelHeader: this.isMultiLevelHeader,
					rowHeight: this.rowHeight,
					headerBuilder: column.headerBuilder,
					cellBuilder: column.cellBuilder,
                    spanMethod: this.spanMethod
				})
			})
		}
        .height(this.rowHeightList[this.rowIndex] || "")
        .alignItems(VerticalAlign.Top)
		.onAreaChange((oldValue: Area, newValue: Area) => {
            if(oldValue.height != newValue.height){
				this.rowHeight = newValue.height as number
                if(this.cellPosition == 'body' && this.isFirstLevel){
                    this.rowHeightList[this.rowIndex] = this.rowHeight
                }
			}
		})
	}
}

@Component
struct FooterCellRow{
    @Prop @Require cellPosition: IBestCellPosition
    @Prop data: AnyType[]
    @ObjectLink columnList: IBestTableColumnInfo[]
    @Prop @Require isMultiLevelHeader: boolean = false
    @Prop summaryList: IBestStringNumber[]
    @Consume bdColor: ResourceColor
    @Consume sumText: ResourceStr
    summaryMethod?: (data: AnyType[], column: IBestTableColumnData) => IBestStringNumber[]

    @State rowHeight: number = 0

    getSummary(){
        let sums: string[] = []
        this.columnList.forEach((column, index) => {
            if (index === 0) {
                sums[index] = getResourceStr(this.sumText)
                return
            }
            const values = this.data.map((item: AnyType) => Number(item[column.prop]))
            const precisions: number[] = []
            let notNumber = true
            values.forEach((value) => {
                if (!Number.isNaN(+value)) {
                    notNumber = false
                    const decimal = `${value}`.split('.')[1]
                    precisions.push(decimal ? decimal.length : 0)
                }
            })
            const precision: number = Math.max(...precisions)
            if (!notNumber) {
                let sum = values.reduce((prev, curr) => {
                    const value = Number(curr)
                    if (!Number.isNaN(+value)) {
                        return Number.parseFloat(
                            (prev + curr).toFixed(Math.min(precision, 20))
                        )
                    } else {
                        return prev
                    }
                }, 0)
                sums[index] = sum.toString()
            } else {
                sums[index] = ''
            }
        })
        return sums
    }
    build() {
        Row(){
            ForEach(this.columnList, (column: IBestTableColumnInfo, index: number) => {
                TableCell({
                    cellType: 'footer',
                    pos: this.cellPosition,
                    column: column,
                    columnIndex: index,
                    isMultiLevelHeader: this.isMultiLevelHeader,
                    rowHeight: this.rowHeight,
                    summaryList: this.summaryList || (this.summaryMethod ? this.summaryMethod(this.data, column) : this.getSummary())
                })
            })
        }
        .backgroundColor(IBestTableColor.footerBgColor)
        .position(this.cellPosition == 'left' ? {left: 0, top: 0} : this.cellPosition == 'right' ? {right: 0, top: 0} : undefined)
        .onAreaChange((oldValue: Area, newValue: Area) => {
            if(newValue.height != oldValue.height){
                this.rowHeight = newValue.height as number
            }
        })
    }
}

@Component
struct TableCell{
    item: AnyType
	@Prop @Require pos: IBestCellPosition
    @Prop @Require cellType: 'header' | 'body' | 'footer'
    @Prop rowIndex: number = 0
    @ObjectLink column: IBestTableColumnInfo
    @Prop @Require columnIndex: number = 0
    @Prop isMultiLevelHeader: boolean = false
    @Consume @Watch("rowHeightChange") rowHeightList: number[]
    @Consume @Watch("columnWidthChange") columnWidthList: number[]
    @Consume headerFontSize: IBestStringNumber
    @Consume headerTextColor: ResourceColor
    @Consume cellFontSize: IBestStringNumber
    @Consume cellTextColor: ResourceColor
    @Consume cellPadding: Length | Padding | LocalizedPadding
    @Consume showBorder: boolean
    @Consume bdColor: ResourceColor
    @Consume stripe: boolean
    @Consume stripeBgColor: ResourceColor
    @Consume cellBgColor: ResourceColor
    @Prop summaryList: IBestStringNumber[]
	@Prop @Require rowHeight: number
    spanMethod: (row: AnyType, column: IBestTableColumnData, rowIndex: number, columnIndex: number) => number[] = () => [1,1]
    @BuilderParam headerBuilder: (column: IBestTableColumnData, columnIndex: number) => void
    @BuilderParam cellBuilder: (row: AnyType, column: IBestTableColumnData, rowIndex: number, columnIndex: number) => void

    @State realWidth: IBestStringNumber = 0
    @State realHeight: IBestStringNumber = 0
    @State rowSpan: number = 0
    @State colSpan: number = 0

    aboutToAppear(): void {
        const spanArr = this.getSpanArr()
        this.rowSpan = spanArr[0]
        this.colSpan = spanArr[1]
    }
    getSpanArr(){
        let arr = this.spanMethod(this.item, this.column, this.rowIndex, this.columnIndex)
        if(arr.length != 2 || arr.some(item => item < 0)){
            arr = [1,1]
        }
        return arr
    }
    rowHeightChange(){
        if(this.rowHeightList.length && this.rowHeightList.every(item => item > 0)){
            if(this.cellType != 'body' || this.column.fixed && this.pos == 'body'){
                this.realHeight = this.rowHeight || 'auto'
                return
            }
            let rowSpan = this.getSpanArr()[0]
            if(rowSpan <= 1){
                this.realHeight = 0
            }else {
                this.realHeight = this.rowHeightList.slice(this.columnIndex, this.columnIndex + rowSpan).reduce((prev, curr) => {
                    return prev + curr
                }, 0)
            }
        }
    }
    columnWidthChange(){
        if(this.columnWidthList.length && this.columnWidthList.every(item => item > 0)){
            if(this.cellType != 'body'){
                this.realWidth = getSizeByUnit(this.column.cellWidth)
                return
            }
            let colSpan = this.getSpanArr()[1]
            if(colSpan <= 1){
                this.realWidth = 0
            }else {
                this.realWidth = this.columnWidthList.slice(this.columnIndex, this.columnIndex + colSpan).reduce((prev, curr) => {
                    return prev + (curr || this.column.cellWidth)
                }, 0)
            }
        }
    }
    getWidth(){
        return this.realWidth || getSizeByUnit(this.column.cellWidth)
    }
    getHeight(){
        return this.rowHeight || 'auto'
    }
    getTextAlign(){
        let align = this.cellType == 'header' ? this.column.headerAlign : this.column.cellAlign
        return align == 'center' ? TextAlign.Center : align == 'right' ? TextAlign.End : TextAlign.Start
    }
    getText(): string{
        if(this.cellType == 'body' && this.column.formatter){
            return this.column.formatter(this.item, {title: this.column.title, prop: this.column.prop}, this.rowIndex, this.columnIndex)
        }else {
            return this.cellType == 'header' ? this.column.title : this.cellType == 'body' ? this.item[this.column.prop]?.toString() : this.summaryList[this.columnIndex].toString()
        }
    }
    getBgColor(){
        if(this.cellType != 'body'){
            return ''
        }else if(this.rowSpan > 1){
            return this.cellBgColor
        }else if(this.rowSpan == 1) {
            return this.stripe && this.rowIndex % 2 == 0 ? this.stripeBgColor : this.cellBgColor
        }else {
            return ''
        }
    }

    build() {
        Column(){
            if(this.cellType == 'header' || !this.column.children.length){
                Stack({alignContent: Alignment.TopStart}){
                    if(this.cellType == 'body'){
                        Row()
                            .width(CONTAINER_SIZE.FULL)
                            .height(this.getHeight())
                    }
                    Row(){
                        if(this.cellType == 'header' && this.headerBuilder){
                            this.headerBuilder({title: this.column.title, prop: this.column.prop}, this.columnIndex)
                        }else if(this.cellType == 'body' && this.cellBuilder){
                            this.cellBuilder(this.item, {title: this.column.title, prop: this.column.prop}, this.rowIndex, this.columnIndex)
                        }else{
                            Text(this.getText())
                                .width(CONTAINER_SIZE.FULL)
                                .fontSize(this.cellType == 'header' ? this.headerFontSize : this.cellFontSize)
                                .fontColor(this.cellType == 'header' ? this.headerTextColor : this.cellTextColor)
                                .fontWeight(this.cellType == 'header' ? 600 : FontWeight.Normal)
                                .textAlign(this.getTextAlign())
                                .maxLines(1)
                                .textOverflow({overflow: TextOverflow.Ellipsis})
                        }
                    }
                    .width(this.getWidth())
                    .height(this.cellType == 'body' ? this.realHeight || this.getHeight() : this.rowHeight && !this.column.children.length ? this.rowHeight : 'auto')
                    .padding(getSizeByUnit(this.cellPadding))
                    .border({
                        width: {
                            right: this.showBorder || this.isMultiLevelHeader ? 1 : 0,
                            bottom: 1
                        }, color: this.bdColor
                    })
                    .backgroundColor(this.getBgColor())
                    .visibility(this.rowSpan > 0 && this.colSpan > 0 ? Visibility.Visible : Visibility.Hidden)
                }
            }
            if(this.column.children.length){
                if(this.cellType == 'header'){
                    HeaderCellRow({
                        cellPosition: this.pos,
                        columnList: this.column.children,
                        isMultiLevelHeader: true
                    })
                }else if(this.cellType == 'body'){
                    BodyCellRow({
                        cellPosition: this.pos,
                        item: this.item,
                        rowIndex: this.rowIndex,
                        columnIndex: this.columnIndex,
                        columnList: this.column.children,
                        isMultiLevelHeader: true,
                        spanMethod: this.spanMethod
                    })
                }else {
                    FooterCellRow({
                        cellPosition: this.pos,
                        columnList: this.column.children,
                        isMultiLevelHeader: true,
                        summaryList: this.summaryList
                    })
                }
            }
        }
        .width(this.pos == 'body' ? getSizeByUnit(this.column.cellWidth) : this.getWidth())
        .height(this.getHeight())
        .layoutWeight(!this.column.cellWidth ? 1 : 0)
        .alignItems(HorizontalAlign.Start)
        .constraintSize({minWidth: getSizeByUnit(this.column.minWidth)})
        .visibility(this.column.show ? Visibility.Visible : Visibility.None)
        .onAreaChange((_: Area, newValue: Area) => {
            if(this.cellType == 'body' && !this.column.parentProp && this.columnWidthList[this.columnIndex] == 0){
                this.columnWidthList[this.columnIndex] = newValue.width as number
            }
        })
    }
}

@Component
export struct IBestTableColumn{
	/**
	 * 表格id
	 */
	@Prop @Require tableId: IBestStringNumber
	/**
	 * 列标题
	 */
	@Prop title: ResourceStr = ""
	/**
	 * 属性
	 */
	@Prop prop: string = ""
	/**
	 * 列宽度
	 */
	@Prop cellWidth: IBestStringNumber = ''
	/**
	 * 列最小宽度
	 */
	@Prop minWidth: IBestStringNumber = ''
	/**
	 * 列是否显示
	 */
	@Prop @Watch("showChange") show: boolean = true
	/**
	 * 单元格对齐方式
	 */
	@Prop cellAlign: 'left' | 'center' | 'right' = 'left'
	/**
	 * 表头对齐方式, 若不设置该项，则使用单元格的对齐方式
	 */
	@Prop headerAlign: 'left' | 'center' | 'right'
	/**
	 * 列是否固定在左侧或者右侧。 true 表示固定在左侧
	 */
	@Prop fixed: boolean | 'left' | 'right' = false
    /**
     * 父标题属性, 多级表头时传入
     */
    @Prop parentProp: string = ""
	/**
	 * 格式化函数
	 */
	formatter?: (row: AnyType, column: IBestTableColumnData, rowIndex: number, columnIndex: number) => string
	/**
	 * 自定义表头内容
	 */
	@BuilderParam headerBuilder: (column: IBestTableColumnData, columnIndex: number) => void
	/**
	 * 自定义单元格内容
	 */
	@BuilderParam cellBuilder: (row: AnyType, column: IBestTableColumnData, rowIndex: number, columnIndex: number) => void

	aboutToAppear(): void {
		ibestEmitter.emit(getEventName(COMPONENT_NAME, TABLE_EVENT_NAME.SEND_COLUMN_ITEM, this.tableId), {
			show: this.show,
			title: this.title,
			prop: this.prop,
			cellWidth: this.cellWidth,
			minWidth: this.minWidth,
			cellAlign: this.cellAlign,
			headerAlign: this.headerAlign || this.cellAlign,
			fixed: this.fixed,
            parentProp: this.parentProp,
			formatter: this.formatter,
			headerBuilder: this.headerBuilder,
			cellBuilder: this.cellBuilder
		})
	}
	showChange(){
		ibestEmitter.emit(getEventName(COMPONENT_NAME, TABLE_EVENT_NAME.COLUMN_ITEM_CHANGE, this.tableId), {
			prop: this.prop,
			show: this.show
		})
	}
	build() {}
}