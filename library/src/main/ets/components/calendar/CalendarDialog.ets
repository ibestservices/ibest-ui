import { ColorType, COLOR_TYPE } from '../../theme-chalk/src/color.type'
import { IBestButton } from '../button'
import {IBestCalendar} from "./index"
import { ConfirmResultType, SelectedStyleType, SelectType } from './index.type'



@Component
export struct IBestCalendarDialog {
    /*
     * 已选日期
     */
    @State selectedDate: ConfirmResultType | Array<ConfirmResultType> = []
    /*
     * 底部偏移
     */
    @Prop offsetY: number = 0
    /*
     * 是否为模态窗口
     */
    @Prop isModal: boolean = true
    /*
     * 背板的圆角半径
     */
    @Prop cornerRadius: number = 10
    /*
     * 弹框展示状态
     */
    @Link @Watch("visibleChange") visible: boolean
    /*
		 * 默认选中日期
		 */
    @Prop defaultSelectedDate: Array<string> = []
    /*
     * 是否显示农历
     */
    @Prop isShowLunar: boolean = true
    /*
     * 选择类型
     */
    @Prop selectType: SelectType = "single"
    /*
     * 选中样式
     */
    @Prop selectedStyleType: SelectedStyleType = "normal"
    /*
     * 选中主题颜色
     */
    @Prop type: ColorType = COLOR_TYPE.PRIMARY
    /*
     * 自定义选中颜色
     */
    @Prop selectedColor: string = ""
    /*
     * 选择回调
     */
    onConfirm: (value: ConfirmResultType | Array<ConfirmResultType>) => void = () => {}

    @Builder ConfirmBtnBuilder() {
        IBestButton({
            text: "确定",
            onClickBtn: () => {
                this.confirm()
            }
        })
    }

    dialogController: CustomDialogController | null = new CustomDialogController({
        builder: IBestCalendar({
            defaultSelectedDate: this.defaultSelectedDate,
            isShowLunar: this.isShowLunar,
            selectType: this.selectType,
            selectedStyleType: this.selectedStyleType,
            type: this.type,
            selectedColor: this.selectedColor,
            confirmBtnBuilder: this.ConfirmBtnBuilder,
            onConfirm: (value): void => this.onGetCalendarResult(value)
        }),
        alignment: DialogAlignment.Bottom,
        offset: { dx: 0, dy: this.offsetY },
        isModal: this.isModal,
        cornerRadius: this.cornerRadius,
        cancel: () => {
            this.visible = false
        }
    })
    visibleChange(){
        if(this.visible){
            this.dialogController?.open()
        }else{
            this.dialogController?.close()
        }
    }
    /*
     * 获取日历选择结果
     */
    onGetCalendarResult(value: ConfirmResultType | Array<ConfirmResultType>) {
        this.selectedDate = value
        if(this.selectType === "single"){
            this.confirm()
        }
    }
    /*
     * 触发onConfirm回调函数 并关闭弹框
     */
    confirm(): void {
        // console.log("confirm")
        typeof this.onConfirm === "function" && this.onConfirm(this.selectedDate)
        this.visible = false
    }
    build() {
    }
}