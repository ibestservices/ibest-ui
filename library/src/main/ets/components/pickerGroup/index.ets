import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { IBestTabs } from '../tab';
import { IBestTabController, IBestTabItemType } from '../tab/index.type';
@Component
export struct IBestPickerGroup{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 分组id
	 */
	@Prop groupId: string = ""
	/**
	 * 标题
	 */
	@Prop title: string = ""
	/**
	 * 顶部标签栏列表
	 */
	@Prop tabs: Array<string> = []
	/**
	 * 下一步
	 */
	@Prop nextStepText: string = ""

	// 渲染的tab列表
	@State tabsList: IBestTabItemType[] = []
	/**
	 * 当前激活tabname
	 */
	@Prop @Watch("tabNameChange") currentName: string = '0'
	// swiper索引
	@State swiperIndex: number = 0
	/**
	 * 是否显示头部工具栏
	 */
	@Prop showToolBar: boolean = true
	/**
	 * 确认按钮文字
	 */
	@Prop confirmText: string = "确定"
	/**
	 * 取消按钮文字
	 */
	@Prop cancelText: string = "取消"
	/**
	 * 默认插槽
	 */
	@BuilderParam defaultBuilder: () => void
	/**
	 * 确认按钮点击事件
	 */
	onConfirm: () => void = () => {}
	/**
	 * 取消按钮点击事件
	 */
	onCancel: () => void = () => {}
	/**
	 * currentName变化事件
	 */
	onTabNameChange: (name: string) => void = () => {}
	private swiperController: SwiperController = new SwiperController()

	aboutToAppear(): void {
		this.init()
	}
	// 初始化tablist
	init(){
		this.tabsList = this.tabs.map((item, index) => {
			let obj: IBestTabItemType = {
				label: item,
				name: index + ''
			}
			return obj
		})
	}
	// tabname 改变
	tabNameChange(){
		this.tabChange(Number(this.currentName))
	}
	// tab切换
	tabChange(index: number){
		this.swiperController.changeIndex(index, true)
		this.onTabNameChange(this.currentName)
	}
	// 确认按钮点击
	onConfirmClick(){
		if(this.nextStepText && this.swiperIndex < this.tabsList.length - 1){
			this.currentName = `${this.swiperIndex+1}`
			this.tabChange(this.swiperIndex+1)
		}else{
			this.onConfirm()
		}
	}

	build() {
		Column(){
			if(this.showToolBar){
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
						Text(this.nextStepText && this.swiperIndex < this.tabsList.length - 1 ? this.nextStepText : this
							.confirmText)
							.height(CONTAINER_SIZE.FULL)
							.fontSize(this.baseStyle.fontSizeMd)
							.fontColor(this.baseStyle.primary)
							.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
							.onClick(() => {
								this.onConfirmClick()
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
			// tabs
			Row(){
				IBestTabs({
					currentName: $currentName,
					tabsList: this.tabsList,
					tabWidthType: "auto",
					onChange: (name: string) => {
						this.tabChange(Number(name))
					}
				})
			}
			.padding({ left: this.baseStyle.spaceXs, right: this.baseStyle.spaceXs, bottom: this.baseStyle.spaceXs })

			Swiper(this.swiperController) {
				this.defaultBuilder()
			}
			.width("100%")
			.disableSwipe(true)
			.indicator(false)
			.loop(false)
			.duration(100)
			.index($$this.swiperIndex)
		}
		.width(CONTAINER_SIZE.FULL)
		.alignItems(HorizontalAlign.Start)
		.backgroundColor(this.baseStyle.default)
	}
}