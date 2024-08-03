import { getIsLandscape, sleep } from '../../assets/ets/utils'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { fontSizeData } from '../../theme-chalk/src/font'
import { IBestUIBaseStyleObjType, IbestUIBaseStyleValue } from '../../theme-chalk/src/index.type'
import { spaceData } from '../../theme-chalk/src/space'
import { IBestTabs } from '../tab'
import { IBestTabController, IBestTabItem } from '../tab/index.type'
import { IBestCascaderOption, IBestCascaderOptionInstance, IBestCascaderOptionInstanceType } from './index.type'
import { IBestPopup } from '../popup/index'

@CustomDialog
@Component
struct IBestCascaderContent{
	/*
	 * 顶部tab栏数据
	 */
	@State tabList: IBestTabItem[] = [
		new IBestTabItem({
			label: "请选择",
			name: "0"
		})
	]
	/*
	 * 当前激活tab name
	 */
	@State currentTabName: string = "0"
	/*
	 * swiper默认显示选项
	 */
	@State swiperDefaultIndex: number = 0
	// 是否横屏
	@State isLandscape: boolean = getIsLandscape(getContext(this))
	/*
	 * 可选项数据源
	 */
	@Consume options: IBestCascaderOption[]
	/*
	 * 数据源实例
	 */
	@State optionsInstance: IBestCascaderOptionInstance[][] = []
	/*
	 * 已选中数据
	 */
	@Prop selectData: IBestCascaderOption[] = []
	/*
	 * 选中颜色
	 */
	@Consume activeColor: string | IbestUIBaseStyleValue
	/*
	 * 列表区域高度
	 */
	@Consume listHeight: number
	/*
	 * 是否开启动态加载
	 */
	@Consume lazy: boolean
	/*
	 * 动态加载函数
	 */
	lazyLoad: ((value: string | number, level: number, cb: (arr: IBestCascaderOption[]) => void) => void) | null = null

	controller?: CustomDialogController
	private tabController: IBestTabController = new IBestTabController()
	private swiperController: SwiperController = new SwiperController()
	/*
	 * 选中项变化时回调函数
	 */
	onChange: (value: string | number, selectedOptions: IBestCascaderOption[], index: number) => void = () => {}
	/*
	 * 全部选择完后回调函数
	 */
	onConfirm: (value: IBestCascaderOption[]) => void = () => {}

	aboutToAppear(): void {
		if(this.selectData.length){
			this.createAllOptionsInstance([], this.options, 0)
		}else {
			this.optionsInstance.push(this.createOptionsInstance(this.options))
		}
	}
	// 创建当前tab下的选项实例
	createOptionsInstance(children: IBestCascaderOption[] = []): IBestCascaderOptionInstance[]{
		return children.length ? children.map((item: IBestCascaderOption) => {
			let obj: IBestCascaderOptionInstanceType = {
				text: item.text,
				value: item.value,
				disabled: item.disabled,
				children: item.children || [],
				actived: false,
				isEnd: item.isEnd
			}
			return new IBestCascaderOptionInstance(obj)
		}) : []
	}
	// 创建全部选项实例
	createAllOptionsInstance(array: IBestCascaderOptionInstance[][] = [], children: IBestCascaderOption[] = [], index: number){
		let curData = this.selectData[index]
		let i = children.findIndex((item: IBestCascaderOption) => item.value === curData.value)
		array.push(
			children.map((item: IBestCascaderOption) => {
				let obj: IBestCascaderOptionInstanceType = {
					text: item.text,
					value: item.value,
					disabled: item.disabled,
					children: item.children || [],
					actived: curData.value === item.value,
					isEnd: item.isEnd
				}
				return new IBestCascaderOptionInstance(obj)
			})
		)
		if(children[i].children?.length){
			this.createAllOptionsInstance(array, children[i].children, index + 1)
		}else{
			this.optionsInstance = array
			this.tabList = this.selectData.map((item: IBestCascaderOption, j: number) => {
				return new IBestTabItem({
					label: item.text,
					name: `${j}`
				})
			})
			this.currentTabName = `${this.selectData.length - 1}`
			this.swiperDefaultIndex = this.selectData.length - 1
		}
	}
	// 顶部tab切换
	tabChange(index: number){
		this.swiperController.changeIndex(index, true)
	}
	// 选中item
	async selectItem(index1: number, index2: number, item: IBestCascaderOptionInstance) {
		// console.log(`选中${index1} ${index2} children ${item.children?.length} isEnd ${item.isEnd}`)
		// 如果选中索引小于当前tab数量,清空tab在索引后的所有项
		if (index1 < this.optionsInstance.length - 1) {
			this.tabList.splice(index1 + 1)
			this.optionsInstance.splice(index1 + 1)
		}
		// 设置当前列表项为选中状态
		this.optionsInstance[index1].forEach((item: IBestCascaderOptionInstance) => {
			item.actived = false
		})
		this.optionsInstance[index1][index2].actived = true
		// 设置当前tab的文字
		this.tabList[index1].label = item.text
		// 如果还有选项 添加一项(请添加)
		if (!(item.children && item.children.length) && (!this.lazy || item.isEnd)) {
			this.onConfirm(this.getSelectedOptions())
		} else {
			this.onChange(item.value, this.getSelectedOptions(), index1)
			if (item.children && item.children.length) {
				this.createNextSwiperData(item.children, index1 + 1)
			} else if (this.lazy && this.lazyLoad) {
				this.lazyLoad(item.value, index1 + 1, (arr: IBestCascaderOption[]) => {
					if (arr.length) {
						item.children = arr
						this.createNextSwiperData(arr, index1 + 1)
					}
				})
			}
		}
	}
	// 创建下一个选项的数据实例
	async createNextSwiperData(children: IBestCascaderOption[], index: number){
		let name = `${Number(this.tabList[this.tabList.length - 1].name) + 1}`
		await sleep(50)
		this.tabList.push(new IBestTabItem({
			label: "请选择",
			name
		}))
		this.currentTabName = name
		this.optionsInstance.push(this.createOptionsInstance(children))
		await sleep(30)
		this.tabController.changeTab(name)
		this.tabChange(index + 1)
	}
	// 获取当前已选中的选项
	getSelectedOptions(): IBestCascaderOption[] {
		let arr: IBestCascaderOption[] = []
		this.optionsInstance.forEach((e: IBestCascaderOptionInstance[]) => {
			arr = arr.concat(e.filter(f => f.actived).map(g => {
				let obj: IBestCascaderOption = {
					text: g.text,
					value: g.value
				}
				return obj
			}))
		})
		return arr
	}

