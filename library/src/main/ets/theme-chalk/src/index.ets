import { borderRadiusData } from './border'
import { colorData } from './color'
import { fontSizeData } from './font'
import { IbestUIBaseStyleType, IbestUIBaseStyleObjType } from './index.type'
import { lineHeightData } from './line-height'
import { spaceData } from './space'


export function getDefaultBaseStyle(): IbestUIBaseStyleObjType {
  const data: IbestUIBaseStyleType = {
    primary: colorData.primary,
    success: colorData.success,
    warning: colorData.warning,
    danger: colorData.danger,
    default: colorData.default,
    spaceMini: spaceData.spaceMini,
    spaceBase: spaceData.spaceBase,
    spaceXs: spaceData.spaceXs,
    spaceSm: spaceData.spaceSm,
    spaceMd: spaceData.spaceMd,
    spaceLg: spaceData.spaceLg,
    spaceXl: spaceData.spaceXl,
    fontSizeXs: fontSizeData.fontSizeXs,
    fontSizeSm: fontSizeData.fontSizeSm,
    fontSizeMd: fontSizeData.fontSizeMd,
    fontSizeLg: fontSizeData.fontSizeLg,
    fontSizeXl: fontSizeData.fontSizeXl,
    borderRadiusSm: borderRadiusData.borderRadiusSm,
    borderRadiusMd: borderRadiusData.borderRadiusMd,
    borderRadiusLg: borderRadiusData.borderRadiusLg,
    borderRadiusMax: borderRadiusData.borderRadiusMax,
    lineHeightXs: lineHeightData.lineHeightXs,
    lineHeightSm: lineHeightData.lineHeightSm,
    lineHeightMd: lineHeightData.lineHeightMd,
    lineHeightLg: lineHeightData.lineHeightLg,
    // 滚动效果
    scrollEdgeEffect: EdgeEffect.Fade,
    // 滚动条颜色
    scrollBarColor: '#dbdfe6',
    animationDuration: 200
  }
  return data;
}

/**
 * 默认的兜底style
 */
export const defaultBaseStyle: IbestUIBaseStyleObjType = getDefaultBaseStyle()

/**
 * AppStorage命名空间
 */
export const IBEST_UI_NAMESPACE = '__IBEST-UI_BASE_STYLE'


/**
 * 设置全局样式
 * @param styleData
 */
export function setIBestUIBaseStyle(styleData: IbestUIBaseStyleObjType) {
  if (!styleData || styleData === null) {
    return
  }
  const newStyleData = getDefaultBaseStyle();
  Object.keys(styleData).forEach(item => {
    if (newStyleData[item]) {
      newStyleData[item] = styleData[item] || newStyleData[item]
    }
  })
  AppStorage.SetOrCreate(IBEST_UI_NAMESPACE, newStyleData)
}