import router from '@ohos.router';
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar';
import { ComponentRouterParams } from '../assets/global.type';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { IBestButton, IBestCountDown, IBestCountDownController } from '@ibestservices/ibest-ui';
@Entry
@Component
struct CountDownPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State time: number = 30 * 60 * 60 * 1000

	@State time1: number = 3 * 1000
	private controller = new IBestCountDownController()

	build() {
		Column() {
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						IBestCountDown({
							time: this.time
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义格式' }) {
						IBestCountDown({
							time: this.time,
							format: "DD 天 HH 时 mm 分 ss 秒"
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '毫秒级渲染' }) {
						IBestCountDown({
							time: this.time,
							format: 'HH:mm:ss:SSS'
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '手动控制' }) {
						Column({space: SPACE.MD}){
							IBestCountDown({
								time: this.time1,
								format: 'ss:SSS',
								autoStart: false,
								controller: this.controller
							})
							Row(){
								IBestButton({
									type: 'primary',
									text: "开始",
									onClickBtn: () => {
										this.controller.start()
									}
								})
								IBestButton({
									type: 'primary',
									text: "暂停",
									onClickBtn: () => {
										this.controller.pause()
									}
								})
								IBestButton({
									type: 'primary',
									text: "重置",
									onClickBtn: () => {
										this.controller.reset()
									}
								})
							}
							.width(CONTAINER_SIZE.FULL)
							.justifyContent(FlexAlign.SpaceBetween)
						}
					}
				}
			}
			.layoutWeight(1)
			.padding({
				left: SPACE.SM,
				right: SPACE.SM
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}