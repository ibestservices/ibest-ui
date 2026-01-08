import { IBestButton, IBestMosaic } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function MosaicBuilder(_: string, title: string){
    Mosaic({title})
}

@Entry
@Component
struct Mosaic {
    @State title: string = ''
    @State showMosaic: boolean = true
    @Builder imgMosaicBuilder(){
        Image("https://gips2.baidu.com/it/u=229998344,1431847233&fm=3074&app=3074&f=PNG?w=2560&h=1440")
            .width("100%")
            .height(200)
            .borderRadius(10)
    }
    @Builder otherContentBuilder(){
        Column(){
            Text("测试马赛克文字测试马赛克文字测试马赛克文字测试马赛克文字测试马赛克文字测试马赛克文字")
                .fontSize(14)
                .fontColor("red")
        }
        .width("100%")
        .alignItems(HorizontalAlign.Start)
    }

    build() {
        NavDestination(){
            CustomNavBar({title: this.title})
            List(){
                ListItem() {
                    ComponentShowContainer({ title: "基础用法" }) {
                        IBestMosaic({radius: 10}){
                            this.imgMosaicBuilder()
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: "自定义马赛克块大小" }) {
                        IBestMosaic({ blockSize: 30 }){
                            this.imgMosaicBuilder()
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: "模糊文字" }) {
                        IBestMosaic(){
                            this.otherContentBuilder()
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: "动态显示", space: SPACE.SM }) {
                        IBestMosaic({ showMosaic: this.showMosaic }){
                            this.imgMosaicBuilder()
                        }
                        IBestButton({
                            type: "primary",
                            text: `切换: ${this.showMosaic ? "显示" : "隐藏"}`,
                            onBtnClick: () => {
                                this.showMosaic = !this.showMosaic
                            }
                        })
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