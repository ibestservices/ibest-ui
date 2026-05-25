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
				Row().width(CONTAINER_SIZE.FULL).height(90)
				Web({
					src: $rawfile("PrivacyPolicy.html"),
					controller: this.webController
				})
					.layoutWeight(1)
			}
		}
	}
}