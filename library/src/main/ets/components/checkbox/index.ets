import { emitter } from '../../assets/ets/EventEmitter';
import { IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';
import { SPACE } from '../../theme-chalk/src/space.type';
import { CheckedItem, updateCheckboxStoreByKey } from '../checkboxGroup/store';
import { CHECKBOX_GROUP_EVENT_NAME, getCheckboxNamespace } from '../checkboxGroup/utils';


export type BuilderArgData = {
  checked: boolean,
  disabled: boolean
}

@Component
export struct IBestCheckbox {
  /**
   * 自定义文本插槽
   */
  @BuilderParam defaultBuilder: (data: BuilderArgData) => any = null
  /**
   * 自定义图标插槽
   */
  @BuilderParam iconBuilder: (data: BuilderArgData) => any = null
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IbestUIBaseStyleType = {}
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
  @Prop checkedColor: string = this.baseStyle.primary;
  /**
   * 图标大小 单位lpx
   * 默认40lpx
   */
  @Prop iconSize: number = 40;
  /**
   * 默认是否选中 非双向绑定
   * 如果要更改数据请从onChange回调中获取最新的值
   */
  @Prop value: boolean;
  /**
   * 是否禁用
   */
  @Prop @Watch('getIsDisabled') disabled: boolean = false
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
  @Prop group: string = ''
  /**
   * 动画时长
   */
  animationDuration = 200;
  /**
   * 改变的回调
   */
  onChange?: (checked: boolean) => void;
  /**
   * 受checkboxgroup的最大可选数量禁用的
   */
  @State @Watch('getIsDisabled') checkboxGroupMaxDisabled: boolean = false;
  @State mergeDisabled: boolean = false;

  /**
   * 获取背景色
   * @returns
   */
  getBackgroundColor() {
    if (this.mergeDisabled) {
      return GRAY_COLOR.GRAY_3
    } else {
      return this.value ? this.checkedColor : 'transparent'
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
      return this.value ? this.checkedColor : GRAY_COLOR.GRAY_5
    }
  }

  /**
   * 获取label的颜色
   * @returns
   */
  getLabelColor() {
    return this.mergeDisabled ? GRAY_COLOR.GRAY_5 : GRAY_COLOR.GRAY_8
  }

  /**
   * 获取图标的颜色
   * @returns
   */
  getIconColor() {
    return this.mergeDisabled ? GRAY_COLOR.GRAY_5 : '#fff'
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
      updateCheckboxStoreByKey(this.group, { name: this.name, checked: this.value })
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
    typeof this.onChange === 'function' && this.onChange(this.value)
    this.updateGroupStore()
  }

  /**
   * 当选中的最大数量变化时 或者选中的数据变化时
   * @param data
   */
  handleMaxChange(data: {
    max: number,
    checkedList: CheckedItem[]
  }) {
    const {max, checkedList} = data || {};
    // max是0说明不限制了
    if( max <= 0){
      this.checkboxGroupMaxDisabled = false;
      return
    }
    // 是要禁用还是解禁？
    const length = checkedList.length;
    const index = checkedList.findIndex(item => item.name === this.name);
    // 如果是已经选中的了 不执行后续操作
    if (index > -1) {
      return
    }
    // 如果是没选中的
    // 并且选中的已经大于等于最大可选中的数量了
    // 如果当前是没有禁用的 那么就要禁用
    this.checkboxGroupMaxDisabled = length >= max;
  }

  /**
   * 获取是否禁用
   */
  getIsDisabled() {
    this.mergeDisabled = this.disabled || this.checkboxGroupMaxDisabled;
  }

  /**
   * 全选反选的响应事件
   * @param {boolean} [isSelectAll] 传true是全选 传false是反选
   */
  handleToggleChange(isSelectAll = true){
    this.handleCheckedChange( isSelectAll ? true : !this.value )
  }


  aboutToAppear() {
    this.updateGroupStore()
    // 如果有组 监听maxchange
    if(this.isHasGroup()){
      emitter.on(getCheckboxNamespace(this.group, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE), this.handleMaxChange.bind(this))
      emitter.on(getCheckboxNamespace(this.group, CHECKBOX_GROUP_EVENT_NAME.ON_TOGGLE_ALL), this.handleToggleChange.bind(this))
    }else{
      this.getIsDisabled()
    }
  }

  aboutToDisappear() {
    if(this.isHasGroup()){
      emitter.off(getCheckboxNamespace(this.group, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE), this.handleMaxChange.bind(this))
      emitter.on(getCheckboxNamespace(this.group, CHECKBOX_GROUP_EVENT_NAME.ON_TOGGLE_ALL), this.handleToggleChange.bind(this))
    }
  }

  @Builder
  LabelContain() {
    if (typeof this.defaultBuilder === 'function') {
      this.defaultBuilder({ checked: this.value, disabled: this.mergeDisabled }).onClick(() => {
        !this.labelDisabled && this.handleCheckedChange()
      })
    } else {
      Text(this.label)
        .fontColor(this.getLabelColor())
        .fontSize(`${this.iconSize * .7}lpx`)
        .margin({
          left: this.isLeftLabel() ? 0 : SPACE.XS,
          right: this.isLeftLabel() ? SPACE.XS : 0
        }).onClick(() => {
        !this.labelDisabled && this.handleCheckedChange()
      })
    }
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
          // 图标
          Image($r('app.media.success'))
            .fillColor(this.getIconColor())
            .width(`${this.iconSize}lpx`)
            .height(`${this.iconSize}lpx`)
            .opacity(this.value ? 1 : 0)
            .animation({
              duration: this.animationDuration,
            })
            .scale({
              x: .9,
              y: .9
            })
        }
      }
      .width(`${this.iconSize}lpx`)
      .height(`${this.iconSize}lpx`)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .border({ color: this.getBorderColor(), width: '2lpx' })
      .borderRadius(this.shape === 'round' ? `${this.iconSize / 2}lpx` : 0)
      .backgroundColor(this.getBackgroundColor())
      .animation({
        duration: this.animationDuration,
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