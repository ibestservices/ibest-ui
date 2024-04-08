import { IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { IbestUIBaseStyleType } from '../../theme-chalk/src/index.type';
import { SPACE } from '../../theme-chalk/src/space.type';

@Component
export struct IBestCheckbox {
  /**
   * 自定义文本
   */
  @BuilderParam defaultBuilder: (data: {
    checked: boolean,
    disabled: boolean
  }) => any = null
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IbestUIBaseStyleType = {}
  /**
   * 标识符，通常为一个唯一的字符串
   * 多选框名称。
   */
  @Prop name: string = '';
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
  @Link value: boolean;
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
   * 动画时长
   */
  animationDuration = 200

  getBackgroundColor() {
    if (this.disabled) {
      return GRAY_COLOR.GRAY_3
    } else {
      return this.value ? this.checkedColor : 'transparent'
    }
  }

  getBorderColor() {
    if (this.disabled) {
      return GRAY_COLOR.GRAY_5
    } else {
      return this.value ? this.checkedColor : GRAY_COLOR.GRAY_5
    }
  }

  getLabelColor() {
    return this.disabled ? GRAY_COLOR.GRAY_3 : GRAY_COLOR.GRAY_8
  }

  getIconColor() {
    return this.disabled ? GRAY_COLOR.GRAY_5 : '#fff'
  }

  isLeftLabel() {
    return this.labelPosition === 'left'
  }


  handleChange(){
    if(this.disabled){
      return
    }
    this.value = !this.value
  }

  @Builder
  LabelContain() {
    if (typeof this.defaultBuilder === 'function') {
      this.defaultBuilder({ checked: this.value, disabled: this.disabled }).onClick(()=>{
         !this.labelDisabled && this.handleChange()
      })
    } else {
      Text(this.label)
        .fontColor(this.getLabelColor())
        .fontSize(`${this.iconSize * .9}lpx`)
        .margin({
          left: this.isLeftLabel() ? 0 : SPACE.XS,
          right: this.isLeftLabel() ? SPACE.XS : 0
        }).onClick(()=>{
        !this.labelDisabled && this.handleChange()
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
        // 中间的内容
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
        this.handleChange()
      })

      if (this.labelPosition === 'right') {
        this.LabelContain()
      }

    }.enabled(!this.disabled)


  }
}