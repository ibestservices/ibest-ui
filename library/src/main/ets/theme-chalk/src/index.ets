import { borderRadiusData } from './border'
import { colorData } from './color'
import { fontSizeData } from './font'
import { IbestUIBaseStyleType } from './index.type'
import { lineHeightData } from './line-height'
import { spaceData } from './space'



/**
 * 默认的兜底style
 */
export const defaultBaseStyle = {
  ...colorData,
  ...spaceData,
  ...fontSizeData,
  ...borderRadiusData,
  ...lineHeightData,
  // 滚动效果
  scrollEdgeEffect: EdgeEffect.Fade,
  // 滚动条颜色
  scrollBarColor: '#dbdfe6',
  animationDuration: 200
}

/**
 * AppStorage命名空间
 */
export const IBEST_UI_NAMESPACE = '__IBEST-UI_BASE_STYLE'


/**
 * 设置全局样式
 * @param styleData
 */
export function setIBestUIBaseStyle(styleData: IbestUIBaseStyleType = {}){
  AppStorage.SetOrCreate(IBEST_UI_NAMESPACE, {...defaultBaseStyle, ...styleData})
}