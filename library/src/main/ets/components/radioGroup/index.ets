import { emitter } from '../../utils/EventEmitter'
import { COMPONENT_NAME, RADIO_GROUP_EVENT_NAME } from './index.type'
import { getSizeByUnit, convertDimensionsWidthUnit, getEventName, sleep } from '../../utils/utils'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
@Component
export struct IBestRadioGroup {
	/**
	 * 分组标识
	 */
	@Prop group: string
	/**
	 * 激活的标识列表
	 * @since 2.0.1
	 */
	@Link @Watch("initRadio") active: string | number | boolean
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
	 * @since 2.0.1
	 */
	@BuilderParam defaultBuilder?: CustomBuilder
	/**
	 * 选中变化的回调
	 * @param name radio子组件的的name值
	 */
	onChange: (name: string | number | boolean) => void = () => {}

	aboutToAppear() {
		emitter.on(getEventName(COMPONENT_NAME, this.group, RADIO_GROUP_EVENT_NAME.ITEM_CHANGE), (name: string | number | boolean): void => this.onItemChange(name))
		sleep(50).then(() => {
			this.initRadio()
		})
	}
	aboutToDisappear() {
		emitter.off(getEventName(COMPONENT_NAME, this.group, RADIO_GROUP_EVENT_NAME.ITEM_CHANGE), (name: string | number | boolean): void => this.onItemChange(name))
	}
	initRadio() {
		emitter.emit(getEventName(COMPONENT_NAME, this.group, RADIO_GROUP_EVENT_NAME.INIT_CHILDREN), this.active)
	}
	onItemChange(name: string | number | boolean) {
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