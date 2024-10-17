import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type'
import { SPACE } from '../../theme-chalk/src/space.type';

@Component
export struct IBestEmpty {
  /**
   * 描述文字底部的builder
   */
  @BuilderParam defaultBuilder: CustomBuilder;
  /**
   * 空状态的builder
   */
  @BuilderParam emptyImgBuilder: CustomBuilder;
  /**
   * 描述文字的builder
   */
  @BuilderParam descriptionBuilder: CustomBuilder;
  /**
   * 图片下方的描述文字 默认空字符串
   */
  @Prop description: string = '';
  /**
   * 描述文字颜色 默认 "#969799"
   */
  @Prop descriptionColor: ResourceColor = GRAY_COLOR.GRAY_6;
  /**
   * 描述文字大小 默认 28lpx
   */
  @Prop descriptionFontSize: string | number = '28lpx';
  /**
   * 空占位图的高度
   */
  @Prop imageSize: string | number = '320lpx';
  /**
   * 图片类型，可选值为 error network search default 默认default
   */
  @Prop emptyImage: 'error' | 'network' | 'search' | 'default' = 'default';

  @Builder
  EmptyImg() {
    if (this.emptyImage === 'default') {
      Image($r('app.media.empty')).height(this.imageSize)
    } else if (this.emptyImage === 'network') {
      Image($r('app.media.empty_network_error')).height(this.imageSize)
    } else if (this.emptyImage === 'search') {
      Image($r('app.media.empty_search_error')).height(this.imageSize)
    } else if (this.emptyImage === 'error') {
      Image($r('app.media.empty_error')).height(this.imageSize)
    } else {
      Image(this.emptyImage).height(this.imageSize)
    }
  }

  build() {
    Column() {
      // 空占位图
      if (typeof this.emptyImgBuilder === 'function') {
        this.emptyImgBuilder()
      } else {
        this.EmptyImg()
      }

      // 描述
      if (typeof this.descriptionBuilder === 'function') {
        this.descriptionBuilder()
      } else {
        Text(this.description)
          .margin({
            top: this.description ?? false ? SPACE.MD : 0
          })
          .padding({
            left: SPACE.XL,
            right: SPACE.XL
          })
          .fontColor(this.descriptionColor)
          .fontSize(this.descriptionFontSize)
      }

      // 底部插槽
      if (typeof this.defaultBuilder === 'function') {
        this.defaultBuilder()
      }

    }.width(CONTAINER_SIZE.FULL)
  }
}