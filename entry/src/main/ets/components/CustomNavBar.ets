import { IBestNavBar } from '@ibestservices/ibest-ui'
import RouterUtil from '../utils/routerUtil'
@Component
export default struct CustomNavBar {
	@Prop title: ResourceStr = ""
	@Prop isShowStatusBar: boolean = true
	build() {
		IBestNavBar({
			title: this.title,
			isShowStatusBar: this.isShowStatusBar,
			onLeftClick: () => {
				RouterUtil.pop()
			}
		})
	}
}