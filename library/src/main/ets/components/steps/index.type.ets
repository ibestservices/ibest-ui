import { IBestStringNumber } from "../../../../../Index"

/**
 * 组件名称
 */
export const COMPONENT_NAME = "STEPS"
/**
 * 事件名称
 */

export enum STEPS_EVENT_NAME {
    /**
     * 获取所有步骤信息
     */
    GET_ALL_STEPS = "GET_ALL_STEPS",
    /**
     * 获取配置信息
     */
    GET_CONFIG = "GET_CONFIG",
  	/**
	 * 获取最大标记宽度
     */
	GET_MAX_MARK_SIZE= "GET_MAX_MARK_SIZE",
    /**
     * 激活索引变化
     */
    ACTIVE_CHANGE = "ACTIVE_CHANGE"
}

/**
 * 配置信息
 */
export interface IBestStepConfig {
    placeDirection: Axis
    type: IBestStepMarkType
    dotSize: IBestStringNumber
    inactiveIcon: ResourceStr
    activeIcon: ResourceStr
    iconSize: IBestStringNumber
    activeColor: ResourceColor
    inactiveColor: ResourceColor
}

/**
 * 步骤标记类型
 */
export type IBestStepMarkType = 'num' | 'dot' | 'icon'