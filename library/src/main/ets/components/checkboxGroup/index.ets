import { emitter } from '../../utils/EventEmitter'
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit, sleep } from '../../utils/utils'
import { CHECKBOX_GROUP_EVENT_NAME, COMPONENT_NAME, IBestCheckboxGroupController } from './index.type'
import { IBestStringNumber } from '../../model/Global.type'

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
	@Prop group: IBestStringNumber
	/**
	 * 最大可选数量 默认0是都可选
	 */
	@Prop @Watch('handleMaxChange') max: number = 0
	/**
	 * 激活的标识列表
	 * @since 2.0.1
	 */
	@Link @Watch("activeChange") activeList: IBestStringNumber[]
	/**
	 * 排列方向
	 * @since 2.0.1
	 */
	@Prop placeDirection: Axis = Axis.Vertical
	/**
	 * 排列间距
	 * @since 2.0.1
	 */
	@Prop space: IBestStringNumber = convertDimensionsWidthUnit(12)
	/**
	 * 默认内容
	 */
	@BuilderParam defaultBuilder: CustomBuilder
	/**
	 * 实例控制器
	 * @since 2.0.1
	 */
	controller: IBestCheckboxGroupController = new IBestCheckboxGroupController()
	/**
	 * 选中变化的回调
	 * 参数是checkbox子组件的的name值
	 */
	onChange: (checkedItemNames: IBestStringNumber[]) => void = () => {}
	/**
	 * 改变前的回调
	 * @since 2.0.8
	 */
	beforeChange?: (checkedItemNames: IBestStringNumber[]) => Promise<boolean> | boolean

	@State uniId: number = 0
	@State allCheckNames: IBestStringNumber[] = []

	aboutToAppear() {
		this.uniId = this.getUniqueId()
		this.controller.toggleAll = (isSelectAll?: boolean): void => this.toggleAll(isSelectAll)
		if (this.group) {
			emitter.on(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.GET_ALL_NAME, this.group), this.uniId, (name: IBestStringNumber): void => this.getAllNames(name))
			emitter.on(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.ITEM_CHANGE, this.group), this.uniId, (name: string, checked: boolean): Promise<void> => this.onItemChange(name, checked))
			sleep().then(() => {
				this.initChildren()
				this.handleMaxChange()
			})
		}
	}
	aboutToDisappear() {
		if(this.group){
			emitter.off(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.GET_ALL_NAME, this.group), this.uniId)
			emitter.off(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.ITEM_CHANGE, this.group), this.uniId)
		}
	}
	getAllNames(name: IBestStringNumber){
		if(!this.allCheckNames.includes(name)){
			this.allCheckNames.push(name)
		}
	}
	initChildren() {
		emitter.emit(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.INIT_CHILDREN, this.group), this.activeList)
	}
	activeChange(){
		this.initChildren()
		this.handleMaxChange()
	}
	async handleBeforeClose(checkedNames: IBestStringNumber[]) {
		let status = true
		try {
			if (this.beforeChange) {
				status = await this.beforeChange(checkedNames)
			}
		} catch (e) {
			status = false
		}
		return status
	}
	async onItemChange(name: string, checked: boolean) {
		let checkedNames: IBestStringNumber[] = [...this.activeList]
		if(checked){
			let index = this.activeList.indexOf(name)
			if(index == -1){
				checkedNames.push(name)
			}
		}else {
			checkedNames = checkedNames.filter(item => item !== name)
		}
		let status = await this.handleBeforeClose(checkedNames)
		if(!status){
			this.activeList = [...this.activeList]
			return
		}
		this.activeList = checkedNames
		this.onChange(checkedNames)
		this.handleMaxChange()
	}
	// 当最大数量变化时
	handleMaxChange() {
		this.max > 0 &&
		emitter.emit(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE, this.group), {
			max: this.max,
			checkedList: this.activeList
		})
	}
	// 全选与反选
	toggleAll(isSelectAll?: boolean) {
		if(typeof isSelectAll == 'boolean'){
			if(isSelectAll){
				this.activeList = this.allCheckNames
			}else {
				this.activeList = []
			}
		}else{
			this.activeList = this.allCheckNames.filter(item => !this.activeList.includes(item))
		}
	}
	build() {
		if (this.placeDirection == Axis.Horizontal) {
			Row({ space: getSizeByUnit(this.space) }) {
				if (this.defaultBuilder) {
					this.defaultBuilder()
				}
			}
		} else {
			Column({ space: getSizeByUnit(this.space) }) {
				if (this.defaultBuilder) {
					this.defaultBuilder()
				}
			}
			.alignItems(HorizontalAlign.Start)
		}
	}
}