import { IBestDropdownMenu } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function DropdownMenuBuilder(_: string, title: string){
    DropdownMenuPage({title})
}

@Entry
@Component
struct DropdownMenuPage {
    @State title: string = ''

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.MD }){
                        IBestDropdownMenu()
                    }
                }
            }
            .layoutWeight(1)
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg)
    }
}