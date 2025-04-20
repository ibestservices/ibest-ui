import { IBestButton, IBestCountTo, IBestCountToController } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function CountToBuilder(_: string, title: string){
    CountToPage({title})
}

@Entry
@Component
struct CountToPage {
    @State title: string = ''
    @State controller: IBestCountToController = new IBestCountToController()

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }){
                        IBestCountTo({
                            start: 0,
                            end: 666
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定时长' }){
                        IBestCountTo({
                            start: 0,
                            end: 1000,
                            duration: 3000
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '显示小数位' }){
                        IBestCountTo({
                            start: 0,
                            end: 666.66,
                            decimals: 2
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '千分位分隔符' }){
                        IBestCountTo({
                            start: 0,
                            end: 12138,
                            separator: ','
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义样式' }){
                        IBestCountTo({
                            start: 0,
                            end: 6666,
                            duration: 3000,
                            fontSize: 40,
                            color: modeColor.primaryColor,
                            fontWeight: FontWeight.Bold,
                            autoPlay: false,
                            controller: this.controller
                        })
                        Row(){
                            IBestButton({
                                type: 'primary',
                                text: "开始",
                                onBtnClick: () => {
                                    this.controller.start()
                                }
                            })
                            IBestButton({
                                type: 'primary',
                                text: "暂停",
                                onBtnClick: () => {
                                    this.controller.pause()
                                }
                            })
                            IBestButton({
                                type: 'primary',
                                text: "继续",
                                onBtnClick: () => {
                                    this.controller.reStart()
                                }
                            })
                            IBestButton({
                                type: 'primary',
                                text: "重置",
                                onBtnClick: () => {
                                    this.controller.reset()
                                }
                            })
                        }.width(CONTAINER_SIZE.FULL).justifyContent(FlexAlign.SpaceBetween)
                    }
                }
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg2)
    }
}