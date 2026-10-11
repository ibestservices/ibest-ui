import { IBestButton, IBestCell, IBestDialogUtil, IBestSwipeCell, IBestToast } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import BasePage from '../../components/BasePage';
import ComponentShowContainer from '../../components/ComponentShowContainer';

@Builder
export function SwipeCellBuilder(_: string, title: string){
	SwipeCellPage({title})
}

@Entry
@Component
struct SwipeCellPage {
	@State title: string = ''
	@Builder cellContent(bd: boolean = true){
		IBestCell({
			title: '单元格',
			value: '内容',
			hasBorder: bd
		})
	}
	@Builder leftContent(){
		IBestButton({
			type: 'primary',
			text: '选择',
			square: true,
			onBtnClick: () => {
				IBestToast.show("选择")
			}
		})
	}
	@Builder rightContent(){
		IBestButton({
			type: 'primary',
			text: '编辑',
			square: true,
			onBtnClick: () => {
				IBestToast.show("编辑")
			}
		})
		IBestButton({
			type: 'danger',
			text: '删除',
			square: true,
			onBtnClick: () => {
				IBestToast.show("删除")
			}
		})
	}

	build() {
		Column(){
			BasePage({ title: this.title, bgColor: modeColor.bg }) {
				List() {
					ListItem().height(84)
					ListItem() {
						ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.XS }) {
							IBestSwipeCell({
								defaultContent: (): void => this.cellContent(),
								leftContent: (): void => this.leftContent(),
								rightContent: (): void => this.rightContent()
							})
							IBestSwipeCell({
								defaultContent: (): void => this.cellContent(),
								leftContent: (): void => this.leftContent(),
								rightContent: (): void => this.rightContent()
							})
							IBestSwipeCell({
								defaultContent: (): void => this.cellContent(),
								leftContent: (): void => this.leftContent(),
								rightContent: (): void => this.rightContent()
							})
							IBestSwipeCell({
								defaultContent: (): void => this.cellContent(),
								leftContent: (): void => this.leftContent(),
								rightContent: (): void => this.rightContent()
							})
							IBestSwipeCell({
								defaultContent: (): void => this.cellContent(false),
								leftContent: (): void => this.leftContent(),
								rightContent: (): void => this.rightContent()
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '异步关闭', titlePaddingLeft: SPACE.XS }) {
							IBestSwipeCell({
								defaultContent: (): void => this.cellContent(),
								rightContent: (): void => this.rightContent(),
								beforeClose: (position) => {
									if (position == 'center') {
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
			}
		}
	}
}