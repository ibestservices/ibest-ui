import { IBestButton, IBestGuide, IBestGuideController, IBestField  } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { LengthMetrics } from '@ohos.arkui.node';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function GuideBuilder(_: string, title: string){
	GuidePage({title})
}

@Builder
function demo(label: string) {
	Text("这是一个自定义插槽："+label)
		.fontSize(20)
		.padding(12)
		.textAlign(TextAlign.Start)
		.fontColor(Color.Pink)
}

@Entry
@Component
struct GuidePage {
	@State title: string = ''
	private controller: IBestGuideController | null = null
	@State uniId: number = 0
	@State value: string = ""

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
	}

	build() {
			NavDestination() {
				IBestGuide({onReady: (controller: IBestGuideController) => {
					this.controller = controller
				}}) {
					CustomNavBar({ title: this.title })
					Flex({
						wrap: FlexWrap.Wrap,
						space: { main: LengthMetrics.vp(SPACE.SM), cross: LengthMetrics.vp(SPACE.SM) }
					}) {
						IBestButton({
							text: $r("app.string.custom_button", $r("app.string.primary")),
							type: 'primary'
						}).id('ibest_guide_button_1_' + this.uniId)
						IBestButton({
							text: $r("app.string.custom_button", $r("app.string.success")),
							type: 'success'
						}).id('ibest_guide_button_2_' + this.uniId)
						IBestButton({
							text: $r("app.string.custom_button", $r("app.string.default")),
							type: 'default'
						}).id('ibest_guide_button_3_' + this.uniId)
						IBestButton({
							text: $r("app.string.custom_button", $r("app.string.danger")),
							type: 'danger'
						}).id('ibest_guide_button_4_' + this.uniId)
						IBestButton({
							text: $r("app.string.custom_button", $r("app.string.warning")),
							type: 'warning'
						}).id('ibest_guide_button_5_' + this.uniId)
					}.padding(20)
					.id('ibest_guide_flex_' + this.uniId)

					Column({space:20}) {
						IBestField({
							value: $value,
							label: "文本",
							placeholder: "请输入文本",
							hasBorder: false
						}).id('ibest_guide_field_' + this.uniId)
					}

					Column({space: 20}){
						IBestButton({
							text: "点我开始引导",
							type: 'primary',
							onClickBtn: () => {
								if(this.controller) {
									this.controller.cleanAll()
									this.controller.setGuideItem('guide_label1', {
										componentId: 'ibest_guide_button_1_' + this.uniId,
										content: "这是一个按钮的引导内容..."
									})
									this.controller.setGuideItem('guide_label2', {
										componentId: 'ibest_guide_button_5_' + this.uniId,
										content: "这是另一个按钮的引导内容..."
									})
									this.controller.setGuideItem('guide_label3', {
										componentId: 'ibest_guide_field_' + this.uniId,
										content: "这是一个输入框的引导内容..."
									})
									this.controller.setGuideItem('guide_label4', {
										componentId: 'ibest_guide_button_6_' + this.uniId,
										content: wrapBuilder(demo),
										placement: Placement.Top
									})
									this.controller.setGuideWay(['guide_label1', 'guide_label3', 'guide_label2', 'guide_label4'], true)
								}
							}
						})
					}
					.justifyContent(FlexAlign.Center)
					.padding(20)

					Column({space: 20}){
						IBestButton({
							text: $r("app.string.custom_button", $r("app.string.warning")),
							type: 'warning'
						}).id('ibest_guide_button_6_' + this.uniId)
					}
					.justifyContent(FlexAlign.Center)
					.height("40%")
				}
			}
			.hideTitleBar(true)
			.backgroundColor(modeColor.bg)
	}
}