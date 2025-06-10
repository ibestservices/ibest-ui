import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { IBestStringNumber } from '../../model/Global.type';
import { IBestForm, IBestFormRule, IBestField, IBestFormController, IBestCellGroup,
  IBestButton,
  IBestToast,
  IBestCascader} from "@ibestservices/ibest-ui";
import { regionData } from "@ibestservices/area-data"
import { IBestContactAddressColor } from './color';
import { convertDimensionsWidthUnit, getSizeByUnit } from '../../utils/utils';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';

@Component
export struct IBestContactAddressForm {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 左侧label字体颜色
   */
  @Prop labelColor: ResourceColor = IBestContactAddressColor.labelColor
  /**
   * 输入框文字大小
   */
  @Prop inputFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
  /**
   * 输入框文字粗细
   */
  @Prop inputFontWeight: string | number | FontWeight = FontWeight.Bold
  /**
   * 底部线条
   */
  @Prop hasBorder: boolean = false
  /**
   * 占位文字颜色
   */
  @Prop placeholderColor: ResourceColor = IBestContactAddressColor.placeholderColor
  /**
   * 识别输入框内占位提示文字
   */
  @Prop identifyPlaceholder: ResourceStr = "请粘贴或输入文本，点击“识别”自动识别姓名、电话和地址"
  /**
   * 识别输入框顶部的提示文字
   */
  @Prop identifyTagText: ResourceStr = "示例：菜小鸟，136xxxx0000，浙江省杭州市西湖区某小区"
  /**
   * 识别输入框顶部标签的背景色
   */
  @Prop identifyTagColor: ResourceColor = "#7F007DFF"
  /**
   * 是否显示识别输入框
   */
  @Prop hasIdentifyInputBox: boolean = true

  @State uniId: number = 0
  @State name: string = "杨俊斌"
  @State phone: string = "15915862747"
  @State provinceCityDistrict: string = ""
  @State visible: boolean = false
  @State selectValue: string[] = []
  @State detail: string = ""
  @State addressText: string = ""

  private formId: string = ''
  private controller: IBestFormController = new IBestFormController()

  aboutToAppear() {
    this.uniId = this.getUniqueId()
    this.formId = `ibest_contact_address_form_${this.uniId}`
  }

  build() {
    Column({space: this.baseStyle.spaceMd as string}) {
      if(this.hasIdentifyInputBox) {
        Stack({alignContent: Alignment.Top}) {
          IBestCellGroup({inset: true, radius: 10}) {
            Column(){
              Column() {
                Text(this.identifyTagText)
                  .backgroundColor(Color.Transparent)
                  .fontSize(getSizeByUnit(11, true))
                  .fontColor(IBestContactAddressColor.inputColor)
              }
              .margin(this.baseStyle.spaceXs)
              .justifyContent(FlexAlign.Start)
              .backgroundColor(Color.Transparent)
              Column().height(this.baseStyle.lineHeightLg)
            }
            .clip(true)
            .backgroundColor(this.identifyTagColor)
            .width(CONTAINER_SIZE.FULL)
          }

          IBestCellGroup({inset: true, radius: 10}) {
            Column({space: this.baseStyle.spaceXs as string}) {
              TextArea({ text: $$this.addressText, placeholder: this.identifyPlaceholder })
                .backgroundColor(Color.Transparent)
                .fontSize(getSizeByUnit(this.inputFontSize, true))
                .fontColor(IBestContactAddressColor.inputColor)
                .fontWeight(this.inputFontWeight)
                .placeholderFont({
                  size: getSizeByUnit(this.inputFontSize, true)
                })
                .placeholderColor(this.placeholderColor)
                .constraintSize({ minHeight: convertDimensionsWidthUnit(4 * 20), maxHeight: convertDimensionsWidthUnit(4 * 20) })
                .lineHeight(this.baseStyle.lineHeightMd)
                .enableAutoFill(false)
                .onChange((value: string) => {
                })

              Row({space: this.baseStyle.spaceSm as string}) {
                Blank().layoutWeight(1)
                IBestButton({
                  text: "清空",
                  type: "primary",
                  btnBorderRadius: 20,
                  btnWidth: 60,
                  btnHeight: 28,
                  color: Color.Transparent,
                  btnBorderColor: Color.Transparent,
                  fontColor: Color.Black
                })
                IBestButton({
                  text: "识别",
                  type: "primary",
                  btnBorderRadius: 20,
                  btnWidth: 60,
                  btnHeight: 28,
                })
              }.margin({bottom: this.baseStyle.spaceSm, left: this.baseStyle.spaceSm, right: this.baseStyle.spaceSm})
            }
            .width(CONTAINER_SIZE.FULL)
            .backgroundColor($r("app.color.ibest_field_background"))
            .clip(true)
            .margin({top: 30})
          }
        }
      }

      IBestForm({
        formId: this.formId,
        controller: this.controller,
        requireAsteriskPosition: "right"
      }){
        IBestCellGroup({inset: true, radius: 10}) {
          IBestField({
            formId: this.formId,
            prop: 'name',
            value: $name,
            label: "姓名",
            placeholder: "请输入姓名",
            rules:[
              { required: true, message: '请输入姓名' },
              { min: 2, max: 5, message: '姓名长度在2-5个字符之间' }
            ],
            showMessage: false,
            required: false,
            hasBorder: this.hasBorder,
            autosize: true,
            type: 'username',
            inputFontWeight: this.inputFontWeight,
            labelColor: this.labelColor,
            inputFontSize: this.inputFontSize,
            placeholderColor: this.placeholderColor
          })
          IBestField({
            formId: this.formId,
            prop: 'phone',
            value: $phone,
            label: "手机号",
            placeholder: "请输入手机号",
            rules: [
              { required: true, message: '请输入手机号' }
            ],
            showMessage: false,
            required: false,
            hasBorder: this.hasBorder,
            autosize: true,
            type: 'phone',
            inputFontWeight: this.inputFontWeight,
            labelColor: this.labelColor,
            inputFontSize: this.inputFontSize,
            placeholderColor: this.placeholderColor
          })
          IBestField({
            formId: this.formId,
            prop: 'provinceCityDistrict',
            value: $provinceCityDistrict,
            label: "省市区",
            placeholder: "请选择省市区",
            isLink: true,
            onFieldClick: () => {
              this.visible = true
            },
            hasBorder: this.hasBorder,
            inputFontWeight: this.inputFontWeight,
            labelColor: this.labelColor,
            inputFontSize: this.inputFontSize,
            placeholderColor: this.placeholderColor
          })
          IBestField({
            formId: this.formId,
            prop: 'detail',
            value: $detail,
            label: "详细地址",
            placeholder: "输入小区/写字楼/门牌号等",
            hasBorder: false,
            inputFontWeight: this.inputFontWeight,
            labelColor: this.labelColor,
            inputFontSize: this.inputFontSize,
            placeholderColor: this.placeholderColor
          })
        }
      }

      // 选择城市
      IBestCascader({
        visible: $visible,
        options: regionData,
        value: $selectValue,
        onConfirm: value => {
          this.provinceCityDistrict = value
            .filter((item, index, arr) => index !== 1 || item.text !== arr[0].text)
            .map(item => item.text)
            .join(' ');
        }
      })
    }
  }
}