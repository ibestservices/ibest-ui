/**
 * 组件名称
 */
export const COMPONENT_NAME = 'CHECKBOX';
/**
 * checkboxgroup的emitter的事件
 */
export enum CHECKBOX_GROUP_EVENT_NAME {
	/**
	 * 获取所有name
	 */
	GET_ALL_NAME = 'GET_ALL_NAME',
	/**
	 * 初始化子组件
	 */
	INIT_CHILDREN = 'INIT_CHILDREN',
	/**
	 * 子组件状态变化
	 */
	ITEM_CHANGE = 'ITEM_CHANGE',
	/**
	 * 当最大可选数量变化时
	 */
	ON_MAX_CHANGE = 'ON_MAX_CHANGE'
}
/**
 * checkboxGroup 控制器
 */
export class IBestCheckboxGroupController {
	/**
	 * 全选与反选
	 */
	toggleAll: (isSelectAll?: boolean) => void = () => {}
}