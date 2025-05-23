import ComponentShowContainer from '../../components/ComponentShowContainer';
import { IBestCell, IBestCellGroup, IBestImagePreview, IBestToast } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function ImagePreviewBuilder(_: string, title: string){
	ImagePreviewPage({title})
}

@Entry
@Component
struct ImagePreviewPage {
	@State title: string = ''

	@State imageList: string[] = [
		"https://inews.gtimg.com/om_bt/Os3eJ8u3SgB3Kd-zrRRhgfR5hUvdwcVPKUTNO6O7sZfUwAA/641",
	  	"https://res1.vmallres.com/pimages/uomcdn/CN/pms/202409/gbom/6942103136221/800_800_333848611DC0B1FC64909F87CD048F2Cmp.png",
		"https://view.horsevision.cn/huataivr/static/images/longImage/%E9%AB%98%E9%A2%9D%E5%9B%9E%E6%8A%A5%E9%9C%80%E8%AD%A6%E6%83%95%EF%BC%8C%E5%88%87%E5%8B%BF%E8%90%BD%E5%85%A5%E2%80%9C%E5%BA%9E%E6%B0%8F%E9%AA%97%E5%B1%80%E2%80%9D.jpg",
		"https://img2.baidu.com/it/u=3121938960,3659852204&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500",
		"https://img2.baidu.com/it/u=1602275124,393968357&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500"
	]

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '预览图片',
								isLink: true,
								hasBorder: false,
								onCellClick: () => {
									IBestImagePreview.show(this.imageList)
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '传入配置项', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '自定义遮罩颜色',
								isLink: true,
								onCellClick: () => {
									IBestImagePreview.show(this.imageList, {
										maskColor: '#fff',
										indexFontColor: "#000"
									})
								}
							})
							IBestCell({
								title: '指定初始索引',
								isLink: true,
								onCellClick: () => {
									IBestImagePreview.show(this.imageList, {
										startIndex: 1
									})
								}
							})
							IBestCell({
								title: '指定页码位置',
								isLink: true,
								onCellClick: () => {
									IBestImagePreview.show(this.imageList, {
										indexPosition: 'top'
									})
								}
							})
							IBestCell({
								title: '禁止循环',
								isLink: true,
								onCellClick: () => {
									IBestImagePreview.show(this.imageList, {
										loop: false
									})
								}
							})
							IBestCell({
								title: '监听事件',
								isLink: true,
								hasBorder: false,
								onCellClick: () => {
									IBestImagePreview.show(this.imageList, {
										closeOnClickImage: false,
										onImgClick: (index) => {
											IBestToast.show('点击了第' + index + '张图片')
										},
										onImgLongPress: (index) => {
											IBestToast.show('长按了第' + index + '张图片')
										}
									})
								}
							})
						}
					}
				}
			}
			.layoutWeight(1)
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}