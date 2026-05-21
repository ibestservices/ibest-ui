import { webview } from '@kit.ArkWeb'
import { CONTAINER_SIZE } from '../assets/styles/BaseStyle'
import BasePage from '../components/BasePage'

@Builder
export function PrivacyPolicyBuilder(){
	PrivacyPolicy()
}

@Entry
@Component
struct PrivacyPolicy {
	private webController: webview.WebviewController = new webview.WebviewController()
	build() {
		Column(){
			BasePage({ title: "隐私政策" }) {
				Row().width(CONTAINER_SIZE.FULL).height(84)
				Web({
					src: "https://ibestservices.github.io/ibest-ui/PrivacyPolicy.html",
					controller: this.webController
				})
					.cacheMode(CacheMode.Online)
					.layoutWeight(1)
			}
		}
	}
}