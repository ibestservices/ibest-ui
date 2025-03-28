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
							value: this.value
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '进度内显示百分比' }){
						IBestProgress({
							value: this.value,
							lineWidth: 18,
							textInside: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式' }){
						Column({space: SPACE.MD}){
							IBestProgress({
								value: this.value,
								color: "#ee0a24"
							})
							IBestProgress({
								value: this.value,
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
							value: this.value,
							inactive: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '不确定进度' }){
						Column({space: SPACE.MD}){
							IBestProgress({
								value: 50,
								indeterminate: true
							})
							IBestProgress({
								value: 100,
								indeterminate: true,
								format: (value: number): string => this.format(value)
							})
							IBestProgress({
								value: 100,
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
								if(this.value > 100){
									this.value = 100
								}
							}
						})
						IBestButton({
							type: 'danger',
							text: "减少",
							onBtnClick: () => {
								this.value -= 10
								if(this.value < 0){
									this.value = 0
								}
							}
						})
					}
					.width(CONTAINER_SIZE.FULL)
					.padding(SPACE.MD)
					.justifyContent(FlexAlign.Center)
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