import router from '@ohos.router';
import { IBestCell, IBestButton } from '@ibestservices/ibest-ui';
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import ComponentShowContainer from '../components/ComponentShowContainer'
import { ComponentRouterParams } from '../assets/global.type';


@Entry
@Component
struct SwipeCellPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@Builder cellContent(){
		IBestCell({
			title: '单元格',
			value: '内容',
			hasBorder: false
		})
	}
	@Builder leftContent(){
		IBestButton({
			type: 'primary',
			text: '选择',
			square: true
		})
	}
	@Builder rightContent(){
		IBestButton({
			type: 'primary',
			text: '编辑',
			square: true
		})
		IBestButton({
			type: 'danger',
			text: '删除',
			square: true
		})
	}

	build() {
		Column() {
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SMALL }) {
						// IBestSwipeCell({
						// 	defaultContent: this.cellContent,
						// 	leftContent: this.leftContent,
						// 	rightContent: this.rightContent,
						// 	onContentClick: () => {
						//
						// 	}
						// })
					}
				}
			}
			.layoutWeight(1)
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(BACKGROUND_COLOR.BASE)
	}
}