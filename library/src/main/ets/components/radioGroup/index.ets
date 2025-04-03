import { emitter } from '../../utils/EventEmitter'
import { COMPONENT_NAME, RADIO_GROUP_EVENT_NAME } from './index.type'
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit, sleep } from '../../utils/utils'
import { IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestRadioGroup {
	@State uniId: number = 0
	/**
	 * 分组标识
	 */
	@Prop group: IBestStringNumber = ''
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
	/**
	 * 改变前的回调
	 * @since 2.0.8
	 */
	beforeChange?: (name: IBestStringNumber | boolean) => Promise<boolean> | boolean

	aboutToAppear() {
		this.uniId = this.getUniqueId()
		if(this.group){
			emitter.on(getEventName(COMPONENT_NAME, RADIO_GROUP_EVENT_NAME.ITEM_CHANGE, this.group), this.uniId, (name: IBestStringNumber | boolean): Promise<void> => this.onItemChange(name))
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
	async handleBeforeClose(name: IBestStringNumber | boolean) {
		let status = true
		try {
			if (this.beforeChange) {
				status = await this.beforeChange(name)
			}
		} catch (e) {
			status = false
		}
		return status
	}
	async onItemChange(name: IBestStringNumber | boolean) {
		let status = await this.handleBeforeClose(name)
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