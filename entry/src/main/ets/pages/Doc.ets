import { IBestNavBar } from '@ibestservices/ibest-ui'
import { webview } from '@kit.ArkWeb'
import { CONTAINER_SIZE } from '../assets/styles/BaseStyle'
import GlobalStore from '../utils/global'
import router from '@ohos.router'
@Entry
@Component
struct Doc {
	private controller: webview.WebviewController = new webview.WebviewController()
	build() {
		Column(){
			IBestNavBar({
				title: "文档",
				onLeftClick: () => {
					router.back()
				}
			})
			Web({
				src: $r("app.string.app_doc_url"),
				controller: this.controller
			})
				.layoutWeight(1)
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.padding({top: GlobalStore.topAvoidHeight})
	}
}