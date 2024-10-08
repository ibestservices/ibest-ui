import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { GRAY_COLOR } from '../../theme-chalk/src/color.type';
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { LengthMetrics, LengthUnit } from '@kit.ArkUI';
import { KeyboardType } from './index.type';
import { IBestPopup } from '../popup';
import { getWindowAvoidSize } from '../../assets/ets/utils';
import { common } from '@kit.AbilityKit';
// import { emitter } from '../../assets/ets/EventEmitter';
@Extend(Row) function keyBoxStyle(fullWidth?: boolean){
	.width(fullWidth ? "calc((100% - 24lpx)/3*2 + 12lpx)" : "calc((100% - 24lpx)/3)")
	.height("96lpx")
	.backgroundColor(getDefaultBaseStyle().default)
	.borderRadius(getDefaultBaseStyle().borderRadiusMd)
	.justifyContent(FlexAlign.Center)
	.alignItems(VerticalAlign.Center)
	.stateStyles({
		pressed: {
			.backgroundColor(GRAY_COLOR.GRAY_2)
		}
	})
}
@Extend(Text) function keyTextStyle(){
	.fontSize("56lpx")
}
@Extend(Row) function keyCustomBoxStyle(bg?: boolean){
	.width(CONTAINER_SIZE.FULL)
	.height("204lpx")
	.borderRadius(getDefaultBaseStyle().borderRadiusMd)
	.justifyContent(FlexAlign.Center)
	.backgroundColor(bg ? getDefaultBaseStyle().primary : getDefaultBaseStyle().default)
	.stateStyles({
		normal: {
			.backgroundColor(bg ? getDefaultBaseStyle().primary : getDefaultBaseStyle().default)
			.opacity(1)
		},
		pressed: {
			.opacity(bg ? 0.5 : 1)
			.backgroundColor(bg ? getDefaultBaseStyle().primary : GRAY_COLOR.GRAY_2)
		}
	})
}

@CustomDialog
@Component
export struct NumberKeyboard{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle();
	/*
	 * 值
	 */
	@Link value: string
	/*
	 * 标题
	 */
	@Prop title: string = ''
	/*
	 * 关闭按钮文字
	 */
	@Prop closeBtnText: string = '完成'
	/*
	 * 额外按键
	 */
	@Prop extraKey: string | string[] = ''
	/*
	 * 删除文字
	 */
	@Prop deleteButtonText: string = ''
	/*
	 * 样式风格
	 */
	@Prop styleType: 'default' | 'custom' = 'default'
	/*
	 * 是否随机排序
	 */
	@Prop isRandomKeyOrder: boolean = false
	/*
	 *  最大长度
	 */
	@Prop maxLength: number = -1
	/*
	 * 底部规避尺寸
	 */
	@State navigationSize: number = 0
	/*
	 * 输入回调
	 */
	onInput: (value: string) => void = () => {}
	/*
	 * 删除回调
	 */
	onDelete: () => void = () => {}
	/*
	 * 关闭回调
	 */
	onClose: () => void = () => {}

	@State keysList: KeyboardType[] = []
	private controller?: CustomDialogController
	private context = getContext(this) as common.BaseContext

	aboutToAppear(): void {
		this.init()
	}
	// 初始化键盘
	async init(){
		let res = await getWindowAvoidSize(this.context)
		this.navigationSize = res.navigationSize
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
						this.onInput(key.text)
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
							.fontColor(GRAY_COLOR.GRAY_7)
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
				.height("80lpx")
				.padding({ top: "12lpx" })
			}
			Row({ space: "12lpx" }){
				Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap, space: { cross: new LengthMetrics(12, LengthUnit.LPX) } }){
					ForEach(this.keysList, (item: KeyboardType) => {
						Row() {
							ExtraButton({ item: item })
						}
						.keyBoxStyle(item.fullWidth)
						.onClick(() => {
							this.selectKey(item)
						})
					}, (_: KeyboardType, index: number) => index + "")
				}
				.layoutWeight(1)
				if(this.styleType == "custom"){
					Column({ space: "12lpx" }){
						Row() {
							ExtraButton({ item: { type: 'delete' } })
						}
						.keyCustomBoxStyle()
						.onClick(() => {
							this.selectKey({ type: 'delete' })
						})
						Row() {
							Text(this.closeBtnText)
								.fontColor(this.baseStyle.default)
								.fontSize(this.baseStyle.fontSizeLg)
						}
						.keyCustomBoxStyle(true)
						.onClick(() => {
							this.selectKey({ type: 'close' })
						})
					}
					.width("160lpx")
				}
			}
			.width(CONTAINER_SIZE.FULL)
			.padding("12lpx")
		}
		.width(CONTAINER_SIZE.FULL)
		.backgroundColor(GRAY_COLOR.GRAY_2)
		.padding({ bottom: `${this.navigationSize}lpx` })
	}
}

// 扩展按钮
@Component
struct ExtraButton{
	@Prop item: KeyboardType
	build(){
		if(this.item.text){
			Text(this.item.text)
				.keyTextStyle()
		}else if(this.item.type == "delete"){
			Image($r("app.media.delete"))
				.width("64lpx")
		}else{
			Image($r("app.media.key_board"))
				.width("60lpx")
		}
	}
}

@Component
export struct IBestNumberKeyboard{
	// 唯一id
	// @State uniId: number = 0
	/*
	 * 弹框展示状态
	 */
	@Link visible: boolean
	/*
	 * 值
	 */
	@Link value: string
	/*
	 * 标题
	 */
	@Prop title: string = ''
	/*
	 * 关闭按钮文字
	 */
	@Prop closeBtnText: string = '完成'
	/*
	 * 额外按键
	 */
	@Prop extraKey: string | string[] = ''
	/*
	 * 删除文字
	 */
	@Prop deleteButtonText: string = ''
	/*
	 * 样式风格
	 */
	@Prop styleType: 'default' | 'custom' = 'default'
	/*
	 * 是否随机排序
	 */
	@Prop isRandomKeyOrder: boolean = false
	/*
	 *  最大长度
	 */
	@Prop maxLength: number = -1
	/*
	 * 输入回调
	 */
	onInput: (value: string) => void = () => {}
	/*
	 * 删除回调
	 */
	onDelete: () => void = () => {}
	/*
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

	// aboutToAppear(): void {
	// 	this.uniId = this.getUniqueId()
	// 	emitter.on("numberKeyboardClose", (uniId: number) => {
	// 		if(this.uniId != uniId){
	// 			this.visible = false
	// 		}
	// 	})
	// }

	// aboutToDisappear(): void {
	// 	emitter.off("numberKeyboardClose", () => {})
	// }
	// visibleChange(){
	// 	if(this.visible){
	// 		emitter.emit("numberKeyboardClose", this.uniId)
	// 	}
	// }
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
			maskColor: "transparent",
			closeOnBackPress: true,
			safeAreaInsetBottom: false,
			contentBuilder: ():void => this.baseBuilder()
		})
	}
}