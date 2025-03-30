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
            Text(String(this.currentPage1))
                .fontSize(32)
                .margin({ top: 20, bottom: 20 })
            ComponentShowContainer({ title: '基础用法' }) {
                IBestPagination({
                    modelValue: $currentPage1,
                    totalItems: 24,
                    itemsPerPage: 5,
                    prevText: '上一页',
                    nextText: '下一页'
                })
            }

            Text(String(this.currentPage2))
            ComponentShowContainer({ title: '简单模式' }) {
                IBestPagination({
                    modelValue: $currentPage2,
                    pageCount: 12,
                    prevText: '上一页',
                    nextText: '下一页',
                    mode: 'simple'
                })
            }
            Text(String(this.currentPage3))
            ComponentShowContainer({ title: '显示省略号' }) {
                IBestPagination({
                    modelValue: $currentPage3,
                    totalItems: 125,
                    showPageSize: 3,
                    forceEllipses: true,
                    prevText: '上一页',
                    nextText: '下一页'
                })
            }
            Text(String(this.currentPage4))
            ComponentShowContainer({ title: '自定义按钮' }) {
                IBestPagination({
                    modelValue: $currentPage4,
                    totalItems: 125,
                    showPageSize: 5
                })
            }
        }
        .width(CONTAINER_SIZE.FULL)
        .height(CONTAINER_SIZE.FULL)
        .backgroundColor(modeColor.bg2)
    }
}
