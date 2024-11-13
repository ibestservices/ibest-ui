import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color.type'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { IBestStepperBtn } from './stepperBtn'
import { accAdd, accSub } from '../../utils/utils'

enum STEPPER_BTN_TYPE {
  PLUS = 'PLUS',
  REDUCE = 'REDUCE'
}

@Component
export struct IBestStepper {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 输入框宽度
   */
  @Prop inputWidth: string = '64lpx'
  /**
   * 按钮大小以及输入框高度
   */
  @Prop buttonSize: string = '54lpx'
  /**
   * 图标大小
   */
  @Prop iconSize: string = '40lpx'
  /**
   * 加减按钮图标的左右radius值
   */
  @Prop buttonRadius: string = this.baseStyle.borderRadiusSm as string;
  /**
   * 默认值
   */
  @Prop @Watch('handleInputNumChange') defaultValue: string | number = 1;
  /**
   * 最小值
   */
  @Prop min: string | number = 1;
  /**
   * 最大值
   */
  @Prop max: string | number = Infinity;
  /**
   * 多少毫秒触发校验修正 0时不校验
   */
  @Prop validateTime: number = 1000;
  /**
   * 是否自动校正超出限制范围的数值，设置为 false 后输入超过限制范围的数值将不会自动校正
   */
  @Prop autoFixed: boolean = true;
  /**
   * 步长，每次点击时改变的值
   */
  @Prop step: number = 1;
  /**
   * 固定显示的小数位数
   */
  @Prop decimalLength: number | string = '';
  /**
   * 是否只允许输入整数
   */
  @Prop integer: boolean = false;
  /**
   * 是否禁用步进器
   */
  @Prop disabled: boolean = false;
  /**
   *  是否禁用增加按钮
   */
  @Prop disablePlus: boolean = false;
  /**
   *  是否禁用减少按钮
   */
  @Prop disableMinus: boolean = false;
  /**
   * 是否禁用输入框
   */
  @Prop disableInput: boolean = false;
  /**
   * 是否显示增加地址
   */
  @Prop showPlus: boolean = true;
  /**
   * 是否显示增加地址
   */
  @Prop showMinus: boolean = true;
  /**
   * 是否显示增加地址
   */
  @Prop showInput: boolean = true;
  /**
   * 是否开启长按手势，开启后可以长按增加和减少按钮
   */
  @Prop longPress: boolean = true;
  /**
   * TODO 输入值变化前的回调函数，返回 false 可阻止输入，支持返回 Promise
   */
  // beforeChange?: (val: number | string) => boolean | Promise<boolean>;
  /**
   * 改变的回调
   */
  onChange?: (val: number | string) => void;
  /**
   * 点击增加按钮的回调
   */
  onPlus?: () => void;
  /**
   * 点击减少按钮的回调
   */
  onMinus?: () => void;
  /**
   * 输入框的值
   * inputNumValue改变会触发绑定的TextInput的change事件
   */
  @State inputNumValue: string = '';
  /**
   * 减少按钮是否禁用
   */
  @State reduceBtnDisabled: boolean = false;
  /**
   * 增加按钮是否禁用
   */
  @State plusBtnDisabled: boolean = false;
  /**
   * loading状态
   */
  @State loading: boolean = false;
  /**
   * 上一次输入正确的值
   */
  preValue: string | number = this.defaultValue;
  /**
   * 自动纠正的时间id
   */
  validateTimeId: number | null = null

  /**
   * TextInput变化时赋值
   * @param val
   * @param {boolean} validateSameVlue 是否触发相同数值的校验 自动修正时 不触发 换句话说 用户手动触发的改变 才触发
   */
  async handleInputNumChange(val: string, validateSameValue = false) {
    clearTimeout(this.validateTimeId)
    // 避免inputNum变化一致情况 当不触发beforechange时说明是修正 修正时不需要判定是否一致 不然可能会导致不更新
    if (validateSameValue && val === this.inputNumValue  ) {
      return
    }
    // 超过范围是否自动纠正
    if (this.autoFixed && val !== '') {
      if (val > this.max) {
        // console.log('触发自动修正')
        this.handleInputNumChange(String(this.max))
        return
      }
      if (val < this.min) {
        this.handleInputNumChange(String(this.min))
        return
      }
    }
    // 数据限制展示多少位
    if (this.decimalLength >= 1) {
      // console.log('触发decimalLength限制')
      val = Number(val).toFixed(Number(this.decimalLength))
    }
    // 限制整数 如果匹配不到正确的整数
    if (this.integer && !/^-?\d+$/.test(val)) {
      // console.log('触发整数限制')
      const numberArr = val.match(/^(-?\d+)/);
      if (Array.isArray(numberArr) && numberArr[0]) {
        val = String(Math.trunc(Number(numberArr[0])))
      } else {
        val = String(this.preValue || this.min)
      }
    }
    // console.log('inputNum赋值', val)
    // 不设置个随机数 UI不更新
    this.inputNumValue = String(Math.random());
    this.inputNumValue = val;
    this.handleSetStepperBtnStatus()
    // 判定输入是否合法
    if (/^-?\d+(\.\d+)?$/.test(val)) {
      this.preValue = val;
      // console.log('preValue赋值', val)
      typeof this.onChange === 'function' && this.onChange(val)
    } else {
      this.handleValidateInputNum()
    }
  }

