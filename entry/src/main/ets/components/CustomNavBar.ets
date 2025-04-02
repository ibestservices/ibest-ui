import { IBestNavBar } from '@ibestservices/ibest-ui'
import RouterUtil from '../utils/routerUtil'
@Component
export default struct CustomNavBar {
	@Prop title: ResourceStr = ""
	build() {
		IBestNavBar({
			title: this.title,
			isShowStatusBar: true,
			onLeftClick: () => {
				RouterUtil.pop()
			}
		})
	}
}