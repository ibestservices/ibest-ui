// resources中的单位会被解析成vp

/**
 * 红色
 */
export enum COLOR_RED {
  BASE = '#F56C6C'
}

/**
 * 红色
 */
export enum COLOR_GRAY {
  BASE = '#969799'
}

/**
 * 置灰的颜色
 */
export enum DISABLE_COLOR {
  VERY_MINI = 'rgba(223,223,223,0.15)',
  MINI = 'rgba(56,65,83,0.5)',
  BASE = '#f2f3f7',
  MEDIUM = '#3E5071'
}

/**
 * 置灰的颜色
 */
export enum BACKGROUND_COLOR {
  BASE = '#F7F8FA'
}

/**
 * 布局宽度和高度
 */
export enum CONTAINER_SIZE {
  TWELVE = '12lpx',
  TWO = '2lpx',
  THIRTY = '30lpx',
  FORTY_TWO = '42lpx',
  FORTY_FOUR = '44lpx',
  SIXTY = '60lpx',
  SIXTY_FIVE = '65lpx',
  SEVENTY_NINE = '79lpx',
  EIGHTY = '80lpx',
  NINETY = '90lpx',
  THREE_HUNDRED = '300lpx',
  ONE_HUNDRED_AND_FIFTY = '150lpx',
  ONE_HUNDRED_AND_TWENTY = '120lpx',
  FULL = '100%',
  SIX_HUNDRED = '600lpx',
  EIGHT_HUNDRED = '800lpx',
  SIX_HUNDRED_AND_SIXTY = '660lpx',
  THREE_HUNDRED_AND_THIRTY_SEVEN = '337lpx',
  THREE_HUNDRED_AND_SIXTY_SEVEN = '367lpx',
  FOUR_HUNDRED_AND_SIXTY_FIVE = '465lpx',
  TWO_HUNDRED= '200lpx',
  TWO_HUNDRED_AND_FIFTY= '250lpx',
  ONE_HUNDRED_AND_SEVENTY_FIVE = '175lpx',
  THREE_HUNDRED_AND_NINETY_FIVE = '395lpx',
  TWO_HUNDRED_AND_EIGHTY_FIVE = '285lpx',
  THREE_HUNDRED_AND_EIGHTY_TWO = '182lpx',


}

/**
 * 颜色
 */
export enum COLOR_BLUE {
  PLACEHOLDER = 'rgba(62,80,113,0.45)',
  TEXT = '#006AE9',
  CANCEL_BTN = '#F2F4FF',
  MINI = '#4B72EF',
  SMALL = '#49689B',
  BASE = '#3E5071',
  MEDIUM = '#30405D',
  LARGE = '#304B78',
}

/**
 * 间距样式
 */
export enum SPACE {
  SEVEN = '7lpx',
  FIVE = '5lpx',
  MINI = '10lpx',
  TWENTY = '20lpx',
  SMALL = '16lpx',
  BASE = '22lpx',
  MEDIA = '36lpx',
  LARGE = '44lpx',
  EIGHTY = '80lpx',
  EIGHTY_EIGHT = '88lpx',
  TWENTY_FIVE = '25lpx',
  THIRTY = '30lpx',
  THIRTY_SEVEN = '37lpx',
  SIXTY = '60lpx',
  THREE_HUNDRED = '300lpx',
  ONE_HUNDRED_AND_SIXTY = '160lpx',
  FIFTY = '50lpx',
}

/**
 * 文字大小
 */
export enum FONT_SIZE {
  MINI = '24lpx',
  SMALL = '26lpx',
  BASE = '28lpx',
  MEDIUM = '32lpx',
  LARGE = '36lpx',
  VERY_LARGE = '44lpx',
  THIRTY = '30lpx',
  THIRTY_THREE = '33lpx'
}

/**
 * 文字大小
 */
export enum FONT_WEIGHT {
  NORMAL = FontWeight.Normal as number,
  LIGHTER = FontWeight.Lighter as number,
  REGULAR = FontWeight.Regular as number,
  MEDIUM = FontWeight.Medium as number,
  BOLD = FontWeight.Bold as number,
  BOLDER = FontWeight.Bolder as number,
}

/**
 * 行高
 */
export enum LINE_HEIGHT {
  BASE = '30lpx',
  MEDIUM = '40lpx',
  FORTY_FOUR = '44lpx',
  SIXTY = '60lpx',
  SIXTY_SIX = '66lpx',
  FIFTY_ONE = '51lpx'
}

/**
 * 圆边距
 */
export enum BORDER_RADIUS {
  BASE = '15lpx',
  MEDIUM = '18lpx',
  LARGE = '22lpx',
  VERY_LARGE = '60lpx'
}

/**
 * 边框宽度
 */
export enum BORDER_WIDTH {
  BASE = '1.85lpx',
}




/**
 * 获取lpx单位中的数字
 * @param styleText
 * @returns
 */
export function getLpxNum(styleText: string) {
  return Number(styleText.replace(/[^\d\.]/g, ''))
}
