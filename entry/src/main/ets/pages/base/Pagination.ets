import { IBestPagination } from '@ibestservices/ibest-ui';
import { modeColor } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function PaginationBuilder(_: string, title: string){
	PaginationPage({title})
}

@Entry
@Component
struct PaginationPage {
    @State title: string = ''

    @State currentPage1: number = 1
    @State currentPage2: number = 1
    @State currentPage3: number = 1
    @State currentPage4: number = 1

    build() {
        NavDestination() {
			CustomNavBar({title: this.title})
            ComponentShowContainer({ title: '基础用法' }) {
                IBestPagination({
                    modelValue: $currentPage1,
                    totalItems: 24,
                    itemsPerPage: 5,
                    onChange: (value: number) => {
                      console.log('基础用法 - 当前页码:', value)
                    }
                })
            }

            ComponentShowContainer({ title: '简单模式' }) {
                IBestPagination({
                    modelValue: $currentPage2,
                    pageCount: 12,
                    mode: 'simple'
                })
            }
            ComponentShowContainer({ title: '显示省略号' }) {
                IBestPagination({
                    modelValue: $currentPage3,
                    totalItems: 125,
                    showPageSize: 3,
                    forceEllipses: true
                })
            }
            ComponentShowContainer({ title: '自定义按钮' }) {
                IBestPagination({
                    modelValue: $currentPage4,
                    totalItems: 125,
                    showPageSize: 5,
                    prevText: 'prev',
                    nextText: 'next'
                })
            }
        }
        .hideTitleBar(true)
        .padding({ left: 20, right: 20 })
        .backgroundColor(modeColor.bg2)
    }
}
