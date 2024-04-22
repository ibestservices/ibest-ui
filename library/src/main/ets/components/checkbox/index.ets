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
  @BuilderParam private defaultBuilder?: (data: BuilderArgData) => any = null;
  /**
   * 自定义图标插槽
   */
  @BuilderParam private iconBuilder?: (data: BuilderArgData) => any = null;
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IbestUIBaseStyleType = {}
  /**
   * 标识符，通常为一个唯一的字符串
   * 多选框名称。
   */
  @Prop private name: string;
  /**
   * 形状
   */
  @Prop private shape: 'square' | 'round' = 'round';
  /**
   * 选中状态颜色
   */
  @Prop private checkedColor: string = '';
  /**
   * 图标大小 单位lpx
   * 默认40lpx
   */
  @Prop private iconSize: number = 40;
  /**
   * 默认是否选中 非双向绑定
   * 如果要更改数据请从onChange回调中获取最新的值
   */
  @Prop @Watch('handleValueChange') @Watch('handleIndeterminateChange') private value: boolean;
  /**
   * 是否禁用
   */
  @Prop @Watch('getIsDisabled') private disabled: boolean = false
  /**
   * 显示的文本
   */
  @Prop private label: string = ''
  /**
   * 文本位置，可选值为 left
   */
  @Prop private labelPosition: 'left' | 'right' = 'right';
  /**
   * 是否禁用复选框文本点击
   */
  @Prop private labelDisabled: boolean = false;
  /**
   * 组名
   */
  @Prop private group: string = '';
  /**
   * 是否为不确定状态
   */
  @Prop @Watch('handleIndeterminateChange') private indeterminate: boolean = false;
  /**
   * 改变的回调
   */
  private onChange?: (checked: boolean) => void;
  /**
   * 受checkboxgroup的最大可选数量禁用的
   */
  @State @Watch('getIsDisabled') private checkboxGroupMaxDisabled: boolean = false;
  /**
   * 合并disabled与checkboxGroupMaxDisabled的最终结果 用来UI渲染
   */
  @State private mergeDisabled: boolean = false;
  /**
   * 是否展示不确定状态的按钮
   * 因为chekbox在切换状态时有动画 但是图片切换没有动画 就会导致有不确定状态切换的时候 会先闪成勾选状态
   */
  @State private isShowIndeterminateImg: boolean = false;
  /**
   * 当不确定图标从显示变隐藏时 等待动画结束后再变
   */
  private isShowIndeterminateTimeId: number | null = null

  /**
   * 是否展示背景色
   * 比如选中了或者需要显示不确定状态时
   * @returns
   */
  private isShowBackground(){
    return this.value || this.indeterminate
  }

  /**
   * 获取背景色
   * @returns
   */
  private getBackgroundColor() {
    if (this.mergeDisabled) {
      return GRAY_COLOR.GRAY_3
    } else {
      return this.isShowBackground() ? this.checkedColor || this.baseStyle.primary : 'transparent'
    }
  }

  /**
   * 获取边框色
   * @returns
   */
  private getBorderColor() {
    if (this.mergeDisabled) {
      return GRAY_COLOR.GRAY_5
    } else {
      return this.isShowBackground() ? this.checkedColor || this.baseStyle.primary : GRAY_COLOR.GRAY_5
    }
  }

  /**
   * 获取label的颜色
   * @returns
   */
  private getLabelColor() {
    return this.mergeDisabled ? GRAY_COLOR.GRAY_5 : GRAY_COLOR.GRAY_8
  }

  /**
   * 获取图标的颜色
   * @returns
   */
  private getIconColor() {
    return this.mergeDisabled ? GRAY_COLOR.GRAY_5 : '#fff'
  }

  /**
   * 是否是在左边的label
   * @returns
   */
  private isLeftLabel() {
    return this.labelPosition === 'left'
  }

  private isHasGroup() {
    return typeof this.group === 'string' && this.group.length > 0
  }

  private updateGroupStore() {
    if (this.isHasGroup()) {
      updateCheckboxStoreByKey(this.group, { name: this.name, checked: this.value })
    }
  }

  /**
   * 改变选中状态的回调
   */
  private handleCheckedChange(status = !this.value) {
    if (this.mergeDisabled) {
      return
    }
    this.value = status;
    this.handleValueChange()
  }

  private handleValueChange(){
    typeof this.onChange === 'function' && this.onChange(this.value)
    this.updateGroupStore()
  }

  /**
   * 当选中的最大数量变化时 或者选中的数据变化时
   * @param data
   */
  private handleMaxChange(data: {
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
  private getIsDisabled() {
    this.mergeDisabled = this.disabled || this.checkboxGroupMaxDisabled;
  }

  /**
   * 全选反选的响应事件
   * @param {boolean} [isSelectAll] 切换所有复选框，传 true 为选中，false 为取消选中，不传参为取反
   */
  private handleToggleChange(isSelectAll?: boolean){
    this.handleCheckedChange( typeof isSelectAll === 'boolean' ? isSelectAll : !this.value )
  }

  /**
   * 当不确定状态发生改变时 响应按钮UI状态图标变化
   */
  private handleIndeterminateChange(){
    clearTimeout(this.isShowIndeterminateTimeId)
    // 当按钮的选中状态变为false时 会触发隐藏动画
    // 这时候如果直接更改不确定状态的图标为false时
    // 在隐藏动画执行的过程中图标会变为全选状态 为了避免所以等动画结束后再执行
    if(!this.value && !this.indeterminate){
      this.isShowIndeterminateTimeId = setTimeout(()=>{
        this.isShowIndeterminateImg = false
      }, this.baseStyle.animationDuration)
      return
    }
    this.isShowIndeterminateImg = this.indeterminate;
  }

  aboutToAppear() {
    this.updateGroupStore()
    // 如果有组 监听max change
    if(this.isHasGroup()){
      emitter.on(getCheckboxNamespace(this.group, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE), this.handleMaxChange.bind(this))
      emitter.on(getCheckboxNamespace(this.group, CHECKBOX_GROUP_EVENT_NAME.ON_TOGGLE_ALL), this.handleToggleChange.bind(this))
    }else{
      this.getIsDisabled()
    }
    this.handleIndeterminateChange()
  }

  aboutToDisappear() {
    if(this.isHasGroup()){
      emitter.off(getCheckboxNamespace(this.group, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE), this.handleMaxChange.bind(this))
      emitter.on(getCheckboxNamespace(this.group, CHECKBOX_GROUP_EVENT_NAME.ON_TOGGLE_ALL), this.handleToggleChange.bind(this))
    }
    clearTimeout(this.isShowIndeterminateTimeId)
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

          Image(this.isShowIndeterminateImg ? $r('app.media.indeterminate') : $r('app.media.success'))
            .fillColor(this.getIconColor())
            .width(`${this.iconSize}lpx`)
            .opacity( this.isShowBackground() ? 1 : 0)
            .animation({
              duration: this.baseStyle.animationDuration,
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
        duration: this.baseStyle.animationDuration,
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