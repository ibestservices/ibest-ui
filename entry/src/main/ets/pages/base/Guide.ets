import { IBestButton, IBestGuide, IBestGuideController, IBestGuideBaseController,
	IBestField, IBestSlider, IBestToast, IBestEmpty, IBestDivider} from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { LengthMetrics } from '@ohos.arkui.node';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function GuideBuilder(_: string, title: string){
	GuidePage({title})
}

@Builder
function demo(sort: number, total: number, ctl: IBestGuideBaseController) {
	Scroll() {
		Column() {
			Text("这是一个自定义插槽，随便写点什么...")
				.width(CONTAINER_SIZE.FULL)
				.padding(SPACE.SM)
				.textAlign(TextAlign.Start)
				.fontColor(Color.Red)

			Row({space: SPACE.MD}) {
				Row({space: SPACE.MD}) {
					Text("第" + sort + "个，共" + total + "个")
						.letterSpacing(SPACE.mini)
						.fontSize(12)
						.fontColor(Color.Green)
				}
				Blank()
				Row({ space: SPACE.LG }) {
					IBestButton({
						text: '上一步',
						type: 'warning',
						buttonSize: 'small',
						fontWeight: FontWeight.Medium,
						onBtnClick: ()=>{
							if(sort > 1){
								ctl.prev()
							}
						},
						disabled: sort==1
					})
					IBestButton({
						text: sort==total ? "结束导览" : "下一步",
						type: 'primary',
						buttonSize: 'small',
						fontWeight: FontWeight.Medium,
						onBtnClick: ()=>{
							if(sort==total) {
								ctl.close()
							} else {
								ctl.next()
							}
						}
					})
				}
			}
			.padding({ left: SPACE.SM, right: SPACE.SM })
		}
		.padding(SPACE.SM)
	}
	.scrollBar(BarState.Auto)
	.height("auto")
	.constraintSize({maxHeight: "auto"})
}

@Entry
@Component
struct GuidePage {
	@State title: string = ''
	private controller: IBestGuideController | null = null
	@State uniId: number = 0
	@State value: string = ""
	@State value1: string = ""
	@State value2: string = ""
	@State value3: string = ""
	@State value4: string = ""
	@State value5: number = 30

	aboutToAppear(): void {
		this.uniId = this.getUniqueId()
	}

