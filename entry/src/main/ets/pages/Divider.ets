import router from '@ohos.router';
import { IBestDivider, IBestNavBar } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';

@Entry
@Component
struct DividerPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''

	@Builder textBuilder(){
		Row({space: 10}){
			Image($r("app.media.icon_star")).width(16)
			Text("自定义内容")
		}
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
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }) {
						Column({space: SPACE.MD}){
							IBestDivider()
						}.padding({top: SPACE.MD, bottom: SPACE.MD})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '展示文本', titlePaddingLeft: SPACE.MD }) {
						Column({space: SPACE.MD}){
							IBestDivider({ text: '细线' })
							IBestDivider({text: '非细线', hairline: false, lineWidth: 4})
							IBestDivider({
								textBuilder: this.textBuilder
							})
						}.padding({top: SPACE.MD, bottom: SPACE.MD})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '内容位置', titlePaddingLeft: SPACE.MD }) {
						Column({space: SPACE.MD}){
							IBestDivider({
								text: '文本',
								leftLineWidth: "10%"
							})
							IBestDivider({
								text: '文本',
								rightLineWidth: 50
							})
						}.padding({top: SPACE.MD, bottom: SPACE.MD})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '虚线', titlePaddingLeft: SPACE.MD }) {
						Column({space: SPACE.MD}){
							IBestDivider({
								text: '文本',
								dashed: true
							})
						}.padding({top: SPACE.MD, bottom: SPACE.MD})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式', titlePaddingLeft: SPACE.MD }) {
						Column({space: SPACE.MD}){
							IBestDivider({
								text: '文本',
								color: "#3d8af2",
								lineColor: "#3d8af2",
								leftRightPadding: 20
							})
						}.padding({top: SPACE.MD, bottom: SPACE.MD})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '垂直', titlePaddingLeft: SPACE.MD }) {
						Row(){
							IBestDivider({ text: '文本', vertical: true })
							Text("文本")
							IBestDivider({ text: '文本', vertical: true, dashed: true })
							Text("文本")
							IBestDivider({ text: '文本', vertical: true, hairline: false, lineWidth: 4 })
							Text("文本")
							IBestDivider({ text: '文本', vertical: true, lineColor: "#3d8af2" })
						}.padding(SPACE.MD)
					}
				}
			}
			.layoutWeight(1)
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg2)
	}
}