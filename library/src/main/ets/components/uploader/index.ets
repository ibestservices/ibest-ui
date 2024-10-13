import { GRAY_COLOR } from '../../theme-chalk/src/color.type'
import { IBestUploaderFile, FileSelectOptions, IBestUploaderSelectType } from './index.type'
import { isImageFile, isImageUrl } from './utils'
import { LengthMetrics, LengthUnit } from '@kit.ArkUI'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container.type'
import { picker } from '@kit.CoreFileKit'
import { common } from '@kit.AbilityKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { IBestLoading } from '../loading'
import fs from '@ohos.file.fs'
import { IBestImagePreview } from '../../../../../Index'

@Component
export struct IBestUploader {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/*
	 * 文件列表
	 */
	@Link fileList: IBestUploaderFile[]
	/*
	 * 选择类型
	 */
	@Prop selectType: IBestUploaderSelectType = "image"
	/*
	 * 自定义触发器图标
	 */
	@Prop uploaderIcon: ResourceStr = $r("app.media.icon_photo")
	/*
	 * 触发器图标大小
	 */
	@Prop uploaderIconSize: number = 48
	/*
	 * 触发器图标大小
	 */
	@Prop uploaderIconColor: ResourceColor = GRAY_COLOR.GRAY_4
	/*
	 * 最大上传数量
	 */
	@Prop max: number = -1
	/*
	 * 文件大小限制，单位为 byte
	 */
	@Prop maxSize: number = -1
	/*
	 * 预览大小
	 */
	@Provide previewSize: number = 160
	/*
	 * 预览图片裁剪方式
	 */
	@Provide imageFit: ImageFit = ImageFit.Cover
	/*
	 * 文件选择配置项
	 */
	@Prop fileSelectOptions: FileSelectOptions
	/*
	 * 自定义上传触发器
	 */
	@BuilderParam customUploader: CustomBuilder
	/*
	 * 选择文件后回调
	 */
	onChange: (file: IBestUploaderFile[]) => void = () => {}
	/*
	 * 超出限制后回调
	 */
	onExceed: () => void = () => {}

	private context = getContext(this) as common.Context

	// 选择器触发
	select(){
		if(this.selectType == "image"){
			this.selectImg()
		}else{
			this.selectFile()
		}
	}
	// 选择文件
	selectFile(){
		let options = new picker.DocumentSelectOptions()
		options.maxSelectNumber = this.max > 0 ? this.max : 500
		options.defaultFilePathUri = this.fileSelectOptions?.defaultFilePathUri
		options.fileSuffixFilters = this.fileSelectOptions?.fileSuffixFilters
		const docPicker = new picker.DocumentViewPicker(this.context)
		docPicker.select(options).then((result: Array<string>) => {
			this.onFileSelect(result)
		})
	}
	// 选择图片
	selectImg(){
		let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions()
		PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
		PhotoSelectOptions.maxSelectNumber = this.max > 0 ? this.max : 500
		let photoPicker = new photoAccessHelper.PhotoViewPicker()
		photoPicker.select(PhotoSelectOptions).then((result: photoAccessHelper.PhotoSelectResult) => {
			this.onFileSelect(result.photoUris)
		})
	}
	// 处理选择的文件
	onFileSelect(uris: string[]){
		if(this.max > 0 && this.fileList.length + uris.length > this.max){
			this.onExceed()
			return
		}
		let arr: Array<IBestUploaderFile> = []
		for (let e of uris) {
			let file = fs.openSync(e, fs.OpenMode.READ_ONLY)
			let stat = fs.statSync(file.fd)
			if(this.maxSize > 0 && stat.size > this.maxSize){
				continue
			}
			let fileName = file.name
			let cacheUri = this.context.cacheDir + "/" + fileName
			fs.copyFileSync(file.fd, cacheUri)
			let obj = new IBestUploaderFile({
				previewUri: e,
				internalUri: `internal://cache/${fileName}`,
				cacheUri: cacheUri,
				name: fileName,
				size: stat.size,
				isImage: this.selectType == "image" || isImageUrl(e)
			})
			arr.push(obj)
			this.fileList.push(obj)
		}
		if(arr.length){
			this.onChange(arr)
		}
	}
	// 删除
	remove(index: number){
		this.fileList.splice(index, 1)
	}
	// 预览图片
	preview(file: IBestUploaderFile){
		let imgLists = this.fileList.filter(e => e.isImage)
		let index = imgLists.findIndex(e => e.internalUri == file.internalUri)
		IBestImagePreview.show(imgLists.map(e => e.url || e.previewUri || ""), { startIndex: index })
	}

