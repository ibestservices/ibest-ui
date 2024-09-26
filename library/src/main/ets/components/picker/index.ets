import { clamp } from '../../assets/ets/utils';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { ColumnType, IBestPickerOption } from './index.type';

@Extend(Text) function pickerItemStyle(itemHeight: number){
	.width(CONTAINER_SIZE.FULL)
	.height(`${itemHeight}lpx`)
	.padding({ left: getDefaultBaseStyle().spaceBase, right: getDefaultBaseStyle().spaceBase })
	.fontSize(getDefaultBaseStyle().fontSizeLg)
	.align(Alignment.Center)
	.textAlign(TextAlign.Center)
	.maxLines(1)
	.textOverflow({ overflow: TextOverflow.Ellipsis })
}

// 惯性滑动思路:
// 在手指离开屏幕时，如果和上一次 move 时的间隔小于 `MOMENTUM_TIME` 且 move
// 距离大于 `MOMENTUM_DISTANCE` 时，执行惯性滑动
const MOMENTUM_TIME = 300
const MOMENTUM_DISTANCE = 30
const swipeDuration = 500


@Component
export struct IBestPicker{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/*
	 * 分组id
	 */
	@Prop groupId: string = ""
	/*
	 * 当前选中的值
	 */
	@Link value: Array<string>
	/*
	 * 选项列表
	 */
	@Prop @Watch("optionsChange") options: IBestPickerOption[] | IBestPickerOption[][] = []
	/*
	 * 标题
	 */
	@Prop title: string = ""
	/*
	 * 单项高度
	 */
	@Prop itemHeight: number = 88
	/*
	 * 确认按钮文字
	 */
	@Prop confirmText: string = "确定"
	/*
	 * 取消按钮文字
	 */
	@Prop cancelText: string = "取消"
	/*
	 * 是否显示顶部栏
	 */
	@Prop showToolBar: boolean = true
	/*
	 * 可见选项数量
  	 */
	@Prop visibleItemCount: number = 6
	/*
	 * 确认按钮点击事件
	 */
	onConfirm: (selectedValues: Array<string>, selectTexts: Array<string>) => void = () => {}
	/*
	 * 取消按钮点击事件
	 */
	onCancel: () => void = () => {}
	/*
	 * 选中项改变事件
	 */
	onChange: (selectedValues: Array<string>, selectTexts: Array<string>, columnIndex: number) => void = () => {}

	// 列表类型
	@State columnType: ColumnType = "multiple"
	// 每列选中索引
	@State indexArr: Array<number> = []
	// 触摸滑动相关参数
	@State touchStartTime: number = 0
	@State startOffset: number = 0
	@State momentumOffset: number = 0
	@State startY: number = 0
	// 选项列表
	@State columns: IBestPickerOption[][] = []
	// offset 列表
	@State offsetList: number[] = []

	@Styles columnItemStyle(){
		.height(CONTAINER_SIZE.FULL)
		.layoutWeight(1)
		.monopolizeEvents(true)
	}

