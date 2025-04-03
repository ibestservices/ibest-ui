import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { IBestHighlight } from '@ibestservices/ibest-ui';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function HighlightBuilder(_: string, title: string){
	HighlightPage({title})
}

@Entry
@Component
struct HighlightPage {
	@State title: string = ''
	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						IBestHighlight({
							keywords: '难题',
							sourceString: '慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。'
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '多字符匹配' }) {
						IBestHighlight({
							keywords: ['轻量', '深色模式', '鸿蒙'],
							sourceString: $r("app.string.app_desc")
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '设置高亮样式' }) {
						IBestHighlight({
							keywords: ['难题', '终有一天', '答案'],
							sourceString: '慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。',
							highLightColor: Color.Red,
							highLightFontSize: 30
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '设置默认样式' }) {
						IBestHighlight({
							keywords: ['难题', '终有一天', '答案'],
							sourceString: '慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。',
							textColor: Color.Red,
							textFontSize: 16
						})
					}
				}
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}