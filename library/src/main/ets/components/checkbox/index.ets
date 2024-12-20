import { emitter } from '../../utils/EventEmitter';
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { CheckedItem, updateCheckboxStoreByKey } from '../checkboxGroup/store';
import { CHECKBOX_GROUP_EVENT_NAME, COMPONENT_NAME } from '../checkboxGroup/index.type';
import { BuilderArgs, MaxChangeArgs } from './index.type';
import { convertDimensionsWidthUnit, getEventName, getSizeByUnit } from '../../utils/utils';
import { IBestCheckboxColor } from './color';
import { IBestIcon } from '../icon';
@Component
export struct IBestCheckbox {
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
  @Prop name: string;
  /**
   * 形状
   */
  @Prop shape: 'square' | 'round' = 'round';
  /**
   * 选中状态颜色
   */
  @Prop checkedColor: ResourceColor = '';
  /**
   * 图标大小
   */
  @Prop iconSize: number | string = convertDimensionsWidthUnit(18)
  /**
   * 默认是否选中 非双向绑定
   * 如果要更改数据请从onChange回调中获取最新的值
   */
  @Prop @Watch('handleValueChange') @Watch('handleIndeterminateChange') value: boolean
  /**
   * 是否禁用
   */
  @Prop @Watch('getIsDisabled') disabled: boolean = false
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
   * 是否为不确定状态
   */
  @Prop @Watch('handleIndeterminateChange') indeterminate: boolean = false;
  /**
   * 改变的回调
   */
  onChange: (checked: boolean) => void = () => {}
  /**
   * 受checkboxgroup的最大可选数量禁用的
   */
  @State @Watch('getIsDisabled') checkboxGroupMaxDisabled: boolean = false;
  /**
   * 合并disabled与checkboxGroupMaxDisabled的最终结果 用来UI渲染
   */
  @State mergeDisabled: boolean = false;
  /**
   * 是否展示不确定状态的按钮
   * 因为chekbox在切换状态时有动画 但是图片切换没有动画 就会导致有不确定状态切换的时候 会先闪成勾选状态
   */
  @State isShowIndeterminateImg: boolean = false;
  /**
   * 当不确定图标从显示变隐藏时 等待动画结束后再变
   */
  private isShowIndeterminateTimeId: number | null = null

  /**
   * 是否展示背景色
   * 比如选中了或者需要显示不确定状态时
   * @returns
   */
  isShowBackground() {
    return this.value || this.indeterminate
  }

  /**
   * 获取背景色
   * @returns
   */
  getBackgroundColor() {
    if (this.mergeDisabled) {
      return IBestCheckboxColor.borderColor
    } else {
      return this.isShowBackground() ? this.checkedColor || this.baseStyle.primary : ""
    }
  }

  /**
   * 获取边框色
   * @returns
   */
  getBorderColor() {
    if (this.mergeDisabled) {
      return GRAY_COLOR.GRAY_5
    } else {
      return this.isShowBackground() ? this.checkedColor || this.baseStyle.primary : IBestCheckboxColor.borderColor
    }
  }

  /**
   * 获取label的颜色
   * @returns
   */
  getLabelColor() {
    return this.mergeDisabled ? IBestCheckboxColor.disabledLabelColor : IBestCheckboxColor.labelColor
  }

