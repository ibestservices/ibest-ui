import { borderRadiusData } from './border'
import { colorData } from './color'
import { fontSizeData } from './font'
import { IbestUIBaseStyleType } from './index.type'
import { spaceData } from './space'



/**
 * 默认的兜底style
 */
export const defaultBaseStyle = {
  ...colorData,
  ...spaceData,
  ...fontSizeData,
  ...borderRadiusData
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