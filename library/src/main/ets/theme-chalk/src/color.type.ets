/**
 * 颜色类型
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
 * 主题色
 */
export enum COLOR {
  /**
   * 主要的
   */
  PRIMARY = '#3D8AF2',
  /**
   * 成功
   */
  SUCCESS = '#58DB6B',
  /**
   * 危险
   */
  DANGER = '#DB3131',
  /**
   * 警告
   */
  WARNING = '#F29C73',
  /**
   * 默认的
   */
  DEFAULT = '#FFF'
}

export enum GRAY_COLOR{
  GRAY_1 =  '#f7f8fa',
  GRAY_2 =  '#f2f3f5',
  GRAY_3 =  '#ebedf0',
  GRAY_4 =  '#dcdee0',
  GRAY_5 =  '#c8c9cc',
  GRAY_6 =  '#969799',
  GRAY_7 =  '#646566',
  GRAY_8 =  '#323233',
}

export enum COLOR_OPACITY{
  /**
   * 主要的
   */
  PRIMARY = 'rgba(61, 138, 242, 0.1)',
  /**
   * 成功
   */
  SUCCESS = 'rgba(88, 219, 107, 0.1)',
  /**
   * 危险
   */
  DANGER = 'rgba(219, 49, 49, 0.1)',
  /**
   * 警告
   */
  WARNING = 'rgba(242, 156, 115, 0.1)'
}

/**
 * 颜色的类型
 */
export type ColorType = `${COLOR_TYPE}`


export interface ColorData {
  primary: string;
  success: string;
  warning: string;
  danger: string;
  default: string;
}
export interface ColorOpacityData {
  primaryOpacity: string;
  successOpacity: string;
  warningOpacity: string;
  dangerOpacity: string;
}