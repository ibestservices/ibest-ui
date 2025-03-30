import { IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { emitter } from '../../utils/EventEmitter'
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit } from '../../utils/utils'
import { PageItem, PaginationMode } from './index.type'

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

  aboutToAppear() {
    this.updatePages();
  }

  updatePages() {
    const count = this.getCount()
    const showPageSize = Number(this.showPageSize) + 1
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
        emitter.emit(getEventName('pagination', 'change'), value)
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
            .width('auto')
            .height(convertDimensionsWidthUnit(40))
            .borderRadius(0)
            .margin({ right: 5 })
        }

        if (this.mode === 'simple') {
          Text(`${this.modelValue}/${this.getCount()}`)
            .fontSize(14)
            .margin({ left: 10, right: 10 })
        } else {
          ForEach(this.pages, (page: PageItem) => {
            Button(page.text.toString(), { type: ButtonType.Normal })
              .enabled(!page.active)
              .onClick(() => this.updateModelValue(page.number, true))
              .width(convertDimensionsWidthUnit(36))
              .height(convertDimensionsWidthUnit(40))
              .borderRadius(0)
              .margin({ left: 1, right: 1 })
              .backgroundColor(page.active ? '#1989fa' : '#f7f8fa')
              .fontColor(page.active ? '#ffffff' : '#000000')
          })
        }

        if (this.showNextButton) {
          Button(this.nextText, { type: ButtonType.Normal })
            .enabled(this.modelValue !== this.getCount())
            .onClick(() => this.updateModelValue(this.modelValue + 1, true))
            .width('auto')
            .height(convertDimensionsWidthUnit(40))
            .borderRadius(0)
            .margin({ left: 5 })
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }.width(CONTAINER_SIZE.FULL)

  }
}