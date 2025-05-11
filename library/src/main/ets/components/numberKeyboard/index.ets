import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { LengthMetrics } from '@kit.ArkUI';
import { KeyboardType } from './index.type';
import { IBestPopup } from '../popup';
import { convertDimensionsWidthUnit, getResourceStr } from '../../utils/utils';
import { IBestNumberKeyboardColor } from './color';

@Extend(Row) function ibestNumberKeyboardKeyBoxStyle(fullWidth?: boolean){
	.width(fullWidth ? `calc((100% - ${convertDimensionsWidthUnit(12)})/3*2 + ${convertDimensionsWidthUnit(6)})` : `calc((100% - ${convertDimensionsWidthUnit(12)})/3)`)
	.height(convertDimensionsWidthUnit(48))
	.borderRadius(getDefaultBaseStyle().borderRadiusMd)
	.justifyContent(FlexAlign.Center)
	.alignItems(VerticalAlign.Center)
	.stateStyles({
		normal: {
			.backgroundColor(IBestNumberKeyboardColor.keyBg)
		},
		pressed: {
			.backgroundColor(IBestNumberKeyboardColor.activeBg)
		}
	})
}
@Extend(Text) function ibestNumberKeyboardKeyTextStyle(){
	.fontSize(convertDimensionsWidthUnit(28, true))
	.fontColor(IBestNumberKeyboardColor.textColor)
}
@Extend(Row) function ibestNumberKeyboardKeyCustomBoxStyle(bg?: boolean){
	.width(CONTAINER_SIZE.FULL)
	.height(convertDimensionsWidthUnit(102))
	.borderRadius(getDefaultBaseStyle().borderRadiusMd)
	.justifyContent(FlexAlign.Center)
	.stateStyles({
		normal: {
			.backgroundColor(bg ? getDefaultBaseStyle().primary : IBestNumberKeyboardColor.keyBg)
			.opacity(1)
		},
		pressed: {
			.opacity(bg ? 0.5 : 1)
			.backgroundColor(bg ? getDefaultBaseStyle().primary : IBestNumberKeyboardColor.activeBg)
		}
	})
}

@Component
export struct NumberKeyboard{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 值
	 */
	@Link value: string
	/**
	 * 标题
	 */
	@Prop title: ResourceStr = ''
	/**
	 * 关闭按钮文字
	 */
	@Prop closeBtnText: ResourceStr = $r("app.string.ibest_text_complete")
	/**
	 * 额外按键
	 */
	@Prop extraKey: string | string[] = ''
	/**
	 * 删除文字
	 */
	@Prop deleteButtonText: ResourceStr = ''
	/**
	 * 样式风格
	 */
	@Prop styleType: 'default' | 'custom' = 'default'
	/**
	 * 是否随机排序
	 */
	@Prop isRandomKeyOrder: boolean = false
	/**
	 *  最大长度
	 */
	@Prop maxLength: number = -1
	/**
	 * 输入回调
	 */
	onInput: (value: string) => void = () => {}
	/**
	 * 删除回调
	 */
	onDelete: () => void = () => {}
	/**
	 * 关闭回调
	 */
	onClose: () => void = () => {}

	@State keysList: KeyboardType[] = []

	@Builder extraButton(item: KeyboardType){
		if(item.type == "delete"){
			if(item.text){
				Text(item.text)
					.fontSize(this.baseStyle.fontSizeLg)
					.fontColor(IBestNumberKeyboardColor.textColor)
			}else{
				Image($r("app.media.ibest_delete"))
					.width(convertDimensionsWidthUnit(32))
					.fillColor(IBestNumberKeyboardColor.textColor)
			}
		}else if(item.text){
			Text(item.text)
				.ibestNumberKeyboardKeyTextStyle()
		}else{
			Image($r("app.media.ibest_key_board"))
				.width(convertDimensionsWidthUnit(30))
				.fillColor(IBestNumberKeyboardColor.textColor)
		}
	}

	aboutToAppear(): void {
		this.init()
	}
	// 初始化键盘
	init(){
		if (this.styleType == 'default') {
			this.keysList = this.genDefaultKeys()
		} else {
			this.keysList = this.genCustomKeys()
		}
	}
	genBasicKeys(){
		const keys: KeyboardType[] = Array(9)
			.fill('')
			.map((_: string, i) => {
				let obj: KeyboardType = {
					text: i + 1 + ''
				}
				return obj
			})
		if (this.isRandomKeyOrder) {
			this.shuffle(keys)
		}
		return keys
	}
	// 获取默认keys
	genDefaultKeys(): KeyboardType[] {
		return [
			...this.genBasicKeys(),
			{ text: this.extraKey as string, type: 'extra' },
			{ text: "0" },
			{ text: this.deleteButtonText, type: 'delete' }
		]
	}
	// 获取自定义keys
	genCustomKeys(): KeyboardType[] {
		const keys = this.genBasicKeys()
		const extraKeys: string[] = Array.isArray(this.extraKey) ? this.extraKey : [this.extraKey]
		if (extraKeys.length === 1) {
			keys.push(
				{ text: "0", fullWidth: true },
				{ text: extraKeys[0], type: 'extra' }
			)
		} else if (extraKeys.length === 2) {
			keys.push(
				{ text: extraKeys[0], type: 'extra' },
				{ text: "0" },
				{ text: extraKeys[1], type: 'extra' }
			)
		}
		return keys
	}
	// 打乱顺序
	shuffle(array: KeyboardType[]): void {
		for (let i = array.length - 1; i > 0; i--) {
			const j = Math.floor(Math.random() * (i + 1))
			const temp = array[i]
			array[i] = array[j]
			array[j] = temp
		}
	}
	// 按键点击
	selectKey(key: KeyboardType): void {
		// console.log("选中", key.text, key.type)
		switch (key.type){
			case "close":
				this.onClose()
				break
			case "delete":
				this.value = this.value.slice(0, -1)
				break
			default:
				if(key.text){
					if(this.maxLength == -1 || this.value.length < this.maxLength){
						this.value += key.text
						this.onInput(getResourceStr(key.text))
					}
				}else{
					this.onClose()
				}
				break
		}
	}

