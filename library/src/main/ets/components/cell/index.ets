import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { SIZE } from '../../theme-chalk/src/size.type';
import { convertDimensionsByUnit, getSizeByUnit } from '../../utils/utils';
import { ARROW_DIRECTION, CellSizeData } from './index.type';

@Component
export struct IBestCell {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
  /**
   * title的插槽 优先级大于 title
   */
  @BuilderParam titleBuilder?: CustomBuilder;
  /**
   * value的插槽 优先级大于 value
   */
  @BuilderParam valueBuilder?: CustomBuilder;
  /**
   * value的插槽 优先级大于 label
   */
  @BuilderParam labelBuilder?: CustomBuilder;
  /**
   * 自定义title左侧icon的插槽
   * 使用titleBuilder时，该插槽不生效
   */
  @BuilderParam iconBuilder?: CustomBuilder;
  /**
   * 自定义value右侧icon的插槽
   * 使用valueBuilder时，该插槽不生效
   */
  @BuilderParam rightIconBuilder?: CustomBuilder;
  /**
   * 左侧标题
   */
  @Prop title: number | string = '';
  /**
   * 标题的文字颜色 默认 #323233
   */
  @Prop titleColor: ResourceColor = GRAY_COLOR.GRAY_8;
  /**
   * 右侧内容
   */
  @Prop value: number | string = '';
  /**
   * 内容的文字颜色 默认 #969799
   */
  @Prop valueColor: ResourceColor = GRAY_COLOR.GRAY_6;
  /**
   * 标题下方的描述信息
   */
  @Prop label: number | string = '';
  /**
   * 描述的文字颜色 默认 #969799
   */
  @Prop labelColor: ResourceColor = GRAY_COLOR.GRAY_6;
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
   * 点击单元格的回调
   */
  onClickCell: (event: ClickEvent) => void = () => {}
  /**
   * 左侧图标
   * @since 1.17.0
   */
  @Prop leftIcon: ResourceStr = ""
  /**
   * 左侧图标颜色
   * @since 1.17.0
   */
  @Prop leftIconColor: ResourceColor = ""
  /**
   * 左侧图标大小
   * @since 1.17.0
   */
  @Prop leftIconSize: number | string = this.baseStyle.fontSizeMd
  /**
   * 右侧图标
   * @since 1.17.0
   */
  @Prop rightIcon: ResourceStr = ""
  /**
   * 右侧图标颜色
   * @since 1.17.0
   */
  @Prop rightIconColor: ResourceColor = ""
  /**
   * 右侧图标大小
   * @since 1.17.0
   */
  @Prop rightIconSize: number | string = this.baseStyle.fontSizeMd
  /**
   * 根据arrow direction获取图标旋转角度
   */
  arrowDirection2RotateDegMap: Record<string, number> = {
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
    const cellSize = this.cellSize;
    switch (cellSize){
        case SIZE.LARGE:
          return new CellSizeData(this.baseStyle.spaceMd, this.baseStyle.fontSizeLg, this.baseStyle.fontSizeMd)
      default:
        return new CellSizeData(convertDimensionsByUnit(14), this.baseStyle.fontSizeMd, this.baseStyle.fontSizeSm)
    }
  }

  getArrowRotateAngle() {
    return this.arrowDirection2RotateDegMap[this.arrowDirection] || this.arrowDirection2RotateDegMap[ARROW_DIRECTION.RIGHT]
  }

  getAlignItems() {
    return this.center ? VerticalAlign.Center : VerticalAlign.Top
  }

  build() {
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
          }
          // 标题与描述
          Column(){
            // 标题
            if (this.titleBuilder) {
              Row() {
                this.titleBuilder()
              }
            } else {
              Row() {
                if (this.iconBuilder) {
                  Row() {
                    this.iconBuilder()
                  }.margin({right: this.baseStyle.spaceBase})
                }else if(this.leftIcon){
                  Image(this.leftIcon)
                    .height(getSizeByUnit(this.leftIconSize))
                    .fillColor(this.leftIconColor)
                    .margin({right: this.baseStyle.spaceBase})
                }
                // 默认标题内容
                Text(String(this.title))
                  .layoutWeight(1)
                  .fontSize(this.getCellSize().fontSize)
                  .fontColor(this.titleColor)
              }.width(CONTAINER_SIZE.FULL)
              .alignItems(this.getAlignItems())
            }

            // 描述信息
            if (this.labelBuilder) {
              Row() {
                this.labelBuilder()
              }
            } else {
              if (this.isHasLabel()) {
                Text(String(this.label))
                  .width(CONTAINER_SIZE.FULL)
                  .fontSize(this.getCellSize().labelFontSize)
                  .margin({
                    top: this.baseStyle.spaceBase
                  })
                  .fontColor(this.labelColor)
              }
            }
          }
          .layoutWeight(1)
          .alignItems( this.center ? HorizontalAlign.Center : HorizontalAlign.Start)


          // 内容
          if (this.valueBuilder) {
            Row() {
              this.valueBuilder()
            }
            .layoutWeight(1)
          } else {
            Row() {
              Text(String(this.value))
                .textAlign(TextAlign.Start)
                .fontSize(this.getCellSize().fontSize)
                .fontColor(this.valueColor)
              if (this.rightIconBuilder) {
                Row() {
                  this.rightIconBuilder()
                }.margin({left: this.baseStyle.spaceBase})

                // 如果是link箭头
              } else if(this.rightIcon){
                Image(this.rightIcon)
                  .width(getSizeByUnit(this.rightIconSize))
                  .fillColor(this.rightIconColor)
                  .margin({left: this.baseStyle.spaceBase})
              } else if (this.isLink) {
                Row() {
                  Image($r("app.media.arrow_right"))
                    .width(this.baseStyle.fontSizeSm)
                    .margin({
                      top: convertDimensionsByUnit(3),
                      left: convertDimensionsByUnit(4)
                    })
                    .rotate({ angle: this.getArrowRotateAngle() })
                    .animation({
                      duration: this.baseStyle.animationDuration as number
                    })
                }
              }
            }.layoutWeight(1)
            .justifyContent(FlexAlign.End)
            .alignItems(this.getAlignItems())
          }

        }
        .alignItems(this.getAlignItems())
        .width(CONTAINER_SIZE.FULL)
        .border({
          width: { bottom: this.hasBorder ? convertDimensionsByUnit(1) : 0 },
          color: GRAY_COLOR.GRAY_3,
        })
        .padding({
          top: this.getCellSize().padding,
          bottom: this.getCellSize().padding,
        })

    }.padding({
      left: this.baseStyle.spaceMd,
      right: this.baseStyle.spaceMd
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
      duration: this.baseStyle.animationDuration as number
    })
    .onClick((event) => {
      this.onClickCell(event)
    })

  }
}