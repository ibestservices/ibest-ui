import { emitter } from '../../assets/ets/EventEmitter';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { SPACE } from '../../theme-chalk/src/space.type';
import { CheckedItem, updateRadioGroupStoreByKey } from '../radioGroup/store';
import { getRadioGroupNamespace, RADIO_GROUP_EVENT_NAME } from '../radioGroup/utils';
import { BuilderArgs } from './index.type';


@Component
export struct IBestRadio {
  /**
   * 自定义文本插槽
   */
  @BuilderParam defaultBuilder: (data: BuilderArgs) => CustomBuilder;
  /**
   * 自定义图标插槽
   */
  @BuilderParam iconBuilder: (data: BuilderArgs) => void;
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
   * 图标大小 单位lpx
   * 默认40lpx
   */
  @Prop iconSize: number = 40;
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
  onChange?: (checked: boolean) => void;

  /**
   * 获取背景色
   * @returns
   */
  getBackgroundColor() {
    if (this.disabled) {
      return GRAY_COLOR.GRAY_3
    } else {
      return this.value && this.shape != 'dot' ? this.checkedColor || this.baseStyle.primary : 'transparent'
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
      return this.value ? this.checkedColor || this.baseStyle.primary : GRAY_COLOR.GRAY_5
    }
  }

  /**
   * 获取label的颜色
   * @returns
   */
  getLabelColor() {
    return this.disabled ? GRAY_COLOR.GRAY_5 : GRAY_COLOR.GRAY_8
  }

  /**
   * 获取图标的颜色
   * @returns
   */
  getIconColor() {
    if (this.disabled) {
      return GRAY_COLOR.GRAY_5
    } else {
      return this.shape === 'dot' ? this.checkedColor || this.baseStyle.primary : '#fff'
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
    typeof this.onChange === 'function' && this.onChange(this.value)
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
      emitter.on(getRadioGroupNamespace(this.group, RADIO_GROUP_EVENT_NAME.ON_INIT), (name: string): void => this.handleRadioGroupInit(name))
    }
  }

  aboutToDisappear() {
    if (this.isHasGroup()) {
      emitter.off(getRadioGroupNamespace(this.group, RADIO_GROUP_EVENT_NAME.ON_INIT), (name: string): void => this.handleRadioGroupInit(name))
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
          .fontSize(`${this.iconSize * .7}lpx`)
      }
    }
    .margin({
      left: this.isLeftLabel() ? 0 : SPACE.XS,
      right: this.isLeftLabel() ? SPACE.XS : 0
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
        if (typeof this.iconBuilder === 'function') {
          this.iconBuilder({ checked: this.value, disabled: this.disabled })
        } else {
          if (this.shape === 'dot') {
            Column() {
            }
            .margin({
              top: '-2lpx'
            })
            .width(`${this.iconSize}lpx`)
            .height(`${this.iconSize}lpx`)
            .backgroundColor(this.getIconColor())
            .borderRadius(`${this.iconSize / 2}lpx`)
            .scale({
              x: this.value ? .618 : 0,
              y: this.value ? .618 : 0
            })
            .animation({
              duration: this.baseStyle.animationDuration as number
            })
          } else {
            Image($r('app.media.success'))
              .fillColor(this.getIconColor())
              .width(`${this.iconSize}lpx`)
              .opacity(this.value ? 1 : 0)
              .animation({
                duration: this.baseStyle.animationDuration as number,
              })
              .scale({
                x: .9,
                y: .9
              })// 升级api11后图形移位了
              .translate({ x: `${this.iconSize * .02}lpx}` })
          }

        }
      }
      .width(`${this.iconSize}lpx`)
      .height(`${this.iconSize}lpx`)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .border({ color: this.getBorderColor(), width: '2lpx' })
      .borderRadius(['round', 'dot'].includes(this.shape) ? `${this.iconSize / 2}lpx` : 0)
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