	aboutToAppear(): void {
		this.init()
	}
	// 获取列表类型
	getColumnType(): ColumnType{
		return Array.isArray(this.options[0]) ? "multiple" : "cascade"
	}
	// 初始化数据
	init(type?: string){
		this.columnType = this.getColumnType()
		this.columns = []
		if(this.columnType == "cascade") {
			if (this.value.length) {
				this.indexArr = Array(this.value.length).fill(0)
				this.offsetList = Array(this.value.length).fill(0)
				this.initWithSelectValue(0, this.options as IBestPickerOption[])
			} else {
				this.initWithEmptyValue([], this.options as IBestPickerOption[])
			}
		}else{
			this.initWidthMultiple(type)
		}
	}
	// 根据已选值 初始化索引位置
	initWithSelectValue(index: number, children: IBestPickerOption[]){
		if(this.value[index] != undefined && children && children.length){
			let i = children.findIndex(item => item.value == this.value[index])
			i = i > -1 ? i : children.length - 1
			this.columns.push(children)
			this.indexArr[index] = i
			this.updateOffsetByIndex(index, i)
			this.initWithSelectValue(index+1, children[i].children!)
		}
	}
	// 初始化value
	initWithEmptyValue(arr: string[], children: IBestPickerOption[]){
		if(children && children.length){
			this.columns.push(children)
			arr.push(children[0].value)
			this.initWithEmptyValue(arr, children[0].children!)
		}else{
			this.indexArr = Array(arr.length).fill(0)
			this.offsetList = Array(arr.length).fill(0)
			this.value = arr
		}
	}
	// 初始化多列类型
	initWidthMultiple(type?:string){
		let options = this.options as IBestPickerOption[][]
		if(!this.value.length){
			this.value = Array(options.length).fill(0)
		}
		if(!this.offsetList.length){
			this.offsetList = Array(this.value.length).fill(0)
		}
		options.forEach((item, index) => {
			let i = item.findIndex(e => e.value == this.value[index])
			i = i > -1 ? i : 0
			this.indexArr[index] = i
			this.value[index] = item[i].value
			if(i > -1){
				if(type == "change"){
					this.value[index] = item[i].value
				}
				this.updateOffsetByIndex(index, i)
			}
			this.columns.push(item)
		})
	}
	// 列表变化
	optionsChange(){
		this.init("change")
	}
	// 获取初始位置
	getBaseOffset(): number{
		return this.itemHeight * (this.visibleItemCount-1) / 2
	}
	// 通过偏移量获取索引
	getIndexByOffset(columnIndex: number, offset: number) {
		return clamp(Math.round(-offset / this.itemHeight), 0, this.columns[columnIndex].length - 1)
	}
	// 通过索引更新偏移量
	updateOffsetByIndex(columnIndex: number, index: number){
		const offset = - index * this.itemHeight
		this.offsetList[columnIndex] = offset
	}
	// 重置列表数据
	resetColumnOptions(columnIndex: number, i: number){
		// console.log("重置列表数据", columnIndex, i)
		this.columns.forEach((item, index, arr) => {
			if(index > columnIndex){
				this.offsetList[index] = 0
				this.indexArr[index] = 0
				if(columnIndex == 0){
					if(index - 1 == columnIndex){
						arr[index] = (this.options as IBestPickerOption[])[i].children || []
					}else{
						arr[index] = (arr[index-1][0].children || [])
					}
				}else{
					arr[index] = (arr[index-1][i].children || [])
				}
			}
		})
	}
	// 更新某一列offset
	updateOffset(columnIndex: number, offset: number){
		this.offsetList[columnIndex] = offset
	}
	// 获取某一列offset
	getOffset = (columnIndex: number): number => this.offsetList[columnIndex]
	// 手指接触屏幕
	onTouchStart(columnIndex: number){
		this.startOffset = this.getOffset(columnIndex)
		this.touchStartTime = Date.now()
		this.momentumOffset = this.startOffset
	}
	// 手指移动
	onTouchMove(event: GestureEvent, columnIndex: number): void {
		let bl = px2lpx(vp2px(event.offsetY))
		let newOffset = this.startOffset + bl
		let list = this.columns[columnIndex]
		if(bl > 0 && newOffset > this.itemHeight){
			newOffset = this.itemHeight
		}else if(bl < 0 && newOffset < - list.length * this.itemHeight){
			newOffset = - list.length * this.itemHeight
		}
		const now = Date.now()
		if (now - this.touchStartTime > MOMENTUM_TIME) {
			this.touchStartTime = now;
			this.momentumOffset = newOffset;
		}
		this.updateOffset(columnIndex, newOffset)
	}
	// 手指离开
	onTouchEnd(columnIndex: number): void {
		let offset = this.getOffset(columnIndex)
		let distance = offset - this.momentumOffset
		const duration = Date.now() - this.touchStartTime
		const startMomentum = duration < MOMENTUM_TIME && Math.abs(distance) > MOMENTUM_DISTANCE
		if (startMomentum) {	// 惯性滑动
			const speed = Math.abs(distance / duration)
			offset = offset + (speed / 0.03) * (distance < 0 ? -1 : 1)
		}
		const index = this.getIndexByOffset(columnIndex, offset)
		this.updateOffsetByIndex(columnIndex, index)
		if(this.indexArr[columnIndex] != index){	// 索引变更
			this.indexArr[columnIndex] = index
			// 重置后面项
			if(this.columnType == "cascade"){
				this.resetColumnOptions(columnIndex, index)
			}
			this.setValueByIndex()
			setTimeout(() => {
				this.onChange(this.value, this.getTextByIndex(), columnIndex)
			}, swipeDuration)
		}
	}
	// 根据索引设置value
	setValueByIndex(){
		this.value = this.columns.map((item, index) => item[this.indexArr[index]].value)
	}
	// 根据索引获取值 文字
	getTextByIndex(): string[]{
		return this.columns.map((item, index) => item[this.indexArr[index]].text)
	}

