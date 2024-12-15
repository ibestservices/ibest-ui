import { ThemeColor } from './color.type';

/**
 * 主题色
 */
export const THEME_COLOR: ThemeColor = {
  /**
   * 主要的
   */
  PRIMARY: '#1989fa',
  /**
   * 成功
   */
  SUCCESS: '#07c160',
  /**
   * 危险
   */
  DANGER: '#ee0a24',
  /**
   * 警告
   */
  WARNING: '#ff976a',
  /**
   * 默认的
   */
  DEFAULT: $r("app.color.ibest_background_2")
}

/**
 * 灰色
 */
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

/**
 * 半透明主题色
 */
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