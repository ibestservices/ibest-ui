import { IBestPicker } from '../picker'
import { IBestPickerOption } from '../picker/index.type'
import { convertDimensionsWidthUnit } from '../../utils/utils'
import { IBestStringNumber } from '../../model/Global.type'

@Component
export struct IBestWeekPicker {
    /**
     * 已选择的值
     */
    @Link @Watch("valueChange") value: IBestStringNumber
    /**
     * 选项列表
     */
    @Prop options: IBestPickerOption[] = [
        { text: $r("app.string.ibest_monday"), value: 1 },
        { text: $r("app.string.ibest_tuesday"), value: 2 },
        { text: $r("app.string.ibest_wednesday"), value: 3 },
        { text: $r("app.string.ibest_thursday"), value: 4 },
        { text: $r("app.string.ibest_friday"), value: 5},
        { text: $r("app.string.ibest_saturday"), value: 6 },
        { text: $r("app.string.ibest_sunday"), value: 0 }
    ]
    /**
     * 标题
     */
    @Prop title: ResourceStr = ""
    /**
     * 单项高度
     */
    @Prop itemHeight: IBestStringNumber = convertDimensionsWidthUnit(44)
    /**
     * 确认按钮文字
     */
    @Prop confirmText: ResourceStr = $r("app.string.ibest_text_confirm")
    /**
     * 取消按钮文字
     */
    @Prop cancelText: ResourceStr = $r("app.string.ibest_text_cancel")
    /**
     * 是否显示顶部栏
     */
    @Prop showToolBar: boolean = true
    /**
     * 可见选项数量
     */
    @Prop visibleItemCount: number = 6
    /**
     * 是否横向
     */
    @Prop horizontal: boolean
    /**
     * 单项宽度, 仅横向时生效
     */
    @Prop itemWidth: IBestStringNumber
    /**
     * 高度, 仅横向时生效
     */
    @Prop contentHeight: IBestStringNumber
    /**
     * 选项字体大小
     */
    @Prop optionFontSize: IBestStringNumber
    /**
     * 外部圆角
     */
    @Prop radius: Length | BorderRadiuses | LocalizedBorderRadiuses = 0
    /**
     * 未选中字体颜色
     */
    @Prop fontColor: ResourceColor
    /**
     * 未选中字体字重
     */
    @Prop fontWeight: FontWeight
    /**
     * 选中字体大小
     */
    @Prop selectedFontSize: IBestStringNumber
    /**
     * 选中文字颜色
     */
    @Prop selectedFontColor: ResourceColor
    /**
     * 选项文字字重
     */
    @Prop selectedFontWeight: FontWeight
    /**
     * 确认按钮点击事件
     */
    onConfirm: (value: IBestStringNumber, text: string) => void = () => {}
    /**
     * 取消按钮点击事件
     */
    onCancel: () => void = () => {}
    /**
     * 选中项改变事件
     */
    onChange: (value: IBestStringNumber, text: string) => void = () => {}

    @State @Watch("pickerValChange") pickerVal: IBestStringNumber[] = [this.value]

    valueChange(){
        this.pickerVal = [this.value]
    }
    pickerValChange(){
        this.value = this.pickerVal[0]
    }

    build() {
        IBestPicker({
            value: $pickerVal,
            title: this.title,
            options: this.options,
            showToolBar: this.showToolBar,
            visibleItemCount: this.visibleItemCount,
            itemHeight: this.itemHeight,
            confirmText: this.confirmText,
            cancelText: this.cancelText,
            horizontal: this.horizontal,
            itemWidth: this.itemWidth,
            contentHeight: this.contentHeight,
            optionFontSize: this.optionFontSize,
            radius: this.radius,
            fontColor: this.fontColor,
            fontWeight: this.fontWeight,
            selectedFontSize: this.selectedFontSize,
            selectedFontColor: this.selectedFontColor,
            selectedFontWeight: this.selectedFontWeight,
            onConfirm: (selectedValues, selectTexts) => {
                this.onConfirm(selectedValues[0], selectTexts[0])
            },
            onCancel: () => {
                this.onCancel()
            },
            onChange: (selectedValues, selectTexts): void => this.onChange(selectedValues[0], selectTexts[0])
        })
    }
}