	build() {
		Column({space: 10}){
			IBestTabs({
				tabController: this.tabController,
				tabsList: this.tabList,
				tabWidthType: "auto",
				tabLineColor: this.activeColor,
				currentName: this.currentTabName,
				onChange: (name: string) => {
					this.tabChange(Number(name))
				}
			})
			Swiper(this.swiperController) {
				ForEach(this.optionsInstance, (item: IBestCascaderOptionInstance[], index: number) => {
					Scroll(){
						Column(){
							ForEach(item, (item1: IBestCascaderOptionInstance, index1: number) => {
								CascaderOptionItem({
									option: item1,
									index: index,
									index1: index1,
									onSelect: (index: number, index1: number, item1: IBestCascaderOptionInstance): Promise<void> => this.selectItem(index, index1, item1)
								})
							})
						}
						.alignItems(HorizontalAlign.Start)
						.padding({ left: spaceData.spaceMd, right: spaceData.spaceMd })
					}
					.width("100%")
					.height("100%")
					.align(Alignment.Top)
					.padding({ bottom: spaceData.spaceMd })
				}, (item: IBestCascaderOptionInstance[], index: number) => index + "")
			}
			.width("100%")
			.height(this.isLandscape ? "" : `${this.listHeight}lpx`)
			.layoutWeight(this.isLandscape ? 1 : 0)
			.indicator(false)
			.loop(false)
			.duration(100)
			.index(this.swiperDefaultIndex)
			.onChange((index: number) => {
				this.tabController.changeTab(`${index}`)
			})
		}
		.width("100%")
		.alignItems(HorizontalAlign.Start)
	}
}

@Component
struct CascaderOptionItem{
	/*
	 * 选项数据
	 */
	@ObjectLink option: IBestCascaderOptionInstance
	/*
	 * 当前tab索引
	 */
	@Prop index: number
	/*
	 * 当前选项索引
	 */
	@Prop index1: number
	/*
	 * 选中颜色
	 */
	@Consume activeColor: string
	/*
	 * item高度
	 */
	@Consume itemHeight: number
	onSelect: (index: number, index1: number, item1: IBestCascaderOptionInstance)=> Promise<void> = () => new Promise((resolve, reject) => {})
	build() {
		Row(){
			Text(this.option.text)
				.fontColor(this.option.actived ? this.activeColor : "#333")
				.fontSize(fontSizeData.fontSizeMd)
			Image($r("app.media.success"))
				.width("36lpx")
				.aspectRatio(1)
				.fillColor(this.activeColor)
				.visibility(this.option.actived ? Visibility.Visible : Visibility.Hidden)
		}
		.width("100%")
		.height(`${this.itemHeight}lpx`)
		.justifyContent(FlexAlign.SpaceBetween)
		.alignItems(VerticalAlign.Center)
		.onClick(() => {
			this.onSelect(this.index, this.index1, this.option)
		})
		.enabled(!this.option.disabled)
		.opacity(this.option.disabled ? 0.5 : 1)
	}
}

@Component
export struct IBestCascader{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/*
	 * 弹框显隐
	 */
	@Link visible: boolean
	/*
	 * 标题
	 */
	@Prop title: string = "请选择"
	/*
	 * 可选项数据源
	 */
	@Provide options: IBestCascaderOption[] = []
	/*
	 * 选中颜色
	 */
	@Provide activeColor: string | IbestUIBaseStyleValue = this.baseStyle.primary
	/*
	 * 列表区域高度
	 */
	@Provide listHeight: number = 700
	/*
	 * 单项高度
	 */
	@Provide itemHeight: number = 80
	/*
	 * 是否开启动态加载
	 */
	@Provide lazy: boolean = false
	/*
	 * 动态加载函数
	 */
	lazyLoad: ((value: string | number, level: number, cb: (arr: IBestCascaderOption[]) => void) => void) | null = null
	/*
	 * 已选项
	 */
	@Prop selectData: IBestCascaderOption[] = []
	/*
	 * 选中项变化时回调函数
	 */
	onChange: (value: string | number, selectedOptions: IBestCascaderOption[], index: number) => void = () => {}
	/*
	 * 全部选择完回调
	 */
	onConfirm: (value: IBestCascaderOption[]) => void = () => {}

	@Builder baseBuilder() {
		IBestCascaderContent({
			selectData: this.selectData,
			lazyLoad: this.lazyLoad,
			onChange: this.onChange,
			onConfirm: (value: IBestCascaderOption[]) => {
				this.onGetResult(value)
			}
		})
	}
	onGetResult(value: IBestCascaderOption[]){
		this.selectData = value
		this.onConfirm(value)
		this.visible = false
	}
	build() {
		IBestPopup({
			visible: this.visible,
			title: this.title,
			isShowHeader: true,
			popupAlign: "bottom",
			safeAreaInsetBottom: true,
			contentBuilder: ():void => this.baseBuilder()
		})
	}
}