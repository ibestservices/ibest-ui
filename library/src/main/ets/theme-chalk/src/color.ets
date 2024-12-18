import { GrayColor, ThemeColor } from './color.type';

/**
 * 主题色
 */
export const THEME_COLOR: ThemeColor = {
  /**
   * 主要的
   */
  PRIMARY: $r("app.color.ibest_primary_color"),
  /**
   * 成功
   */
  SUCCESS: $r("app.color.ibest_success_color"),
  /**
   * 危险
   */
  DANGER: $r("app.color.ibest_danger_color"),
  /**
   * 警告
   */
  WARNING: $r("app.color.ibest_warning_color")
}

/**
 * 灰色
 */
export const GRAY_COLOR: GrayColor = {
  GRAY_1:  $r("app.color.ibest_gray_1"),
  GRAY_2:  $r("app.color.ibest_gray_2"),
  GRAY_3:  $r("app.color.ibest_gray_3"),
  GRAY_4:  $r("app.color.ibest_gray_4"),
  GRAY_5:  $r("app.color.ibest_gray_5"),
  GRAY_6:  $r("app.color.ibest_gray_6"),
  GRAY_7:  $r("app.color.ibest_gray_7"),
  GRAY_8:  $r("app.color.ibest_gray_8")
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