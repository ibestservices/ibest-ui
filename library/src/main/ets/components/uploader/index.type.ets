/**
 * 选择类型
 */
export type IBestUploaderSelectType = "image" | "file"
/**
 * 上传文件类型
 */
class IBestUploaderFileType{
	// 文件在线地址
	url?: string
	// internal协议地址
	internalUri?: string
	// 预览文件地址
	previewUri?: string
	// 缓存地址
	cacheUri?: string
	// 文件名称
	name?: string
	// 文件大小 单位Byte
	size?: number
	// 是否是图片
	isImage?: boolean
	// 上传状态
	status?: 'uploading' | 'failed' | 'done'
}
@Observed
export class IBestUploaderFile extends IBestUploaderFileType{
	constructor(value: IBestUploaderFileType) {
		super()
		this.url = value.url || ''
		this.internalUri = value.internalUri || ''
		this.previewUri = value.previewUri || ''
		this.cacheUri = value.cacheUri || ''
		this.name = value.name || ''
		this.size = value.size || 0
		this.isImage = value.isImage || false
		this.status = value.status
	}
}
/**
 * 文件选择配置项
 */
export interface FileSelectOptions{
	defaultFilePathUri?: string
	fileSuffixFilters?: string[]
}