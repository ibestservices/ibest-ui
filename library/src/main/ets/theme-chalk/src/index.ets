import { convertDimensionsByUnit } from '../../utils/utils'
import { BORDER_RADIUS } from './border'
import { COLOR, COLOR_OPACITY } from './color'
import { FONT_SIZE } from './font'
import { IBestUIBaseStyleType, IBestUIBaseStyleObjType } from './index.type'
import { LINE_HEIGHT } from './line-height'
import { SPACE } from './space'
/**
 * 框架默认主题
 */
export function getDefaultBaseStyle(): IBestUIBaseStyleObjType {
  const data: IBestUIBaseStyleType = {
    primary: COLOR.PRIMARY,
    success: COLOR.SUCCESS,
    warning: COLOR.WARNING,
    danger: COLOR.DANGER,
    default: COLOR.DEFAULT,
    primaryOpacity: COLOR_OPACITY.PRIMARY,
    successOpacity: COLOR_OPACITY.SUCCESS,
    warningOpacity: COLOR_OPACITY.WARNING,
    dangerOpacity: COLOR_OPACITY.DANGER,
    spaceMini: convertDimensionsByUnit(SPACE.MINI),
    spaceBase: convertDimensionsByUnit(SPACE.BASE),
    spaceXs: convertDimensionsByUnit(SPACE.XS),
    spaceSm: convertDimensionsByUnit(SPACE.SM),
    spaceMd: convertDimensionsByUnit(SPACE.MD),
    spaceLg: convertDimensionsByUnit(SPACE.LG),
    spaceXl: convertDimensionsByUnit(SPACE.XL),
    fontSizeXs: convertDimensionsByUnit(FONT_SIZE.XS, true),
    fontSizeSm: convertDimensionsByUnit(FONT_SIZE.SM, true),
    fontSizeMd: convertDimensionsByUnit(FONT_SIZE.MD, true),
    fontSizeLg: convertDimensionsByUnit(FONT_SIZE.LG, true),
    fontSizeXl: convertDimensionsByUnit(FONT_SIZE.XL, true),
    borderRadiusSm: convertDimensionsByUnit(BORDER_RADIUS.SM),
    borderRadiusMd: convertDimensionsByUnit(BORDER_RADIUS.MD),
    borderRadiusLg: convertDimensionsByUnit(BORDER_RADIUS.LG),
    borderRadiusMax: convertDimensionsByUnit(BORDER_RADIUS.MAX),
    lineHeightXs: convertDimensionsByUnit(LINE_HEIGHT.XS),
    lineHeightSm: convertDimensionsByUnit(LINE_HEIGHT.SM),
    lineHeightMd: convertDimensionsByUnit(LINE_HEIGHT.MD),
    lineHeightLg: convertDimensionsByUnit(LINE_HEIGHT.LG),
    // 滚动效果
    scrollEdgeEffect: EdgeEffect.Fade,
    // 滚动条颜色
    scrollBarColor: '#dbdfe6',
    animationDuration: 200
  }
  return data;
}

/**
 * AppStorage命名空间
 */
export const IBEST_UI_NAMESPACE = '__IBEST-UI_BASE_STYLE'

/**
 * 设置全局样式
 * @param styleData
 */
export function setIBestUIBaseStyle(styleData?: Partial<IBestUIBaseStyleType>) {
  const newStyleData = getDefaultBaseStyle();
  if (typeof styleData === 'object' && styleData !== null) {
    Object.keys(styleData).forEach(item => {
      if (newStyleData[item]) {
        newStyleData[item] = (styleData as IBestUIBaseStyleObjType )[item] ?? newStyleData[item]
      }
    })
  }
  AppStorage.setOrCreate(IBEST_UI_NAMESPACE, newStyleData)
}