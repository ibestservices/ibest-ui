import { IBestCaliper } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function CaliperBuilder(_: string, title: string){
    CaliperPage({title})
}

@Entry
@Component
struct CaliperPage {
    @State title: string = ''
    @State value: number = 6
    @State value1: number = 50
    @State value2: number = 0
    @State value3: number = 0
    @State value4: number = 0
    @State value5: number = 0

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }){
                        Column({space: SPACE.BASE}){
                            Text(this.value.toString())
                            IBestCaliper({
                                value: $value
                            })
                        }.alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '设置开始结尾数' }){
                        Column({space: SPACE.BASE}){
                            Text(this.value1.toString())
                            IBestCaliper({
                                value: $value1,
                                startNum: 50,
                                endNum: 200
                            })
                        }.alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义刻度' }){
                        Column({space: SPACE.MD}){
                            Text(this.value2.toString())
                            IBestCaliper({
                                value: $value2,
                                scaleSize: 2
                            })
                            Text(this.value3.toString())
                            IBestCaliper({
                                value: $value3,
                                scales: 5,
                                scaleSize: 2
                            })
                        }.alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义样式' }){
                        Column({space: SPACE.BASE}){
                            Text(this.value4.toString())
                            IBestCaliper({
                                value: $value4,
                                bgColor: "#d8e9f6",
                                fontColor: "#038cfd",
                                bigScaleHeight: 50,
                                smallScaleHeight: 40,
                                activeScaleColor: "red",
                                activeFontWeight: FontWeight.Bold
                            })
                        }.alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '刻度对齐方式' }){
                        Column({space: SPACE.SM}){
                            Text(this.value5.toString())
                            IBestCaliper({
                                value: $value5,
                                scaleAlign: "center"
                            })
                            IBestCaliper({
                                value: $value5,
                                scaleAlign: "bottom"
                            })
                        }.alignItems(HorizontalAlign.Start)
                    }
                }
                ListItem().height(50)
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg2)
    }
}