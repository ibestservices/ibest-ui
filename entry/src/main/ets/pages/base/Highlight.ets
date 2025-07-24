import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { IBestHighlight, IBestHighlightKeywords } from '@ibestservices/ibest-ui';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function HighlightBuilder(_: string, title: string){
	HighlightPage({title})
}

@Entry
@Component
struct HighlightPage {
	@State title: string = ''
	@State keywords: IBestHighlightKeywords[] = [
		{ text: "难题", color: Color.Red },
		{ text: "答案", fontSize: 20 }
	]
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
					ComponentShowContainer({ title: '设置非高亮样式' }) {
						IBestHighlight({
							keywords: ['难题', '终有一天', '答案'],
							sourceString: '慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。',
							textColor: Color.Red,
							textFontSize: 16
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义高亮样式' }) {
						IBestHighlight({
							keywords: ['难题', '终有一天', '答案'],
							sourceString: '慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。',
							highLightColor: Color.Red,
							highLightFontSize: 30
						})
					}
				}
				ListItem(){
					ComponentShowContainer({ title: '自定义高亮词样式' }) {
						IBestHighlight({
							sourceString: '慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。',
							keywords: this.keywords
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