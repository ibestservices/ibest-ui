export interface ThemeColor {
  PRIMARY: ResourceColor
  SUCCESS: ResourceColor
  WARNING: ResourceColor
  DANGER: ResourceColor
}

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
  primary: ResourceColor;
  success: ResourceColor;
  warning: ResourceColor;
  danger: ResourceColor;
  primaryOpacity: ResourceColor;
  successOpacity: ResourceColor;
  warningOpacity: ResourceColor;
  dangerOpacity: ResourceColor;
}