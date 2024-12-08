import router from '@ohos.router';
// import { IBestButton, IBestCountDown } from '@ibestservices/ibest-ui'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar';
import { ComponentRouterParams } from '../assets/global.type';
@Entry
@Component
struct CountDownPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State time: number = 30 * 60 * 60 * 1000

	build() {
		Column() {
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				// ListItem() {
				// 	ComponentShowContainer({ title: '基础用法' }) {
				// 		IBestCountDown({
				// 			time: this.time
				// 		}){
				// 			IBestButton({
				// 				type: "primary",
				// 				text: "浅色风格"
				// 			})
				// 		}
				// 	}
				// }
				// ListItem() {
				// 	ComponentShowContainer({ title: '毫秒级渲染' }) {
				// 		IBestCountDown({
				// 			time: this.time,
				// 			millisecond: true,
				// 			format: 'HH:mm:ss:SSS'
				// 		})
				// 	}
				// }
			}
			.layoutWeight(1)
			.padding({
				left: SPACE.SM,
				right: SPACE.SM
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(BACKGROUND_COLOR.BASE)
	}
}