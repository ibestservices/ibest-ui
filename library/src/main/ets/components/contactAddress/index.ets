import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { IBestStringNumber } from '../../model/Global.type';
import { regionData } from "@ibestservices/area-data"
import { IBestContactAddressColor } from './color';
import { convertDimensionsWidthUnit, getResourceStr, getSizeByUnit } from '../../utils/utils';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { IBestContactAddressFormResult, IBestContactAddressController } from './index.type';
import { IBestCascaderOption } from '../cascader/index.type';
import { IBestFormController, IBestFormRule } from '../form/index.type';
import { IBestCellGroup } from '../cellGroup';
import { IBestTextEllipsis } from '../textEllipsis';
import { IBestButton } from '../button';
import { IBestForm } from '../form';
import { IBestLoading } from '../loading';
import { IBestField } from '../field';
import { IBestCascader } from '../cascader';
import { addressParse, filterPhone, judgeIsName } from './utils';
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
	@Prop @Watch("identifyTagTextChange") identifyTagText: ResourceStr = "示例：菜小鸟，136xxxx0000，浙江省杭州市西湖区某小区"
	/**
	 * 识别输入框顶部标签的背景色
	 */
	@Prop identifyTagColor: ResourceColor = "#7F007DFF"
	/**
	 * 是否显示识别输入框
	 */
	@Prop hasIdentifyInputBox: boolean = true
	// 组件控制器
	controller: IBestContactAddressController = new IBestContactAddressController()

	@State name: string = ""
	@State phone: string = ""
	@State provinceCityDistrict: Array<IBestCascaderOption> = []
	@State provinceCityDistrictStr: string = ""
	@State visible: boolean = false
	@State selectValue: string[] = []
	@State detail: string = ""
	@State postalCode: string = ""
	@State addressText: string = ""
	@State showLoading: boolean = false
	@State identifyTagTextLength: number = 0
	private formId: string = ''
	private formController: IBestFormController = new IBestFormController()
	private rules: IBestFormRule = {
		"name": [
			{ required: true, message: $r('app.string.ibest_text_input_name') },
			{ validator: this.validatorName, message: $r('app.string.ibest_text_input_correct_content') }
		],
		"phone": [
			{ required: true, message: $r('app.string.ibest_text_input_phone') },
			{ validator: this.validatorPhone, message: $r('app.string.ibest_text_input_correct_content') }
		],
		"provinceCityDistrictStr": [
			{ required: true, message: $r('app.string.ibest_text_select_region') }
		]
	}

	aboutToAppear() {
		this.formId = `ibest_contact_address_form_${this.getUniqueId()}`
		this.controller.validateForm = (callBack) => {
			return this.formController.validate(callBack)
		}
		this.controller.getFormValues = (): IBestContactAddressFormResult => this.getFormValues()

		this.controller.setFormValues = (val: IBestContactAddressFormResult): void => this.setFormValues(val)

		this.controller.cleanFormValues = (): void => {
			this.phone = ''
			this.provinceCityDistrict = []
			this.provinceCityDistrictStr = ''
			this.detail = ''
			this.name = ''
			this.postalCode = ''
		}
	}
	identifyTagTextChange() {
		this.identifyTagTextLength = getResourceStr(this.identifyTagText).length
	}
	validatorName(val: string){
		return judgeIsName(val)
	}
	validatorPhone(val: string){
		return filterPhone(val).target != ''
	}
	// 获取表单数据
	getFormValues() {
		return {
			phone: this.phone,
			province: this.provinceCityDistrict.length > 0 ? getResourceStr(this.provinceCityDistrict[0].text) : '',
			city: this.provinceCityDistrict.length > 1 ? getResourceStr(this.provinceCityDistrict[1].text) : '',
			area: this.provinceCityDistrict.length > 2 ? getResourceStr(this.provinceCityDistrict[2].text) : '',
			detail: this.detail,
			name: this.name,
			provinceCode: this.provinceCityDistrict.length > 0 ? this.provinceCityDistrict[0].value : '',
			cityCode: this.provinceCityDistrict.length > 1 ? this.provinceCityDistrict[1].value : '',
			areaCode: this.provinceCityDistrict.length > 2 ? this.provinceCityDistrict[2].value : '',
			postalCode: this.postalCode
		} as IBestContactAddressFormResult
	}
	// 设置表单数据
	setFormValues(val: IBestContactAddressFormResult) {
		this.phone = val.phone
		this.provinceCityDistrict = [
			{ text: val.province, value: val.provinceCode as string },
			{ text: val.city, value: val.cityCode as string },
			{ text: val.area, value: val.areaCode as string },
		]
		this.provinceCityDistrictStr = this.provinceCityDistrict
			.filter((item, index, arr) => index !== 1 || item.text !== arr[0].text)
			.map(item => item.text)
			.join(' ')
		this.detail = val.detail
		this.name = val.name
		this.postalCode = val.postalCode || ''
	}
	build() {
		Column({ space: this.baseStyle.spaceSm as string }) {
			if (this.hasIdentifyInputBox) {
				IBestCellGroup({ inset: true, radius: 10 }) {
					Column() {
						Column() {
							if (this.identifyTagTextLength > 30) {
								IBestTextEllipsis({
									text: this.identifyTagText,
									textFontSize: getSizeByUnit(this.baseStyle.fontSizeSm as string, true),
									textColor: IBestContactAddressColor.inputColor
								})
							} else {
								Text(this.identifyTagText)
									.fontSize(getSizeByUnit(this.baseStyle.fontSizeSm as string, true))
									.fontColor(IBestContactAddressColor.inputColor)
									.textAlign(TextAlign.Center)
							}
						}
						.margin(this.baseStyle.spaceXs)
						.justifyContent(FlexAlign.Center)
						.backgroundColor(Color.Transparent)
					}
					.clip(true)
					.backgroundColor(this.identifyTagColor)
					.width(CONTAINER_SIZE.FULL)
					Column({ space: this.baseStyle.spaceXs as string }) {
						TextArea({ text: $$this.addressText, placeholder: this.identifyPlaceholder })
							.backgroundColor(Color.Transparent)
							.fontSize(getSizeByUnit(this.inputFontSize, true))
							.fontColor(IBestContactAddressColor.inputColor)
							.fontWeight(this.inputFontWeight)
							.placeholderFont({
								size: getSizeByUnit(this.inputFontSize, true)
							})
							.placeholderColor(this.placeholderColor)
							.constraintSize({
								minHeight: convertDimensionsWidthUnit(4 * 20),
								maxHeight: convertDimensionsWidthUnit(4 * 20)
							})
							.lineHeight(this.baseStyle.lineHeightMd)
							.enableAutoFill(false)
						Row({ space: this.baseStyle.spaceSm as string }) {
							Blank().layoutWeight(1)
							IBestButton({
								text: $r('app.string.ibest_text_clear'),
								type: "primary",
								btnBorderRadius: 20,
								btnWidth: 60,
								btnHeight: 28,
								color: Color.Transparent,
								btnBorderColor: Color.Transparent,
								fontColor: Color.Black,
								onBtnClick: () => {
									this.addressText = ""
								}
							}).visibility(this.addressText.length > 0 ? Visibility.Visible : Visibility.Hidden)
							IBestButton({
								text: $r('app.string.ibest_text_identify'),
								type: "primary",
								btnBorderRadius: 20,
								btnWidth: 60,
								btnHeight: 28,
								disabled: this.addressText.length < 5,
								color: this.identifyTagColor,
								btnBorderColor: this.identifyTagColor,
								onBtnClick: () => {
									this.setFormValues(addressParse(this.addressText))
								}
							})
						}
						.margin({
							bottom: this.baseStyle.spaceSm,
							left: this.baseStyle.spaceSm,
							right: this.baseStyle.spaceSm
						})
					}
					.width(CONTAINER_SIZE.FULL)
					.backgroundColor($r("app.color.ibest_field_background"))
					.clip(true)
				}
			}
			IBestForm({
				formId: this.formId,
				controller: this.formController,
				requireAsteriskPosition: "right",
				rules: this.rules
			}) {
				Stack() {
					if (this.showLoading) {
						Column() {
							IBestLoading({
								loadingSize: 64,
								loadingColor: this.identifyTagColor
							})
						}.zIndex(99)
					}
					IBestCellGroup({ inset: true, radius: 10 }) {
						IBestField({
							formId: this.formId,
							prop: 'name',
							value: $name,
							label: $r('app.string.ibest_text_name'),
							placeholder: $r('app.string.ibest_text_input_name'),
							hasBorder: this.hasBorder,
							autosize: true,
							inputFontWeight: this.inputFontWeight,
							labelColor: this.labelColor,
							inputFontSize: this.inputFontSize,
							placeholderColor: this.placeholderColor,
						})
						IBestField({
							formId: this.formId,
							prop: 'phone',
							value: $phone,
							label: $r('app.string.ibest_text_phone_number'),
							placeholder: $r('app.string.ibest_text_input_phone'),
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
							prop: 'provinceCityDistrictStr',
							value: $provinceCityDistrictStr,
							label: $r('app.string.ibest_text_province_city_district'),
							placeholder: $r('app.string.ibest_text_select_region2'),
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
							label: $r('app.string.ibest_text_detailed_address'),
							placeholder: $r('app.string.ibest_text_detailed_address_description'),
							hasBorder: this.hasBorder,
							inputFontWeight: this.inputFontWeight,
							labelColor: this.labelColor,
							inputFontSize: this.inputFontSize,
							placeholderColor: this.placeholderColor,
							autosize: true
						})
						IBestField({
							formId: this.formId,
							prop: 'postalCode',
							value: $postalCode,
							label: $r('app.string.ibest_text_postal_code'),
							placeholder: $r('app.string.ibest_text_input_postal_code'),
							autosize: true,
							type: 'number',
							max: 6,
							inputFontWeight: this.inputFontWeight,
							labelColor: this.labelColor,
							inputFontSize: this.inputFontSize,
							placeholderColor: this.placeholderColor,
							hasBorder: false,
						})
					}
				}
			}
			// 选择城市
			IBestCascader({
				visible: $visible,
				options: regionData,
				value: $selectValue,
				onConfirm: value => {
					this.provinceCityDistrict = value
					this.provinceCityDistrictStr = value
						.filter((item, index, arr) => index !== 1 || item.text !== arr[0].text)
						.map(item => item.text)
						.join(' ');
				}
			})
		}
	}
}