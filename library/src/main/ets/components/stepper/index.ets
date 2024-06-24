import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color.type'
import { IbestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import {IBestStepperBtn} from './stepperBtn'
import {accAdd, accSub} from '../../assets/ets/utils'

enum STEPPER_BTN_TYPE {
  PLUS = 'PLUS',
  REDUCE = 'REDUCE'
}

@Component
export struct IBestStepper {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IbestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 输入框宽度
   */
  @Prop private inputWidth: string = '64lpx'
  /**
   * 按钮大小以及输入框高度
   */
  @Prop private buttonSize: string = '54lpx'
  /**
   * 图标大小
   */
  @Prop private iconSize: string = '40lpx'
  /**
   * 加减按钮图标的左右radius值
   */
  @Prop private buttonRadius: string = this.baseStyle.borderRadiusSm as string;
  /**
   * 默认值
   */
  @Prop @Watch('handleDefaultValueChange') private defaultValue: string  = '1';
  /**
   * 最小值
   */
  @Prop min: string | number = 1
  /**
   * 最大值
   */
  @Prop max: string | number = Infinity;
  /**
   * 多少毫秒触发校验
   */
  @Prop validateTime: number = 1000;
  /**
   * 是否自动校正超出限制范围的数值，设置为 false 后输入超过限制范围的数值将不会自动校正
   */
  @Prop autoFixed: boolean = true;
  /**
   * 步长，每次点击时改变的值
   */
  @Prop step: number | string = 5;
  /**
   * 固定显示的小数位数
   */
  @Prop decimalLength: number | string = '';
  /**
   * 输入框的值
   * inputNumValue改变会触发绑定的TextInput的change事件
   */
  @State inputNumValue: string = this.defaultValue;
  /**
   * 减少按钮是否禁用
   */
  @State reduceBtnDisabled: boolean = false;
  /**
   * 增加按钮是否禁用
   */
  @State plusBtnDisabled: boolean = false;
  /**
   * 上一次输入正确的值
   */
  preValue: string = this.defaultValue;
  /**
   * 自动纠正的时间
   */
  validateTimeId: number | null = null

  /**
   * TextInput变化时赋值
   * @param val
   */
  handleInputNumChange(val: string){
    clearTimeout(this.validateTimeId)
    // 避免inputNum变化一致情况
    if(val === this.inputNumValue){
      return
    }
    // 超过范围是否自动纠正
    if(this.autoFixed){
      if(val > this.max){
        this.handleInputNumChange(String(this.max))
        return
      }
      if(val < this.min){
        this.handleInputNumChange(String(this.min))
        return
      }
    }

    this.inputNumValue = val;
    this.handleSetStepperBtnStatus()
    // 判定输入是否合法
    if(/^-?\d+(\.\d+)?$/.test(val)){
      this.preValue = val;
    }else{
      this.handleValidateInputNum()
    }

  }

  /**
   * 输入值变化时如果不合法使用上一个有效值
   */
  handleValidateInputNum(){
    this.validateTimeId = setTimeout(()=>{
      // 不加这个它不更新 ？？？ 王德发
      this.inputNumValue = Math.random().toString()
      this.inputNumValue = this.preValue
      this.handleSetStepperBtnStatus()
    }, this.validateTime)
  }


  /**
   * 监听inputNumChange改变按钮状态
   */
  handleSetStepperBtnStatus(){
    const val = this.inputNumValue;
    this.reduceBtnDisabled = val <= this.min;
    this.plusBtnDisabled = val >= this.max;
  }

  /**
   * 当默认值发生改变时重新赋值
   */
  handleDefaultValueChange(){
    this.inputNumValue = Math.random().toString()
    this.inputNumValue = this.defaultValue;
    this.preValue = this.defaultValue;
  }

  /**
   * 当点击加减按钮时
   * @param { STEPPER_BTN_TYPE } btnType
   */
  handleClickStepperBtn(btnType: STEPPER_BTN_TYPE){
    let nextValue = '0';
    // 如果增加
    if(btnType === STEPPER_BTN_TYPE.PLUS){
      nextValue = String(accAdd(Number(this.inputNumValue), Number(this.step)));
      if(nextValue > this.max){
        nextValue = String(this.max)
      }
    }else{
      nextValue = String(accSub(Number(this.inputNumValue),  Number(this.step)));
      if(nextValue < this.min){
        nextValue = String(this.min)
      }
    }
    this.handleInputNumChange(nextValue)
  }

  aboutToAppear(){
    this.handleDefaultValueChange()
    this.handleSetStepperBtnStatus()
  }

  aboutToDisappear(){
    clearTimeout(this.validateTimeId)
  }

  build(){
    Row(){

      // 减少按钮
      IBestStepperBtn({
        buttonSize: this.buttonSize,
        radiusLeftTop: this.buttonRadius,
        radiusLeftBottom: this.buttonRadius,
        disabled: this.reduceBtnDisabled,
        onClickBtn: (): void => this.handleClickStepperBtn(STEPPER_BTN_TYPE.REDUCE)
      }){
        Image($r('app.media.minus')).width(this.iconSize)
      }

      // 输入框
        TextInput({ text: this.inputNumValue })
          .width(this.inputWidth)
          .height(this.buttonSize)
          .padding(0)
          .margin({top: 0, bottom: 0, left: '4lpx', right: '4lpx'})
          .fontSize(this.baseStyle.fontSizeMd)
          .fontColor(GRAY_COLOR.GRAY_8)
          .backgroundColor(GRAY_COLOR.GRAY_2)
          .borderRadius(0)
          .textAlign(TextAlign.Center)
          .inputFilter('[0-9\.-]')
          .onChange((val)=>this.handleInputNumChange(val)

          )




      // 增加按钮
      IBestStepperBtn({
        buttonSize: this.buttonSize,
        radiusRightTop: this.buttonRadius,
        radiusRightBottom: this.buttonRadius,
        disabled: this.plusBtnDisabled,
        onClickBtn: (): void => this.handleClickStepperBtn(STEPPER_BTN_TYPE.PLUS)

      }){
        Column(){
          Image($r('app.media.minus')).width(this.iconSize)
          Image($r('app.media.minus'))
            .width(this.iconSize)
            .position({})
            .rotate({
              angle: '90deg'
            })
        }

      }

    }
  }
}