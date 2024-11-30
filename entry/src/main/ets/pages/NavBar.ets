import router from '@ohos.router';
import { IBestNavBar, IBestToast } from '@ibestservices/ibest-ui'
import { BACKGROUND_COLOR, COLOR_BLUE, COLOR_RED, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer'
import { ComponentRouterParams } from '../assets/global.type';
@Entry
@Component
struct NavBarPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State searchVal: string = ''

	@Builder leftBuilder(){
		Row({space: SPACE.BASE}){
			Image($r("app.media.icon_star_o"))
				.width(16)
			Text("自定义左侧")
		}
	}
	@Builder rightBuilder(){
		Row({space: SPACE.BASE}){
			Image($r("app.media.icon_like"))
				.width(16)
			Text("自定义右侧")
		}
	}
	@Builder titleBuilder(){
		TextInput({text: this.searchVal, placeholder: "请输入搜索内容"}).width("70%").height("70%")
	}

	build() {
		Column() {
			IBestNavBar({
				title: this.title,
				onLeftClick: () => {
					router.back()
				}
			})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }){
						IBestNavBar({
							title: "标题"
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式', titlePaddingLeft: SPACE.MD }){
						Column({space: SPACE.XS}){
							IBestNavBar({
								title: "标题",
								titleColor: COLOR_BLUE.DEFAULT,
								titleFontSize: 14,
								isTitleBold: true,
								bgColor: COLOR_BLUE.MINI,
								leftIconColor: COLOR_BLUE.DEFAULT
							})
							IBestNavBar({
								title: "标题",
								titleColor: COLOR_BLUE.DEFAULT,
								bgLinearGradient: {
									angle: 90,
									colors: [[0xff0000, 0.0], [0x0000ff, 0.3], [0xffff00, 1.0]]
								}
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义显示区域', titlePaddingLeft: SPACE.MD }){
						Column({space: SPACE.XS}){
							IBestNavBar({
								leftIcon: $r("app.media.app_icon"),
								leftLabel: "IBest-UI",
								leftIconRadius: "50%"
							})
							IBestNavBar({
								title: "标题",
								leftIcon: $r("app.media.icon_star_o"),
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义标题内容', titlePaddingLeft: SPACE.MD }){
						Column({space: SPACE.MD}){
							IBestNavBar({
								titleBuilder: (): void => this.titleBuilder()
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义左右内容', titlePaddingLeft: SPACE.MD }){
						Column({space: SPACE.XS}){
							IBestNavBar({
								title: "标题",
								leftLabel: "返回",
								isShowRight: true,
								rightIconName: "wap-nav",
								rightLabel: "更多"
							})
							IBestNavBar({
								title: "标题",
								leftBuilder: (): void => this.leftBuilder(),
								isShowRight: true,
								rightBuilder: (): void => this.rightBuilder(),
								// onLeftClick: () => {
								// 	IBestToast.show("点击左侧")
								// },
								// onRightClick: (): void => {
								// 	IBestToast.show("点击右侧")
								// }
							})
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '二级标题', titlePaddingLeft: SPACE.MD }){
						IBestNavBar({
							title: "标题",
							subTitle: "二级标题"
						})
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