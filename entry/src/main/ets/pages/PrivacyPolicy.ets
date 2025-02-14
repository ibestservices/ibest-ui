import { IBestNavBar } from '@ibestservices/ibest-ui'
import { webview } from '@kit.ArkWeb'
import { CONTAINER_SIZE } from '../assets/styles/BaseStyle'
import { router } from '@kit.ArkUI'
@Entry
@Component
struct PrivacyPolicy {
	private webController: webview.WebviewController = new webview.WebviewController()
	build() {
		Column() {
			IBestNavBar({
				title: "隐私政策",
				isShowStatusBar: true,
				onLeftClick: () => {
					router.back()
				}
			})
			Web({
				src: "https://ibestservices.github.io/ibest-ui/PrivacyPolicy.html",
				controller: this.webController
			})
				.cacheMode(CacheMode.Online)
				.layoutWeight(1)
				.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
	}
}