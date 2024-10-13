import router from '@ohos.router';
import { IBestUploader, IBestUploaderFile } from '@ibestservices/ibest-ui'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { ComponentRouterParams } from '../assets/global.type';

@Entry
@Component
struct UploaderPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''

	@State imgList: IBestUploaderFile[] = []
	@State imgList1: IBestUploaderFile[] = []
	@State imgList2: IBestUploaderFile[] = [
		new IBestUploaderFile({
			url: "https://img0.baidu.com/it/u=3237306772,3637376846&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=1199",
			isImage: true,
			status: "uploading"
		}),
		new IBestUploaderFile({
			url: "https://img1.baidu.com/it/u=733418214,3903491350&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=313",
			isImage: true,
			status: "failed"
		})
	]
	@State imgList3: IBestUploaderFile[] = [
		new IBestUploaderFile({
			url: "https://img1.baidu.com/it/u=733418214,3903491350&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=313",
			isImage: true
		})
	]
	@State imgList4: IBestUploaderFile[] = []
	@State imgList5: IBestUploaderFile[] = []
	@State imgList6: IBestUploaderFile[] = []
	@State imgList7: IBestUploaderFile[] = [
		new IBestUploaderFile({
			url: "https://img1.baidu.com/it/u=733418214,3903491350&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=313",
			isImage: true
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

	build() {
		Column() {
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
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
					ComponentShowContainer({ title: '自定义预览大小' }) {
						IBestUploader({
							fileList: $imgList7,
							previewSize: 100
						})
					}
				}
			}
			.layoutWeight(1)
			.padding({
				left: SPACE.BASE,
				right: SPACE.BASE
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(BACKGROUND_COLOR.DEFAULT)
	}
}