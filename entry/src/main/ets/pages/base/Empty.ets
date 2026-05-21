import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { IBestButton, IBestEmpty } from '@ibestservices/ibest-ui';
import BasePage from '../../components/BasePage';

@Builder
export function EmptyBuilder(_: string, title: string){
	EmptyPage({title})
}
@Entry
@Component
struct EmptyPage {
	@State title: string = ''
	@Builder Arrow() {
		Image($r('app.media.title_back')).height(160).rotate({ angle: 180 })
	}
	@Builder Btn() {
		IBestButton({ text: '按钮', type: 'primary' }).margin({ top: SPACE.SM })
	}
	build() {
		Column(){
			BasePage({ title: this.title, bgColor: modeColor.bg }) {
				List() {
					ListItem().height(84)
					ListItem() {
						ComponentShowContainer({ title: '基础用法' }) {
							IBestEmpty({
								description: '描述文字'
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '图片类型' }) {
							IBestEmpty({
								emptyImage: 'error',
								description: '通用错误'
							})
							IBestEmpty({
								emptyImage: 'network',
								description: '网络错误'
							})
							IBestEmpty({
								emptyImage: 'search',
								description: '搜索提示'
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '自定义大小' }) {
							IBestEmpty({
								imageSize: 100,
								description: '描述文字'
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '自定义图片' }) {
							IBestEmpty({
								description: '描述文字',
								emptyImgBuilder: (): void => this.Arrow()
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '底部内容' }) {
							IBestEmpty({
								description: '描述文字',
								defaultBuilder: (): void => this.Btn()
							})
						}
					}

					ListItem().height(50)
				}
				.padding({ left: SPACE.SM, right: SPACE.SM })
			}
		}
	}
}