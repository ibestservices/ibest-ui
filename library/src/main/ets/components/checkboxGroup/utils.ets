/**
 * checkboxgroup的emitter的命名空间
 */
export const CHECKBOX_GROUP_NAMESPACE = '__CHECKBOX_GROUP_NAMESPACE';

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

/**
 * 获取checkboxgroup的emittername
 * @param groupName
 * @param eventName
 * @returns
 */
export function getCheckboxNamespace(groupName: string, eventName: string){
  return `${CHECKBOX_GROUP_NAMESPACE}_${groupName}_${eventName}`
}