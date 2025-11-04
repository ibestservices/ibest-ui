import { convertDimensionsWidthUnit, getResourceStr, getSizeByUnit, sleep } from '../../utils/utils'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { IBestTabs } from '../tab'
import { IBestTabItem } from '../tab/index.type'
import { IBestCascaderOption, IBestCascaderOptionInstance, IBestCascaderOptionInstanceType } from './index.type'
import { IBestPopup } from '../popup/index'
import { IBestCascaderColor } from './color'
import { IBestIcon } from '../icon'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'

@Component
export struct IBestCascaderContent{
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	// 是否横屏
	@StorageProp(IBestStorageKey.IS_LANDSCAPE) isLandscape: boolean = false
	/**
	 * 可选项数据源
	 */
	@Prop @Watch("optionsChange") options: IBestCascaderOption[] = []
	/**
	 * 已选中数据
	 */
	@Link value: IBestStringNumber[]
	/**
	 * 选中颜色
	 */
	@Provide({allowOverride: "activeColor"}) activeColor: ResourceColor = ""
	/**
	 * 列表区域高度
	 */
	@Prop listHeight: IBestStringNumber
	/**
	 * 单项高度
	 */
	@Provide({allowOverride: "itemHeight"}) itemHeight: IBestStringNumber = convertDimensionsWidthUnit(40)
	/**
	 * 是否开启动态加载
	 */
	@Prop lazy: boolean = false
	/**
	 * 动态加载函数
	 */
	lazyLoad: ((value: IBestStringNumber, level: number, cb: (arr: IBestCascaderOption[]) => void) => void) | null = null
	/**
	 * 选中项变化时回调函数
	 */
	onChange: (value: IBestStringNumber, selectedOptions: IBestCascaderOption[], index: number) => void = () => {}
	/**
	 * 全部选择完后回调函数
	 */
	onConfirm: (value: IBestCascaderOption[]) => void = () => {}

	// 顶部tab栏数据
	@State tabList: IBestTabItem[] = [
		new IBestTabItem({
			label: $r("app.string.ibest_please_select"),
			name: 0
		})
	]
	// 当前激活tab name
	@State currentTabName: number = 0
	//数据源实例
	@State optionsInstance: IBestCascaderOptionInstance[][] = []
	// swiper默认显示选项
	@State swiperIndex: number = 0
	private swiperController: SwiperController = new SwiperController()

