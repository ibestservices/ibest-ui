import { IBestCell, IBestCellGroup, IBestNotify } from '@ibestservices/ibest-ui';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function NotifyBuilder(_: string, title: string){
	NotifyPage({title})
}

@Entry
@Component
struct NotifyPage {
	@State title: string = ''
	@Builder customContent(){
		Row({space: 10}){
			Image("https://img0.baidu.com/it/u=2616823501,3205478532&fm=253&fmt=auto&app=138&f=JPEG?w=509&h=500")
				.width(30)
			Text("通知内容")
		}
		.width("100%")
		.backgroundColor("#7337ab")
		.justifyContent(FlexAlign.Center)
	}

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '基础用法',
								isLink: true,
								hasBorder: false,
								onCellClick: () => {
									IBestNotify.show({
										message: '我们嘲笑过少年的无知，也嘲笑过岁月的苍老。我们行走在路上，理想宏大，眼窝却浅显。'
									})
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '通知类型', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '主要通知',
								isLink: true,
								onCellClick: () => {
									IBestNotify.show({
										message: '通知内容',
										type: 'primary'
									})
								}
							})
							IBestCell({
								title: '成功通知',
								isLink: true,
								onCellClick: () => {
									IBestNotify.show({
										message: '通知内容',
										type: 'success'
									})
								}
							})
							IBestCell({
								title: '危险通知',
								isLink: true,
								onCellClick: () => {
									IBestNotify.show({
										message: '通知内容',
										type: 'danger'
									})
								}
							})
							IBestCell({
								title: '警告通知',
								isLink: true,
								hasBorder: false,
								onCellClick: () => {
									IBestNotify.show({
										message: '通知内容',
										type: 'warning'
									})
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义配置', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '自定义颜色',
								isLink: true,
								onCellClick: () => {
									IBestNotify.show({
										message: '通知内容',
										color: '#ad0000',
										backgroundColor: '#ffe1e1'
									})
								}
							})
							IBestCell({
								title: '自定义文字大小',
								isLink: true,
								onCellClick: () => {
									IBestNotify.show({
										message: '如果你爱上了某个星球的一朵花。那么，只要在夜晚仰望星空，就会觉得漫天的繁星就像一朵朵盛开的花。',
										fontSize: 18
									})
								}
							})
							IBestCell({
								title: '自定义时长',
								isLink: true,
								hasBorder: false,
								onCellClick: () => {
									IBestNotify.show({
										message: '通知内容',
										duration: 3000
									})
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义内容', titlePaddingLeft: SPACE.MD }) {
						IBestCellGroup({ inset: true }) {
							IBestCell({
								title: '自定义内容',
								isLink: true,
								hasBorder: false,
								onCellClick: () => {
									IBestNotify.show({
										customContent: (): void => this.customContent()
									})
								}
							})
						}
					}
				}
			}
			.layoutWeight(1)
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}