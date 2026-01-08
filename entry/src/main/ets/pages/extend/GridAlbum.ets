import { IBestGridAlbum } from "@ibestservices/ibest-ui"
import { SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"

@Builder
export function GridAlbumBuilder(_: string, title: string){
    GridAlbum({title})
}

@Entry
@Component
struct GridAlbum {
    @State title: string = ''

    build() {
        NavDestination(){
            CustomNavBar({ title: this.title })
            List(){
                ListItem() {
                    ComponentShowContainer({ title: "基础用法" }) {
                        IBestGridAlbum({
                            url: "https://q8.itc.cn/q_70/images03/20251108/5e7ed50788e94e9bba8e8aecfa810156.jpeg"
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: "横向长图" }) {
                        IBestGridAlbum({
                            url: "https://gips2.baidu.com/it/u=641660390,3943119249&fm=3074&app=3074&f=PNG?w=2560&h=1440"
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: "自定义尺寸样式" }) {
                        IBestGridAlbum({
                            url: "https://img1.baidu.com/it/u=2498831369,2480570398&fm=253&app=138&f=JPEG?w=800&h=1353",
                            componentWidth: 300,
                            space: 6,
                            bgColor: "#f2f3f5",
                            gridBgColor: "#969799",
                            radius: 10
                        })
                    }
                }
                ListItem().height(50)
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })

        }
        .width('100%')
        .height('100%')
        .hideTitleBar(true)
    }
}