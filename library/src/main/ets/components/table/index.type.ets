import { AnyType } from '../../model/AnyType'
/**
 * 组件名称
 */
export const COMPONENT_NAME = "TABLE"
/**
 * Table事件名称
 */

export enum TABLE_EVENT_NAME {
	/**
	 * 获取所有列信息
	 */
	SEND_COLUMN_ITEM = "SEND_ITEM",
	/**
	 * 列属性变化
     */
	COLUMN_ITEM_CHANGE = "COLUMN_ITEM_CHANGE"
}
/**
 * 单元格位置
 */
export type IBestCellPosition = "left" | "right" | "body"
/**
 * 列信息
 */
export class IBestTableColumnData {
	/**
	 * 列标题
	 */
	title: ResourceStr = ""
	/**
	 * 属性
	 */
	prop: string = ""
}
class IBestTableColumnType extends IBestTableColumnData {
	/**
	 * 列是否显示
	 */
	show: boolean = true
	/**
	 * 列宽度
	 */
	cellWidth: number = 0
	/**
	 * 列最小宽度
	 */
	minWidth: number = 0
	/**
	 * 单元格对齐方式
	 */
	cellAlign: 'left' | 'center' | 'right' = 'left'
	/**
	 * 表头对齐方式, 若不设置该项，则使用单元格的对齐方式
	 */
	headerAlign: 'left' | 'center' | 'right' = 'left'
	/**
	 * 列是否固定在左侧或者右侧。 true 表示固定在左侧
	 */
	fixed: boolean | 'left' | 'right' = false
	/**
	 * 父标题属性
     */
	parentProp: string = ""
	/**
	 * 子列
     */
	children: IBestTableColumnInfo[] = []
	/**
	 * 格式化函数
	 */
	formatter?: (row: AnyType, column: IBestTableColumnData, rowIndex: number, columnIndex: number) => string
	/**
	 * 自定义表头内容
     */
	headerBuilder?: (column: IBestTableColumnData, columnIndex: number) => void
	/**
	 * 自定义单元格内容
	 */
	cellBuilder?: (row: AnyType, column: IBestTableColumnData, rowIndex: number, columnIndex: number) => void
}
@Observed
export class IBestTableColumnInfo extends IBestTableColumnType {
	constructor(value: IBestTableColumnType) {
		super()
		this.show = value.show
		this.title = value.title
		this.prop = value.prop
		this.cellWidth = value.cellWidth
		this.minWidth = value.minWidth
		this.cellAlign = value.cellAlign
		this.headerAlign = value.headerAlign
		this.fixed = value.fixed
		this.parentProp = value.parentProp
		this.formatter = value.formatter
		this.headerBuilder = value.headerBuilder
		this.cellBuilder = value.cellBuilder
	}
}