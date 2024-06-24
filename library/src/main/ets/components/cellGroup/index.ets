import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type';
import { IbestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';

@Component
export struct IBestCellGroup {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IbestUIBaseStyleObjType = getDefaultBaseStyle();
  /**
   * 默认插槽
   */
  @BuilderParam private defaultBuilder?: CustomBuilder;
  /**
   * 分组标题
   * title没有设计成builder是因为如果设计成了builder就没法用尾随闭包方式初始化Cell或别的组件了
   * must have one and only one property decorated with @BuilderParam, and its @BuilderParam expects no parameter.
   */
  @Prop private title: string | number = '';
  /**
   * 是否展示为圆角卡片风格
   */
  @Prop private inset: boolean = false;
  /**
   * 是否显示外边框
   */
  @Prop private hasBorder: boolean = true;

  /**
   * 获取边框宽度
   * @returns
   */
  private getBorderWidth() {
    return this.hasBorder && !this.inset ? '2lpx' : 0
  }

  /**
   * 获取margin
   * @returns
   */
  private getMargin() {
    return this.inset ? { left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd } as Padding : 0
  }

  /**
   * 是否传入了title
   * @returns
   */
  private isHasTitle() {
    const titleText = String(this.title);
    return titleText.length
  }

  build() {
    Column() {
      if (this.isHasTitle()) {
        Text(String(this.title))
          .textAlign(TextAlign.Start)
          .width(CONTAINER_SIZE.FULL)
          .border({
            width: { bottom: this.getBorderWidth() },
            color: GRAY_COLOR.GRAY_3,
          })
          .padding(this.baseStyle.spaceMd)
          .lineHeight('32lpx')
          .fontSize(this.baseStyle.fontSizeMd)
          .fontColor(GRAY_COLOR.GRAY_6)
      }

      if (typeof this.defaultBuilder === 'function') {
        this.defaultBuilder()
      }
    }
    .border({
      width: { bottom: this.getBorderWidth(), top: this.isHasTitle() ? 0 : this.getBorderWidth() },
      color: GRAY_COLOR.GRAY_3,
    })
    .margin(this.getMargin())
    .borderRadius(this.inset ? this.baseStyle.borderRadiusLg : 0)
    .clip(true)
  }
}