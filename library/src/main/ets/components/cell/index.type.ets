import { IbestUIBaseStyleValue } from '../../theme-chalk/src/index.type'

export enum ARROW_DIRECTION {
  TOP = 'top',
  RIGHT = 'right',
  BOTTOM = 'bottom',
  LEFT = 'left'
}

export class CellSizeData {
  padding?: IbestUIBaseStyleValue
  fontSize?: IbestUIBaseStyleValue
  labelFontSize?: IbestUIBaseStyleValue

  constructor(padding: IbestUIBaseStyleValue, fontSize: IbestUIBaseStyleValue, labelFontSize: IbestUIBaseStyleValue) {
    this.padding = padding;
    this.fontSize = fontSize;
    this.labelFontSize = labelFontSize
  }
}

