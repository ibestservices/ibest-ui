/**
 * radio group的emitter的命名空间
 */
export const RADIO_GROUP_NAMESPACE = '__RADIO_GROUP_NAMESPACE';

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

/**
 * 获取radio group的emitter name
 * @param groupName
 * @param eventName
 * @returns
 */
export function getRadioGroupNamespace(groupName: string, eventName: string){
  return `${RADIO_GROUP_NAMESPACE}_${groupName}_${eventName}`
}