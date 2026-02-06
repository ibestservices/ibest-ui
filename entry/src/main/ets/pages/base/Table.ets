import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import {
	IBestButton,
	IBestIcon,
	IBestTable,
	IBestTableColumn,
	IBestTableColumnData,
	IBestToast
} from '@ibestservices/ibest-ui';
import CustomNavBar from '../../components/CustomNavBar';
import { UIUtils } from '@kit.ArkUI'

@Builder
export function TableBuilder(_: string, title: string){
	TablePage({title})
}

interface TableData{
	date: string
	name: string
	desc: string
}
interface TableData1{
	id: string
	name: string
	amount1: number
	amount2: number
	amount3: number
	amount4: number
	amount5: number
}
class TableData2{
	name: string = ""
	number: number = 0
	constructor(name: string, number: number) {
		this.name = name
		this.number = number
	}
}
interface TableData3{
	name: string
	info1: string
	info3: string
	info4: string
	info5: string
}

@Entry
@Component
struct TablePage {
	@State title: string = ''
	@State tableId: string = "table"
	@State data: TableData[] = []
	@State data1: TableData[] = [
		{ date: '2025-03-10', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' },
		{ date: '2025-03-09', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' },
		{ date: '2025-03-08', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' },
		{ date: '2025-03-07', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' },
		{ date: '2025-03-06', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' },
		{ date: '2025-03-05', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' },
		{ date: '2025-03-04', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' }
	]
	@State data2: TableData1[] = [
		{ id: "123453333", name: "数据1", amount1: 95, amount2: 93.2, amount3: 88.1, amount4: 85.3, amount5: 79.5 },
		{ id: "123455555", name: "数据2", amount1: 100, amount2: 98.6, amount3: 87.5, amount4: 98.6, amount5: 94.2 },
		{ id: "123456666", name: "数据3", amount1: 68.8, amount2: 100, amount3: 96.6, amount4: 76.5, amount5: 77.4 },
		{ id: "123457777", name: "数据4", amount1: 98.5, amount2: 87.4, amount3: 86.9, amount4: 87.3, amount5: 76.4 },
		{ id: "123458888", name: "数据5", amount1: 87, amount2: 97, amount3: 78.8, amount4: 76.3, amount5: 98.54 },
		{ id: "123459999", name: "数据6", amount1: 88, amount2: 97, amount3: 85.9, amount4: 68.3, amount5: 76.9 }
	]
	@State data3: TableData2[] = [
		UIUtils.makeObserved(new TableData2("数据1", 10)),
		UIUtils.makeObserved(new TableData2("数据2", 20))
	]
	@State data4: TableData3[] = [
		{ name: 'IBest-UI', info1: '开源', info3: '轻量', info4: "易用", info5: "主题定制" },
		{ name: 'IBest-UI', info1: '开源', info3: '轻量', info4: "易用", info5: "主题定制" },
		{ name: 'IBest-UI', info1: '开源', info3: '轻量', info4: "易用", info5: "主题定制" }
	]

	@State tableId1: string = "table1"
	@State tableId2: string = "table2"
	@State tableId3: string = "table3"
	@State tableId4: string = "table4"
	@State showDate: boolean = true
	@State tableId5: string = "table5"
	@State tableId6: string = "table6"
	@State tableId7: string = "table7"
	@State tableId8: string = "table8"
	@State tableId9: string = "table9"
	@State tableId10: string = "table10"
	@Builder headerBuilder(column: IBestTableColumnData, columnIndex: number){
		Row({space: SPACE.BASE}){
			Text(column.title).fontSize(14)
			IBestIcon({
				name: "question-o",
				iconSize: 30
			})
		}
	}
	@Builder customCell(row: TableData, column: IBestTableColumnData, rowIndex: number, columnIndex: number){
		if(column.prop == 'date'){
			Row({space: SPACE.BASE}){
				IBestIcon({
					name: "underway-o",
					iconSize: 14
				})
				Text(row.date).fontSize(14)
			}
		}else{
			IBestButton({
				type: "primary",
				text: "操作",
				onBtnClick: () => {
					IBestToast.show(`当前点击的行数据为${row.date} ${row.name}`)
				}
			})
		}
	}
	formatDate(row: TableData, column: IBestTableColumnData, rowIndex: number, columnIndex: number){
		return row.date.replaceAll('-', '/')
	}
	arraySpanMethod(row: TableData, column: IBestTableColumnData, rowIndex: number, columnIndex: number) {
		// 合并第一行的第一列和第二列
		if (rowIndex === 0) {
			if (columnIndex === 0) {
				return [1, 2]
			} else if (columnIndex === 1) {
				return [0, 0]
			}
		}
		// 合并第一列的第三行和第四行
		if (columnIndex === 0) {
			if (rowIndex === 2) {
				return [2,1]
			}else if (rowIndex === 3){
				return [0, 0]
			}
		}
		// 合并偶数行的第三列和第四列
		if (rowIndex % 2 === 0) {
			if (columnIndex === 2) {
				return [1, 2]
			} else if (columnIndex === 3) {
				return [0, 0]
			}
		}
		return [1, 1]
	}
	aboutToAppear(): void {
		setTimeout(() => {
			this.data = [
				{ date: '2025-03-10', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' },
				{ date: '2025-03-09', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' },
				{ date: '2025-03-08', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' }
			]
		}, 500)
	}
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						IBestTable({ tableId: this.tableId, data: this.data }){
                            IBestTableColumn({ tableId: this.tableId, title: "日期", prop: "date", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId, title: "名称", prop: "name", cellWidth: 70 })
							IBestTableColumn({ tableId: this.tableId, title: "描述", prop: "desc" })
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '斑马纹' }) {
						IBestTable({ tableId: this.tableId1, data: this.data, stripe: true }){
							IBestTableColumn({ tableId: this.tableId1, title: "日期", prop: "date", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId1, title: "名称", prop: "name", cellWidth: 70 })
							IBestTableColumn({ tableId: this.tableId1, title: "描述", prop: "desc" })
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '边框' }) {
						IBestTable({ tableId: this.tableId2, data: this.data, showBorder: true }){
							IBestTableColumn({ tableId: this.tableId2, title: "日期", prop: "date", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId2, title: "名称", prop: "name", cellWidth: 70 })
							IBestTableColumn({ tableId: this.tableId2, title: "描述", prop: "desc" })
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '固定列和表头' }) {
						IBestTable({ tableId: this.tableId3, data: this.data1, fixHeight: 140 }){
							IBestTableColumn({ tableId: this.tableId3, title: "日期", prop: "date", fixed: true, cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId3, title: "名称", prop: "name", cellWidth: 70 })
							IBestTableColumn({ tableId: this.tableId3, title: "描述", prop: "desc", cellWidth: 500 })
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '动态显示列', space: SPACE.SM }) {
						IBestButton({
							type: "primary",
							text: "切换日期列显示",
							onBtnClick: () => {
								this.showDate = !this.showDate
							}
						})
						IBestTable({ tableId: this.tableId4, data: this.data }){
							IBestTableColumn({ tableId: this.tableId4, title: "日期", prop: "date", cellWidth: 100, show: this.showDate })
							IBestTableColumn({ tableId: this.tableId4, title: "名称", prop: "name", cellWidth: 70 })
							IBestTableColumn({ tableId: this.tableId4, title: "描述", prop: "desc" })
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '格式化单元格内容' }) {
						IBestTable({ tableId: this.tableId5, data: this.data }){
							IBestTableColumn({
								tableId: this.tableId5,
								title: "日期",
								prop: "date",
								cellWidth: 100,
								formatter: (row: TableData, column, rowIndex, columnIndex): string => this.formatDate(row, column, rowIndex, columnIndex)
							})
							IBestTableColumn({ tableId: this.tableId5, title: "名称", prop: "name", cellWidth: 70 })
							IBestTableColumn({ tableId: this.tableId5, title: "描述", prop: "desc" })
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义单元格内容' }) {
						IBestTable({ tableId: this.tableId6, data: this.data, showBorder: true }){
							IBestTableColumn({
								tableId: this.tableId6,
								title: "日期",
								prop: "date",
								cellWidth: 130,
								cellBuilder: (row: TableData, column: IBestTableColumnData, rowIndex: number, columnIndex: number): void => this.customCell(row, column, rowIndex, columnIndex)
							})
							IBestTableColumn({ tableId: this.tableId6, title: "名称", prop: "name" })
							IBestTableColumn({
								tableId: this.tableId6,
								title: "操作",
								cellWidth: 90,
								headerBuilder: (column: IBestTableColumnData, columnIndex: number): void => this.headerBuilder(column, columnIndex),
								cellBuilder: (row: TableData, column: IBestTableColumnData, rowIndex: number, columnIndex: number): void => this.customCell(row, column, rowIndex, columnIndex)
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '表尾合计行' }) {
						IBestTable({ tableId: this.tableId7, data: this.data2, showSummary: true }){
							IBestTableColumn({ tableId: this.tableId7, title: "名称", prop: "name", cellWidth: 70, fixed: true })
							IBestTableColumn({ tableId: this.tableId7, title: "数量1", prop: "amount1", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId7, title: "数量2", prop: "amount2", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId7, title: "数量3", prop: "amount3", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId7, title: "数量4", prop: "amount4", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId7, title: "数量5", prop: "amount5", cellWidth: 100, fixed: "right" })
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '合并行列', space: SPACE.SM }) {
						IBestTable({ tableId: this.tableId8, data: this.data2, stripe: true, showBorder: true, spanMethod: this.arraySpanMethod}){
							IBestTableColumn({ tableId: this.tableId8, title: "ID", prop: "id", cellWidth: 80, fixed: true })
							IBestTableColumn({ tableId: this.tableId8, title: "名称", prop: "name", cellWidth: 50 })
							IBestTableColumn({ tableId: this.tableId8, title: "数量1", prop: "amount1", cellWidth: 50 })
							IBestTableColumn({ tableId: this.tableId8, title: "数量2", prop: "amount2", cellWidth: 50 })
							IBestTableColumn({ tableId: this.tableId8, title: "数量3", prop: "amount3", cellWidth: 50 })
							IBestTableColumn({ tableId: this.tableId8, title: "数量4", prop: "amount4", cellWidth: 50 })
							IBestTableColumn({ tableId: this.tableId8, title: "数量5", prop: "amount5", cellWidth: 50 })
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '动态修改数据', space: SPACE.SM }) {
						IBestTable({ tableId: this.tableId9, data: this.data3 }){
							IBestTableColumn({ tableId: this.tableId9, title: "名称", prop: "name", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId9, title: "数量", prop: "number"})
						}
						Row({space: SPACE.SM}){
							IBestButton({
								type: "primary",
								text: "修改数量",
								onBtnClick: () => {
									this.data3[0].number += 10
								}
							})
							IBestButton({
								type: "primary",
								text: "修改整个数据",
								onBtnClick: () => {
									this.data3 = [
										UIUtils.makeObserved(new TableData2("数据3", 30)),
										UIUtils.makeObserved(new TableData2("数据4", 40))
									]
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '多级表头' }) {
						IBestTable({ tableId: this.tableId10, data: this.data4 }){
							IBestTableColumn({ tableId: this.tableId10, title: "名称", prop: "name", cellWidth: 70, fixed: true })
							IBestTableColumn({
								tableId: this.tableId10,
								title: "详细信息",
								prop: "detail",
								cellWidth: 150,
								headerBuilder: (column: IBestTableColumnData, columnIndex: number): void => this.headerBuilder(column, columnIndex),
							})
							IBestTableColumn({ tableId: this.tableId10, title: "信息1", prop: "info1", parentProp: "detail", cellWidth: 50 })
							IBestTableColumn({ tableId: this.tableId10, title: "信息2", prop: "info2", parentProp: "detail" })
							IBestTableColumn({ tableId: this.tableId10, title: "信息3", prop: "info3", parentProp: "info2", cellWidth: 50 })
							IBestTableColumn({ tableId: this.tableId10, title: "信息4", prop: "info4", parentProp: "info2" })
							IBestTableColumn({ tableId: this.tableId10, title: "信息5", prop: "info5", cellWidth: 200 })
						}
					}
				}
				ListItem().height(100)
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}