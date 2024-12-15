import router from '@ohos.router';
import { IBestBadge } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';
@Entry
@Component
struct BadgePage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@Builder badgeContent() {
		Row()
			.width(40)
			.height(40)
			.borderRadius(5)
			.backgroundColor("#f2f3f5")
	}
	build() {
		Column() {
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }){
						Row({space: 20}) {
							IBestBadge({
								content: 0
							}){
								this.badgeContent()
							}
							IBestBadge({
								content: 10
							}){
								this.badgeContent()
							}
							IBestBadge({
								content: "Hot"
							}){
								this.badgeContent()
							}
							IBestBadge({
								content: 66
							}){
								Text("查看信息")
							}
							IBestBadge({
								dot: true
							}){
								Text("查看信息")
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '最大值' }){
						Row({space: 20}) {
							IBestBadge({
								content: 20,
								max: 9
							}){
								this.badgeContent()
							}
							IBestBadge({
								content: 50,
								max: 20
							}){
								this.badgeContent()
							}
							IBestBadge({
								content: 200,
								max: 99
							}){
								this.badgeContent()
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义颜色' }){
						Row({space: 20}) {
							IBestBadge({
								content: 5,
								color: '#1989fa'
							}){
								this.badgeContent()
							}
							IBestBadge({
								content: 10,
								color: '#1989fa'
							}){
								this.badgeContent()
							}
							IBestBadge({
								dot: true,
								color: '#1989fa'
							}){
								this.badgeContent()
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义徽标位置' }){
						Row({space: 20}) {
							IBestBadge({
								content: 10,
								badgePosition: "top-left"
							}){
								this.badgeContent()
							}
							IBestBadge({
								content: 10,
								badgePosition: "bottom-left"
							}){
								this.badgeContent()
							}
							IBestBadge({
								content: 10,
								badgePosition: "bottom-right"
							}){
								this.badgeContent()
							}
						}
					}
				}
			}
			.layoutWeight(1)
			.clip(false)
			.padding({
				left: SPACE.SM,
				right: SPACE.SM
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg2)
	}
}