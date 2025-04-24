import { IBestStringNumber } from "../../../../../Index"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { emitter } from "../../utils/EventEmitter"
import { getEventName } from "../../utils/utils"
import { COMPONENT_NAME, STEPS_EVENT_NAME } from "./index.type"


@Component
export struct IBestSteps{
	/**
	 * 分组id
     */
	@Prop groupId: IBestStringNumber
	/**
	 * 当前激活的步骤索引
     */
	@Link active: number
	/**
	 * 步骤条方向
     */
	@Provide placeDirection: Axis = Axis.Horizontal
	/**
	 * 自定义内容
     */
	@BuilderParam defaultBuilder: CustomBuilder

	onDidBuild(): void {
		console.log('onDidBuild')
	}

	build() {
		if(this.placeDirection == Axis.Vertical){
			Column(){
				if(this.defaultBuilder){
					this.defaultBuilder()
				}
			}
			.width(CONTAINER_SIZE.FULL)
		}else {
			Row(){
				if(this.defaultBuilder){
					this.defaultBuilder()
				}
			}
			.width(CONTAINER_SIZE.FULL)
		}
	}
}

@Component
export struct IBestStep{
	/**
	 * 分组id
	 */
	@Prop groupId: IBestStringNumber
	/**
	 * 标题
     */
	@Prop title: ResourceStr
	/**
	 * 描述
     */
	@Prop description: ResourceStr
	/**
	 * 自定义内容
	 */
	@BuilderParam defaultBuilder: CustomBuilder

	@State uniId: number = 0
	@State placeDirection: Axis = Axis.Horizontal

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
		emitter.on(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.SEND_CONFIG, this.groupId), this.uniId, (direction: Axis): void => this.saveDirection(direction))
		console.log('aboutToAppear')
	}
	aboutToDisappear(): void {
		emitter.off(getEventName(COMPONENT_NAME, STEPS_EVENT_NAME.SEND_CONFIG, this.groupId), this.uniId)
	}
	saveDirection(direction: Axis){
		this.placeDirection = direction
	}
	build() {
		Column(){
			if(this.title){
				Text(this.title)
			}
			if(this.description){
				Text(this.description)
			}
		}
	}
}