  /**
   * 获取图标的颜色
   * @returns
   */
  getIconColor() {
    return this.mergeDisabled ? IBestCheckboxColor.disabledIconColor : IBestCheckboxColor.whiteColor
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
      updateCheckboxStoreByKey(this.group, { name: this.name, checked: this.value } as CheckedItem)
    }
  }

  /**
   * 改变选中状态的回调
   */
  handleCheckedChange(status = !this.value) {
    if (this.mergeDisabled) {
      return
    }
    this.value = status;
    this.handleValueChange()
  }

  handleValueChange() {
    this.onChange(this.value)
    this.updateGroupStore()
  }

  /**
   * 当选中的最大数量变化时 或者选中的数据变化时
   * @param data
   */
  handleMaxChange(data: MaxChangeArgs) {
    // max是0说明不限制了
    if (data.max <= 0) {
      this.checkboxGroupMaxDisabled = false;
      return
    }
    // 是要禁用还是解禁？
    const length = data.checkedList.length;
    const index = data.checkedList.findIndex(item => item.name === this.name);
    // 如果是已经选中的了 不执行后续操作
    if (index > -1) {
      return
    }
    // 如果是没选中的
    // 并且选中的已经大于等于最大可选中的数量了
    // 如果当前是没有禁用的 那么就要禁用
    this.checkboxGroupMaxDisabled = length >= data.max;
  }

  /**
   * 获取是否禁用
   */
  getIsDisabled() {
    this.mergeDisabled = this.disabled || this.checkboxGroupMaxDisabled;
  }

  /**
   * 全选反选的响应事件
   * @param {boolean} [isSelectAll] 切换所有复选框，传 true 为选中，false 为取消选中，不传参为取反
   */
  handleToggleChange(isSelectAll?: boolean) {
    this.handleCheckedChange(typeof isSelectAll === 'boolean' ? isSelectAll : !this.value)
  }

  /**
   * 当不确定状态发生改变时 响应按钮UI状态图标变化
   */
  handleIndeterminateChange() {
    clearTimeout(this.isShowIndeterminateTimeId)
    // 当按钮的选中状态变为false时 会触发隐藏动画
    // 这时候如果直接更改不确定状态的图标为false时
    // 在隐藏动画执行的过程中图标会变为全选状态 为了避免所以等动画结束后再执行
    if (!this.value && !this.indeterminate) {
      this.isShowIndeterminateTimeId = setTimeout(() => {
        this.isShowIndeterminateImg = false
      }, this.baseStyle.animationDuration as number)
      return
    }
    this.isShowIndeterminateImg = this.indeterminate;
  }

  aboutToAppear() {
    this.updateGroupStore()
    // 如果有组 监听max change
    if (this.isHasGroup()) {
      emitter.on(getEventName(COMPONENT_NAME, this.group, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE), (data: MaxChangeArgs): void => this.handleMaxChange(data))
      emitter.on(getEventName(COMPONENT_NAME, this.group, CHECKBOX_GROUP_EVENT_NAME.ON_TOGGLE_ALL), (isSelectAll: boolean): void => this.handleToggleChange(isSelectAll))
    } else {
      this.getIsDisabled()
    }
    this.handleIndeterminateChange()
  }

  aboutToDisappear() {
    if (this.isHasGroup()) {
      emitter.off(getEventName(COMPONENT_NAME, this.group, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE), (data: MaxChangeArgs): void => this.handleMaxChange(data))
      emitter.on(getEventName(COMPONENT_NAME, this.group, CHECKBOX_GROUP_EVENT_NAME.ON_TOGGLE_ALL), (isSelectAll: boolean): void => this.handleToggleChange(isSelectAll))
    }
    clearTimeout(this.isShowIndeterminateTimeId)
  }

  @Builder
  LabelContain() {
    Row() {
      if (this.defaultBuilder) {
        this.defaultBuilder({ checked: this.value, disabled: this.mergeDisabled })
      } else {
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

      // checkbox
      Column() {
        if (typeof this.iconBuilder === 'function') {
          this.iconBuilder({ checked: this.value, disabled: this.mergeDisabled })
        } else {
          IBestIcon({
            name: this.isShowIndeterminateImg ? "minus" : "success",
            iconSize: this.iconSize,
            color: this.getIconColor()
          })
            .opacity(this.isShowBackground() ? 1 : 0)
            .animation({
              duration: this.baseStyle.animationDuration as number,
            })
        }
      }
      .padding(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .border({ color: this.getBorderColor(), width: 1 })
      .borderRadius(this.shape === 'round' ? this.baseStyle.borderRadiusMax : 0)
      .backgroundColor(this.getBackgroundColor())
      .clip(true)
      .hitTestBehavior(HitTestMode.Block)
      .animation({
        duration: this.baseStyle.animationDuration as number
      })
      .onClick(() => {
        this.handleCheckedChange()
      })

      if (this.labelPosition === 'right') {
        this.LabelContain()
      }
    }.enabled(!this.mergeDisabled)
  }
}