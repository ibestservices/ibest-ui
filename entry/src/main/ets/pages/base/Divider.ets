import { IBestDivider } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';
@Builder
export function DividerBuilder(_: string, title: string){
	DividerPage({title})
}

@Entry
@Component
struct DividerPage {
	@State title: string = ''

	@Builder textBuilder(){
		Row({space: 10}){
			Image($r("app.media.ibest_icon_star")).width(16)
			Text("自定义内容")
		}
	}

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }) {
						Column(){
							IBestDivider()
						}.padding({top: SPACE.MD})
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
						}.padding({top: SPACE.MD})
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
						}.padding({top: SPACE.MD})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '虚线', titlePaddingLeft: SPACE.MD }) {
						Column(){
							IBestDivider({
								text: '文本',
								dashed: true
							})
						}.padding({top: SPACE.MD})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式', titlePaddingLeft: SPACE.MD }) {
						Column(){
							IBestDivider({
								text: '文本',
								color: "#3d8af2",
								lineColor: "#3d8af2",
								leftRightPadding: 20
							})
						}.padding({top: SPACE.MD})
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
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg2)
	}
}