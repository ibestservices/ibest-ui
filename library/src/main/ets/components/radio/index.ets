import { emitter } from '../../utils/EventEmitter';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { CheckedItem, updateRadioGroupStoreByKey } from '../radioGroup/store';
import { COMPONENT_NAME, RADIO_GROUP_EVENT_NAME } from '../radioGroup/index.type';
import { BuilderArgs } from './index.type';
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit } from '../../utils/utils';
import { IBestRadioColor } from './color';
import { IBestIcon } from '../icon';
@Component
export struct IBestRadio {
  /**
   * 自定义文本插槽
   */
  @BuilderParam defaultBuilder?: (data: BuilderArgs) => void;

  /**
   * 自定义图标插槽
   */
  @BuilderParam iconBuilder?: (data: BuilderArgs) => void;
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 标识符，通常为一个唯一的字符串
   * 多选框名称。
   */
  @Prop name: string = '';
  /**
   * 形状
   */
  @Prop shape: 'square' | 'round' | 'dot' = 'round';
  /**
   * 选中状态颜色
   */
  @Prop checkedColor: ResourceColor = '';
  /**
   * 图标大小
   */
  @Prop iconSize: number | string = convertDimensionsWidthUnit(20)
  /**
   * 默认是否选中 非双向绑定
   * 如果要更改数据请从onChange回调中获取最新的值
   */
  @Prop value: boolean = false;
  /**
   * 是否禁用
   */
  @Prop disabled: boolean = false
  /**
   * 显示的文本
   */
  @Prop label: string = ''
  /**
   * 文本大小
   * @since 1.18.0
   */
  @Prop labelFontSize: number | string = convertDimensionsWidthUnit(16)
  /**
   * 文本位置，可选值为 left
   */
  @Prop labelPosition: 'left' | 'right' = 'right';
  /**
   * 是否禁用复选框文本点击
   */
  @Prop labelDisabled: boolean = false;
  /**
   * 组名
   */
  @Prop group: string = '';
  /**
   * 改变的回调
   */
  onChange: (checked: boolean) => void = () => {}

  /**
   * 获取背景色
   * @returns
   */
  getBackgroundColor() {
    if (this.disabled) {
      return IBestRadioColor.borderColor
    } else {
      return this.value && this.shape != 'dot' ? this.checkedColor || this.baseStyle.primary : ''
    }
  }

  /**
   * 获取边框色
   * @returns
   */
  getBorderColor() {
    if (this.disabled) {
      return GRAY_COLOR.GRAY_5
    } else {
      return this.value ? this.checkedColor || this.baseStyle.primary : IBestRadioColor.borderColor
    }
  }

  /**
   * 获取label的颜色
   * @returns
   */
  getLabelColor() {
    return this.disabled ? IBestRadioColor.disabledLabelColor : IBestRadioColor.labelColor
  }

  /**
   * 获取图标的颜色
   * @returns
   */
  getIconColor() {
    if (this.disabled) {
      return IBestRadioColor.disabledIconColor
    } else {
      return this.shape === 'dot' ? this.checkedColor || this.baseStyle.primary : IBestRadioColor.whiteColor
    }
  }

  /**
   * 是否是在左边的label
   * @returns
   */
  isLeftLabel() {
    return this.labelPosition === 'left'
  }

  isHasGroup() {
    return typeof this.group === 'string' && this.group.length > 0
  }

  updateGroupStore() {
    if (this.isHasGroup()) {
      updateRadioGroupStoreByKey(this.group, { name: this.name, checked: this.value } as CheckedItem)
    }
  }

  /**
   * 改变选中状态的回调
   */
  handleCheckedChange() {
    if (this.disabled || this.value) {
      return
    }
    this.value = true;
    this.onChange(this.value)
    this.updateGroupStore()
  }

  /**
   * 当radioGroup初始化时 赋值选中逻辑
   * @param name
   */
  handleRadioGroupInit(name: string) {
    this.value = name === this.name
  }

  aboutToAppear() {
    this.value && this.updateGroupStore()
    // 如果有组 监听max change
    if (this.isHasGroup()) {
      emitter.on(getEventName(COMPONENT_NAME, this.group, RADIO_GROUP_EVENT_NAME.ON_INIT), (name: string): void => this.handleRadioGroupInit(name))
    }
  }

  aboutToDisappear() {
    if (this.isHasGroup()) {
      emitter.off(getEventName(COMPONENT_NAME, this.group, RADIO_GROUP_EVENT_NAME.ON_INIT), (name: string): void => this.handleRadioGroupInit(name))
    }
  }

  @Builder
  LabelContain() {
    Row() {
      if (this.defaultBuilder) {
        this.defaultBuilder({ checked: this.value, disabled: this.disabled })
      }else {
        Text(this.label)
          .fontColor(this.getLabelColor())
          .fontSize(getSizeByUnit(this.labelFontSize, true))
      }
    }
    .margin({
      left: this.isLeftLabel() ? 0 : this.baseStyle.spaceXs,
      right: this.isLeftLabel() ? this.baseStyle.spaceXs : 0
    })
    .onClick(() => {
      !this.labelDisabled && this.handleCheckedChange()
    })
  }

  build() {
    Row() {
      if (this.labelPosition === 'left') {
        this.LabelContain()
      }
      // radio
      Column() {
        if (this.iconBuilder) {
          this.iconBuilder({ checked: this.value, disabled: this.disabled })
        } else {
          if (this.shape === 'dot') {
            Column()
              .width(getSizeByUnit(this.iconSize))
              .aspectRatio(1)
              .backgroundColor(this.getIconColor())
              .borderRadius(this.baseStyle.borderRadiusMax)
              .scale({
                x: this.value ? 0.7 : 0,
                y: this.value ? 0.7 : 0
              })
              .animation({
                duration: this.baseStyle.animationDuration as number
              })
          } else {
            IBestIcon({
              name: "success",
              iconSize: this.iconSize,
              color: this.getIconColor(),
              onIconClick: () => {
                this.handleCheckedChange()
              }
            })
              .opacity(this.value ? 1 : 0)
              .animation({
                duration: this.baseStyle.animationDuration as number,
              })
          }
        }
      }
      .padding(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .border({ color: this.getBorderColor(), width: 1 })
      .borderRadius(['round', 'dot'].includes(this.shape) ? this.baseStyle.borderRadiusMax : 0)
      .backgroundColor(this.getBackgroundColor())
      .animation({
        duration: this.baseStyle.animationDuration as number,
      })
      .onClick(() => {
        this.handleCheckedChange()
      })
      if (this.labelPosition === 'right') {
        this.LabelContain()
      }
    }.enabled(!this.disabled)
  }
}