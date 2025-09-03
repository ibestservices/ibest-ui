import { FileSelectOptions, IBestUploaderFile, IBestUploaderSelectType } from './index.type'
import { isImageFile, isImageUrl } from './utils'
import { LengthMetrics } from '@kit.ArkUI'
import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { CONTAINER_SIZE } from '../../theme-chalk/src/container'
import { picker } from '@kit.CoreFileKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { IBestLoading } from '../loading'
import fs from '@ohos.file.fs'
import { IBestIcon, IBestImagePreview } from '../../../../../Index'
import { convertDimensions, convertDimensionsWidthUnit, getLengthUnit, getSizeByUnit } from '../../utils/utils'
import { IBestUploaderColor } from './color'
import { IBestAwaitable, IBestStorageKey, IBestStringNumber } from '../../model/Global.type'

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
	 * 图片选择配置
	 * @since 2.1.3
     */
	@Prop imageSelectOption: photoAccessHelper.PhotoSelectOptions = {}
	/**
	 * 文件选择配置
	 * @since 2.1.3
     */
	@Prop fileSelectOption: picker.DocumentSelectOptions = {}
	/**
	 * 触发器背景色
	 * @since 2.0.1
     */
	@Prop uploaderBgColor: ResourceColor = IBestUploaderColor.uploaderBgColor
	/**
	 * 自定义触发器图标
	 */
	@Prop uploaderIcon: ResourceStr = "photograph"
	/**
	 * 触发器图标大小
	 */
	@Prop uploaderIconSize: IBestStringNumber = convertDimensionsWidthUnit(24)
	/**
	 * 触发器图标颜色
	 */
	@Prop uploaderIconColor: ResourceColor = IBestUploaderColor.uploaderIconColor
	/**
	 * 最大上传数量，超过max时不显示触发器
	 */
	@Prop max: number = -1
	/**
	 * 文件大小限制，单位为 byte
	 */
	@Prop maxSize: number = -1
	/**
	 * 预览大小
	 */
	@Provide({allowOverride: "previewSize"}) previewSize: IBestStringNumber = convertDimensionsWidthUnit(80)
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
	@Provide({allowOverride: "cornerRadius"}) cornerRadius: IBestStringNumber = 0
	/**
	 * 是否显示删除按钮
	 */
	@Provide({allowOverride: "showDelete"}) showDelete: boolean = true
	/**
	 * 文件选择配置项
	 * @deprecated since 2.1.3
	 * @useinstead imageSelectOption/fileSelectOption
	 */
	@Prop fileSelectOptions: FileSelectOptions
	/**
	 * 禁用
	 */
	@Provide({allowOverride: "disabled"}) disabled: boolean = false
	/**
	 * 是否展示预览列表
	 * @since 2.0.6
     */
	@Prop showPreviewList: boolean = true
	/**
	 * 自定义上传触发器
	 */
	@BuilderParam customUploader: CustomBuilder
	/**
	 * 自定义预览样式
	 */
	@BuilderParam customPreview: (file: IBestUploaderFile, index: number) => void
	/**
	 * 删除前回调
	 * @since 2.1.3
	 */
	beforeRemove?: (file: IBestUploaderFile, index: number) => IBestAwaitable
	/**
	 * 文件插入前事件
	 */
	onBeforeInsert: (file: IBestUploaderFile) => boolean = () => true
	/**
	 * 文件插入后事件
	 */
	onChange: (insertFile: IBestUploaderFile[], allFile: IBestUploaderFile[]) => void = () => {}
	/**
	 * 超出限制事件
	 */
	onExceed: () => void = () => {}
	/**
	 * 文件删除后事件
	 * @since 2.1.3
     */
	onRemove: (file: IBestUploaderFile, allFile: IBestUploaderFile[]) => void = () => {}
	/**
	 * 文件点击事件, 仅当isPreviewFullImage为false时生效
	 * @since 2.1.3
     */
	onFileClick: (file: IBestUploaderFile, index: number) => void = () => {}

	private context = this.getUIContext().getHostContext() as Context

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
		const docPicker = new picker.DocumentViewPicker(this.context)
		docPicker.select(this.fileSelectOption).then(result => {
			this.onFileSelect(result)
		})
	}
	// 选择图片
	selectImg(){
		let photoPicker = new photoAccessHelper.PhotoViewPicker()
		photoPicker.select(this.imageSelectOption).then((result: photoAccessHelper.PhotoSelectResult) => {
			this.onFileSelect(result.photoUris)
		})
	}
	// 处理选择的文件
	onFileSelect(uris: string[]){
		if(this.max > 0 && this.fileList.length + uris.length > this.max){
			this.onExceed()
			return
		}
		let arr: IBestUploaderFile[] = []
		for (let e of uris) {
			let index = e.lastIndexOf("/")
			let file = fs.openSync(e, fs.OpenMode.READ_ONLY)
			let stat = fs.statSync(file.fd)
			if(this.maxSize > 0 && stat.size > this.maxSize){
				continue
			}
			// 元服务暂不支持
			// let fileName = file.name
			let fullName = e.slice(index + 1)
			let fileName = decodeURI(fullName.split(".")[0])
			let cacheUri = this.context.cacheDir + "/" + fullName
			fs.copyFileSync(file.fd, cacheUri)
			let obj = new IBestUploaderFile({
				previewUri: e,
				internalUri: `internal://cache/${fullName}`,
				cacheUri,
				status: "ready",
				name: fileName,
				size: stat.size,
				isImage: isImageUrl(e)
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
	// 处理删除前回调
	async handleBeforeRemove(file: IBestUploaderFile, index: number){
		let status = true
		if(this.beforeRemove){
			try {
				status = await this.beforeRemove(file, index)
			} catch (e) {
				status = false
			}
		}
		return status
	}
	// 删除
	async remove(file: IBestUploaderFile, index: number){
		let status = await this.handleBeforeRemove(file, index)
		if(status){
			this.fileList.splice(index, 1)
			this.onRemove(file, this.fileList)
		}
	}
	// 预览图片
	preview(file: IBestUploaderFile, index: number){
		if(this.isPreviewFullImage){
			let imgLists = this.fileList.filter(e => e.isImage || isImageUrl(e.url as string))
			let index = imgLists.findIndex(e => e.internalUri == file.internalUri || e.url == file.url)
			IBestImagePreview.show(imgLists.map(e => e.url || e.previewUri || ""), { startIndex: index || 0 })
		}else {
			this.onFileClick(file, index)
		}
	}

	build() {
		Flex({ wrap: FlexWrap.Wrap, space: {
			main: new LengthMetrics(convertDimensions(8), getLengthUnit()),
			cross: new LengthMetrics(convertDimensions(8), getLengthUnit())
		}}){
			if(this.showPreviewList && this.fileList.length){
				ForEach(this.fileList, (item: IBestUploaderFile, index: number) => {
					UploadItem({
						file: item,
						index,
						customPreview: this.customPreview,
						remove: (file: IBestUploaderFile, index: number): Promise<void> => this.remove(file, index),
						preview: (file: IBestUploaderFile, index: number): void => this.preview(file, index)
					})
				})
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
					IBestIcon({
						name: this.uploaderIcon,
						iconSize: this.uploaderIconSize,
						color: this.uploaderIconColor
					})
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
						.backgroundColor(this.uploaderBgColor)
					},
					pressed: {
						.backgroundColor(IBestUploaderColor.activeBg)
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
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	@State isError: boolean = false

	@ObjectLink file: IBestUploaderFile
	@Prop index: number
	@Consume previewSize: number
	@Consume imageFit: ImageFit
	@Consume cornerRadius: number
	@Consume showDelete: boolean
	@Consume disabled: boolean
	@BuilderParam customPreview: (file: IBestUploaderFile, index: number) => void

	// 移除文件
	remove: (file: IBestUploaderFile, index: number) => Promise<void> = () => Promise.resolve()
	// 预览
	preview: (file: IBestUploaderFile, index: number) => void = () => {}

	build() {
		Column() {
			if (this.customPreview) {
				this.customPreview(this.file, this.index)
			} else {
				if (isImageFile(this.file)) {
					if(this.isError){
						IBestIcon({
							name: "photo-fail",
							iconSize: convertDimensionsWidthUnit(32),
							color: IBestUploaderColor.textColor
						})
					}else{
						Image(this.file.url || this.file.previewUri)
							.width(CONTAINER_SIZE.FULL)
							.aspectRatio(1)
							.fillColor(IBestUploaderColor.textColor)
							.objectFit(this.imageFit)
							.draggable(false)
							.onError(() => {
								this.isError = true
							})
							.onClick(() => {
								this.preview(this.file, this.index)
							})
					}
				} else {
					IBestIcon({
						name: "description",
						iconSize: convertDimensionsWidthUnit(20),
						color: IBestUploaderColor.textColor
					})
					if (this.file.name) {
						Text(this.file.name)
							.fontColor(IBestUploaderColor.textColor)
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
			if (this.file.status == 'uploading' || this.file.status == 'failed') {
				Column({ space: convertDimensionsWidthUnit(6) }) {
					if (this.file.status == 'uploading') {
						IBestLoading({
							loadingSize: convertDimensionsWidthUnit(18),
							loadingStrokeWidth: 2,
							loadingColor: IBestUploaderColor.maskTextColor
						})
					} else {
						IBestIcon({
							name: "close",
							iconSize: convertDimensionsWidthUnit(20),
							color: IBestUploaderColor.maskTextColor
						})
					}
					Text(this.file.status == 'failed' ? $r("app.string.ibest_upload_failed") : $r("app.string.ibest_uploading"))
						.fontSize(this.baseStyle.fontSizeSm)
						.fontColor(IBestUploaderColor.maskTextColor)
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
					IBestIcon({
						name: "cross",
						iconSize: convertDimensionsWidthUnit(14),
						color: IBestUploaderColor.maskTextColor
					})
						.scale({ x: 0.7, y: 0.7 })
						.translate({ x: "10%", y: "-10%" })
				}
				.width(convertDimensionsWidthUnit(16))
				.aspectRatio(1)
				.position({ right: 0, top: 0 })
				.backgroundColor("rgba(0,0,0,0.7)")
				.borderRadius({ bottomLeft: this.baseStyle.borderRadiusMax })
				.visibility(this.file.status == 'uploading' ? Visibility.None : Visibility.Visible)
				.onClick(() => {
					this.remove(this.file, this.index)
				})
			}
		}
		.width(getSizeByUnit(this.previewSize))
		.aspectRatio(1)
		.justifyContent(FlexAlign.Center)
		.alignItems(HorizontalAlign.Center)
		.borderRadius(getSizeByUnit(this.cornerRadius))
		.backgroundColor(isImageFile(this.file) ? '' : IBestUploaderColor.fileBgColor)
		.clip(true)
	}
}