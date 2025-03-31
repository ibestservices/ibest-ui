import router from '@ohos.router';
import { IBestNavBar, IBestSideBar, IBestSideBarItem, IBestToast, IBestPagination } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { ComponentRouterParams } from '../../assets/global.type';

@Entry
@Component
struct PaginationPage {
    @State title: string = (router.getParams() as ComponentRouterParams).title || ''

    @State currentPage1: number = 1
    @State currentPage2: number = 1
    @State currentPage3: number = 1
    @State currentPage4: number = 1

    build() {
        Column() {
            IBestNavBar({
                title: this.title,
                isShowStatusBar: true,
                onLeftClick: () => {
                    router.back()
                }
            })
            ComponentShowContainer({ title: '基础用法' }) {
                IBestPagination({
                    modelValue: $currentPage1,
                    totalItems: 24,
                    itemsPerPage: 5,
                    onChange: (value: number) => {
                      // IBestToast.show(`基础用法 - 当前页码:${value}`)
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
        .width(CONTAINER_SIZE.FULL)
        .height(CONTAINER_SIZE.FULL)
        .padding({ left: 20, right: 20 })
        .backgroundColor(modeColor.bg2)
    }
}