	build() {
		Column(){
			if(this.title){
				Stack({ alignContent: Alignment.End }){
					Row(){
						Text(this.title)
							.fontSize(this.baseStyle.fontSizeLg)
							.fontColor(IBestNumberKeyboardColor.textColor)
					}
					.width(CONTAINER_SIZE.FULL)
					.justifyContent(FlexAlign.Center)
					Text(this.closeBtnText)
						.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd })
						.fontSize(this.baseStyle.fontSizeMd)
						.fontColor(this.baseStyle.primary)
						.onClick(() => {
							this.selectKey({ type: 'close' })
						})
				}
				.width(CONTAINER_SIZE.FULL)
				.height(convertDimensionsWidthUnit(40))
				.padding({ top: convertDimensionsWidthUnit(6) })
			}
			Row({ space:6 }){
				Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap, space: { cross: new LengthMetrics(6) } }){
					ForEach(this.keysList, (item: KeyboardType) => {
						Row() {
							this.extraButton(item)
						}
						.ibestNumberKeyboardKeyBoxStyle(item.fullWidth)
						.onClick(() => {
							this.selectKey(item)
						})
					}, (_: KeyboardType, index: number) => index + "")
				}
				.layoutWeight(1)
				if(this.styleType == "custom"){
					Column({ space: 6 }){
						Row() {
							this.extraButton({ text: this.deleteButtonText, type: 'delete' })
						}
						.ibestNumberKeyboardKeyCustomBoxStyle()
						.onClick(() => {
							this.selectKey({ type: 'delete' })
						})
						Row() {
							Text(this.closeBtnText)
								.fontColor(IBestNumberKeyboardColor.white)
								.fontSize(this.baseStyle.fontSizeLg)
						}
						.ibestNumberKeyboardKeyCustomBoxStyle(true)
						.onClick(() => {
							this.selectKey({ type: 'close' })
						})
					}
					.width(convertDimensionsWidthUnit(80))
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.padding(6)
		}
		.width(CONTAINER_SIZE.FULL)
		.backgroundColor(IBestNumberKeyboardColor.bg)
	}
}

@Component
export struct IBestNumberKeyboard{
	/**
	 * 弹框展示状态
	 */
	@Link visible: boolean
	/**
	 * 值
	 */
	@Link value: string
	/**
	 * 标题
	 */
	@Prop title: ResourceStr = ''
	/**
	 * 关闭按钮文字
	 */
	@Prop closeBtnText: ResourceStr = $r("app.string.ibest_text_complete")
	/**
	 * 额外按键
	 */
	@Prop extraKey: string | string[] = ''
	/**
	 * 删除文字
	 */
	@Prop deleteButtonText: ResourceStr = ''
	/**
	 * 样式风格
	 */
	@Prop styleType: 'default' | 'custom' = 'default'
	/**
	 * 是否随机排序
	 */
	@Prop isRandomKeyOrder: boolean = false
	/**
	 *  最大长度
	 */
	@Prop maxLength: number = -1
	/**
	 * 输入回调
	 */
	onInput: (value: string) => void = () => {}
	/**
	 * 删除回调
	 */
	onDelete: () => void = () => {}
	/**
	 * 关闭回调
	 */
	onClose: () => void = () => {}

	@Builder baseBuilder() {
		NumberKeyboard({
			value: $value,
			title: this.title,
			closeBtnText: this.closeBtnText,
			extraKey: this.extraKey,
			deleteButtonText: this.deleteButtonText,
			styleType: this.styleType,
			isRandomKeyOrder: this.isRandomKeyOrder,
			maxLength: this.maxLength,
			onInput: (value: string): void => this.onInput(value),
			onDelete: (): void => this.onDelete(),
			onClose: (): void => this.close()
		})
	}

	// 关闭
	close(){
		this.visible = false
		this.onClose()
	}

	build() {
		IBestPopup({
			visible: $visible,
			popupAlign: "bottom",
			popupHeight: "auto",
			bgColor: IBestNumberKeyboardColor.bg,
			maskColor: "transparent",
			closeOnBackPress: true,
			safeAreaInsetBottom: true,
			contentBuilder: ():void => this.baseBuilder()
		})
	}
}