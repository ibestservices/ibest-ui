import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { IBestCarKeyboardKey } from './index.type'
import { IBestPopup } from '../popup'
import { convertDimensionsWidthUnit, getComponentsInfo, getResourceStr, getSizeByUnit } from '../../utils/utils'
import { IBestCarKeyboardColor } from './color'
import { IBestStringNumber } from '../../model/Global.type'
const keyWidth = 0.09

@Extend(Row) function ibestCarKeyboardKeyBoxStyle(){
    .borderRadius(getDefaultBaseStyle().borderRadiusMd)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .stateStyles({
        normal: {
            .backgroundColor(IBestCarKeyboardColor.keyBg)
        },
        pressed: {
            .backgroundColor(IBestCarKeyboardColor.activeBg)
        }
    })
}
@Extend(Text) function ibestCarKeyboardKeyTextStyle(){
    .fontSize(getDefaultBaseStyle().fontSizeLg)
    .fontColor(IBestCarKeyboardColor.textColor)
}

@Component
export struct CarKeyboard{
    @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@StorageProp("IBestBottomBarHeight") bottomBarHeight: number = 0
    @Link @Watch("switchDisabled") value: string
	@Prop maxLength: number = 8
    @Prop title: ResourceStr = ''
    @Prop confirmBtnText: ResourceStr = $r("app.string.ibest_text_complete")
	@Prop keyHeight: IBestStringNumber = convertDimensionsWidthUnit(42)
    onInput: (value: string) => void = () => {}
    onDelete: () => void = () => {}
    onClose: () => void = () => {}
	onConfirm: () => void = () => {}

