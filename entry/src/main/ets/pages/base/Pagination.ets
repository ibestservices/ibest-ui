import { IBestPagination } from '@ibestservices/ibest-ui';
import { modeColor } from '../../assets/styles/BaseStyle';
import BasePage from '../../components/BasePage';
import ComponentShowContainer from '../../components/ComponentShowContainer';

@Builder
export function PaginationBuilder(_: string, title: string){
	PaginationPage({title})
}

@Entry
@Component
struct PaginationPage {
    @State title: string = ''

    @State currentPage: number = 1
    @State currentPage1: number = 1
    @State currentPage2: number = 1
    @State currentPage3: number = 1
    @State currentPage4: number = 1

    build() {
		Column(){
			BasePage({ title: this.title, bgColor: modeColor.bg }) {
				List() {
					ListItem().height(84)
					ListItem() {
						ComponentShowContainer({ title: '基础用法' }) {
							IBestPagination({
								currentPage: $currentPage,
								totalItems: 24,
								itemsPerPage: 5,
								onChange: (value: number) => {
									console.log('当前页码:', value)
								}
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '简单模式' }) {
							IBestPagination({
								currentPage: $currentPage1,
								pageCount: 12,
								mode: 'simple'
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '自定义样式' }) {
							IBestPagination({
								currentPage: $currentPage2,
								totalItems: 24,
								itemsPerPage: 5,
								textColor: "#ddd",
								bgColor: "#13ce66",
								activeBgColor: "#f56c6c"
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '显示省略号' }) {
							IBestPagination({
								currentPage: $currentPage3,
								totalItems: 125,
								showPageSize: 3,
								forceEllipses: true
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '自定义按钮' }) {
							IBestPagination({
								currentPage: $currentPage4,
								totalItems: 125,
								showPageSize: 5,
								prevText: 'prev',
								nextText: 'next'
							})
						}
					}
				}
				.padding({ left: 20, right: 20 })
			}
        }
    }
}
