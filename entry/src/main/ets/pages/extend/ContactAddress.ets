import { IBestContactAddressForm } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function ContactAddressBuilder(_: string, title: string){
  ContactAddressPage({title})
}

@Entry
@Component
struct ContactAddressPage {
  @State title: string = ''

  aboutToAppear() {}

  build() {
    NavDestination() {
      CustomNavBar({title: this.title})
      List() {
        ListItem() {
          ComponentShowContainer({title: ""}) {
            IBestContactAddressForm()
          }
        }
        ListItem().height(50)
      }
      .layoutWeight(1)
      .padding({ left: SPACE.SM, right: SPACE.SM })
    }
    .hideTitleBar(true)
    .backgroundColor(modeColor.bg)
  }
}