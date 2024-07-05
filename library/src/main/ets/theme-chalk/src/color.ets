import { COLOR, ColorData, COLOR_OPACITY, ColorOpacityData } from './color.type'

export const colorData: ColorData = {
  primary: COLOR.PRIMARY as string,
  success: COLOR.SUCCESS as string,
  warning: COLOR.WARNING as string,
  danger: COLOR.DANGER as string,
  default: COLOR.DEFAULT as string,
}

export const colorOpacityData: ColorOpacityData = {
  primaryOpacity: COLOR_OPACITY.PRIMARY,
  successOpacity: COLOR_OPACITY.SUCCESS,
  warningOpacity: COLOR_OPACITY.WARNING,
  dangerOpacity: COLOR_OPACITY.DANGER
}