import { IbestUIBaseStyleValue } from '../../theme-chalk/src/index.type';

/**
 * 按钮尺寸样式的类型
 */
export interface BtnSizeStyle {
  height: IbestUIBaseStyleValue;
  padding: IbestUIBaseStyleValue;
  width?: IbestUIBaseStyleValue;
}

/**
 * 按钮尺寸对象数据
 */
export class ButtonSizeData {
  padding: IbestUIBaseStyleValue
  height: IbestUIBaseStyleValue
  fontSize: IbestUIBaseStyleValue
  width?: IbestUIBaseStyleValue

  constructor(padding: IbestUIBaseStyleValue, height: IbestUIBaseStyleValue, fontSize: IbestUIBaseStyleValue,
    width?: IbestUIBaseStyleValue) {
    this.padding = padding;
    this.height = height;
    this.fontSize = fontSize
    this.width = width
  }
}