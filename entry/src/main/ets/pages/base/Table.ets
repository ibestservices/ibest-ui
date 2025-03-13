import router from '@ohos.router';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { IBestButton, IBestIcon, IBestNavBar, IBestTable, IBestTableColumn, IBestTableColumnData, IBestToast } from '@ibestservices/ibest-ui';
import { ComponentRouterParams } from '../../assets/global.type';

interface TableData{
	date: string
	name: string
	desc: string
}
interface TableData1{
	name: string
	amount1: number
	amount2: number
	amount3: number
	amount4: number
	amount5: number
}
@Entry
@Component
struct TablePage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State tableId: string = "table"
	@State data: TableData[] = [
        { date: '2025-03-10', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' },
        { date: '2025-03-09', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' },
		{ date: '2025-03-08', name: 'IBest-UI', desc: '一个轻量、简单易用、可定制主题、支持深色模式和浅色模式的鸿蒙开源UI组件库。' }
	]
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
		{ name: "数据1", amount1: 100, amount2: 98.6, amount3: 87.5, amount4: 98.6, amount5: 94.2 },
		{ name: "数据2", amount1: 68.8, amount2: 100, amount3: 96.6, amount4: 76.5, amount5: 77.4 },
		{ name: "数据3", amount1: 98.5, amount2: 87.4, amount3: 86.9, amount4: 87.3, amount5: 76.4 },
		{ name: "数据4", amount1: 87, amount2: 97, amount3: 78.8, amount4: 76.3, amount5: 98.54 },
		{ name: "数据5", amount1: 88, amount2: 97, amount3: 85.9, amount4: 68.3, amount5: 76.9 }
	]

	@State tableId1: string = "table1"
	@State tableId2: string = "table2"
	@State tableId3: string = "table3"
	@State tableId4: string = "table4"
	@State showDate: boolean = true
	@State tableId5: string = "table5"
	@State tableId6: string = "table6"
	@State tableId7: string = "table7"
	@Builder headerBuilder(column: IBestTableColumnData, columnIndex: number){
		Row({space: SPACE.BASE}){
			Text(column.title).fontSize(14)
			IBestIcon({
				name: "question-o",
				iconSize: 14
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
				onClickBtn: () => {
					IBestToast.show(`当前点击的行数据为${row.date} ${row.name}`)
				}
			})
		}
	}
	formatDate(row: TableData, column: IBestTableColumnData, rowIndex: number, columnIndex: number){
		console.log("formatDate", JSON.stringify(row), JSON.stringify(column), rowIndex, columnIndex)
		return row.date.replaceAll('-', '/')
	}
	build() {
		Column() {
			IBestNavBar({
				title: this.title,
				isShowStatusBar: true,
				onLeftClick: () => {
					router.back()
				}
			})
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
					ComponentShowContainer({ title: '动态显示列' }) {
						Column({space: SPACE.SM}){
							IBestButton({
								type: "primary",
								text: "切换日期列显示",
								onClickBtn: () => {
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
						IBestTable({ tableId: this.tableId6, data: this.data }){
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
							IBestTableColumn({ tableId: this.tableId7, title: "Amount1", prop: "amount1", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId7, title: "Amount2", prop: "amount2", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId7, title: "Amount3", prop: "amount3", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId7, title: "Amount4", prop: "amount4", cellWidth: 100 })
							IBestTableColumn({ tableId: this.tableId7, title: "Amount5", prop: "amount5", cellWidth: 100 })
						}
					}
				}
			}
			.layoutWeight(1)
			.padding({
				left: SPACE.SM,
				right: SPACE.SM,
				bottom: SPACE.XL
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}