import ibestEmitter from '../../utils/eventEmitter'
import { COMPONENT_NAME, RADIO_GROUP_EVENT_NAME } from './index.type'
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit, handleBeforeFunction, sleep } from '../../utils/utils'
import { IBestAwaitable, IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestRadioGroup {
	@State uniId: number = 0
	/**
	 * 分组标识
	 */
	@Prop @Require group: IBestStringNumber
	/**
	 * 激活的标识列表
	 * @since 2.0.1
	 */
	@Link @Watch("initRadio") active: IBestStringNumber | boolean
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
	@Prop @Watch("initRadio") disabled: boolean = false
	/**
	 * 默认内容
	 * @since 2.0.1
	 */
	@BuilderParam defaultBuilder: CustomBuilder
	/**
	 * 选中变化的回调
	 * @param name radio子组件的的name值
	 */
	onChange: (name: IBestStringNumber | boolean) => void = () => {}
	/**
	 * 改变前的回调
	 * @since 2.0.8
	 */
	beforeChange?: (name: IBestStringNumber | boolean) => IBestAwaitable

	aboutToAppear() {
		this.uniId = this.getUniqueId()
		ibestEmitter.on(getEventName(COMPONENT_NAME, RADIO_GROUP_EVENT_NAME.ITEM_CHANGE, this.group), this.uniId, (name: IBestStringNumber | boolean): Promise<void> => this.onItemChange(name))
		sleep(50).then(() => {
			this.initRadio()
		})
	}
	aboutToDisappear() {
		ibestEmitter.off(getEventName(COMPONENT_NAME, RADIO_GROUP_EVENT_NAME.ITEM_CHANGE, this.group), this.uniId)
	}
	initRadio() {
		ibestEmitter.emit(getEventName(COMPONENT_NAME, RADIO_GROUP_EVENT_NAME.INIT_CHILDREN, this.group), this.active, this.disabled)
	}
	async onItemChange(name: IBestStringNumber | boolean) {
		let status = await handleBeforeFunction(this.beforeChange, name)
		if(!status){
			return
		}
		this.active = name
		this.onChange(name)
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