	build() {
		Flex({ wrap: FlexWrap.Wrap, space: { main: new LengthMetrics(16, LengthUnit.LPX), cross: new LengthMetrics(16, LengthUnit.LPX) } }){
			if(this.fileList.length){
				ForEach(this.fileList, (item: IBestUploaderFile, index: number) => {
					UploadItem({
						file: item,
						index,
						remove: (index: number): void => this.remove(index),
						preview: (file: IBestUploaderFile): void => this.preview(file)
					})
				}, (item: IBestUploaderFile, index) => index + "")
			}
			if(this.customUploader){
				Row(){
					this.customUploader()
				}
				.visibility(this.max <= 0 || this.fileList.length < this.max ? Visibility.Visible : Visibility.None)
				.onClick(() => {
					this.select()
				})
			}else{
				Row(){
					Image(this.uploaderIcon)
						.width(`${this.uploaderIconSize}lpx`)
						.aspectRatio(1)
						.fillColor(this.uploaderIconColor)
						.draggable(false)
				}
				.width(`${this.previewSize}lpx`)
				.aspectRatio(1)
				.justifyContent(FlexAlign.Center)
				.stateStyles({
					normal: {
						.backgroundColor(GRAY_COLOR.GRAY_1)
					},
					pressed: {
						.backgroundColor(GRAY_COLOR.GRAY_2)
					}
				})
				.visibility(this.max <= 0 || this.fileList.length < this.max ? Visibility.Visible : Visibility.None)
				.onClick(() => {
					this.select()
				})
			}
		}
	}
}

@Component
struct UploadItem{
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@ObjectLink file: IBestUploaderFile
	@Prop index: number
	@Consume previewSize: number
	@Consume imageFit: ImageFit

	// 移除文件
	remove: (index: number) => void = () => {}
	// 预览
	preview: (file: IBestUploaderFile) => void = () => {}

	build() {
		Row(){
			if(isImageFile(this.file)){
				Image(this.file.url || this.file.previewUri)
					.width(CONTAINER_SIZE.FULL)
					.aspectRatio(1)
					.objectFit(this.imageFit)
					.draggable(false)
					.stateStyles({
						normal: {
							.backgroundColor(GRAY_COLOR.GRAY_1)
						},
						pressed: {
							.backgroundColor(GRAY_COLOR.GRAY_2)
						}
					})
					.onClick(() => {
						this.preview(this.file)
					})
			}else{
				Column({ space: this.baseStyle.spaceBase }){
					Image($r("app.media.icon_file"))
						.width("40lpx")
						.aspectRatio(1)
						.draggable(false)
						.fillColor(GRAY_COLOR.GRAY_7)
					Text(this.file.name)
						.fontColor(GRAY_COLOR.GRAY_7)
						.fontSize(this.baseStyle.fontSizeSm)
						.width(CONTAINER_SIZE.FULL)
						.maxLines(1)
						.textAlign(TextAlign.Center)
						.textOverflow({ overflow: TextOverflow.Ellipsis })
						.padding({ left: this.baseStyle.spaceBase, right: this.baseStyle.spaceBase })
				}
				.width(CONTAINER_SIZE.FULL)
				.aspectRatio(1)
				.justifyContent(FlexAlign.Center)
				.alignItems(HorizontalAlign.Center)
			}
			if(this.file.status && this.file.status != 'done'){
				Column({ space: "12lpx" }){
					if(this.file.status == 'uploading'){
						IBestLoading({
							loadingSize: "36lpx",
							loadingStrokeWidth: "2lpx",
							loadingColor: this.baseStyle.default
						})
					}else{
						Image($r("app.media.icon_close_circle"))
							.width("40lpx")
							.aspectRatio(1)
							.fillColor(this.baseStyle.default)
					}
					Text(this.file.status == 'failed' ? "上传失败" : "上传中...")
						.fontSize(this.baseStyle.fontSizeSm)
						.fontColor(this.baseStyle.default)
				}
				.width(CONTAINER_SIZE.FULL)
				.height(CONTAINER_SIZE.FULL)
				.justifyContent(FlexAlign.Center)
				.alignItems(HorizontalAlign.Center)
				.backgroundColor("rgba(50,50,51,0.88)")
				.position({ left: 0, top: 0 })
			}
			Row(){
				Image($r("app.media.icon_cuo"))
					.width(this.baseStyle.fontSizeMd)
					.aspectRatio(1)
					.fillColor(this.baseStyle.default)
					.scale({ x: 0.7, y: 0.7 })
					.translate({ x: "10%", y: "-10%" })
			}
			.width(this.baseStyle.fontSizeMd)
			.aspectRatio(1)
			.position({ right: 0, top: 0 })
			.backgroundColor("rgba(0,0,0,0.7)")
			.borderRadius({ bottomLeft: 9999 })
			.visibility(this.file.status == 'uploading' ? Visibility.None : Visibility.Visible)
			.onClick(() => {
				this.remove(this.index)
			})
		}
		.width(`${this.previewSize}lpx`)
		.aspectRatio(1)
	}
}