	@State uniId: number = 0
    private provinceKeys: string[][] = [
		['京', '津', '沪', '渝', '冀', '豫', '云', '辽', '黑'],
		['湘', '皖', '鲁', '新', '苏', '浙', '赣', '鄂', '桂'],
		['甘', '晋', '蒙', '陕', '吉', '闽', '贵', '粤', '青'],
		['藏', '川', '宁', '琼', '使', '领', '临']
	]
	private numKeys: string[][] = [
		['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
		['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
		['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
		['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
		['港', '澳', '学', '警', '挂']
	]
	@State provinceKeysList: IBestCarKeyboardKey[][] = []
	@State numKeysList: IBestCarKeyboardKey[][] = []
	@State space: number = 0
	@State space1: number = 0
	private uiContext = this.getUIContext()

	@Builder deleteButton(){
		Row(){
			Image($r("app.media.ibest_delete"))
				.width(convertDimensionsWidthUnit(20))
				.fillColor(IBestCarKeyboardColor.textColor)
		}
		.layoutWeight(1)
		.height(getSizeByUnit(this.keyHeight))
		.ibestCarKeyboardKeyBoxStyle()
		.onClick(() => {
			this.selectKey(new IBestCarKeyboardKey("delete"))
		})
	}

    aboutToAppear(): void {
		this.init()
    }
	init(){
		this.uniId = this.getUniqueId()
		this.provinceKeysList = this.provinceKeys.map(e => {
			return e.map(f => new IBestCarKeyboardKey("text", f))
		})
		this.numKeysList = this.numKeys.map(e => {
			return e.map(f =>  new IBestCarKeyboardKey("text", f))
		})
		if(this.value){
			this.switchDisabled()
		}
		setTimeout(() => {
			let width = getComponentsInfo(this.uiContext, `ibest_car_keyboard_${this.uniId}`).width
			this.space = (width - width * keyWidth * 9 ) / 8
			this.space1 = (width - width * keyWidth * 10) / 9
		}, 100)
	}
    // 按键点击
    selectKey(key: IBestCarKeyboardKey): void {
        switch (key.type){
            case "delete":
                this.value = this.value.slice(0, -1)
				this.onDelete()
                break
            default:
				if(this.value.length < this.maxLength){
					this.value += key.text
					this.onInput(getResourceStr(key.text!))
				}
                break
        }
    }
	// 切换禁用
	switchDisabled(){
		const valueLength = this.value.length
		if(valueLength == 1) {
			const keys = this.numKeys[0]
			this.numKeysList.forEach(e => {
				e.forEach(f => {
					f.disabled = keys.includes(f.text)
				})
			})
		} else if(valueLength == this.maxLength - 2) {
			this.numKeysList.forEach(e => {
				e.forEach(f => {
					f.disabled = f.text === 'I' || f.text === 'O'
				})
			})
		} else {
			const keys = this.numKeys[this.numKeysList.length - 1].concat(['I', 'O'])
			this.numKeysList.forEach(e => {
				e.forEach(f => {
					f.disabled = keys.includes(f.text)
				})
			})
		}
	}

    build() {
        Column(){
			Stack({ alignContent: Alignment.End }){
				if(this.title){
					Row(){
						Text(this.title)
						.fontSize(this.baseStyle.fontSizeLg)
						.fontColor(IBestCarKeyboardColor.textColor)
					}
					.width(CONTAINER_SIZE.FULL)
					.justifyContent(FlexAlign.Center)
				}
				Text(this.confirmBtnText)
					.padding({ left: this.baseStyle.spaceMd, right: this.baseStyle.spaceSm })
					.fontSize(this.baseStyle.fontSizeMd)
					.fontColor(this.baseStyle.primary)
					.onClick(() => {
						this.onClose()
						this.onConfirm()
					})
			}
			.width(CONTAINER_SIZE.FULL)
			.height(convertDimensionsWidthUnit(40))
			Column(){
				Column({ space: this.baseStyle.spaceXs as string }){
					ForEach(this.provinceKeysList, (item: IBestCarKeyboardKey[], index: number) => {
						Row({space: this.space}){
							ForEach(item, (e: IBestCarKeyboardKey) => {
								KeyButton({
									item: e,
									keyHeight: this.keyHeight,
									selectKey: (key: IBestCarKeyboardKey) => this.selectKey(key)
								})
							}, (_: IBestCarKeyboardKey, i: number) => i.toString())
							if(index == this.provinceKeysList.length - 1){
								this.deleteButton()
							}
						}
						.width(CONTAINER_SIZE.FULL)
						.justifyContent(FlexAlign.SpaceBetween)
					})
				}
				.width(CONTAINER_SIZE.FULL)
				.visibility(this.value.length ? Visibility.None : Visibility.Visible)
				Column({ space: this.baseStyle.spaceXs as string }){
					ForEach(this.numKeysList, (item: IBestCarKeyboardKey[], index: number) => {
						Row({space: this.space1}){
							ForEach(item, (e: IBestCarKeyboardKey) => {
								KeyButton({
									item: e,
									keyHeight: this.keyHeight,
									full: index == this.numKeysList.length - 1,
									selectKey: (key: IBestCarKeyboardKey) => this.selectKey(key)
								}).layoutWeight(index == this.numKeysList.length - 1 ? 1 : 0)
							}, (_: IBestCarKeyboardKey, i: number) => i.toString())
							if(index == this.numKeysList.length - 2){
								this.deleteButton()
							}
						}
						.width(CONTAINER_SIZE.FULL)
						.justifyContent(index == 2 ? FlexAlign.Center : index == 3 ? FlexAlign.Start : FlexAlign.SpaceBetween)
					}, (_: IBestCarKeyboardKey[], i: number) => i.toString())
				}
				.width(CONTAINER_SIZE.FULL)
				.visibility(this.value.length ? Visibility.Visible : Visibility.None)
			}
			.id(`ibest_car_keyboard_${this.uniId}`)
        }
        .width(CONTAINER_SIZE.FULL)
        .backgroundColor(IBestCarKeyboardColor.bg)
		.padding({
			left: this.baseStyle.spaceBase as string,
			right: this.baseStyle.spaceBase as string,
			bottom: this.bottomBarHeight
		})
    }
}

@Component
struct KeyButton{
	@ObjectLink item: IBestCarKeyboardKey
	@Prop keyHeight: IBestStringNumber
	@Prop full: boolean = false
	selectKey: (e: IBestCarKeyboardKey) => void = () => {}
	build() {
		Row(){
			Text(this.item.text)
				.ibestCarKeyboardKeyTextStyle()
		}
		.width(this.full ? CONTAINER_SIZE.FULL : keyWidth * 100 + '%')
		.height(getSizeByUnit(this.keyHeight))
		.ibestCarKeyboardKeyBoxStyle()
		.enabled(!this.item.disabled)
		.opacity(this.item.disabled ? 0.6 : 1)
		.onClick(() => {
			this.selectKey(this.item)
		})
	}
}

@Component
export struct IBestCarKeyboard{
    /**
     * 弹框展示状态
     */
    @Link visible: boolean
    /**
     * 值
     */
    @Link value: string
	/**
	 * 最大长度
     */
	@Prop maxLength: number = 8
    /**
     * 标题
     */
    @Prop title: ResourceStr
	/**
	 * 确认按钮文字
	 */
	@Prop confirmBtnText: ResourceStr
	/**
	 * 按键高度
     */
	@Prop keyHeight: IBestStringNumber
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
	/**
	 * 完成回调
     */
	onConfirm: (value: string) => void = () => {}

    @Builder baseBuilder() {
        CarKeyboard({
            value: $value,
			maxLength: this.maxLength,
			title: this.title,
			confirmBtnText: this.confirmBtnText,
			keyHeight: this.keyHeight,
            onInput: (value: string): void => this.onInput(value),
            onDelete: (): void => this.onDelete(),
            onClose: (): void => this.close(),
			onConfirm: (): void => this.onConfirm(this.value)
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
            bgColor: IBestCarKeyboardColor.bg,
            maskColor: "transparent",
            closeOnBackPress: true,
            safeAreaInsetBottom: false,
            contentBuilder: ():void => this.baseBuilder()
        })
    }
}