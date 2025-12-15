import { IBestStringNumber } from "../../model/Global.type"


/**
 * 组件名称
 */
export const COMPONENT_NAME = "STEPS"
/**
 * 事件名称
 */

export enum STEPS_EVENT_NAME {
    /**
     * 初始化步骤信息
     */
    INIT_STEPS = "INIT_STEPS",
    /**
     * 保存步骤信息
     */
    SAVE_STEPS = "SAVE_STEPS",
    /**
     * 删除步骤
     */
    DELETE_STEP = "DELETE_STEP",
    /**
     * 获取配置信息
     */
    GET_CONFIG = "GET_CONFIG",
  	/**
	 * 获取最大标记宽度
     */
	GET_MAX_MARK_SIZE = "GET_MAX_MARK_SIZE",
	/**
	 * 获取步骤项宽度
     */
	GET_STEP_ITEM_WIDTH = "GET_STEP_ITEM_WIDTH",
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
    bgColor: ResourceColor
}

/**
 * 步骤标记类型
 */
export type IBestStepMarkType = 'num' | 'dot' | 'icon'