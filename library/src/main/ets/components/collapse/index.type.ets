/**
 * Collapse事件名称
 */

export enum COLLAPSE_EVENT_NAME {
	/**
	 * 获取所有子组件的name
     */
	GET_ALL_ITEM_NAME = "GET_ALL_ITEM_NAME",
	/**
	 * 初始化子组件状态
	 */
	INIT_ITEM = "INIT_ITEM",
	/**
	 * 子组件状态改变
     */
	ITEM_STATE_CHANGE = "ITEM_STATE_CHANGE"
}

export interface CollapseItem{
	name: string
	disabled: boolean
}

export interface ToggleOption{
	/**
	 * 是否展开
	 * @description 默认为切换, true 为展开, false 为收起
	 */
	expanded?: boolean
	/**
	 * 是否跳过禁用或只读项
	 * @description true 为跳过
	 */
	skipDisabled?: boolean
}

export class IBestCollapseController{
	toggleAll: (option?: boolean | ToggleOption) => void = () => {}
}