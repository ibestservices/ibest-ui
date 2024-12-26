import { emitter } from '../../utils/EventEmitter';
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit, sleep } from '../../utils/utils';
import { CHECKBOX_GROUP_EVENT_NAME, COMPONENT_NAME, IBestCheckboxGroupController } from './index.type';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
export interface CheckboxGroupContext {
	/**
	 * 切换全选反选
	 * @param { boolean } [isSelectedAll] 切换所有复选框，传 true 为选中，false 为取消选中，不传参为取反
	 */
	toggleAll: (isSelectedAll?: boolean) => void
}
@Component
export struct IBestCheckboxGroup {
	/**
	 * 多个相同群组名称的CheckboxGroup，仅第一个CheckboxGroup生效。
	 */
	@Prop group: string;
	/**
	 * 最大可选数量 默认0是都可选
	 */
	@Prop @Watch('handleMaxChange') max: number = 0;
	/**
	 * 激活的标识列表
	 * @since 2.0.1
	 */
	@Link @Watch("activeChange") activeList: string[]
	/**
	 * 排列方向
	 * @since 2.0.1
	 */
	@Prop placeDirection: Axis = Axis.Vertical
	/**
	 * 排列间距
	 * @since 2.0.1
	 */
	@Prop space: number | string = convertDimensionsWidthUnit(12)
	/**
	 * 默认内容
	 */
	@BuilderParam defaultBuilder?: CustomBuilder
	/**
	 * 实例控制器
	 * @since 2.0.1
	 */
	controller: IBestCheckboxGroupController = new IBestCheckboxGroupController()
	/**
	 * 选中变化的回调
	 * 参数是checkbox子组件的的name值
	 */
	onChange: (checkedItemNames: string[]) => void = () => {}
	/**
	 * 初始化的回调
	 * @deprecated since 2.0.1
	 */
	onReady: (checkboxGroupContext: CheckboxGroupContext) => void = () => {}
	aboutToAppear() {
		this.controller.toggleAll = (isSelectAll?: boolean): void => this.toggleAll(isSelectAll)
		if (this.group) {
			emitter.on(getEventName(COMPONENT_NAME, this.group, CHECKBOX_GROUP_EVENT_NAME.ITEM_CHANGE), (name: string, checked: boolean): void => this.onItemChange(name, checked))
			sleep().then(() => {
				this.initChildren()
				this.handleMaxChange()
				this.onReady(this)
			})
		}
	}
	aboutToDisappear() {
		emitter.off(getEventName(COMPONENT_NAME, this.group, CHECKBOX_GROUP_EVENT_NAME.ITEM_CHANGE), (name: string, checked: boolean): void => this.onItemChange(name, checked))
	}

	initChildren() {
		emitter.emit(getEventName(COMPONENT_NAME, this.group, CHECKBOX_GROUP_EVENT_NAME.INIT_CHILDREN), this.activeList)
	}
	activeChange(){
		this.initChildren()
		this.handleMaxChange()
	}
	onItemChange(name: string, checked: boolean) {
		if(checked){
			let index = this.activeList.indexOf(name)
			if(index == -1){
				this.activeList.push(name)
			}
		}else {
			this.activeList = this.activeList.filter(item => item !== name)
		}
		this.onChange(this.activeList)
		this.handleMaxChange()
	}
	/**
	 * 当最大数量变化时
	 */
	handleMaxChange() {
		this.max > 0 &&
		emitter.emit(getEventName(COMPONENT_NAME, this.group, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE), {
			max: this.max,
			checkedList: this.activeList
		})
	}
	/**
	 * 全选与反选
	 * @param {boolean} [isSelectAll] 切换所有复选框，传 true 为选中，false 为取消选中，不传参为取反
	 */
	toggleAll(isSelectAll?: boolean) {
		emitter.emit(getEventName(COMPONENT_NAME, this.group, CHECKBOX_GROUP_EVENT_NAME.ON_TOGGLE_ALL), isSelectAll)
	}
	build() {
		if (this.placeDirection == Axis.Horizontal) {
			Row({ space: getSizeByUnit(this.space) }) {
				if (this.defaultBuilder) {
					this.defaultBuilder()
				}
			}
			.width(CONTAINER_SIZE.FULL)
		} else {
			Column({ space: getSizeByUnit(this.space) }) {
				if (this.defaultBuilder) {
					this.defaultBuilder()
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.alignItems(HorizontalAlign.Start)
		}
	}
}