	build() {
		Column() {
			// 头部
			if(!this.groupId && this.showToolBar){
				Stack({alignContent: Alignment.Center}) {
					Row(){
						Text(this.cancelText)
							.height(CONTAINER_SIZE.FULL)
							.fontSize(this.baseStyle.fontSizeMd)
							.fontColor(GRAY_COLOR.GRAY_6)
							.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
							.onClick(() => {
								this.onCancel()
							})
						Text(this
							.confirmText)
							.height(CONTAINER_SIZE.FULL)
							.fontSize(this.baseStyle.fontSizeMd)
							.fontColor(this.baseStyle.primary)
							.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
							.onClick(() => {
								this.onConfirm(this.value, this.getTextByIndex())
							})
					}
					.width(CONTAINER_SIZE.FULL)
					.height("88lpx")
					.justifyContent(FlexAlign.SpaceBetween)
					Text(this.title)
						.constraintSize({ maxWidth: "50%" })
						.fontWeight(600)
						.fontSize(this.baseStyle.fontSizeLg)
						.maxLines(1)
						.textOverflow({ overflow: TextOverflow.Ellipsis })
				}
			}
			Stack() {
				// 数据层
				Row() {
					ForEach(this.columns, (item: IBestPickerOption[], index) => {
						Column() {
							ForEach(item, (e: IBestPickerOption) => {
								Text(e.text)
									.pickerItemStyle(this.itemHeight)
							})
						}
						.translate({ x: 0, y: `${this.offsetList[index] + this.getBaseOffset()}lpx`, z: 0 })
						.columnItemStyle()
						.animation({
							duration: swipeDuration,
							curve: Curve.Ease
						})
					})
				}
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
				.justifyContent(FlexAlign.Center)
				// 模糊蒙层
				Column(){
					Row()
						.width(CONTAINER_SIZE.FULL)
						.height(`calc(50% - ${this.itemHeight/2}lpx)`)
						.linearGradient({ angle: 180, colors: [["rgba(255,255,255,0.9)", 0.1], [ "rgba(255,255,255,0.4)", 0.9]] })
						.border({ width: { bottom: 1 }, color: "#ededed" })
					Row()
						.width(CONTAINER_SIZE.FULL)
						.height(`calc(50% - ${this.itemHeight/2}lpx)`)
						.linearGradient({ angle: 0, colors: [["rgba(255,255,255,0.9)", 0.1], [ "rgba(255,255,255,0.4)", 0.9]] })
						.border({ width: { top: 1 }, color: "#ededed" })
				}
				.height(CONTAINER_SIZE.FULL)
				.justifyContent(FlexAlign.SpaceBetween)
				// 触摸层
				Row() {
					ForEach(this.columns, (item: IBestPickerOption[], index) => {
						Column()
							.columnItemStyle()
							.gesture(
								PanGesture({
									fingers: 1,
									direction: PanDirection.Vertical,
									distance: 1
								})
									.onActionStart(() => {
										this.onTouchStart(index)
									})
									.onActionUpdate((event: GestureEvent) => {
										this.onTouchMove(event, index)
									})
									.onActionEnd(() => {
										this.onTouchEnd(index)
									})
							)
					})
				}
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
				.justifyContent(FlexAlign.Center)
			}
			.height(`${this.itemHeight * this.visibleItemCount}lpx`)
			.clip(true)
		}
		.width(CONTAINER_SIZE.FULL)
		.alignItems(HorizontalAlign.Start)
		.backgroundColor(this.baseStyle.default)
	}
}