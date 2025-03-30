import router from '@ohos.router';
import { IBestButton, IBestNavBar, IBestProgress } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { ComponentRouterParams } from '../../assets/global.type';
@Entry
@Component
struct ProgressPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State value: number = 50
	@State value1: number = 120
	@State value2: number = 50
	@State value3: number = 100

	format(value: number){
		return value < 100 ? `${value}%` : 'Full'
	}

	build() {
		Column() {
			IBestNavBar({
				title: this.title,
				isShowStatusBar: true,
				onLeftClick: () => {
					router.back()
				}
			})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }){
						IBestProgress({
							value: $value
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '最大值' }){
						IBestProgress({
							value: $value,
							target: 100
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '进度内显示百分比' }){
						IBestProgress({
							value: $value,
							lineWidth: 18,
							textInside: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式' }){
						Column({space: SPACE.MD}){
							IBestProgress({
								value: $value,
								color: "#ee0a24"
							})
							IBestProgress({
								value: $value,
								linearGradientColor:{
									angle: 90,
									colors: [['#be99ff', 0], ['#7232dd', 1]]
								},
								format: (value: number): string => this.format(value)
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '置灰' }){
						IBestProgress({
							value: $value,
							inactive: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '不确定进度' }){
						Column({space: SPACE.MD}){
							IBestProgress({
								value: $value2,
								indeterminate: true
							})
							IBestProgress({
								value: $value3,
								indeterminate: true,
								format: (value: number): string => this.format(value)
							})
							IBestProgress({
								value: $value3,
								indeterminate: true,
								duration: 1,
								color: "#DB3131"
							})
						}
					}
				}
				ListItem() {
					Row({space: SPACE.SM}){
						IBestButton({
							type: 'primary',
							text: "增加",
							onBtnClick: () => {
								this.value += 10
							}
						})
						IBestButton({
							type: 'danger',
							text: "减少",
							onBtnClick: () => {
								this.value -= 10
							}
						})
					}
					.width(CONTAINER_SIZE.FULL)
					.padding(SPACE.MD)
					.justifyContent(FlexAlign.Center)
				}
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}