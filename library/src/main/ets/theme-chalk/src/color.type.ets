/**
 * 颜色类型枚举
 */
export enum COLOR_TYPE {
  /**
   * 主要的
   */
  PRIMARY = 'primary',
  /**
   * 成功
   */
  SUCCESS = 'success',
  /**
   * 危险
   */
  DANGER = 'danger',
  /**
   * 警告
   */
  WARNING = 'warning',
  /**
   * 默认
   */
  DEFAULT = 'default'
}

/**
 * 颜色类型
 */
export type ColorType = `${COLOR_TYPE}`


export interface ColorData {
  primary: string;
  success: string;
  warning: string;
  danger: string;
  default: string;
  primaryOpacity: string;
  successOpacity: string;
  warningOpacity: string;
  dangerOpacity: string;
}