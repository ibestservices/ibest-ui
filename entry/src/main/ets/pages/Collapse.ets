import router from '@ohos.router';
import { IBestCollapse, IBestCollapseItem } from '@ibestservices/ibest-ui';
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar';
import ComponentShowContainer from '../components/ComponentShowContainer';
import { ComponentRouterParams } from '../assets/global.type';

@Entry
@Component
struct CollapsePage {
    @State title: string = (router.getParams() as ComponentRouterParams).title || ''
    @State activeName: string = '1'

    build() {
        Column() {
            TitleBar({
                title: this.title
            }).backgroundColor('#FFF')
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }) {
                        IBestCollapse({
                            activeName: $activeName
                        }){
                            IBestCollapseItem({
                                name: '1',
                                title: '标题1'
                            }){
                                Text('内容1')
                            }
                            IBestCollapseItem({
                                name: '2',
                                title: '标题2'
                            }){
                                Text('内容2')
                            }
                            IBestCollapseItem({
                                name: '3',
                                title: '标题3'
                            }){
                                Text('内容3')
                            }
                        }
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