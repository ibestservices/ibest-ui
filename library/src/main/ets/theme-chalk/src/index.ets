import { IBestStorageKey } from '../../model/Global.type'
import { convertDimensionsWidthUnit } from '../../utils/utils'
import { BORDER_RADIUS } from './border'
import { COLOR_OPACITY, THEME_COLOR } from './color'
import { FONT_SIZE } from './font'
import { IBestUIBaseStyleObjType, IBestUIBaseStyleType } from './index.type'
import { LINE_HEIGHT } from './line-height'
import { SPACE } from './space'
/**
 * 框架默认主题
 */
export function getDefaultBaseStyle(): IBestUIBaseStyleObjType {
	const data: IBestUIBaseStyleType = {
		default: THEME_COLOR.DEFAULT,
		primary: THEME_COLOR.PRIMARY,
		success: THEME_COLOR.SUCCESS,
		warning: THEME_COLOR.WARNING,
		danger: THEME_COLOR.DANGER,
		primaryOpacity: COLOR_OPACITY.PRIMARY,
		successOpacity: COLOR_OPACITY.SUCCESS,
		warningOpacity: COLOR_OPACITY.WARNING,
		dangerOpacity: COLOR_OPACITY.DANGER,
		spaceMini: convertDimensionsWidthUnit(SPACE.MINI),
		spaceBase: convertDimensionsWidthUnit(SPACE.BASE),
		spaceX: convertDimensionsWidthUnit(SPACE.X),
		spaceXs: convertDimensionsWidthUnit(SPACE.XS),
		spaceSm: convertDimensionsWidthUnit(SPACE.SM),
		spaceMd: convertDimensionsWidthUnit(SPACE.MD),
		spaceLg: convertDimensionsWidthUnit(SPACE.LG),
		spaceXl: convertDimensionsWidthUnit(SPACE.XL),
		fontSizeXs: convertDimensionsWidthUnit(FONT_SIZE.XS, true),
		fontSizeSm: convertDimensionsWidthUnit(FONT_SIZE.SM, true),
		fontSizeMd: convertDimensionsWidthUnit(FONT_SIZE.MD, true),
		fontSizeLg: convertDimensionsWidthUnit(FONT_SIZE.LG, true),
		fontSizeXl: convertDimensionsWidthUnit(FONT_SIZE.XL, true),
		borderRadiusSm: convertDimensionsWidthUnit(BORDER_RADIUS.SM),
		borderRadiusMd: convertDimensionsWidthUnit(BORDER_RADIUS.MD),
		borderRadiusLg: convertDimensionsWidthUnit(BORDER_RADIUS.LG),
		borderRadiusMax: convertDimensionsWidthUnit(BORDER_RADIUS.MAX),
		lineHeightXs: convertDimensionsWidthUnit(LINE_HEIGHT.XS),
		lineHeightSm: convertDimensionsWidthUnit(LINE_HEIGHT.SM),
		lineHeightMd: convertDimensionsWidthUnit(LINE_HEIGHT.MD),
		lineHeightLg: convertDimensionsWidthUnit(LINE_HEIGHT.LG),
		// 滚动效果
		scrollEdgeEffect: EdgeEffect.Fade,
		// 滚动条颜色
		scrollBarColor: '#dbdfe6',
		animationDuration: 200
	}
	return data;
}
/**
 * 设置全局样式
 * @param styleData
 */
export function setIBestUIBaseStyle(styleData?: Partial<IBestUIBaseStyleType>) {
	const newStyleData = getDefaultBaseStyle();
	if (typeof styleData === 'object' && styleData !== null) {
		Object.keys(styleData).forEach(item => {
			if (newStyleData[item]) {
				newStyleData[item] = (styleData as IBestUIBaseStyleObjType)[item] ?? newStyleData[item]
			}
		})
	}
	AppStorage.setOrCreate(IBestStorageKey.BASE_STYLE, newStyleData)
}