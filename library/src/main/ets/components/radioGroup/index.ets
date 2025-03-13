import { emitter } from '../../utils/EventEmitter'
import { COMPONENT_NAME, RADIO_GROUP_EVENT_NAME } from './index.type'
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit, sleep } from '../../utils/utils'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestRadioGroup {
	@State uniId: number = 0
	/**
	 * 分组标识
	 */
	@Prop group: string
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
	 * 默认内容
	 * @since 2.0.1
	 */
	@BuilderParam defaultBuilder?: CustomBuilder
	/**
	 * 选中变化的回调
	 * @param name radio子组件的的name值
	 */
	onChange: (name: IBestStringNumber | boolean) => void = () => {}

	aboutToAppear() {
		this.uniId = this.getUniqueId()
		if(this.group){
			emitter.on(getEventName(COMPONENT_NAME, RADIO_GROUP_EVENT_NAME.ITEM_CHANGE, this.group), this.uniId, (name: IBestStringNumber | boolean): void => this.onItemChange(name))
			sleep(50).then(() => {
				this.initRadio()
			})
		}
	}
	aboutToDisappear() {
		if(this.group){
			emitter.off(getEventName(COMPONENT_NAME, RADIO_GROUP_EVENT_NAME.ITEM_CHANGE, this.group), this.uniId)
		}
	}
	initRadio() {
		emitter.emit(getEventName(COMPONENT_NAME, RADIO_GROUP_EVENT_NAME.INIT_CHILDREN, this.group), this.active)
	}
	onItemChange(name: IBestStringNumber | boolean) {
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