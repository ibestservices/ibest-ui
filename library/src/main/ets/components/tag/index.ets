import { IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { ColorType, COLOR_TYPE, GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type';
import { IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';
import { SIZE } from '../../theme-chalk/src/size.type';

@Extend(Row)
function tagSizeStyle(data: {
  height: string,
  padding: string,
  borderRadius: string,
}) {
  .padding({ top: 0, right: data.padding, bottom: 0, left: data.padding })
  .height(data.height)
  .borderRadius(data.borderRadius)
}

@Component
export struct IBestTag {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IbestUIBaseStyleType = {};
  /**
   * 类型，可选值为 primary success warning danger
   */
  @Prop type: ColorType = COLOR_TYPE.PRIMARY;
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
  @Prop color: string = '';
  /**
   * 文本颜色，优先级高于 color 属性
   */
  @Prop textColor: string = ''
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
  onClose?: (event: ClickEvent) => void;
  /**
   * 点击标签触发的回调
   */
  onClickTag?: (event: ClickEvent) => void
  /**
   * 根据buttonSize换对应的按钮尺寸
   */
  tagSizeMap = {
    'medium': {
      padding: '12lpx',
      height: '40lpx',
      fontSize: this.baseStyle.fontSizeSm,
      borderRadius: '4lpx'
    },
    [SIZE.LARGE]: {
      padding: this.baseStyle.spaceXs,
      height: '48lpx',
      fontSize: this.baseStyle.fontSizeMd,
      borderRadius: '8lpx'
    },
    // 默认尺寸配置
    default: {
      padding: this.baseStyle.spaceBase,
      height: '34lpx',
      fontSize: this.baseStyle.fontSizeSm,
      borderRadius: '4lpx'
    },
  };

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
    return this.type === COLOR_TYPE.DEFAULT ? GRAY_COLOR.GRAY_8 : this.getTagColor(this.plain)
  }

  /**
   * 根据size获取按钮的尺寸
   * @returns
   */
  getTagSize() {
    const sizeData = this.tagSizeMap[this.tagSize] || this.tagSizeMap.default
    return {
      ...sizeData,
      borderRadius: this.getBorderRadius(sizeData.borderRadius)
    };
  }

  /**
   * 获取边框radius
   * @param borderRadius
   * @returns
   */
  getBorderRadius(borderRadius: string): BorderRadiuses | Length {
    if (this.round) {
      return this.baseStyle.borderRadiusMAX
    } else if (this.mark) {
      return {
        topLeft: 0,
        topRight: this.baseStyle.borderRadiusMAX,
        bottomLeft: 0,
        bottomRight: this.baseStyle.borderRadiusMAX
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
            animateTo({ duration: this.baseStyle.animationDuration }, () => {
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