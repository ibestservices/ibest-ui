/**
 * 背景色颜色
 */
interface ModeColor {
  bg: ResourceColor
  bg2: ResourceColor
  bg3: ResourceColor
  active: ResourceColor
  textColor: ResourceColor
  textColor2: ResourceColor
  textColor4: ResourceColor
  borderColor: ResourceColor
}
/**
 * 背景色颜色
 */
export const modeColor: ModeColor = {
  bg: $r("app.color.doc_background"),
  bg2: $r("app.color.doc_background_2"),
  bg3: $r("app.color.doc_background_3"),
  active: $r("app.color.doc_active_color"),
  textColor: $r("app.color.doc_text_color_1"),
  textColor2: $r("app.color.doc_text_color_2"),
  textColor4: $r("app.color.doc_text_color_4"),
  borderColor: $r("app.color.doc_border_color")
};

interface ColorRed {
  DEFAULT: ResourceColor
  BASE: ResourceColor
}
/**
 * 红色
 */
export const COLOR_RED: ColorRed = {
  DEFAULT: "#DB3131",
  BASE: '#F56C6C'
};

/**
 * 灰色
 */
export enum COLOR_GRAY {
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
 * 置灰的颜色
 */
interface GeneratedObjectLiteralInterface_2 {
  VERY_MINI: string;
  MINI: string;
  BASE: string;
  MEDIUM: string;
}

export const DISABLE_COLOR: GeneratedObjectLiteralInterface_2 = {
  VERY_MINI: 'rgba(223,223,223,0.15)',
  MINI: 'rgba(56,65,83,0.5)',
  BASE: '#f2f3f7',
  MEDIUM: '#3E5071'
};

/**
 * 布局宽度和高度
 */
interface GeneratedObjectLiteralInterface_3 {
  FOURTEEN: number;
  SIXTEEN: number;
  TWENTY_TWO: number;
  FORTY: number;
  FULL: string;
}

export const CONTAINER_SIZE: GeneratedObjectLiteralInterface_3 = {
  FOURTEEN: 14,
  SIXTEEN: 16,
  TWENTY_TWO: 22,
  FORTY: 40,
  FULL: '100%'
};

/**
 * 颜色
 */
interface GeneratedObjectLiteralInterface_4 {
  DEFAULT: string;
  PLACEHOLDER: string;
  TEXT: string;
  CANCEL_BTN: string;
  MINI: string;
  SMALL: string;
  BASE: string;
  MEDIUM: string;
  LARGE: string;
}

export const COLOR_BLUE: GeneratedObjectLiteralInterface_4 = {
  DEFAULT: '#FFFFFF',
  PLACEHOLDER: 'rgba(62,80,113,0.45)',
  TEXT: '#006AE9',
  CANCEL_BTN: '#F2F4FF',
  MINI: '#4B72EF',
  SMALL: '#49689B',
  BASE: '#3E5071',
  MEDIUM: '#30405D',
  LARGE: '#304B78'
};

/**
 * 间距样式
 */
interface GeneratedObjectLiteralInterface_5 {
  mini: number;
  BASE: number;
  XS: number;
  SM: number;
  MD: number;
  LG: number;
  XL: number;
}

export const SPACE: GeneratedObjectLiteralInterface_5 = {
  mini: 2,
  BASE: 4,
  XS: 8,
  SM: 12,
  MD: 16,
  LG: 24,
  XL: 32
};

/**
 * 文字大小
 */
interface GeneratedObjectLiteralInterface_6 {
  XS: number;
  SM: number;
  MD: number;
  LG: number;
}

export const FONT_SIZE: GeneratedObjectLiteralInterface_6 = {
  XS: 10,
  SM: 12,
  MD: 14,
  LG: 16
};

/**
 * 文字大小
 */
interface GeneratedObjectLiteralInterface_7 {
  NORMAL: number;
  LIGHTER: number;
  REGULAR: number;
  MEDIUM: number;
  BOLD: number;
  BOLDER: number;
}

export const FONT_WEIGHT: GeneratedObjectLiteralInterface_7 = {
  NORMAL: FontWeight.Normal as number,
  LIGHTER: FontWeight.Lighter as number,
  REGULAR: FontWeight.Regular as number,
  MEDIUM: FontWeight.Medium as number,
  BOLD: FontWeight.Bold as number,
  BOLDER: FontWeight.Bolder as number
};

/**
 * 行高
 */
interface GeneratedObjectLiteralInterface_8 {
  XS: number;
  SM: number;
  MD: number;
  LG: number;
}

export const LINE_HEIGHT: GeneratedObjectLiteralInterface_8 = {
  XS: 14,
  SM: 18,
  MD: 20,
  LG: 22
};

/**
 * 圆角
 */
interface GeneratedObjectLiteralInterface_9 {
  BASE: number;
  MEDIUM: number;
  LARGE: number;
  VERY_LARGE: number;
}

export const BORDER_RADIUS: GeneratedObjectLiteralInterface_9 = {
  BASE: 6,
  MEDIUM: 8,
  LARGE: 10,
  VERY_LARGE: 30
}