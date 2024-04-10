import { IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type';
import { IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';
import { SIZE } from '../../theme-chalk/src/size.type';
import { ARROW_DIRECTION } from './index.type';

@Component
export struct IBestCell {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IbestUIBaseStyleType = {};
  /**
   * title的插槽 优先级大于 title
   */
  @BuilderParam titleBuilder: CustomBuilder = null;
  /**
   * value的插槽 优先级大于 value
   */
  @BuilderParam valueBuilder: CustomBuilder = null;
  /**
   * value的插槽 优先级大于 label
   */
  @BuilderParam labelBuilder: CustomBuilder = null;
  /**
   * 自定义title左侧icon的插槽
   * 使用titleBuilder时，该插槽不生效
   */
  @BuilderParam iconBuilder: CustomBuilder = null;
  /**
   * 自定义value右侧icon的插槽
   * 使用valueBuilder时，该插槽不生效
   */
  @BuilderParam rightIconBuilder: CustomBuilder = null;
  /**
   * 左侧标题
   */
  @Prop title: number | string = '';
  /**
   * 标题的文字颜色 默认 #323233
   */
  @Prop titleColor: string = GRAY_COLOR.GRAY_8;
  /**
   * 右侧内容
   */
  @Prop value: number | string = '';
  /**
   * 内容的文字颜色 默认 #969799
   */
  @Prop valueColor: string = GRAY_COLOR.GRAY_6;
  /**
   * 标题下方的描述信息
   */
  @Prop label: number | string = '';
  /**
   * 描述的文字颜色 默认 #969799
   */
  @Prop labelColor: string = GRAY_COLOR.GRAY_6;
  /**
   * 是否显示内边框
   */
  @Prop hasBorder: boolean = true;
  /**
   * 单元格大小 默认 'normal'
   */
  @Prop cellSize: `${SIZE.LARGE}` | `${SIZE.NORMAL}` = SIZE.NORMAL;
  /**
   * 是否开启点击反馈
   */
  @Prop clickable: boolean = false;
  /**
   * 是否展示右侧箭头并开启点击反馈
   */
  @Prop isLink: boolean = false;
  /**
   * 是否展示右侧箭头并开启点击反馈
   */
  @Prop arrowDirection: `${ARROW_DIRECTION}` = ARROW_DIRECTION.RIGHT;
  /**
   * 是否显示必填*号
   */
  @Prop required: boolean = false;
  /**
   * 是否使内容垂直居中
   */
  @Prop center: boolean = false;
  /**
   * 根据buttonSize换对应的按钮尺寸
   */
  cellSizeMap = {
    [SIZE.LARGE]: {
      padding: this.baseStyle.spaceSm,
      fontSize: this.baseStyle.fontSizeLg,
      labelFontSize: this.baseStyle.fontSizeMd,
    },
    // 默认尺寸配置
    default: {
      padding: '20lpx',
      fontSize: this.baseStyle.fontSizeMd,
      labelFontSize: this.baseStyle.fontSizeSm,
    },
  };
  /**
   * 根据arrow direction获取图标旋转角度
   */
  arrowDirection2RotateDegMap = {
    [ARROW_DIRECTION.RIGHT]: 0,
    [ARROW_DIRECTION.TOP]: -90,
    [ARROW_DIRECTION.BOTTOM]: 90,
    [ARROW_DIRECTION.LEFT]: 180,
  }

  isHasLabel() {
    const labelText = String(this.label)
    return labelText.length
  }

  /**
   * 根据size获取单元格的尺寸
   * @returns
   */
  getCellSize() {
    return this.cellSizeMap[this.cellSize] || this.cellSizeMap.default
  }

  getArrowRotateAngle() {
    return this.arrowDirection2RotateDegMap[this.arrowDirection] || this.arrowDirection2RotateDegMap[ARROW_DIRECTION.RIGHT]
  }

  getAlignItems() {
    return this.center ? VerticalAlign.Center : VerticalAlign.Top
  }

  build() {
    Column() {
      Column() {
        // 标题与内容
        Row() {
          // 必选符号
          if (this.required) {
            Text('*')
              .margin({
                right: this.baseStyle.spaceMini
              })
              .fontSize(this.baseStyle.fontSizeSm)
              .fontColor(this.baseStyle.danger)
              .constraintSize({
                minHeight: '48lpx'
              })
          }
          // 标题
          if (typeof this.titleBuilder === 'function') {
            Row() {
              this.titleBuilder()
            }.constraintSize({
              minHeight: '48lpx'
            })
          } else {
            Row() {
              if (typeof this.iconBuilder === 'function') {
                Row() {
                  this.iconBuilder()
                }.constraintSize({
                  minHeight: '48lpx'
                })
              }
              // 默认标题内容
              Text(String(this.title))
                .layoutWeight(1)
                .lineHeight('48lpx')
                .fontSize(this.getCellSize().fontSize)
                .fontColor(this.titleColor)
            }.layoutWeight(1)
            .alignItems(this.getAlignItems())
          }

          // 内容
          if (typeof this.valueBuilder === 'function') {
            Row() {
              this.valueBuilder()
            }.constraintSize({
              minHeight: '48lpx'
            }).layoutWeight(1)
          } else {
            Row() {
              Text(String(this.value))
                .textAlign(TextAlign.Start)
                .lineHeight('48lpx')
                .fontSize(this.getCellSize().fontSize)
                .fontColor(this.valueColor)
              if (typeof this.rightIconBuilder === 'function') {
                Row() {
                  this.rightIconBuilder()
                }.constraintSize({
                  minHeight: '48lpx'
                })

                // 如果是link箭头
              } else if (this.isLink) {
                Row() {
                  Image($r("app.media.arrow_right"))
                    .width(this.baseStyle.fontSizeSm)
                    .margin({
                      top: '6lpx',
                      left: '8lpx'
                    })
                    .rotate({ angle: this.getArrowRotateAngle() })
                    .animation({
                      duration: this.baseStyle.animationDuration
                    })
                  // 行高会导致对不齐 所以要加个做小高度和行高一样
                }.constraintSize({
                  minHeight: '48lpx'
                })
              }
            }.layoutWeight(1)
            .justifyContent(FlexAlign.End)
            .alignItems(this.getAlignItems())
          }

        }.alignItems(this.getAlignItems())

        // 描述信息
        if (typeof this.labelBuilder === 'function') {
          Row() {
            this.labelBuilder()
          }.constraintSize({
            minHeight: '36lpx'
          })
        } else {
          if (this.isHasLabel()) {
            Text(String(this.label))
              .width(CONTAINER_SIZE.FULL)
              .lineHeight('36lpx')
              .fontSize(this.getCellSize().labelFontSize)
              .margin({
                top: this.baseStyle.spaceBase
              })
              .fontColor(this.labelColor)
          }
        }
      }
      .width(CONTAINER_SIZE.FULL)
      .border({
        width: { bottom: this.hasBorder ? '2lpx' : 0 },
        color: GRAY_COLOR.GRAY_3,
      })
      .padding({
        top: this.getCellSize().padding,
        bottom: this.getCellSize().padding,
      })
    }.padding({
      left: '32lpx',
      right: '32lpx'
    })
    .stateStyles({
      normal: {
        .backgroundColor('#fff')
      },
      pressed: {
        .backgroundColor(this.isLink || this.clickable ? '#f2f3f5' : '#fff')
      }
    })
    .animation({
      duration: this.baseStyle.animationDuration
    })

  }
}