	build() {
			NavDestination() {
				IBestGuide({onReady: (controller: IBestGuideController) => {
						this.controller = controller
				}}) {
					CustomNavBar({ title: this.title })
					List() {
						ListItem() {
							ComponentShowContainer({ title: $r("app.string.custom_type", $r("app.string.button")) }) {
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
									})
									IBestButton({
										text: $r("app.string.custom_button", $r("app.string.default")),
										type: 'default'
									})
									IBestButton({
										text: $r("app.string.custom_button", $r("app.string.danger")),
										type: 'danger'
									})
									IBestButton({
										text: $r("app.string.custom_button", $r("app.string.warning")),
										type: 'warning'
									})
									IBestButton({
										text: $r('app.string.guid_mixed_use_slots'),
										plain: true,
										type: 'warning',
										onClickBtn: () => {
											if(this.controller) {
												this.controller.cleanAll()
												this.controller.setGuideItem({
													label: 'guide_label1',
													componentId: 'ibest_guide_button_1_' + this.uniId,
													content: "这是一个按钮的引导内容..."
												})
												this.controller.setGuideItem({
													label: 'guide_label2',
													componentId: 'ibest_guide_button_2_' + this.uniId,
													content: "这是一个按钮的引导内容..."
												})
												this.controller.setGuideItem({
													label: 'guide_label3',
													componentId: 'ibest_guide_button_3_' + this.uniId,
													content: wrapBuilder(demo),
													placement: Placement.Top
												})
												this.controller.setGuideItem({
													label: 'guide_label4',
													componentId: 'ibest_guide_field_' + this.uniId,
													content: "这是一个输入框的引导内容..."
												})
												this.controller.setGuideItem({
													label: 'guide_label5',
													componentId: 'ibest_guide_slider_' + this.uniId,
													content: "一个滑块??"
												})
												this.controller.setGuideWay(['guide_label1', 'guide_label4', 'guide_label2', 'guide_label3', 'guide_label5'], true)
											}
										}
									})
								}
							}
						}

						ListItem() {
							ComponentShowContainer({ title: '基础用法' }) {
								IBestField({
									value: $value,
									label: "文本",
									placeholder: "请输入文本",
									hasBorder: false
								}).id('ibest_guide_field_' + this.uniId)
							}
						}

						ListItem() {
							ComponentShowContainer({ title: '自定义类型' }) {
								// 密码
								IBestField({
									value: $value1,
									label: "密码",
									placeholder: "请输入密码",
									type: "password"
								}).id('ibest_guide_form_1_' + this.uniId)
								// 手机号
								IBestField({
									value: $value2,
									label: "手机号",
									placeholder: "请输入手机号",
									type: "phone"
								})
								// 整数数字
								IBestField({
									value: $value3,
									label: "整数",
									placeholder: "请输入整数",
									type: "number"
								})
								// 小数
								IBestField({
									value: $value4,
									label: "小数",
									hasBorder: false,
									placeholder: "请输入小数",
									type: "decimal",
									decimalLength: 2
								}).id('ibest_guide_form_2_' + this.uniId)
							}
						}

						ListItem() {
							ComponentShowContainer({ title: $r("app.string.custom_button", $r("app.string.plain")) }) {
								Row({ space: SPACE.SM }) {
									IBestButton({
										text: $r('app.string.guid_merge_rects'),
										type: 'primary',
										plain: true,
										onClickBtn: () => {
											if(this.controller) {
												this.controller.cleanAll()
												this.controller.setStrictMode(true)
												this.controller.setGuideItem({
													label: 'guide_label1',
													componentId: ['ibest_guide_form_1_' + this.uniId, 'ibest_guide_form_2_' + this.uniId],
													content: "多组件合并区域..."
												})
												this.controller.setGuideWay(['guide_label1'], true)
											}
										}
									}).id('ibest_guide_button_2_' + this.uniId)
									IBestButton({
										text: $r('app.string.guid_use_single'),
										plain: true,
										type: 'success',
										onClickBtn: () => {
											if(this.controller) {
												this.controller.cleanAll()
												this.controller.setStrictMode(true)
												const ok = this.controller.setGuideItem({
													label: 'guide_label1',
													componentId: 'ibest_guide_button_1_' + this.uniId,
													content: "这是单个引导内容..."
												})
												if(!ok) {
													IBestToast.show("请检查该区域是否在屏幕内!")
													return
												}
												this.controller.setGuideWay(['guide_label1'], true)
											}
										}
									}).id('ibest_guide_button_3_' + this.uniId)
									IBestButton({
										text: $r('app.string.guid_basic_usage'),
										plain: true,
										type: 'warning',
										onClickBtn: () => {
											if(this.controller) {
												this.controller.cleanAll()
												this.controller.setGuideItem({
													label: 'guide_label2',
													componentId: 'ibest_guide_button_2_' + this.uniId,
													content: "这是一个按钮的引导内容..."
												})
												this.controller.setGuideItem({
													label: 'guide_label3',
													componentId: 'ibest_guide_button_3_' + this.uniId,
													content: "这是另一个按钮的引导内容..."
												})
												this.controller.setGuideWay(['guide_label2', 'guide_label3'], true)
											}
										}
									})
								}
							}
						}

						ListItem() {
							ComponentShowContainer({ title: '自定义样式' }) {
								IBestSlider({
									value: $value5,
									barHeight: 8,
									activeColor: "#ee0a24",
									onChange: (val) => {
										IBestToast.show(val.toString())
									}
								}).id('ibest_guide_slider_' + this.uniId)
							}
						}

						ListItem() {
							ComponentShowContainer({ title: 'IBestEmpty' }) {
								IBestEmpty({
									description: '描述文字'
								})
							}
						}

						ListItem() {
							Column() {
								IBestDivider()
							}.padding({ top: SPACE.MD })
						}

						ListItem() {
							ComponentShowContainer({ title: '测试屏幕外组件引导，严格模式不会弹出引导，宽松模式允许在屏幕边界弹出' }) {
								Flex({
									wrap: FlexWrap.Wrap,
									space: { main: LengthMetrics.vp(SPACE.SM), cross: LengthMetrics.vp(SPACE.SM) }
								}) {
									IBestButton({
										text: $r('app.string.guid_is_strict_mode'),
										type: 'warning',
										onClickBtn: () => {
											if(this.controller) {
												this.controller.cleanAll()
												this.controller.setStrictMode(true)
												const ok = this.controller.setGuideItem({
													label: 'guide_label1',
													componentId: 'ibest_guide_button_1_' + this.uniId,
													content: "这是一个按钮的引导内容..."
												})
												if(!ok) {
													IBestToast.show("请检查该区域是否在屏幕内!")
													return
												}
												this.controller.setGuideItem({
													label: 'guide_label2',
													componentId: 'ibest_guide_button_2_' + this.uniId,
													content: "这是另一个按钮的引导内容..."
												})
												this.controller.setGuideWay(['guide_label1', 'guide_label2'], true)
											}
										}
									})

									IBestButton({
										text: $r('app.string.guid_is_loose_mode'),
										type: 'primary',
										onClickBtn: () => {
											if(this.controller) {
												this.controller.cleanAll()
												this.controller.setStrictMode(false)
												this.controller.setGuideItem({
													label: 'guide_label1',
													componentId: 'ibest_guide_button_1_' + this.uniId,
													content: "这是一个按钮的引导内容..."
												})
												this.controller.setGuideItem({
													label: 'guide_label2',
													componentId: 'ibest_guide_button_2_' + this.uniId,
													content: "这是另一个按钮的引导内容..."
												})
												this.controller.setGuideWay(['guide_label1', 'guide_label2'], true)
											}
										}
									})
								}
							}
						}
						ListItem().height(50)
					}
					.layoutWeight(1)
					.padding({ left: SPACE.SM, right: SPACE.SM })
				}
			}
			.hideTitleBar(true)
			.backgroundColor(modeColor.bg)
	}
}