	aboutToAppear(): void {
		if(this.options.length){
			if(this.value.length){
				this.createAllOptionsInstance([], this.options, 0)
			}else {
				this.optionsChange()
			}
		}
	}
	getListHeight(){
		return this.listHeight ? getSizeByUnit(this.listHeight) : (this.isLandscape ? "60%" : convertDimensionsWidthUnit(350))
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
		let curValue = this.value[index]
		let i = children.findIndex((item: IBestCascaderOption) => item.value === curValue)
		i = i > -1 ? i : 0
		array.push(
			children.map((item: IBestCascaderOption) => {
				let obj: IBestCascaderOptionInstanceType = {
					text: item.text,
					value: item.value,
					disabled: item.disabled,
					children: item.children || [],
					actived: curValue === item.value,
					isEnd: item.isEnd
				}
				return new IBestCascaderOptionInstance(obj)
			})
		)
		if(children[i].children?.length){
			this.createAllOptionsInstance(array, children[i].children, index + 1)
		}else{
			this.optionsInstance = array
			let value = this.value
			if(value.length > array.length){
				value = value.slice(0, array.length)
			}
			this.tabList = value.map((item: IBestStringNumber, j: number) => {
				let a = array[j].find((e: IBestCascaderOptionInstance) => e.value == item)
				return new IBestTabItem({
					label: a?.text ?? "",
					name: j
				})
			})
			this.currentTabName = this.swiperIndex = value.length - 1
		}
	}
	// 选项变化
	optionsChange(){
		if(this.options.length) {
			this.optionsInstance = []
			this.optionsInstance.push(this.createOptionsInstance(this.options))
		}
	}
	// 顶部tab切换
	tabChange(index: number){
		this.swiperController.changeIndex(index, true)
	}
	// 选中item
	selectItem(index1: number, index2: number, item: IBestCascaderOptionInstance) {
		// 如果选中索引小于当前tab数量,清空tab在索引后的所有项
		if (index1 < this.optionsInstance.length - 1) {
			this.tabList.splice(index1 + 1)
			this.optionsInstance.splice(index1 + 1)
		}
		// 设置当前列表项为选中状态
		this.optionsInstance[index1].forEach((item: IBestCascaderOptionInstance, index: number) => {
			item.actived = index == index2
		})
		// 设置当前tab的文字
		this.tabList[index1].label = item.text
		// 如果还有选项 添加一项(请添加)
		let selectOption = this.getSelectedOptions()
		if (!(item.children && item.children.length) && (!this.lazy || item.isEnd)) {
			this.value = selectOption.map((e: IBestCascaderOption) => e.value)
			this.onConfirm(selectOption)
		} else {
			this.onChange(item.value, selectOption, index1)
			if (item.children && item.children.length) {
				this.createNextSwiperData(item.children, index1 + 1)
			} else if (this.lazy && this.lazyLoad) {
				this.lazyLoad(item.value, index1 + 1, (arr: IBestCascaderOption[]) => {
					if (arr.length) {
						this.createNextSwiperData(arr, index1 + 1)
						this.changeOriginOption(this.options, arr, index1, 0)
					}
				})
			}
		}
	}
	// 改变原数组
	changeOriginOption(children: IBestCascaderOption[], arr: IBestCascaderOption[], level: number, index: number){
		let selected = this.getSelectedOptions()
		let item = children.find(e => e.value == selected[index].value)
		if(item){
			if(level == index){
				item.children = arr
			}else if(item.children){
				this.changeOriginOption(item.children, arr, level, index + 1)
			}
		}
	}
	// 创建下一个选项的数据实例
	async createNextSwiperData(children: IBestCascaderOption[], index: number){
		await sleep(30)
		let tab = new IBestTabItem({
			label: $r("app.string.ibest_please_select"),
			name: index
		})
		let optionsInstance = this.createOptionsInstance(children)
		if(this.value[index] !== undefined){
			let i = optionsInstance.findIndex((e: IBestCascaderOptionInstance) => e.value == this.value[index])
			if(i > -1){
				optionsInstance[i].actived = true
				tab.label = optionsInstance[i].text
			}
		}
		this.optionsInstance.push(optionsInstance)
		this.tabList.push(tab)
		await sleep(30)
		this.tabChange(index)
	}
	// 获取当前已选中的选项
	getSelectedOptions(): IBestCascaderOption[] {
		let arr: IBestCascaderOption[] = []
		this.optionsInstance.forEach((e: IBestCascaderOptionInstance[]) => {
			arr = arr.concat(e.filter(f => f.actived).map(g => {
				let obj: IBestCascaderOption = {
					text: getResourceStr(g.text),
					value: g.value
				}
				return obj
			}))
		})
		return arr
	}

