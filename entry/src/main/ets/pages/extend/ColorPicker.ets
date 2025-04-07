import { IBestColorPicker } from '@ibestservices/ibest-ui';
import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function ColorPickerBuilder(_: string, title: string){
	ColorPickerPage({title})
}

@Entry
@Component
struct ColorPickerPage {
	@State title: string = ""
	@State color: string = "#1989fa"
	@State color1: string = ""
	build() {
		NavDestination(){
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法' }) {
						Text(this.color)
						IBestColorPicker({
							value: $color
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '透明度' }) {
						IBestColorPicker({
							value: $color1,
							enableAlpha: true
						})
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