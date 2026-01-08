import { getDefaultBaseStyle } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { IBestStorageKey, IBestStringNumber, IBestLoadingIconType } from '../../model/Global.type';
import { IBestLoadingCircular } from './circular';
import { IBestLoadingSpinner } from './spinner';
import { getSizeByUnit } from '../../utils/utils';
import { IBestLoadingColor } from './color';
@Component
export struct IBestLoading {
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
	/**
	 * 类型，可选值为 spinner
	 */
	@Prop loadingIconType: IBestLoadingIconType = 'circular'
	/**
	 * loading的尺寸
	 */
	@Prop loadingSize: IBestStringNumber
	/**
	 * loading的颜色
	 */
	@Prop loadingColor: ResourceColor = GRAY_COLOR.GRAY_5;
	/**
	 * loading的线条宽度
	 */
	@Prop loadingStrokeWidth: Length
	/**
	 * loading的遮罩颜色
	 */
	@Prop loadingMaskColor: ResourceColor = 'transparent';
	/**
	 * loading的图标距离顶部的margin 只有在vertical为true 即垂直布局时有效
	 * @deprecated since 2.0.8
	 * @useinstead space
	 */
	@Prop loadingIconMarginTop: IBestStringNumber = 0
	/**
	 * loadingText的marginLeft值 只有在vertical为false 即横向布局时有效
	 * @deprecated since 2.0.8
	 * @useinstead space
	 */
	@Prop loadingTextMarginLeft: IBestStringNumber = this.baseStyle.spaceXs as string
	/**
	 * loadingText的marginTop值 只有在vertical为true 即垂直布局时有效
	 * @deprecated since 2.0.8
	 * @useinstead space
	 */
	@Prop loadingTextMarginTop: IBestStringNumber = this.baseStyle.spaceXs as string
	/**
	 * 加载的文案
	 */
	@Prop loadingText: ResourceStr = "";
	/**
	 * loading的文字颜色
	 */
	@Prop loadingTextColor: ResourceColor = IBestLoadingColor.textColor
	/**
	 * loading的文字大小
	 */
	@Prop loadingTextFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string;
	/**
	 * 菊花图的每条线的长度
	 */
	@Prop spinnerStrokeHeight: IBestStringNumber
	/**
	 * 是否垂直排列图标和文字内容
	 */
	@Prop vertical: boolean = true;
	/**
	 * 图标与文字间距
	 */
	@Prop space: IBestStringNumber = this.baseStyle.spaceXs as string;
	/**
	 * 默认插槽 loading覆盖的插槽
	 */
	@BuilderParam defaultBuilder: CustomBuilder;
	/**
	 * loading的图标的插槽
	 */
	@BuilderParam loadingIconBuilder: CustomBuilder;
	/**
	 * loading的文案的插槽
	 */
	@BuilderParam loadingTextBuilder: CustomBuilder;
	/**
	 * 当前stack容器的尺寸
	 */
	@State sizeValue?: SizeOptions = undefined;
	@Builder
	LoadingContent() {
		// loading图标
		if (this.loadingIconBuilder) {
			this.loadingIconBuilder()
		} else {
			if (this.loadingIconType === 'spinner') {
				IBestLoadingSpinner({
					spinnerSize: this.loadingSize,
					strokeWidth: this.loadingStrokeWidth,
					strokeHeight: this.spinnerStrokeHeight,
					color: this.loadingColor,
				});
			} else {
				IBestLoadingCircular({
					circularSize: this.loadingSize,
					color: this.loadingColor,
					strokeWidth: this.loadingStrokeWidth
				})
			}
		}
		// 加载的文案
		if (this.loadingTextBuilder) {
			this.loadingTextBuilder()
		} else {
			if (this.loadingText) {
				Text(this.loadingText)
					.fontSize(getSizeByUnit(this.loadingTextFontSize, true))
					.fontColor(this.loadingTextColor)
			}
		}
	}
	build() {
		Stack() {
			if (this.defaultBuilder) {
				this.defaultBuilder()
			}
			// 如果是竖直排列的loading
			if (this.vertical) {
				Column({space: getSizeByUnit(this.space)}) {
					this.LoadingContent()
				}
				.justifyContent(FlexAlign.Center)
				.width(this.sizeValue?.width || 'auto')
				.height(this.sizeValue?.height || 'auto')
				.backgroundColor(this.loadingMaskColor)
			} else {
				Row({space: getSizeByUnit(this.space)}) {
					this.LoadingContent()
				}
				.justifyContent(FlexAlign.Center)
				.width(this.sizeValue?.width || 'auto')
				.height(this.sizeValue?.height || 'auto')
				.backgroundColor(this.loadingMaskColor)
			}
		}.onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
			this.sizeValue = newValue
		})
	}
}