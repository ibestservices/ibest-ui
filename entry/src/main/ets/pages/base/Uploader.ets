import { IBestToast, IBestUploader, IBestUploaderFile } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function UploaderBuilder(_: string, title: string){
	UploaderPage({title})
}

@Entry
@Component
struct UploaderPage {
	@State title: string = ''

	@State imgList: IBestUploaderFile[] = []
	@State imgList1: IBestUploaderFile[] = []
	@State imgList2: IBestUploaderFile[] = [
		new IBestUploaderFile({
			url: "https://img0.baidu.com/it/u=2229144304,3578627907&fm=253&fmt=auto&app=138&f=JPEG?w=467&h=300",
			isImage: true,
			status: "uploading"
		}),
		new IBestUploaderFile({
			url: "https://pic1.zhimg.com/80/v2-03cdb3bff2090e98885fe4951799a1f4_1440w.webp",
			status: "failed"
		})
	]
	@State imgList3: IBestUploaderFile[] = [
		new IBestUploaderFile({
			url: "https://pic1.zhimg.com/80/v2-03cdb3bff2090e98885fe4951799a1f4_1440w.webp"
		})
	]
	@State imgList4: IBestUploaderFile[] = []
	@State imgList5: IBestUploaderFile[] = []
	@State imgList6: IBestUploaderFile[] = []
	@State imgList7: IBestUploaderFile[] = [
		new IBestUploaderFile({
			url: "https://pic1.zhimg.com/80/v2-03cdb3bff2090e98885fe4951799a1f4_1440w.webp"
		})
	]
	@State imgList8: IBestUploaderFile[] = []
	@State imgList9: IBestUploaderFile[] = [
		new IBestUploaderFile({
			url: "https://pic1.zhimg.com/80/v2-03cdb3bff2090e98885fe4951799a1f4_1440w.webp"
		})
	]

	@Builder customUploader(){
		Text("选择图片")
			.width(100)
			.height(50)
			.textAlign(TextAlign.Center)
			.backgroundColor("#3D8AF2")
			.fontColor(Color.White)
			.fontSize(14)
	}

	@Builder previewItem(file: IBestUploaderFile){
		Column() {
			Image(file.url || file.previewUri)
				.width("100%")
			Text(file.name)
				.width("100%")
				.fontColor("#fff")
				.fontSize(14)
				.textAlign(TextAlign.Center)
				.maxLines(1)
				.textOverflow({ overflow: TextOverflow.Ellipsis })
				.position({ left: 0, bottom: 0 })
		}
		.width("100%")
		.height("100%")
		.justifyContent(FlexAlign.Center)
	}

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						IBestUploader({
							fileList: $imgList
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '选择文件' }) {
						IBestUploader({
							fileList: $imgList1,
							selectType: "file"
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '上传状态' }) {
						IBestUploader({
							fileList: $imgList2,
							selectType: "file"
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '限制上传数量' }) {
						IBestUploader({
							fileList: $imgList3,
							max: 1
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '限制上传大小' }) {
						IBestUploader({
							fileList: $imgList4,
							maxSize: 1024 * 2
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义上传触发器' }) {
						Column({ space: 20 }){
							IBestUploader({
								fileList: $imgList5,
								uploaderIcon: $r("app.media.icon_plus")
							})
							IBestUploader({
								fileList: $imgList6,
								customUploader: (): void => this.customUploader()
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义预览样式' }) {
						IBestUploader({
							fileList: $imgList7,
							previewSize: 120,
							cornerRadius: 8
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义预览内容' }) {
						IBestUploader({
							fileList: $imgList7,
							customPreview: (file: IBestUploaderFile): void => this.previewItem(file)
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '插入前处理' }) {
						IBestUploader({
							fileList: $imgList8,
							onBeforeInsert: (file: IBestUploaderFile): boolean => {
								if(file.size as number > 10 * 1024){
									IBestToast.show("请上传10k以下的图片")
									return false
								}
								return true
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用' }) {
						IBestUploader({
							fileList: $imgList9,
							disabled: true
						})
					}
				}
				ListItem().height(50)
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg2)
	}
}