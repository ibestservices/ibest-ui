import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { IbestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import {IBestLoadingCircular} from './circular'
import {IBestLoadingSpinner} from './spinner'

@Component
export struct IBestLoading {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IbestUIBaseStyleObjType = getDefaultBaseStyle();
  /**
   * 默认插槽 loading覆盖的插槽
   */
  @BuilderParam defaultBuilder?: CustomBuilder;
  /**
   * loading的图标的插槽
   */
  @BuilderParam loadingIconBuilder?: CustomBuilder;
  /**
   * loading的文案的插槽
   */
  @BuilderParam loadingTextBuilder?: CustomBuilder;
  /**
   * 类型，可选值为 spinner
   */
  @Prop loadingIconType: 'circular' | 'spinner' = 'circular'
  /**
   * loading的尺寸
   */
  @Prop private loadingSize: string = '60lpx'
  /**
   * loading的颜色
   */
  @Prop private loadingColor: string = '#c9c9c9';
  /**
   * loading的线条宽度
   */
  @Prop private loadingStrokeWidth: string = '6lpx';
  /**
   * loading的遮罩颜色
   */
  @Prop private loadingMaskColor: string = 'transparent';
  /**
   * loading的图标距离顶部的margin 因为默认loading是垂直居中布局的 可通过该属性调整loading图标的上下位置 只有在vertical为true 即垂直布局时有效
   */
  @Prop private loadingIconMarginTop: string | number = '0';
  /**
   * loadingText的marginLeft值 只有在vertical为false 即横向布局时有效
   */
  @Prop private loadingTextMarginLeft: string | number = this.baseStyle.spaceXs;
  /**
   * loadingText的marginLeft值 只有在vertical为true 即垂直布局时有效
   */
  @Prop private loadingTextMarginTop: string | number = this.baseStyle.spaceXs;
  /**
   * 加载的文案
   */
  @Prop private loadingText?: string = undefined;
  /**
   * loading的文字颜色
   */
  @Prop private loadingTextColor: string = GRAY_COLOR.GRAY_6;
  /**
   * loading的文字大小
   */
  @Prop private loadingTextFontSize: string = this.baseStyle.fontSizeMd as string;
  /**
   * 菊花图的每条线的长度
   */
  @Prop private spinnerStrokeHeight: string | number = '15lpx';
  /**
   * 是否垂直排列图标和文字内容
   */
  @Prop private vertical: boolean = true;
  /**
   * 当前stack容器的尺寸
   */
  @State sizeValue?: SizeOptions = undefined;


  @Builder LoadingContent(){
    // loading图标
    if(typeof this.loadingIconBuilder === 'function'){
      this.loadingIconBuilder()
    }else{
      if(this.loadingIconType === 'spinner'){
        IBestLoadingSpinner({
          spinnerSize: this.loadingSize,
          strokeWidth: this.loadingStrokeWidth,
          strokeHeight: this.spinnerStrokeHeight,
          color: this.loadingColor,
        });
      }else{
        IBestLoadingCircular({
          circularSize: this.loadingSize,
          color: this.loadingColor,
          strokeWidth: this.loadingStrokeWidth
        }).margin({
          top: this.vertical ? this.loadingIconMarginTop : 0
        })
      }

    }
    // 加载的文案
    if(typeof this.loadingTextBuilder === 'function'){
      this.loadingTextBuilder()
    }else{
      if(this.loadingText?.trim()){
        Text(this.loadingText)
          .margin({
            top: this.vertical ? this.loadingTextMarginTop : 0,
            left: this.vertical ? 0 : this.loadingTextMarginLeft
          })
          .fontSize(this.loadingTextFontSize)
          .fontColor(this.loadingTextColor)
      }
    }
  }


  build(){
    Stack(){
      if(typeof this.defaultBuilder === 'function'){
        this.defaultBuilder()
      }

      // 如果是竖直排列的loading
      if(this.vertical){
        Column(){
          this.LoadingContent()
        }
        .justifyContent(FlexAlign.Center)
        // 避免边框超过绘制区域
        .padding(this.loadingStrokeWidth)
        .width(this.sizeValue?.width || 'auto')
        .height(this.sizeValue?.height || 'auto')
        .backgroundColor(this.loadingMaskColor)
      }else{
        Row(){
          this.LoadingContent()
        }
        .justifyContent(FlexAlign.Center)
        // 避免边框超过绘制区域
        .padding(this.loadingStrokeWidth)
        .width(this.sizeValue?.width || 'auto')
        .height(this.sizeValue?.height || 'auto')
        .backgroundColor(this.loadingMaskColor)
      }
    }.onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      this.sizeValue = newValue
    })


  }
}