	build() {
		Column({space: 10}){
			Row(){
				IBestTabs({
					tabsList: this.tabList,
					tabWidthType: "auto",
					tabLineColor: this.activeColor || this.baseStyle.primary,
					currentName: $currentTabName,
					onChange: name => {
						this.tabChange(Number(name))
					}
				})
			}
			.padding({ left: this.baseStyle.spaceXs, right: this.baseStyle.spaceXs })
			Swiper(this.swiperController) {
				ForEach(this.optionsInstance, (item: IBestCascaderOptionInstance[], index: number) => {
					Scroll(){
						Column(){
							ForEach(item, (item1: IBestCascaderOptionInstance, index1: number) => {
								CascaderOptionItem({
									option: item1,
									index: index,
									index1: index1,
									onSelect: (index: number, index1: number, item1: IBestCascaderOptionInstance): void => this.selectItem(index, index1, item1)
								})
							})
						}
						.alignItems(HorizontalAlign.Start)
						.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
					}
					.width("100%")
					.height("100%")
					.align(Alignment.Top)
					.padding({ bottom: this.baseStyle.spaceMd })
				}, (_: IBestCascaderOptionInstance[], index: number) => index + "")
			}
			.width(CONTAINER_SIZE.FULL)
			.height(this.getListHeight())
			.indicator(false)
			.loop(false)
			.duration(100)
			.index(this.swiperIndex)
			.onChange(index => {
				this.currentTabName = index
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.alignItems(HorizontalAlign.Start)
		.backgroundColor(IBestCascaderColor.bgColor)
	}
}

@Component
struct CascaderOptionItem{
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 选项数据
	 */
	@ObjectLink option: IBestCascaderOptionInstance
	/**
	 * 当前tab索引
	 */
	@Prop index: number
	/**
	 * 当前选项索引
	 */
	@Prop index1: number
	@Consume activeColor: ResourceColor
	@Consume itemHeight: number
	onSelect: (index: number, index1: number, item1: IBestCascaderOptionInstance)=> void = () => {}
	build() {
		Row(){
			Text(this.option.text)
				.fontColor(this.option.actived ? this.activeColor || this.baseStyle.primary : IBestCascaderColor.textColor)
				.fontSize(this.baseStyle.fontSizeMd)
			IBestIcon({
				name: "success",
				iconSize: convertDimensionsWidthUnit(18),
				color: this.activeColor || this.baseStyle.primary
			})
				.visibility(this.option.actived ? Visibility.Visible : Visibility.Hidden)
		}
		.width("100%")
		.height(getSizeByUnit(this.itemHeight))
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
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 弹框显隐
	 */
	@Link visible: boolean
	/**
	 * 标题
	 */
	@Prop title: ResourceStr = $r("app.string.ibest_please_select")
	/**
	 * 可选项数据源
	 */
	@Prop options: IBestCascaderOption[] = []
	/**
	 * 选中颜色
	 */
	@Prop activeColor: ResourceColor = ""
	/**
	 * 列表区域高度
	 */
	@Prop listHeight: IBestStringNumber
	/**
	 * 单项高度
	 */
	@Prop itemHeight: IBestStringNumber
	/**
	 * 是否开启动态加载
	 */
	@Prop lazy: boolean
	/**
	 * 动态加载函数
	 */
	lazyLoad: ((value: IBestStringNumber, level: number, cb: (arr: IBestCascaderOption[]) => void) => void) | null = null
	/**
	 * 已选项
	 */
	@Link value: IBestStringNumber[]
	/**
	 * 选中项变化时回调函数
	 */
	onChange: (value: IBestStringNumber, selectedOptions: IBestCascaderOption[], index: number) => void = () => {}
	/**
	 * 全部选择完回调
	 */
	onConfirm: (value: IBestCascaderOption[]) => void = () => {}

	@Builder baseBuilder() {
		IBestCascaderContent({
			value: $value,
			options: this.options,
			activeColor: this.activeColor,
			listHeight: this.listHeight,
			itemHeight: this.itemHeight,
			lazy: this.lazy,
			lazyLoad: this.lazyLoad,
			onChange: this.onChange,
			onConfirm: (value: IBestCascaderOption[]): void => this.onGetResult(value)
		})
	}
	onGetResult(value: IBestCascaderOption[]){
		this.onConfirm(value)
		this.visible = false
	}
	build() {
		IBestPopup({
			visible: $visible,
			title: this.title,
			isShowHeader: true,
			popupAlign: "bottom",
			popupHeight: "auto",
			safeAreaInsetBottom: true,
			contentBuilder: ():void => this.baseBuilder()
		})
	}
}