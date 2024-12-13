/**
 * 组件名称
 */
export const COMPONENT_NAME = 'CHECKBOX';

/**
 * checkboxgroup的emitter的事件
 */
export enum CHECKBOX_GROUP_EVENT_NAME {
  /**
   * 当最大可选数量变化时
   */
  ON_MAX_CHANGE = 'ON_MAX_CHANGE',
  /**
   * 当触发全选/反选时
   */
  ON_TOGGLE_ALL = 'ON_TOGGLE_ALL'
}