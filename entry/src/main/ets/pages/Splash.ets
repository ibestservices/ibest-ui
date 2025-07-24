import { CONTAINER_SIZE, modeColor } from '../assets/styles/BaseStyle'
import { process } from '@kit.ArkTS'
PersistentStorage.persistProp("isAgree", false)

@Entry
@Component
struct Splash {
	@StorageLink("isAgree") isAgree: boolean = false
	private router = this.getUIContext().getRouter()

	aboutToAppear(): void {
		if(this.isAgree) {
			this.enterIndex()
		}
	}
	exitApp() {
		new process.ProcessManager().exit(0)
	}
	agree(){
		this.isAgree = true
		this.enterIndex()
	}
	enterIndex(){
		this.router.replaceUrl({
			url: 'pages/Index'
		})
	}
	viewPrivacyPolicy(){
		this.router.pushUrl({
			url: 'pages/PrivacyPolicy'
		})
	}

	build() {
		Stack() {
			if(!this.isAgree){
				Column(){
					Text("隐私政策").fontSize(22).fontColor(modeColor.textColor)
					Text("欢迎使用本软件!")
						.width(CONTAINER_SIZE.FULL)
						.textAlign(TextAlign.Start)
						.margin({top: 20})
						.fontColor(modeColor.textColor2)
					Text("在使用本软件前,请您认真阅读并了解隐私政策,以了解我们的服务内容和我们在应用中如何收集并处理个人信息。我们将严格按照隐私政策为您提供服务,保护个人信息。")
						.width(CONTAINER_SIZE.FULL)
						.fontColor(modeColor.textColor2)
					Text("《隐私政策》")
						.width(CONTAINER_SIZE.FULL)
						.fontSize(14)
						.fontColor(modeColor.primaryColor)
						.textAlign(TextAlign.Start)
						.margin({top: 20})
						.onClick(() => {
							this.viewPrivacyPolicy()
						})
					Button("同意")
						.width(CONTAINER_SIZE.FULL)
						.height(40)
						.margin({top: 20})
						.backgroundColor(modeColor.primaryColor)
						.onClick(() => {
							this.agree()
						})
					Text("不同意")
						.fontSize(12)
						.fontColor(modeColor.primaryColor)
						.margin({top: 20})
						.onClick(() => {
							this.exitApp()
						})
				}
				.width("80%")
				.borderRadius(20)
				.backgroundColor(modeColor.bg2)
				.padding({top: 30, bottom: 20, left: 20, right: 20})
				.shadow({
					radius: 20,
					color: modeColor.borderColor
				})
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(modeColor.bg)
		.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
	}
}