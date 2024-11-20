import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { convertDimensionsByUnit, getSizeByUnit } from '../../utils/utils';
@Component
export struct IBestEmpty {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 描述文字底部的builder
   */
  @BuilderParam defaultBuilder?: CustomBuilder;
  /**
   * 占位图的builder
   */
  @BuilderParam emptyImgBuilder?: CustomBuilder;
  /**
   * 描述文字的builder
   */
  @BuilderParam descriptionBuilder?: CustomBuilder;
  /**
   * 图片下方的描述文字 默认空字符串
   */
  @Prop description: string = '';
  /**
   * 描述文字颜色 默认 "#969799"
   */
  @Prop descriptionColor: ResourceColor = GRAY_COLOR.GRAY_6;
  /**
   * 描述文字大小
   */
  @Prop descriptionFontSize: string | number = convertDimensionsByUnit(14)
  /**
   * 空占位图的高度
   */
  @Prop imageSize: string | number = convertDimensionsByUnit(160)
  /**
   * 图片类型，可选值为 error network search default 默认default
   */
  @Prop emptyImage: 'error' | 'network' | 'search' | 'default' = 'default';
  /**
   * 自定义占位图
   * @since 1.18.0
   */
  @Prop emptyImgUrl: ResourceStr = ''

  @Styles imgStyle(){
    .height(getSizeByUnit(this.imageSize))
  }

  @Builder EmptyImg() {
    if(this.emptyImgUrl){
      Image(this.emptyImage).imgStyle()
    }else if (this.emptyImage === 'default') {
      Image($r('app.media.empty')).imgStyle()
    } else if (this.emptyImage === 'network') {
      Image($r('app.media.empty_network_error')).imgStyle()
    } else if (this.emptyImage === 'search') {
      Image($r('app.media.empty_search_error')).imgStyle()
    } else if (this.emptyImage === 'error') {
      Image($r('app.media.empty_error')).imgStyle()
    }
  }

  build() {
    Column() {
      // 空占位图
      if (this.emptyImgBuilder) {
        this.emptyImgBuilder()
      } else {
        this.EmptyImg()
      }

      // 描述
      if (this.descriptionBuilder) {
        this.descriptionBuilder()
      } else {
        Text(this.description)
          .margin({
            top: this.description ?? false ? this.baseStyle.spaceMd : 0
          })
          .padding({
            left: this.baseStyle.spaceXl,
            right: this.baseStyle.spaceXl
          })
          .fontColor(this.descriptionColor)
          .fontSize(getSizeByUnit(this.descriptionFontSize, true))
      }

      // 底部插槽
      if (this.defaultBuilder) {
        this.defaultBuilder()
      }

    }.width(CONTAINER_SIZE.FULL)
  }
}