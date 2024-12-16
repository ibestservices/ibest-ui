import router from '@ohos.router';
import { IBestButton, IBestCell, IBestDialogUtil, IBestNavBar, IBestSwipeCell } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';


@Entry
@Component
struct SwipeCellPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@Builder cellContent(){
		IBestCell({
			title: '单元格',
			value: '内容',
			hasBorder: false
		})
	}
	@Builder leftContent(){
		IBestButton({
			type: 'primary',
			text: '选择',
			square: true
		})
	}
	@Builder rightContent(){
		IBestButton({
			type: 'primary',
			text: '编辑',
			square: true
		})
		IBestButton({
			type: 'danger',
			text: '删除',
			square: true
		})
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
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.XS }) {
						IBestSwipeCell({
							defaultContent: this.cellContent,
							leftContent: this.leftContent,
							rightContent: this.rightContent
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '异步关闭', titlePaddingLeft: SPACE.XS }) {
						IBestSwipeCell({
							defaultContent: this.cellContent,
							rightContent: this.rightContent,
							beforeClose: (position) => {
								if(position == 'center'){
									return true
								}
								return new Promise((resolve) => {
									IBestDialogUtil.open({
										message: '确定删除吗?',
										showCancelButton: true,
										onConfirm: () => {
											resolve(true)
										},
										onCancel: () => {
											resolve(false)
										}
									})
								})
							}
						})
					}
				}
			}
			.layoutWeight(1)
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
	}
}