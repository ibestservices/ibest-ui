import { webview } from '@kit.ArkWeb'
import BasePage from '../components/BasePage'

@Builder
export function DocBuilder(){
	DocPage()
}

@Entry
@Component
struct DocPage {
	private controller: webview.WebviewController = new webview.WebviewController()
	build() {
		Column(){
			BasePage({ title: "文档" }) {
				Row().height(84)
				Web({
					src: $r("app.string.app_doc_url"),
					controller: this.controller
				})
					.layoutWeight(1)
			}
		}
	}
}