import router from '@ohos.router';
import { IBestIcon, IBestIconClassify, IBestNavBar, IBestTabItemType, IBestTabs } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, FONT_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';
@Entry
@Component
struct IconsPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State curTabName: string = "1"
	@State tabsList: IBestTabItemType[] = [
		{
			label: "用法示例",
			name: "1"
		},
		{
			label: "基础图标",
			name: "2"
		},
		{
			label: "线框风格",
			name: "3"
		},
		{
			label: "实底风格",
			name: "4"
		}
	]
	@Builder
	example() {
		List() {
			ListItem() {
				ComponentShowContainer({ title: '基础用法' }) {
					IBestIcon({ name: 'like' })
				}
			}
			ListItem() {
				ComponentShowContainer({ title: '图标颜色' }) {
					Row({ space: SPACE.SM }) {
						IBestIcon({ name: 'cart-o', color: '#1989fa' })
						IBestIcon({ name: 'fire-o', color: '#ee0a24' })
					}
				}
			}
			ListItem() {
				ComponentShowContainer({ title: '图标大小' }) {
					Row({ space: SPACE.SM }) {
						IBestIcon({ name: 'chat-o', iconSize: 20 })
						IBestIcon({ name: 'chat-o', iconSize: 40 })
					}
				}
			}
		}
		.layoutWeight(1)
		.padding({
			left: SPACE.MD,
			right: SPACE.MD
		})
		.backgroundColor(modeColor.bg2)
		.borderRadius(SPACE.SM)
	}
	copyText(text: string) {
		// const pasteboardData = pasteboard.createData(pasteboard.MIMETYPE_TEXT_PLAIN, text);
		// const systemPasteboard = pasteboard.getSystemPasteboard();
		// systemPasteboard.setData(pasteboardData); // 将数据放入剪切板
		// systemPasteboard.getData().then((data) => {
		//   if (data) {
		//     // promptAction.showToast({ message: '复制成功' });
		//     IBestNotify.show({
		//       message: `已复制到剪切板`,
		//       color: Color.White,
		//       backgroundColor: '#58be6a'
		//     })
		//   } else {
		//     promptAction.showToast({ message: '复制失败' });
		//   }
		// })
	}
	@Builder
	iconShowList(list: string[]) {
		Grid() {
			ForEach(list, (item: string) => {
				GridItem() {
					Column({ space: SPACE.MD }) {
						IBestIcon({ name: item, iconSize: 30 })
						Text(item)
							.fontSize(FONT_SIZE.SM)
							.textAlign(TextAlign.Center)
							.padding({ left: SPACE.BASE, right: SPACE.BASE })
							.fontColor(modeColor.textColor)
					}
					.width(CONTAINER_SIZE.FULL)
					.alignItems(HorizontalAlign.Center)
					.padding({ top: SPACE.MD, bottom: SPACE.MD })
					.stateStyles({
						pressed: {
							.backgroundColor(modeColor.active)
						},
						normal: {
							.backgroundColor(modeColor.bg2)
						}
					})
				}
				.onClick(() => {
					this.copyText(item)
				})
			})
		}
		.columnsTemplate("1fr 1fr 1fr 1fr")
		.cellLength(100)
		.layoutWeight(1)
		.backgroundColor(modeColor.bg2)
		.borderRadius(SPACE.SM)
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
			IBestTabs({
				tabsList: this.tabsList,
				currentName: $curTabName
			})
			Column() {
				if (this.curTabName === '1') {
					this.example()
				} else if (this.curTabName === '2') {
					this.iconShowList(IBestIconClassify.basic)
				} else if (this.curTabName === '3') {
					this.iconShowList(IBestIconClassify.outline)
				} else if (this.curTabName === '4') {
					this.iconShowList(IBestIconClassify.filled)
				}
			}
			.layoutWeight(1)
			.padding({
				left: SPACE.SM,
				right: SPACE.SM,
				bottom: SPACE.SM
			})
			.margin({ top: SPACE.SM })
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}