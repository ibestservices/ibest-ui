import { IBestNavBar } from '@ibestservices/ibest-ui';
import { COLOR_BLUE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';
import { getRandomColor } from '../../utils/utils';

@Builder
export function NavBarBuilder(_: string, title: string){
	NavBarPage({title})
}

@Entry
@Component
struct NavBarPage {
	@State title: string = ''
	@State searchVal: string = ''
	@State navBarBgColor: string = "#3D8AF2"

	@Builder leftBuilder(){
		Row({space: SPACE.BASE}){
			Image($r("app.media.ibest_icon_star_o"))
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
		TextInput({text: this.searchVal, placeholder: "请输入搜索内容"}).width("100%").height("70%")
	}

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }){
						IBestNavBar({
							title: "IBest-UI"
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义样式', titlePaddingLeft: SPACE.MD, space: SPACE.XS }){
						IBestNavBar({
							title: "IBest-UI",
							titleColor: COLOR_BLUE.DEFAULT,
							titleFontSize: 14,
							titleFontWeight: FontWeight.Bold,
							navBarBgColor: COLOR_BLUE.MINI,
							leftIconColor: COLOR_BLUE.DEFAULT
						})
						IBestNavBar({
							title: "IBest-UI",
							titleColor: COLOR_BLUE.DEFAULT,
							leftIconColor: COLOR_BLUE.DEFAULT,
							bgLinearGradient: {
								angle: 90,
								colors: [[0xff0000, 0.0], [0x0000ff, 0.3], [0xffff00, 1.0]]
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '标题居左', titlePaddingLeft: SPACE.MD }){
						IBestNavBar({
							title: "IBest-UI",
							titleTextAlign: "left",
							isShowRight: true,
							rightBuilder: (): void => this.rightBuilder()
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义显示区域', titlePaddingLeft: SPACE.MD, space: SPACE.XS }){
						IBestNavBar({
							leftIcon: "https://img1.baidu.com/it/u=498751481,2849377151&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=800",
							leftLabel: "IBest-UI",
							leftIconRadius: 999
						})
						IBestNavBar({
							isShowLeft: false,
							title: "IBest-UI",
							titleIcon: $r("app.media.app_icon")
						})
						IBestNavBar({
							isShowLeft: false,
							isShowRight: true,
							rightIcon: "https://img1.baidu.com/it/u=498751481,2849377151&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=800",
							rightLabel: "IBest-UI"
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义标题内容', titlePaddingLeft: SPACE.MD }){
						IBestNavBar({
							titleBuilder: (): void => this.titleBuilder()
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义左右内容', titlePaddingLeft: SPACE.MD, space: SPACE.XS }){
						IBestNavBar({
							title: "IBest-UI",
							leftLabel: "返回",
							isShowRight: true,
							rightIconName: "wap-nav",
							rightLabel: "更多"
						})
						IBestNavBar({
							title: "IBest-UI",
							leftBuilder: (): void => this.leftBuilder(),
							isShowRight: true,
							rightBuilder: (): void => this.rightBuilder()
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '二级标题', titlePaddingLeft: SPACE.MD }){
						IBestNavBar({
							title: "IBest-UI",
							subTitle: "一套轻量、可定制化主题的鸿蒙UI组件库"
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '显示状态栏', titlePaddingLeft: SPACE.MD }){
						IBestNavBar({
							title: "点我修改颜色",
							titleColor: COLOR_BLUE.DEFAULT,
							leftIconColor: COLOR_BLUE.DEFAULT,
							navBarBgColor: this.navBarBgColor,
							isShowStatusBar: true,
							onTitleClick: () => {
								this.navBarBgColor = getRandomColor()
							}
						})
					}
				}
				ListItem().height(50)
			}
			.layoutWeight(1)
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}