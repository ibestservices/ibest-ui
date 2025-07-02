import {
	IBestButton,
	IBestCanvasContent,
	IBestCanvasDrawer,
	IBestCellGroup,
	IBestDialog,
	IBestField,
	IBestForm,
	IBestFormController,
	IBestFormRule,
	IBestRadio,
	IBestRadioGroup,
	IBestToast,
	IBestUploader,
	IBestUploaderFile
} from '@ibestservices/ibest-ui'
import { FONT_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle'
import CustomNavBar from '../components/CustomNavBar'
import { generateId, savePixelMap, shareImage } from '../utils/utils'
import { common } from '@kit.AbilityKit'
@Builder
export function MakePosterBuilder(){
	MakePosterPage()
}
@Observed
class canvasContent extends IBestCanvasContent {
	id: string = ""
	constructor(value?: IBestCanvasContent) {
		super()
		this.id = generateId()
		if(value){
			this.type = value.type
			this.url = value.url
			this.text = value.text
			this.width = value.width
			this.height = value.height
			this.top = value.top
			this.bottom = value.bottom
			this.left = value.left
			this.right = value.right
			this.maxLineNumber = value.maxLineNumber
			this.fontSize = value.fontSize
			this.lineHeight = value.lineHeight
			this.fontColor = value.fontColor
			this.fontWeight = value.fontWeight
			this.textDecoration = value.textDecoration
			this.textAlign = value.textAlign
			this.borderRadius = value.borderRadius
			this.deg = value.deg
		}
	}
}
@Entry
@Component
struct MakePosterPage {
	@State canvasShow: boolean = false
	@State pixelMap: PixelMap | null = null
	@State imgVisible: boolean = false

	@State formId: string = "posterForm"
	@State canvasWidth: number | string = ""
	@State canvasHeight: number | string = ""
	@State canvasBgType: string = ''
	@State canvasBgColor: string = ''
	@State canvasBgImg: IBestUploaderFile[] = []
	@State radius: number | string = ''
	@State contentList: canvasContent[] = []
	private formController: IBestFormController = new IBestFormController()
	private rules: IBestFormRule = {
		"canvasWidth": [
			{ required: true, message: '请输入海报宽度' }
		],
		"canvasHeight": [
		  	{ required: true, message: '请输入海报高度' }
		],
		"canvasBgType": [
		  	{ required: true, message: '请选择海报背景类型' }
		],
		"canvasBgColor": [
		  	{ required: true, message: '请输入海报背景颜色' }
		],
		"contentType": [
		  	{ required: true, message: '请选择内容类型' }
		],
		"canvasBgImg": [
		  	{ required: true, message: '请选择海报背景图片' }
		],
		"text": [
		    { required: true, message: '请输入文字' }
		],
		"image": [
		    { required: true, message: '请选择图片' }
		],
		"width": [
		    { required: true, message: '请输入宽度' }
		],
		"height": [
		    { required: true, message: '请输入高度'}
		]
	}
	private context = getContext(this) as common.UIAbilityContext

	@Builder bgTypeBuilder(){
		IBestRadioGroup({group: "radioGroup", active: $canvasBgType, placeDirection: Axis.Horizontal}){
			IBestRadio({
				group: "radioGroup",
				name: "color",
				label: "颜色",
				iconSize: 14,
				labelFontSize: 14
			})
			IBestRadio({
				group: "radioGroup",
				name: "img",
				label: "图片",
				iconSize: 14,
				labelFontSize: 14
			})
		}
	}
	@Builder selectImgBuilder(){
		IBestUploader({
			fileList: $canvasBgImg,
			max: 1
		})
	}

	@Builder imgBuilder(){
		Column({space: SPACE.MD}){
			Image(this.pixelMap)
				.width(this.canvasWidth)
				.height(this.canvasHeight)
			Row({space: SPACE.MD}){
				SaveButton({ text: SaveDescription.SAVE_IMAGE })
					.onClick((event: ClickEvent, result: SaveButtonOnClickResult) => {
						if (result == SaveButtonOnClickResult.SUCCESS) {
							this.saveImg(this.pixelMap)
						}
					})
				IBestButton({
					text: "分享",
					btnWidth: 100,
					btnHeight: 40,
					round: true,
					onBtnClick: () => {
						shareImage(this.context, this.pixelMap!)
					}
				})
			}
		}
		.padding(SPACE.MD)
	}

	async saveImg(pixelMap: PixelMap | null){
		if(pixelMap){
			await savePixelMap(this.context, pixelMap)
			IBestToast.show({ message: `截图保存成功` })
		}
	}
	deleteContent(index: number){
		this.contentList.splice(index, 1)
	}
	getRadius(){
		return Number(this.radius)
	}

	build() {
		NavDestination(){
			CustomNavBar({title: "制作海报"})
			Scroll(){
				Column({space: SPACE.MD}){
					IBestForm({
						formId: this.formId,
						labelWidth: 100,
						rules: this.rules,
						controller: this.formController
					}){
						Row().height(1)
						IBestCellGroup({inset: true}){
							IBestField({
								formId: this.formId,
								prop: "canvasWidth",
								label: "海报宽度",
								value: $canvasWidth,
								type: "number",
								placeholder: "请输入海报宽度, 最小为100",
								min: 100
							})
							IBestField({
								formId: this.formId,
								prop: "canvasHeight",
								label: "海报高度",
								value: $canvasHeight,
								type: "number",
								placeholder: "请输入海报高度, 最小为100",
								min: 100
							})
							IBestField({
								formId: this.formId,
								prop: "radius",
								label: "海报圆角",
								value: $radius,
								type: "number",
								placeholder: "请输入海报圆角"
							})
							IBestField({
								formId: this.formId,
								prop: "canvasBgType",
								label: "海报背景类型",
								value: $canvasBgType,
								hasBorder: this.canvasBgType !== "",
								customRightContent: (): void => this.bgTypeBuilder()
							})
							if(this.canvasBgType === "color"){
								IBestField({
									formId: this.formId,
									prop: "canvasBgColor",
									label: "海报背景颜色",
									value: $canvasBgColor,
									placeholder: "请输入海报背景颜色, 例如 #fff",
									hasBorder: false
								})
							} else if(this.canvasBgType === "img"){
								IBestField({
									formId: this.formId,
									prop: "canvasBgImg",
									label: "海报背景图片",
									value: $canvasBgImg,
									hasBorder: false,
									customRightContent: (): void => this.selectImgBuilder()
								})
							}
						}
						ForEach(this.contentList, (item: canvasContent, index: number) => {
							contentItem({
								item: item,
								formId: this.formId,
								index: index,
								delete: (): void => this.deleteContent(index)
							})
						}, (item: canvasContent) => item.id)
					}
					IBestButton({
						text: "添加内容",
						type: "primary",
						round: true,
						btnWidth: "90%",
						onBtnClick: () => {
							this.contentList.push(new canvasContent())
						}
					})
					IBestButton({
						text: "生成海报",
						type: "primary",
						round: true,
						btnWidth: "90%",
						onBtnClick: () => {
							this.formController.validate((valid, field) => {
								if(valid){
									console.log("海报内容", JSON.stringify(this.contentList))
									this.canvasShow = true
								}else{
									console.log("校验失败", JSON.stringify(field))
								}
							})
						}
					})
				}
			}
			.layoutWeight(1)
			.align(Alignment.Top)
			if(this.canvasShow){
				IBestCanvasDrawer({
					canvasWidth: Number(this.canvasWidth),
					canvasHeight: Number(this.canvasHeight),
					canvasBgColor: this.canvasBgColor,
					canvasBgImg: this.canvasBgImg[0]?.previewUri,
					radius: this.getRadius(),
					contentList: this.contentList,
					onDrawFinish: pixelMap => {
						this.pixelMap = pixelMap
						this.canvasShow = false
						this.imgVisible = true
					}
				})
			}
			IBestDialog({
				visible: $imgVisible,
				defaultBuilder: (): void => this.imgBuilder()
			})
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}

@Component
struct contentItem{
	@ObjectLink item: canvasContent
	@Prop formId: string
	@Prop index: number
	@State groupId: string = "radioGroup" + this.index
	@State @Watch("contentTypeChange") conType: "image" | "text" | "" = ""
	@State @Watch("textChange") itemText: string = ''
	@State @Watch("imageChange") imgList: IBestUploaderFile[] = []
	@State @Watch("topChange") top: number | string = ''
	@State @Watch("leftChange") left: number | string = ''
	@State @Watch("fontSizeChange") textFontSize: number | string = ''
	@State @Watch("fontColorChange") fontColor: string = ''
	@State @Watch("radiusChange") radius: number | string = ''
	@State @Watch("angleChange") angle: number | string = ''
	@State @Watch("widthChange") imgWidth: number | string = ''
	@State @Watch("heightChange") imgHeight: number | string = ''
	delete: (index: number) => void = () => {}
	@Builder contentTypeBuilder(){
		IBestRadioGroup({group: this.groupId, active: $conType, placeDirection: Axis.Horizontal}){
			IBestRadio({
				group: this.groupId,
				name: "text",
				label: "文字",
				iconSize: 14,
				labelFontSize: 14
			})
			IBestRadio({
				group: this.groupId,
				name: "image",
				label: "图片",
				iconSize: 14,
				labelFontSize: 14
			})
		}
	}
	@Builder selectImgBuilder(){
		IBestUploader({
			fileList: $imgList,
			max: 1
		})
	}
	aboutToAppear(): void {
		let item = this.item
		if(item.type){
			this.conType = item.type
		}
		if(item.text){
			this.itemText = item.text as string
		}
		if(item.url){
			this.imgList = [new IBestUploaderFile({previewUri: item.url as string, isImage: true})]
		}
		if(item.top){
			this.top = item.top as number
		}
		if(item.left) {
			this.left = item.left as number
		}
		if(item.fontSize){
			this.textFontSize = item.fontSize as number
		}
		if(item.fontColor){
			this.fontColor = item.fontColor as string
		}
		if(item.borderRadius){
			this.radius = item.borderRadius as number
		}
		if(item.deg){
			this.angle = item.deg as number
		}
		if(item.width){
			this.imgWidth = item.width as number
		}
		if(item.height){
			this.imgHeight = item.height as number
		}
	}
	contentTypeChange(){
		if(this.conType){
			this.item.type = this.conType
		}
	}
	textChange(){
		this.item.text = this.itemText
	}
	imageChange(){
		this.item.url = this.imgList[0].previewUri
	}
	topChange(){
		this.item.top = Number(this.top)
	}
	leftChange(){
		this.item.left = Number(this.left)
	}
	fontSizeChange(){
		this.item.fontSize = Number(this.textFontSize)
	}
	fontColorChange(){
		this.item.fontColor = this.fontColor
	}
	widthChange(){
		this.item.width = Number(this.imgWidth)
	}
	heightChange(){
		this.item.height = Number(this.imgHeight)
	}
	radiusChange(){
		this.item.borderRadius = Number(this.radius)
	}
	angleChange(){
		this.item.deg = Number(this.angle)
	}
	build() {
		IBestCellGroup({title: `内容${this.index+1}`, inset: true}){
			Text("删除")
				.fontColor(modeColor.textColor4)
				.fontSize(FONT_SIZE.SM)
				.position({right: 0, top: 17})
				.onClick(() => {
					this.delete(this.index)
				})
			IBestField({
				formId: this.formId,
				prop: `contentType.${this.index}`,
				label: "内容类型",
				value: $conType,
				customRightContent: (): void => this.contentTypeBuilder()
			})
			if(this.conType === "text"){
				IBestField({
					formId: this.formId,
					prop: `text.${this.index}`,
					label: "文字内容",
					value: $itemText,
					placeholder: "请输入文字内容"
				})
				IBestField({
					formId: this.formId,
					prop: `fontSize.${this.index}`,
					label: "文字大小",
					value: $textFontSize,
					type: "number",
					placeholder: "请输入文字大小"
				})
				IBestField({
					formId: this.formId,
					prop: `fontColor.${this.index}`,
					label: "文字颜色",
					value: $fontColor,
					placeholder: "请输入文字颜色"
				})
			} else if(this.conType === "image"){
				IBestField({
					formId: this.formId,
					prop: `image.${this.index}`,
					label: "图片",
					value: $imgList,
					customRightContent: (): void => this.selectImgBuilder()
				})
				IBestField({
					formId: this.formId,
					prop: `width.${this.index}`,
					label: "宽度",
					value: $imgWidth,
					type: "number",
					placeholder: "请输入图片宽度"
				})
				IBestField({
					formId: this.formId,
					prop: `height.${this.index}`,
					label: "高度",
					value: $imgHeight,
					type: "number",
					placeholder: "请输入图片高度"
				})
				IBestField({
					formId: this.formId,
					prop: `radius.${this.index}`,
					label: "圆角",
					value: $radius,
					type: "number",
					placeholder: "请输入图片圆角"
				})
				IBestField({
					formId: this.formId,
					prop: `angle.${this.index}`,
					label: "旋转角度",
					value: $angle,
					type: "number",
					placeholder: "请输入图片旋转角度"
				})
			}
			IBestField({
				formId: this.formId,
				prop: `top.${this.index}`,
				label: "顶部距离",
				value: $top,
				type: "number",
				placeholder: "请输入顶部距离"
			})
			IBestField({
				formId: this.formId,
				prop: `left.${this.index}`,
				label: "左侧距离",
				value: $left,
				type: "number",
				placeholder: "请输入左侧距离",
				hasBorder: false
			})
		}
	}
}