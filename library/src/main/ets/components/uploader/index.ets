import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { IBestUploaderFile, FileSelectOptions, IBestUploaderSelectType } from './index.type'
import { isImageFile, isImageUrl } from './utils'
import { LengthMetrics, LengthUnit } from '@kit.ArkUI'
import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { picker } from '@kit.CoreFileKit'
import { common } from '@kit.AbilityKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { IBestLoading } from '../loading'
import fs from '@ohos.file.fs'
import { IBestImagePreview } from '../../../../../Index'
import { convertDimensionsByUnit, getLengthUnit, getSizeByUnit } from '../../utils/utils'
@Component
export struct IBestUploader {
	/**
	 * 文件列表
	 */
	@Link fileList: IBestUploaderFile[]
	/**
	 * 选择类型
	 */
	@Prop selectType: IBestUploaderSelectType = "image"
	/**
	 * 自定义触发器图标
	 */
	@Prop uploaderIcon: ResourceStr = $r("app.media.icon_photo")
	/**
	 * 触发器图标大小
	 */
	@Prop uploaderIconSize: number | string = convertDimensionsByUnit(24)
	/**
	 * 触发器图标颜色
	 */
	@Prop uploaderIconColor: ResourceColor = GRAY_COLOR.GRAY_4
	/**
	 * 最大上传数量
	 */
	@Prop max: number = -1
	/**
	 * 文件大小限制，单位为 byte
	 */
	@Prop maxSize: number = -1
	/**
	 * 预览大小
	 */
	@Provide({allowOverride: "previewSize"}) previewSize: number | string = convertDimensionsByUnit(80)
	/**
	 * 是否在点击预览图后展示全屏图片预览
	 */
	@Prop isPreviewFullImage: boolean = true
	/**
	 * 预览图片裁剪方式
	 */
	@Provide({allowOverride: "imageFit"}) imageFit: ImageFit = ImageFit.Cover
	/**
	 * 圆角大小
	 */
	@Provide({allowOverride: "cornerRadius"}) cornerRadius: number = 0
	/**
	 * 是否显示删除按钮
	 */
	@Provide({allowOverride: "showDelete"}) showDelete: boolean = true
	/**
	 * 文件选择配置项
	 */
	@Prop fileSelectOptions: FileSelectOptions
	/**
	 * 禁用
	 */
	@Provide({allowOverride: "disabled"}) disabled: boolean = false
	/**
	 * 自定义上传触发器
	 */
	@BuilderParam customUploader?: CustomBuilder
	/**
	 * 自定义预览样式
	 */
	@BuilderParam customPreview?: (file: IBestUploaderFile) => void
	/**
	 * 文件插入前回调
	 */
	onBeforeInsert: (file: IBestUploaderFile) => boolean = () => true
	/**
	 * 文件全部插入后回调
	 */
	onChange: (insertFile: IBestUploaderFile[], allFile: IBestUploaderFile[]) => void = () => {}
	/**
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
		const docPicker = new picker.DocumentViewPicker(this.context)
		options.maxSelectNumber = this.max > 0 ? this.max : 500
		if(this.fileSelectOptions){
			options.defaultFilePathUri = this.fileSelectOptions.defaultFilePathUri
			options.fileSuffixFilters = this.fileSelectOptions.fileSuffixFilters
		}
		docPicker.select(options).then((result: Array<string>) => {
			this.onFileSelect(result)
		})
	}
	// 选择图片
	selectImg(){
		let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions()
		let photoPicker = new photoAccessHelper.PhotoViewPicker()
		PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
		PhotoSelectOptions.maxSelectNumber = this.max > 0 ? this.max : 500
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
				cacheUri,
				name: fileName,
				size: stat.size,
				isImage: this.selectType == "image" || isImageUrl(e)
			})
			if(this.onBeforeInsert(obj)){
				arr.push(obj)
				this.fileList.push(obj)
			}
		}
		if(arr.length){
			this.onChange(arr, this.fileList)
		}
	}
	// 删除
	remove(index: number){
		this.fileList.splice(index, 1)
	}
	// 预览图片
	preview(file: IBestUploaderFile){
		if(this.isPreviewFullImage){
			let imgLists = this.fileList.filter(e => e.isImage || isImageUrl(e.url as string))
			let index = imgLists.findIndex(e => e.internalUri == file.internalUri)
			IBestImagePreview.show(imgLists.map(e => e.url || e.previewUri || ""), { startIndex: index || 0 })
		}
	}

	build() {
		Flex({ wrap: FlexWrap.Wrap, space: {
			main: new LengthMetrics(parseFloat(convertDimensionsByUnit(8)), getLengthUnit()),
			cross: new LengthMetrics(parseFloat(convertDimensionsByUnit(8)), getLengthUnit())
		}}){
			if(this.fileList.length){
				ForEach(this.fileList, (item: IBestUploaderFile, index: number) => {
					UploadItem({
						file: item,
						index,
						customPreview: this.customPreview,
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
						.width(getSizeByUnit(this.uploaderIconSize))
						.aspectRatio(1)
						.fillColor(this.uploaderIconColor)
						.draggable(false)
				}
				.width(getSizeByUnit(this.previewSize))
				.aspectRatio(1)
				.justifyContent(FlexAlign.Center)
				.borderRadius(getSizeByUnit(this.cornerRadius))
				.clip(true)
				.enabled(!this.disabled)
				.opacity(this.disabled ? 0.5 : 1)
				.stateStyles({
					normal: {
						.backgroundColor(GRAY_COLOR.GRAY_1)
					},
					pressed: {
						.backgroundColor(GRAY_COLOR.GRAY_2)
					}
				})
				.visibility(this.max > 0 && this.fileList.length >= this.max ? Visibility.None : Visibility.Visible)
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
	@State isError: boolean = false

	@ObjectLink file: IBestUploaderFile
	@Prop index: number
	@Consume previewSize: number
	@Consume imageFit: ImageFit
	@Consume cornerRadius: number
	@Consume showDelete: boolean
	@Consume disabled: boolean
	@BuilderParam customPreview?: (file: IBestUploaderFile) => void

	// 移除文件
	remove: (index: number) => void = () => {}
	// 预览
	preview: (file: IBestUploaderFile) => void = () => {}

	build() {
		Column() {
			if (this.customPreview) {
				this.customPreview(this.file)
			} else {
				if (isImageFile(this.file)) {
					Image(this.isError ? $r("app.media.icon_photo_fail") : (this.file.url || this.file.previewUri))
						.width(this.isError ? convertDimensionsByUnit(32) : CONTAINER_SIZE.FULL)
						.aspectRatio(1)
						.objectFit(this.imageFit)
						.draggable(false)
						.onError(() => {
							this.isError = true
						})
						.onClick(() => {
							this.preview(this.file)
						})
				} else {
					Image($r("app.media.icon_file"))
						.width(convertDimensionsByUnit(20))
						.aspectRatio(1)
						.draggable(false)
						.fillColor(GRAY_COLOR.GRAY_7)
					if (this.file.name) {
						Text(this.file.name)
							.fontColor(GRAY_COLOR.GRAY_7)
							.fontSize(this.baseStyle.fontSizeSm)
							.width(CONTAINER_SIZE.FULL)
							.maxLines(1)
							.textAlign(TextAlign.Center)
							.textOverflow({ overflow: TextOverflow.Ellipsis })
							.padding({ left: this.baseStyle.spaceBase, right: this.baseStyle.spaceBase })
							.margin({ top: this.baseStyle.spaceBase })
					}
				}
			}
			// 状态展示
			if (this.file.status && this.file.status != 'done') {
				Column({ space: convertDimensionsByUnit(6) }) {
					if (this.file.status == 'uploading') {
						IBestLoading({
							loadingSize: 18,
							loadingStrokeWidth: 1,
							loadingColor: this.baseStyle.default
						})
					} else {
						Image($r("app.media.icon_close_circle"))
							.width(convertDimensionsByUnit(20))
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
			// 删除按钮
			if (this.showDelete && !this.disabled) {
				Row() {
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
				.borderRadius({ bottomLeft: this.baseStyle.borderRadiusMax })
				.visibility(this.file.status == 'uploading' ? Visibility.None : Visibility.Visible)
				.onClick(() => {
					this.remove(this.index)
				})
			}
		}
		.width(getSizeByUnit(this.previewSize))
		.aspectRatio(1)
		.justifyContent(FlexAlign.Center)
		.alignItems(HorizontalAlign.Center)
		.backgroundColor(GRAY_COLOR.GRAY_1)
		.borderRadius(getSizeByUnit(this.cornerRadius))
		.clip(true)
	}
}