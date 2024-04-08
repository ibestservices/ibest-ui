import emitter from '@ohos.events.emitter';
import { IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';
import { SPACE } from '../../theme-chalk/src/space.type';
import { updateCheckboxStoreByKey } from '../checkboxGroup/store';


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
   * 是否选中
   */
  @Prop value: boolean;
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
   * 获取背景色
   * @returns
   */
  getBackgroundColor() {
    if (this.disabled) {
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
    if (this.disabled) {
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
    return this.disabled ? GRAY_COLOR.GRAY_3 : GRAY_COLOR.GRAY_8
  }

  /**
   * 获取图标的颜色
   * @returns
   */
  getIconColor() {
    return this.disabled ? GRAY_COLOR.GRAY_5 : '#fff'
  }

  /**
   * 是否是在左边的label
   * @returns
   */
  isLeftLabel() {
    return this.labelPosition === 'left'
  }

  isHasGroup(){
    return typeof this.group === 'string' && this.group.length > 0
  }

  updateGroupStore(){
    if(this.isHasGroup()){
      updateCheckboxStoreByKey(this.group, { name:this.name, checked: this.value})
    }
  }

  /**
   * 改变选中状态的回调
   */
  handleCheckedChange(){
    if(this.disabled){
      return
    }
    this.value = !this.value;
    typeof this.onChange === 'function' && this.onChange(this.value)
    this.updateGroupStore()
  }

  aboutToAppear(){
    this.updateGroupStore()
  }

  @Builder
  LabelContain() {
    if (typeof this.defaultBuilder === 'function') {
      this.defaultBuilder({ checked: this.value, disabled: this.disabled }).onClick(()=>{
         !this.labelDisabled && this.handleCheckedChange()
      })
    } else {
      Text(this.label)
        .fontColor(this.getLabelColor())
        .fontSize(`${this.iconSize * .9}lpx`)
        .margin({
          left: this.isLeftLabel() ? 0 : SPACE.XS,
          right: this.isLeftLabel() ? SPACE.XS : 0
        }).onClick(()=>{
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
        if(typeof this.iconBuilder === 'function'){
          this.iconBuilder({ checked: this.value, disabled: this.disabled })
        }else{
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
      .onClick(()=>{
        this.handleCheckedChange()
      })

      if (this.labelPosition === 'right') {
        this.LabelContain()
      }

    }.enabled(!this.disabled)


  }
}