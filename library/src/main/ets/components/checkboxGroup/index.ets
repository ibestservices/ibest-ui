import { emitter } from '../../utils/EventEmitter'
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit, handleBeforeFunction, sleep } from '../../utils/utils'
import { CHECKBOX_GROUP_EVENT_NAME, COMPONENT_NAME, IBestCheckboxGroupController } from './index.type'
import { IBestAwaitable, IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestCheckboxGroup {
	/**
	 * 分组id
	 */
	@Prop @Require group: IBestStringNumber
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
	 * 是否禁用
	 * @since 2.1.0
     */
	@Prop @Watch('initChildren') disabled: boolean = false
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
	beforeChange?: (checkedItemNames: IBestStringNumber[]) => IBestAwaitable

	@State uniId: number = 0
	@State allCheckNames: IBestStringNumber[] = []

	aboutToAppear() {
		this.uniId = this.getUniqueId()
		this.controller.toggleAll = (isSelectAll?: boolean): void => this.toggleAll(isSelectAll)
		if (this.group) {
			emitter.on(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.GET_ALL_NAME, this.group), this.uniId, (name: IBestStringNumber): void => this.getAllNames(name))
			emitter.on(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.ITEM_CHANGE, this.group), this.uniId, (name: string, checked: boolean): Promise<void> => this.onItemChange(name, checked))
			sleep(50).then(() => {
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
		emitter.emit(getEventName(COMPONENT_NAME, CHECKBOX_GROUP_EVENT_NAME.INIT_CHILDREN, this.group), this.activeList, this.disabled)
	}
	activeChange(){
		this.initChildren()
		this.handleMaxChange()
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
		let status = await handleBeforeFunction(this.beforeChange, checkedNames)
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
		this.onChange(this.activeList)
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