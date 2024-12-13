/**
 * 组件名称
 */
export const COMPONENT_NAME = 'RADIO';

/**
 * radio group的emitter的事件
 */
export enum RADIO_GROUP_EVENT_NAME {
  /**
   * 初始化赋值
   */
  ON_INIT = 'ON_INIT',
  /**
   * 当当前组的radio改变选中状态时
   */
  ON_RADIO_CHECKED_CHANGE = 'ON_RADIO_CHECKED_CHANGE',
}