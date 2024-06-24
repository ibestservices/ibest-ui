import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { ColorType, COLOR_TYPE, GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type';
import { IbestUIBaseStyleObjType, IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';
import { SIZE } from '../../theme-chalk/src/size.type';
import { TagSizeData } from './index.type';

@Extend(Row)
function tagSizeStyle(data: TagSizeData) {
  .padding({ top: 0, right: data.padding, bottom: 0, left: data.padding })
  .height(data.height)
  .borderRadius(data.borderRadius)
}

@Component
export struct IBestTag {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IbestUIBaseStyleObjType = getDefaultBaseStyle();
  /**
   * 类型，可选值为 primary success warning danger 默认值为default
   */
  @Prop private type: ColorType = COLOR_TYPE.DEFAULT;
  /**
   * 大小，可选值为 large normal small mini
   * size是保留字所以没使用size
   */
  @Prop private tagSize: `${SIZE.LARGE}` | `medium` | `${SIZE.SMALL}` = SIZE.SMALL;
  /**
   * 标签内容
   */
  @Prop private text: string = '';
  /**
   * 标签颜色
   */
  @Prop private color: string = '';
  /**
   * 文本颜色，优先级高于 color 属性
   */
  @Prop private textColor: string = ''
  /**
   * 是否为空心样式
   */
  @Prop private plain: boolean = false;
  /**
   * 是否为圆角样式
   */
  @Prop private round: boolean = false;
  /**
   * 是否为标记样式
   */
  @Prop private mark: boolean = false;
  /**
   * 是否为可关闭标签 关闭标签时会触发 close 事件，在 close 事件中可以执行隐藏标签的逻辑
   */
  @Prop private closeable: boolean = false;
  /**
   * 是否展示标签
   */
  @Prop private show: boolean = true;
  /**
   * 点击关闭按钮触发的回调
   */
  private onClose?: (event: ClickEvent) => void;
  /**
   * 点击标签触发的回调
   */
  private onClickTag?: (event: ClickEvent) => void


  /**
   * 根据颜色type获取背景色
   * @returns
   */
  private getBackgroundColor() {
    return this.color ? this.color : this.baseStyle[this.type]
  }

  /**
   * 获取按钮的颜色
   * @param {boolean} isHasColor 是否需要展示颜色
   * @returns
   */
  private getTagColor(isHasColor: boolean) {
    return isHasColor ? this.getBackgroundColor() : '#fff'
  }

  /**
   * 获取按钮文字的颜色
   * @returns
   */
  private getTagTextColor() {
    if (this.textColor) {
      return this.textColor
    }
    return this.type === COLOR_TYPE.DEFAULT ? GRAY_COLOR.GRAY_8 : this.getTagColor(this.plain)
  }


  /**
   * 根据size获取tag的尺寸
   * @returns
   */
  private getTagSize() {
    const tagSize = this.tagSize;
    switch (tagSize) {
      case 'medium':
        return new TagSizeData('12lpx', '40lpx', this.baseStyle.fontSizeSm, this.getBorderRadius('4lpx') ) ;
      case SIZE.LARGE:
        return new TagSizeData(this.baseStyle.spaceXs, '48lpx', this.baseStyle.fontSizeMd,  this.getBorderRadius('8lpx') ) ;
      default:
        return new TagSizeData(this.baseStyle.spaceBase, '34lpx', this.baseStyle.fontSizeSm, this.getBorderRadius('4lpx') ) ;
    }
  }

  /**
   * 获取边框radius
   * @param borderRadius
   * @returns
   */
  private getBorderRadius(borderRadius: string): BorderRadiuses | Length {
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
      return borderRadius
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
              typeof this.onClose === 'function' && this.onClose(event)
            })
          })
        }

      }
      .tagSizeStyle(this.getTagSize())
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .borderWidth('2lpx')
      .backgroundColor(this.getTagColor(!this.plain))
      .borderColor(this.type === COLOR_TYPE.DEFAULT ? GRAY_COLOR.GRAY_4 : this.getTagColor(this.plain))
      .transition({ type: TransitionType.Insert, opacity: 1 })
      .transition({ type: TransitionType.Delete, opacity: 0 })
      .onClick((event)=>{
        typeof this.onClickTag === 'function' && this.onClickTag(event)
      })
    }
  }
}