import { IBestSkeleton } from "@ibestservices/ibest-ui"
import { modeColor, SPACE } from "../../assets/styles/BaseStyle"
import ComponentShowContainer from "../../components/ComponentShowContainer"
import CustomNavBar from "../../components/CustomNavBar"

@Builder
export function SkeletonBuilder(_: string, title: string){
    SkeletonPage({title})
}

@Entry
@Component
struct SkeletonPage {
    @State title: string = ''

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }){
                        IBestSkeleton()
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