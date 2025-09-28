import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { convertDimensionsWidthUnit } from '../../utils/utils'
import { IBestPageItem, IBestPaginationMode, IBestTurnBtnType } from './index.type'
import { IBestPaginationColor } from './color'

@Component
export struct IBestPagination {
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 当前页码
	 */
	@Link currentPage: number
	/**
	 * 分页模式
	 */
	@Prop mode: IBestPaginationMode = 'multi'
	/**
	 * 上一页按钮文本
	 */
	@Prop prevText: ResourceStr = '上一页'
	/**
	 * 下一页按钮文本
	 */
	@Prop nextText: ResourceStr = '下一页'
	/**
	 * 总页数
	 */
	@Prop pageCount: IBestStringNumber = 0
	/**
	 * 总条目数
	 */
	@Prop totalItems: IBestStringNumber = 0
	/**
	 * 显示页码数
	 */
	@Prop showPageSize: IBestStringNumber = 5
	/**
	 * 每页条目数
	 */
	@Prop itemsPerPage: IBestStringNumber = 10
	/**
	 * 是否强制显示省略号
	 */
	@Prop forceEllipses: boolean = false
	/**
	 * 是否显示上一页按钮
	 */
	@Prop showPrevButton: boolean = true
	/**
	 * 是否显示下一页按钮
	 */
	@Prop showNextButton: boolean = true
	/**
	 * 未激活文字颜色
     */
	@Prop textColor: ResourceColor = this.baseStyle.primary
	/**
	 * 激活文字颜色
     */
	@Prop activeTextColor: ResourceColor = IBestPaginationColor.activeTextColor
	/**
	 * 禁用文字颜色
     */
	@Prop disabledTextColor: ResourceColor = IBestPaginationColor.itemDisabledColor
	/**
	 * 未激活背景色
     */
	@Prop bgColor: ResourceColor = IBestPaginationColor.bgColor
	/**
	 * 激活背景色
     */
	@Prop activeBgColor: ResourceColor = this.baseStyle.primary
	/**
	 * 禁用背景色
     */
	@Prop disabledBgColor: ResourceColor = IBestPaginationColor.itemDisabledBackground
	/**
	 * 边框颜色
     */
	@Prop bdColor: ResourceColor = IBestPaginationColor.borderColor
	/**
	 * 页码变化时的回调函数
	 */
	onChange: (page: number) => void = () => {}
	@Builder turnButton(type: IBestTurnBtnType){
		Button(type == 'prev' ? this.prevText : this.nextText, { type: ButtonType.Normal })
			.height(CONTAINER_SIZE.FULL)
			.fontSize(this.baseStyle.fontSizeSm)
			.borderRadius(0)
			.stateEffect(true)
			.flexGrow(1)
			.flexShrink(1)
			.fontColor(this.getTurnBtnFontColor(type))
			.backgroundColor(this.getTurnBtnBgColor(type))
			.border({ width: this.getTurnBtnBorder(type), color: this.bdColor })
			.enabled(this.currentPage !== this.getTarget(type))
			.onClick(() => this.updateCurrentPage(type == 'prev' ? this.currentPage - 1 : this.currentPage + 1))
	}

	makePage(number: number, text: IBestStringNumber, active?: boolean): IBestPageItem {
		return { number, text, active }
	}
	getPages() {
		const count = this.getCount()
		const showPageSize = Number(this.showPageSize)
		const isMaxSized = showPageSize < count
		let startPage = 1
		let endPage = count
		if (isMaxSized) {
			startPage = Math.max(this.currentPage - Math.floor(showPageSize / 2), 1)
			endPage = startPage + showPageSize - 1
			if (endPage > count) {
				endPage = count
				startPage = endPage - showPageSize + 1
			}
		}
		const items: IBestPageItem[] = []
		for (let number = startPage; number <= endPage; number++) {
			const page = this.makePage(number, number, number === this.currentPage)
			items.push(page)
		}
		if (isMaxSized && showPageSize > 0 && this.forceEllipses) {
			if (startPage > 1) {
				const prevPages = this.makePage(startPage - 1, '...')
				items.unshift(prevPages)
			}
			if (endPage < count) {
				const nextPages = this.makePage(endPage + 1, '...')
				items.push(nextPages)
			}
		}
		return items
	}
	getCount(): number {
		const pageCount = Number(this.pageCount);
		const totalItems = Number(this.totalItems);
		const itemsPerPage = Number(this.itemsPerPage);
		const count = pageCount || Math.ceil(totalItems / itemsPerPage);
		return Math.max(1, count);
	}
	getTarget(type: IBestTurnBtnType){
		return type == 'prev' ? 1 : this.getCount()
	}
	getTurnBtnFontColor(type: IBestTurnBtnType){
		return this.currentPage !== this.getTarget(type) ? this.textColor : this.disabledTextColor
	}
	getTurnBtnBgColor(type: IBestTurnBtnType){
		return this.currentPage !== this.getTarget(type) ? this.bgColor : this.disabledBgColor
	}
	getTurnBtnBorder(type: IBestTurnBtnType){
		let border: EdgeWidths = {}
		if(type == 'prev'){
			border = { left: 1, top: 1, bottom: 1, right: this.mode == 'simple' ? 1 : 0 }
		}else{
			border = { left: 1, top: 1, bottom: 1, right: 1 }
		}
		return border
	}
	updateCurrentPage(value: number) {
		value = Math.max(1, Math.min(value, this.getCount()))
		if (this.currentPage !== value) {
			this.currentPage = value
			this.onChange(value)
		}
	}
	build() {
		Column() {
			Row() {
				if (this.showPrevButton) {
					this.turnButton('prev')
				}
				if (this.mode === 'simple') {
					Text(`${this.currentPage}/${this.getCount()}`)
						.fontSize(this.baseStyle.fontSizeSm)
						.margin({ left: 10, right: 10 })
						.flexGrow(1)
						.flexShrink(1)
						.textAlign(TextAlign.Center)
				} else {
					ForEach(this.getPages(), (page: IBestPageItem) => {
						Button(page.text.toString(), { type: ButtonType.Normal })
							.width(convertDimensionsWidthUnit(36))
							.height(CONTAINER_SIZE.FULL)
							.fontSize(this.baseStyle.fontSizeSm)
							.fontColor(page.active ? this.activeTextColor : this.textColor)
							.borderRadius(0)
							.padding(0)
							.backgroundColor(page.active ? this.activeBgColor : this.bgColor)
							.border({ width: { left: 1, top: 1, bottom: 1, right: 0 }, color: this.bdColor })
							.onClick(() => this.updateCurrentPage(page.number))
					})
				}
				if (this.showNextButton) {
					this.turnButton('next')
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.height(convertDimensionsWidthUnit(40))
			.justifyContent(FlexAlign.SpaceBetween)
		}
		.width(CONTAINER_SIZE.FULL)
	}
}