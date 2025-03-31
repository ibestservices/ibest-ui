import { IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { convertDimensionsWidthUnit } from '../../utils/utils'
import { PageItem, PaginationMode } from './index.type'
import { IBestPaginationColor } from './color'

const makePage = (
  number: number,
  text: IBestStringNumber,
  active?: boolean,
): PageItem => ({ number, text, active });


@Component
export struct IBestPagination {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 分页模式
   */
  @Prop mode: PaginationMode = 'multi'
  /**
   * 上一页按钮文本
   */
  @Prop prevText: string = '上一页'
  /**
   * 下一页按钮文本
   */
  @Prop nextText: string = '下一页'
  /**
   * 总页数
   */
  @Prop @Watch('updatePages') pageCount: IBestStringNumber = 0
  /**
   * 当前页码
   */
  @Link @Watch('updatePages') modelValue: number
  /**
   * 总条目数
   */
  @Prop @Watch('updatePages') totalItems: IBestStringNumber = 0
  /**
   * 显示页码数
   */
  @Prop @Watch('updatePages') showPageSize: IBestStringNumber = 5
  /**
   * 每页条目数
   */
  @Prop @Watch('updatePages') itemsPerPage: IBestStringNumber = 10
  /**
   * 是否强制显示省略号
   */
  @Prop @Watch('updatePages') forceEllipses: boolean = false
  /**
   * 是否显示上一页按钮
   */
  @Prop showPrevButton: boolean = true
  /**
   * 是否显示下一页按钮
   */
  @Prop showNextButton: boolean = true
  @State pages: PageItem[] = []
  /**
   * 页码变化时的回调函数
   */
  onChange: (checked: number) => void = () => {}

  aboutToAppear() {
    this.updatePages();
  }

  updatePages() {
    const count = this.getCount()
    const showPageSize = Number(this.showPageSize)
    const isMaxSized = showPageSize < count
    let startPage = 1
    let endPage = count

    if (isMaxSized) {
      startPage = Math.max(this.modelValue - Math.floor(showPageSize / 2), 1)
      endPage = startPage + showPageSize - 1

      if (endPage > count) {
        endPage = count
        startPage = endPage - showPageSize + 1
      }
    }

    const items: PageItem[] = []
    for (let number = startPage; number <= endPage; number++) {
      const page = makePage(number, number, number === this.modelValue)
      items.push(page)
    }

    if (isMaxSized && showPageSize > 0 && this.forceEllipses) {
      if (startPage > 1) {
        const prevPages = makePage(startPage - 1, '...')
        items.unshift(prevPages)
      }

      if (endPage < count) {
        const nextPages = makePage(endPage + 1, '...')
        items.push(nextPages)
      }
    }

    this.pages = items
  }

  getCount(): number {
    const pageCount = Number(this.pageCount);
    const totalItems = Number(this.totalItems);
    const itemsPerPage = Number(this.itemsPerPage);
    const count = pageCount || Math.ceil(totalItems / itemsPerPage);
    return Math.max(1, count);
  }

  updateModelValue(value: number, emitChange?: boolean) {
    value = Math.max(1, Math.min(value, this.getCount()))

    if (this.modelValue !== value) {
      this.modelValue = value

      if (emitChange) {
        this.onChange(value)
      }
    }
  }

  build() {
    Column() {
      Row() {
        if (this.showPrevButton) {
          Button(this.prevText, { type: ButtonType.Normal })
            .enabled(this.modelValue !== 1)
            .onClick(() => this.updateModelValue(this.modelValue - 1, true))
            .height(convertDimensionsWidthUnit(40))
            .fontSize(this.baseStyle.fontSizeSm)
            .fontColor(this.modelValue !== 1 ? IBestPaginationColor.textColor : IBestPaginationColor.activeTextColor)
            .borderRadius(0)
            .margin({ right: 0 })
            .backgroundColor(this.modelValue !== 1 ? IBestPaginationColor.bgColor :
            IBestPaginationColor.itemDisabledBackground)
            .fontColor(this.modelValue !== 1 ? IBestPaginationColor.textColor : IBestPaginationColor.itemDisabledColor)
            .stateEffect(true)
            .border({ width: 1, color: IBestPaginationColor.borderColor })
            .flexGrow(1)
            .flexShrink(1)
        }

        if (this.mode === 'simple') {
          Text(`${this.modelValue}/${this.getCount()}`)
            .fontSize(this.baseStyle.fontSizeSm)
            .margin({ left: 10, right: 10 })
            .flexGrow(1)
            .flexShrink(1)
            .textAlign(TextAlign.Center)
        } else {
          ForEach(this.pages, (page: PageItem) => {
            Button(page.text.toString(), { type: ButtonType.Normal })
              .onClick(() => this.updateModelValue(page.number, true))
              .width(convertDimensionsWidthUnit(36))
              .height(convertDimensionsWidthUnit(40))
              .fontSize(this.baseStyle.fontSizeSm)
              .fontColor(page.active ? IBestPaginationColor.activeTextColor : IBestPaginationColor.textColor)
              .borderRadius(0)
              .margin({ left: 0, right: 0 })
              .padding(2)
              .backgroundColor(page.active ? IBestPaginationColor.activeBg : IBestPaginationColor.bgColor)
              .border({ width: 1, color: IBestPaginationColor.borderColor })
          })
        }

        if (this.showNextButton) {
          Button(this.nextText, { type: ButtonType.Normal })
            .enabled(this.modelValue !== this.getCount())
            .onClick(() => this.updateModelValue(this.modelValue + 1, true))
            .height(convertDimensionsWidthUnit(40))
            .fontSize(this.baseStyle.fontSizeSm)
            .fontColor(this.modelValue !== this.getCount() ? IBestPaginationColor.textColor :
            IBestPaginationColor.activeTextColor)
            .borderRadius(0)
            .margin({ left: 0 })
            .backgroundColor(this.modelValue !== this.getCount() ? IBestPaginationColor.bgColor :
            IBestPaginationColor.itemDisabledBackground)
            .fontColor(this.modelValue !== this.getCount() ? IBestPaginationColor.textColor :
            IBestPaginationColor.itemDisabledColor)
            .stateEffect(true)
            .border({ width: 1, color: IBestPaginationColor.borderColor })
            .flexGrow(1)
            .flexShrink(1)

        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }.width(CONTAINER_SIZE.FULL)
  }
}