  /**
   * 输入值变化时如果不合法使用上一个有效值
   */
  handleValidateInputNum() {
    this.validateTimeId = setTimeout(() => {
      // 校验延迟时间为0时不自动修复
      if (this.validateTime !== 0) {
        // 不设置个随机数 UI不更新
        this.inputNumValue = String(Math.random());
        this.inputNumValue = String(this.preValue);
        // console.log('不合法自动修正赋值', this.preValue)
        typeof this.onChange === 'function' && this.onChange(this.preValue)
      }
      this.handleSetStepperBtnStatus()
    }, this.validateTime)
  }

  /**
   * 监听inputNumChange改变按钮状态
   */
  handleSetStepperBtnStatus() {
    const val = this.inputNumValue;
    this.reduceBtnDisabled = val <= this.min;
    this.plusBtnDisabled = val >= this.max;
  }

  /**
   * 当点击加减按钮时
   * @param { STEPPER_BTN_TYPE } btnType
   */
  handleClickStepperBtn(btnType: STEPPER_BTN_TYPE) {
    if (this.disabled || this.loading) {
      return
    }
    let nextValue = '0';
    // 如果增加
    if (btnType === STEPPER_BTN_TYPE.PLUS) {
      if (this.disablePlus) {
        return
      }
      nextValue = String(accAdd(Number(this.inputNumValue), this.step));
      typeof this.onPlus === 'function' && this.onPlus()
    } else {
      if (this.disableMinus) {
        return
      }
      nextValue = String(accSub(Number(this.inputNumValue), this.step));
      typeof this.onMinus === 'function' && this.onMinus()
    }
    this.handleInputNumChange(nextValue, true)
  }

  aboutToAppear() {
    this.handleInputNumChange(String(this.defaultValue))
  }

  aboutToDisappear() {
    clearTimeout(this.validateTimeId)
  }

  build() {
    Row() {

      if (this.showMinus) {
        // 减少按钮
        IBestStepperBtn({
          buttonSize: this.buttonSize,
          radiusLeftTop: this.buttonRadius,
          radiusLeftBottom: this.buttonRadius,
          disabled: this.reduceBtnDisabled || this.disabled || this.disableMinus || this.loading,
          onClickBtn: (): void => this.handleClickStepperBtn(STEPPER_BTN_TYPE.REDUCE),
          onLongPress: (): void => this.handleClickStepperBtn(STEPPER_BTN_TYPE.REDUCE)
        }) {
          Image($r('app.media.minus')).width(this.iconSize)
        }
      }


      // 输入框
      if (this.showInput) {
        TextInput({ text: this.inputNumValue })
          .width(this.inputWidth)
          .height(this.buttonSize)
          .padding(0)
          .margin({
            top: 0,
            bottom: 0,
            left: '4lpx',
            right: '4lpx'
          })
          .fontSize(this.baseStyle.fontSizeMd)
          .fontColor(GRAY_COLOR.GRAY_8)
          .backgroundColor(GRAY_COLOR.GRAY_2)
          .borderRadius(0)
          .textAlign(TextAlign.Center)
          .inputFilter(this.integer ? '[0-9-]' : '[0-9\.-]')
          .onChange((val) => this.handleInputNumChange(val, true))
          .enabled(!this.disabled && !this.disableInput && !this.loading)
      }

      if (this.showPlus) {
        // 增加按钮
        IBestStepperBtn({
          buttonSize: this.buttonSize,
          radiusRightTop: this.buttonRadius,
          radiusRightBottom: this.buttonRadius,
          disabled: this.plusBtnDisabled || this.disabled || this.disablePlus || this.loading,
          onClickBtn: (): void => this.handleClickStepperBtn(STEPPER_BTN_TYPE.PLUS),
          onLongPress: (): void => this.handleClickStepperBtn(STEPPER_BTN_TYPE.PLUS)
        }) {
          Column() {
            Image($r('app.media.minus')).width(this.iconSize)
            Image($r('app.media.minus'))
              .width(this.iconSize)
              .position({ top: 0 })
              .rotate({
                angle: '90deg'
              })
          }

        }
      }
    }
  }
}