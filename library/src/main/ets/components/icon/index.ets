import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { IBestIconData } from './config'
import { IBestIconDataType } from './index.type'
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { IBestLoading } from '../loading';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
@Component
export struct IBestIcon {
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 图标名称或图片链接
   */
  @Prop name: keyof IBestIconDataType | ResourceStr = 'arrow'
  /**
   * 图标颜色
   */
  @Prop color: ResourceColor = ''
  /**
   * 图标大小
   */
  @Prop iconSize: number | string = convertDimensionsWidthUnit(20)
  /**
   * 点击回调
   */
  onIconClick: () => void = () => {}

  isOnlineImage(): boolean {
    return (this.name as string).startsWith("http")
  }

  build() {
    Row() {
      if(typeof this.name == "string"){
        if (this.isOnlineImage()) {
          Image(this.name).width(getSizeByUnit(this.iconSize)).aspectRatio(1)
        } else {
          Text(Object(IBestIconData)[this.name])
            .fontFamily('ibestFont')
            .fontColor(this.color)
            .fontSize(getSizeByUnit(this.iconSize, true))
        }
      }else{
        Image(this.name).width(getSizeByUnit(this.iconSize)).aspectRatio(1).fillColor(this.color)
      }
    }
    .onClick(() => {
      this.onIconClick()
    })
  }
}