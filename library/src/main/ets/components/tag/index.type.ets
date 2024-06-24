/**
 * 按钮尺寸对象数据
 */
import { IbestUIBaseStyleValue } from '../../theme-chalk/src/index.type'

export class TagSizeData {
  padding: IbestUIBaseStyleValue
  height: IbestUIBaseStyleValue
  fontSize: IbestUIBaseStyleValue
  borderRadius: BorderRadiuses | Length

  constructor(padding: IbestUIBaseStyleValue, height: IbestUIBaseStyleValue, fontSize: IbestUIBaseStyleValue,
    borderRadius: BorderRadiuses | Length) {
    this.padding = padding;
    this.height = height;
    this.fontSize = fontSize
    this.borderRadius = borderRadius
  }
}