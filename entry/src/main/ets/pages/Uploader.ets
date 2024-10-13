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

	@State imgList: IBestUploaderFile[] = [
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