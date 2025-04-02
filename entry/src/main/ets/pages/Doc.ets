import { webview } from '@kit.ArkWeb'
import CustomNavBar from '../components/CustomNavBar'

@Builder
export function DocBuilder(){
	DocPage()
}

@Entry
@Component
struct DocPage {
	private controller: webview.WebviewController = new webview.WebviewController()
	build() {
		NavDestination(){
			CustomNavBar({title: "文档"})
			Web({
				src: $r("app.string.app_doc_url"),
				controller: this.controller
			})
				.layoutWeight(1)
		}
		.hideTitleBar(true)
	}
}