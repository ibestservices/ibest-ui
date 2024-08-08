import { clamp } from '../../assets/ets/utils';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { IBestPickerOption } from './index.type';
import { matrix4 } from '@kit.ArkUI'

@Extend(Text) function pickerItemStyle(itemHeight: number){
	.width(CONTAINER_SIZE.FULL)
	.height(`${itemHeight}lpx`)
	.padding({ left: getDefaultBaseStyle().spaceBase, right: getDefaultBaseStyle().spaceBase })
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


@Component
export struct IBestPicker{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/*
	 * 当前选中的值
	 */
	@Link value: Array<string>
	/*
	 * 选项列表
	 */
	@Prop options: IBestPickerOption[] | IBestPickerOption[][] = []
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
	onChange: (selectedValues: Array<string>, selectTexts: Array<string>) => void = () => {}


	// 列表类型
	@State columnType: "cascade" | "multiple" = "multiple"
	// 每列选中索引
	@State indexArr: Array<number> = []
	// 触摸滑动相关参数
	@State touchStartTime: number = 0
	@State startOffset: number = 0
	@State momentumOffset: number = 0
	@State startY: number = 0
	/*
	 * 第一列当前偏移量
	 */
	@State curOffset1: number = 0
	/*
	 * 第二列当前偏移量
	 */
	@State curOffset2: number = 0
	/*
	 * 第三列当前偏移量
	 */
	@State curOffset3: number = 0
	@State list: IBestPickerOption[] = []
	@State list1: IBestPickerOption[] = []
	@State list2: IBestPickerOption[] = []

	@Styles columnItemStyle(){
		.height(CONTAINER_SIZE.FULL)
		.layoutWeight(1)
	}

	aboutToAppear(): void {
		this.columnType = this.getColumnType()
		// 级联选择
		if(this.columnType == "cascade") {
			if (this.value.length) {
				this.initWithSelectValue(0, this.options as IBestPickerOption[])
			} else {
				this.initWithEmptyValue([], this.options as IBestPickerOption[], 0)
			}
		}else{
			this.initWidthMultiple()
		}
	}
	// 获取列表类型
	getColumnType(): "cascade" | "multiple"{
		return Array.isArray(this.options[0]) ? "multiple" : "cascade"
	}
	// 根据已选值 初始化索引位置
	initWithSelectValue(index: number, children: IBestPickerOption[]){
		if(index < 3 && this.value[index] != undefined && children.length){
			let i = children.findIndex(item => item.value == this.value[index])
			this.indexArr.push(i)
			this.updateOffsetByIndex(index, i)
			this.setList(index, children)
			this.initWithSelectValue(index+1, children[i].children!)
		}
	}
	// 初始化value
	initWithEmptyValue(arr: string[], children: IBestPickerOption[], index: number){
		if(arr.length < 3 && children && children.length){
			this.setList(index, children)
			arr.push(children[0].value)
			this.indexArr.push(0)
			this.initWithEmptyValue(arr, children[0].children!, index + 1)
		}else{
			this.value = arr
		}
	}
	// 初始化多列类型
	initWidthMultiple(){
		let options = this.options as IBestPickerOption[][]
		options.forEach((item, index) => {
			let i = this.value.findIndex(e => e == item[index].value)
			this.indexArr.push(i > -1 ? i : 0)
			if(i > -1){
				this.updateOffsetByIndex(index, i)
			}else{
				this.value.push(item[0].value)
			}
			this.setList(index, item)
		})
	}
	// 根据列索引设置列表数据
	setList(columnIndex: number, list: IBestPickerOption[]){
		if(columnIndex == 0){
			this.list = list
		}else if(columnIndex == 1){
			this.list1 = list
		}else if(columnIndex == 2){
			this.list2 = list
		}
	}
	// 获取初始位置
	getBaseOffset(): number{
		return this.itemHeight * 5 / 2
	}
	// 通过偏移量获取索引
	getIndexByOffset(columnIndex: number, offset: number) {
		if(columnIndex == 0){
			return clamp(Math.round(-offset / this.itemHeight), 0, this.list.length - 1)
		}else if(columnIndex == 1){
			return clamp(Math.round(-offset / this.itemHeight), 0, this.list1.length - 1)
		}else{
			return clamp(Math.round(-offset / this.itemHeight), 0, this.list2.length - 1)
		}
	}
	// 通过索引更新偏移量
	updateOffsetByIndex(columnIndex: number, index: number){
		const offset = - index * this.itemHeight
		this.updateOffset(columnIndex, offset)
	}
	// 重置列表数据
	resetColumnOptions(columnIndex: number, index: number){
		// console.log("重置列表数据", columnIndex, index)
		if(columnIndex == 0){
			if(this.list1.length){
				this.curOffset2 = 0
				this.list1 = (this.options as IBestPickerOption[])[index].children || []
				this.indexArr[1] = 0
				if(this.list2.length){
					this.curOffset3 = 0
					this.indexArr[2] = 0
					this.list2 = this.list1[0].children || []
				}
			}
		}else if(columnIndex == 1){
			if(this.list2.length){
				this.curOffset3 = 0
				this.indexArr[2] = 0
				this.list2 = this.list1[index].children || []
			}
		}
	}
	// 更新某一列offset
	updateOffset(columnIndex: number, offset: number){
		if(columnIndex == 0){
			this.curOffset1 = offset
		}else if(columnIndex == 1){
			this.curOffset2 = offset
		}else{
			this.curOffset3 = offset
		}
	}
	// 获取某一列offset
	getOffset(columnIndex: number): number{
		if(columnIndex == 0){
			return this.curOffset1
		}else if(columnIndex == 1){
			return this.curOffset2
		}else{
			return this.curOffset3
		}
	}
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
		let list = columnIndex == 0 ? this.list : columnIndex == 1 ? this.list1 : this.list2
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
		if (startMomentum) {
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
		}
		this.onChange(this.value, this.getTextByIndex())
	}
	// 根据索引设置value
	setValueByIndex(){
		let arr: string[] = []
		if(this.columnType == "cascade"){
			arr = [(this.options as IBestPickerOption[])[this.indexArr[0]].value]
			if (this.list1.length) {
				arr.push(this.list1[this.indexArr[1]].value)
			}
			if (this.list2.length) {
				arr.push(this.list2[this.indexArr[2]].value)
			}
		}else{
			(this.options as IBestPickerOption[][]).forEach((item, index) => {
				arr.push(item[this.indexArr[index]].value)
			})
		}
		this.value = arr
	}
	// 根据索引获取值 文字
	getTextByIndex(): string[]{
		let arr: string[] = []
		if(this.columnType == "cascade"){
			arr = [(this.options as IBestPickerOption[])[this.indexArr[0]].text]
			if (this.list1.length) {
				arr.push(this.list1[this.indexArr[1]].text)
			}
			if (this.list2.length) {
				arr.push(this.list2[this.indexArr[2]].text)
			}
		}else{
			(this.options as IBestPickerOption[][]).forEach((item, index) => {
				arr.push(item[this.indexArr[index]].text)
			})
		}
		return arr
	}

	build() {
		Column() {
			// 头部
			if(this.showToolBar){
				Row() {
					Text(this.cancelText)
						.height(CONTAINER_SIZE.FULL)
						.fontSize(this.baseStyle.fontSizeMd)
						.fontColor(GRAY_COLOR.GRAY_6)
						.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
						.onClick(() => {
							this.onCancel()
						})
					Text(this.title)
						.fontWeight(600)
					Text(this.confirmText)
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
			}
			// 内容
			Stack() {
				// 数据层
				Row() {
					Column() {
						ForEach(this.list, (item: IBestPickerOption) => {
							Text(item.text)
								.pickerItemStyle(this.itemHeight)
						})
					}
					.translate({ x: 0, y: `${this.curOffset1 + this.getBaseOffset()}lpx`, z: 0 })
					.columnItemStyle()
					.animation({
						duration: 1000,
						curve: Curve.Ease
					})
					Column() {
						ForEach(this.list1, (item: IBestPickerOption) => {
							Text(item.text)
								.pickerItemStyle(this.itemHeight)
						})
					}
					.translate({ x: 0, y: `${this.curOffset2 + this.getBaseOffset()}lpx`, z: 0 })
					.visibility(this.list1.length ? Visibility.Visible : Visibility.None)
					.columnItemStyle()
					.animation({
						duration: 1000,
						curve: Curve.Ease
					})
					Column() {
						ForEach(this.list2, (item: IBestPickerOption) => {
							Text(item.text)
								.pickerItemStyle(this.itemHeight)
						})
					}
					.translate({ x: 0, y: `${this.curOffset3 + this.getBaseOffset()}lpx`, z: 0 })
					.visibility(this.list2.length ? Visibility.Visible : Visibility.None)
					.columnItemStyle()
					.animation({
						duration: 1000,
						curve: Curve.Ease
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
					Column()
						.columnItemStyle()
						.gesture(
							PanGesture({
								fingers: 1,
								direction: PanDirection.Vertical,
								distance: 1
							})
								.onActionStart(() => {
									this.onTouchStart(0)
								})
								.onActionUpdate((event: GestureEvent) => {
									this.onTouchMove(event, 0)
								})
								.onActionEnd(() => {
									this.onTouchEnd(0)
								})
						)
					Column()
						.columnItemStyle()
						.visibility(this.list1.length ? Visibility.Visible : Visibility.None)
						.gesture(
							PanGesture({
								fingers: 1,
								direction: PanDirection.Vertical,
								distance: 1
							})
								.onActionStart(() => {
									this.onTouchStart(1)
								})
								.onActionUpdate((event: GestureEvent) => {
									this.onTouchMove(event, 1)
								})
								.onActionEnd(() => {
									this.onTouchEnd(1)
								})
						)
					Column()
						.columnItemStyle()
						.visibility(this.list2.length ? Visibility.Visible : Visibility.None)
						.gesture(
							PanGesture({
								fingers: 1,
								direction: PanDirection.Vertical,
								distance: 1
							})
								.onActionStart(() => {
									this.onTouchStart(2)
								})
								.onActionUpdate((event: GestureEvent) => {
									this.onTouchMove(event, 2)
								})
								.onActionEnd(() => {
									this.onTouchEnd(2)
								})
						)
				}
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
				.justifyContent(FlexAlign.Center)
			}
			.height(`${this.itemHeight * 6}lpx`)
			.clip(true)
		}
		.width(CONTAINER_SIZE.FULL)
		.alignItems(HorizontalAlign.Start)
		.backgroundColor(this.baseStyle.default)
	}
}