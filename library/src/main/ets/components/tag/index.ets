import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { ColorType, COLOR_TYPE } from '../../theme-chalk/src/color.type';
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { SIZE } from '../../theme-chalk/src/size.type';
import { TagSizeData } from './index.type';
import { convertDimensionsByUnit, getSizeByUnit } from '../../utils/utils';
@Extend(Row) function tagSizeStyle(data: TagSizeData) {
  .padding({ top: 0, right: data.padding, bottom: 0, left: data.padding })
  .height(data.height)
  .borderRadius(data.borderRadius)
}

@Component
export struct IBestTag {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
  /**
   * 类型，可选值为 primary success warning danger 默认值为default
   */
  @Prop type: ColorType = COLOR_TYPE.DEFAULT;
  /**
   * 大小，可选值为 large normal small mini
   * size是保留字所以没使用size
   */
  @Prop tagSize: `${SIZE.LARGE}` | `medium` | `${SIZE.SMALL}` = SIZE.SMALL;
  /**
   * 标签内容
   */
  @Prop text: string = '';
  /**
   * 标签颜色
   */
  @Prop color: ResourceColor = '';
  /**
   * 文本颜色，优先级高于 color 属性
   */
  @Prop textColor: ResourceColor = ''
  /**
   * 是否为空心样式
   */
  @Prop plain: boolean = false;
  /**
   * 是否为圆角样式
   */
  @Prop round: boolean = false;
  /**
   * 是否为标记样式
   */
  @Prop mark: boolean = false;
  /**
   * 是否为可关闭标签 关闭标签时会触发 close 事件，在 close 事件中可以执行隐藏标签的逻辑
   */
  @Prop closeable: boolean = false;
  /**
   * 是否展示标签
   */
  @Prop show: boolean = true;
  /**
   * 点击关闭按钮触发的回调
   */
  onClose: (event: ClickEvent) => void = () => {}
  /**
   * 点击标签触发的回调
   */
  onClickTag: (event: ClickEvent) => void = () => {}


  /**
   * 根据颜色type获取背景色
   * @returns
   */
  getBackgroundColor() {
    return this.color ? this.color : this.baseStyle[this.type]
  }

  /**
   * 获取按钮的颜色
   * @param {boolean} isHasColor 是否需要展示颜色
   * @returns
   */
  getTagColor(isHasColor: boolean) {
    return isHasColor ? this.getBackgroundColor() : '#fff'
  }

  /**
   * 获取按钮文字的颜色
   * @returns
   */
  getTagTextColor() {
    if (this.textColor) {
      return this.textColor
    }
    return this.type === COLOR_TYPE.DEFAULT && !this.color ? GRAY_COLOR.GRAY_8 : this.getTagColor(this.plain)
  }


  /**
   * 根据size获取tag的尺寸
   * @returns
   */
  getTagSize() {
    const tagSize = this.tagSize;
    switch (tagSize) {
      case 'medium':
        return new TagSizeData(convertDimensionsByUnit(6), convertDimensionsByUnit(20), this.baseStyle.fontSizeSm, this.getBorderRadius(convertDimensionsByUnit(2)) ) ;
      case SIZE.LARGE:
        return new TagSizeData(this.baseStyle.spaceXs, convertDimensionsByUnit(24), this.baseStyle.fontSizeMd,  this.getBorderRadius(convertDimensionsByUnit(4)) ) ;
      default:
        return new TagSizeData(this.baseStyle.spaceBase, convertDimensionsByUnit(17), this.baseStyle.fontSizeSm, this.getBorderRadius(convertDimensionsByUnit(2)) ) ;
    }
  }

  /**
   * 获取边框radius
   * @param borderRadius
   * @returns
   */
  getBorderRadius(borderRadius: number | string): BorderRadiuses | Length {
    if (this.round) {
      return this.baseStyle.borderRadiusMax
    } else if (this.mark) {
      return {
        topLeft: 0,
        topRight: this.baseStyle.borderRadiusMax,
        bottomLeft: 0,
        bottomRight: this.baseStyle.borderRadiusMax
      }
    } else {
      return getSizeByUnit(borderRadius)
    }
  }

  build() {
    if (this.show) {
      Row() {
        Text(this.text)
          .fontSize(this.getTagSize()?.fontSize)
          .fontColor(this.getTagTextColor())
        if (this.closeable) {
          Column() {
            Image($r('app.media.close'))
              .height('50%')
              .margin({ left: this.baseStyle.spaceMini })
          }.height(this.getTagSize().height)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .onClick((event) => {
            animateTo({ duration: this.baseStyle.animationDuration as number}, () => {
              this.onClose(event)
            })
          })
        }

      }
      .tagSizeStyle(this.getTagSize())
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderWidth(1)
      .backgroundColor(this.getTagColor(!this.plain))
      .borderColor(this.type === COLOR_TYPE.DEFAULT && !this.textColor && !this.color ? GRAY_COLOR.GRAY_4 : this.getTagColor(this.plain))
      .transition({ type: TransitionType.Insert, opacity: 1 })
      .transition({ type: TransitionType.Delete, opacity: 0 })
      .onClick((event)=>{
        this.onClickTag(event)
      })
    }
  }
}