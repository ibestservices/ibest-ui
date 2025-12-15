import { IBestActionSheet, IBestButton, IBestDialogUtil, IBestToast } from '@ibestservices/ibest-ui';
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle';
import CustomNavBar from '../../components/CustomNavBar';

@Builder
export function ActionSheetBuilder(_: string, title: string){
	ActionSheetPage({title})
}

@Entry
@Component
struct ActionSheetPage {
	@State title: string = ''
	@Builder defaultContent(){
		Scroll(){
			Column({ space: 10 }){
				Text("浔阳江头夜送客，枫叶荻花秋瑟瑟。")
				Text("主人下马客在船，举酒欲饮无管弦。")
				Text("醉不成欢惨将别，别时茫茫江浸月。")
				Text("忽闻水上琵琶声，主人忘归客不发。")
				Text("寻声暗问弹者谁，琵琶声停欲语迟。")
				Text("移船相近邀相见，添酒回灯重开宴。")
				Text("千呼万唤始出来，犹抱琵琶半遮面。")
				Text("转轴拨弦三两声，未成曲调先有情。")
				Text("弦弦掩抑声声思，似诉平生不得志。")
				Text("低眉信手续续弹，说尽心中无限事。")
				Text("轻拢慢捻抹复挑，初为《霓裳》后《六幺》。")
				Text("大弦嘈嘈如急雨，小弦切切如私语。")
				Text("嘈嘈切切错杂弹，大珠小珠落玉盘。")
				Text("间关莺语花底滑，幽咽泉流冰下难。")
				Text("冰泉冷涩弦凝绝，凝绝不通声暂歇。")
				Text("别有幽愁暗恨生，此时无声胜有声。")
				Text("银瓶乍破水浆迸，铁骑突出刀枪鸣。")
				Text("曲终收拨当心画，四弦一声如裂帛。")
				Text("东船西舫悄无言，唯见江心秋月白。")
				Text("沉吟放拨插弦中，整顿衣裳起敛容。")
				Text("自言本是京城女，家在虾蟆陵下住。")
				Text("十三学得琵琶成，名属教坊第一部。")
				Text("曲罢曾教善才服，妆成每被秋娘妒。")
				Text("五陵年少争缠头，一曲红绡不知数。")
				Text("钿头银篦击节碎，血色罗裙翻酒污。")
				Text("今年欢笑复明年，秋月春风等闲度。")
				Text("弟走从军阿姨死，暮去朝来颜色故。")
				Text("门前冷落鞍马稀，老大嫁作商人妇。")
				Text("商人重利轻别离，前月浮梁买茶去。")
				Text("去来江口守空船，绕船月明江水寒。")
			}
			.width(CONTAINER_SIZE.FULL)
			.alignItems(HorizontalAlign.Center)
			.padding(SPACE.SM)
		}
		.layoutWeight(1)
	}

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			Column({ space: 20 }){
				IBestButton({
					text: '基础用法',
					onBtnClick: () => {
						IBestActionSheet.show({
							actions: ["选项一", "选项二", "选项三"],
							beforeClose: (index: number, name?: string | number) => {
								return new Promise((resolve, reject) => {
									IBestDialogUtil.open({
										title: "提示",
										message: `确定选择${name}？`,
										showCancelButton: true,
										onConfirm: () => {
											resolve(true)
										},
										onCancel: () => {
											reject(false)
										}
									})
								})
							},
							onSelect: (index: number, name?: string | number) => {
								IBestToast.show(`点击了第${index}个选项，名称为${name}`)
							}
						})
					}
				})
				IBestButton({
					text: '展示图标',
					onBtnClick: () => {
						IBestActionSheet.show({
							actions: [
								{ name: '选项一', icon: $r("app.media.icon_like") },
								{ name: '选项二', icon: "https://ibestui.ibestservices.com/favicon.ico" },
								{ name: '选项三', icon: $r("app.media.ibest_icon_star_o") }
							],
							onSelect: (index: number, name?: string | number) => {
								IBestToast.show(`点击了第${index}个选项，名称为${name}`)
							}
						})
					}
				})
				IBestButton({
					text: '展示取消按钮',
					onBtnClick: () => {
						IBestActionSheet.show({
							actions: [
								{ name: '选项一' },
								{ name: '选项二' },
								{ name: '选项三' }
							],
							cancelText: '取消',
							onSelect: (index: number, name?: string | number) => {
								IBestToast.show(`点击了第${index}个选项，名称为${name}`)
							},
							onCancel: () => {
								IBestToast.show(`取消`)
							}
						})
					}
				})
				IBestButton({
					text: '展示标题、描述信息',
					onBtnClick: () => {
						IBestActionSheet.show({
							customTitle: $r("app.string.app_name"),
							description: $r("app.string.app_desc"),
							actions: [
								{ name: $r("app.string.app_name") },
								{ name: '选项二', subName: $r("app.string.app_doc_url") },
								{ name: '选项三', icon: $r("app.media.app_icon") }
							],
							cancelText: '取消'
						})
					}
				})
				IBestButton({
					text: '选项状态',
					onBtnClick: () => {
						IBestActionSheet.show({
							description: '这是一段描述信息',
							actions: [
								{ name: '正常选项', color: '#ff0000' },
								{ name: '禁用选项', isDisabled: true },
								{ name: '只读选项', readonly: true }
							],
							itemHeight: 60,
							cancelText: '取消',
							cancelTextColor: '#3d8af2'
						})
					}
				})
				IBestButton({
					text: '指定选项标识',
					onBtnClick: () => {
						IBestActionSheet.show({
							actions: [
								{ name: '选项一', value: '1' },
								{ name: '选项二', value: '2' },
								{ name: '选项三', value: '3' }
							],
							onSelect: (index: number, value?: string | number, name?: string | number) => {
								IBestToast.show(`点击了第${index}个选项，标识为${value}，名称为${name}`)
							}
						})
					}
				})
				IBestButton({
					text: '多行选项',
					onBtnClick: () => {
						IBestActionSheet.show({
							actions: [
								[
									{ name: '选项一', value: '1', icon: "https://img1.baidu.com/it/u=626427719,3451396095&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500", isDisabled: true },
									{ name: '选项二', value: '2', icon: "https://img1.baidu.com/it/u=700838104,4078529388&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500" },
									{ name: '选项三', value: '3', icon: "https://img2.baidu.com/it/u=4065465253,912770067&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=800" },
									{ name: '选项四', value: '4', icon: "https://img1.baidu.com/it/u=2725751717,2191296050&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500" },
									{ name: '选项五', value: '5', icon: "https://img1.baidu.com/it/u=3680872223,3132467302&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500" },
									{ name: '选项六', value: '6', icon: "https://img2.baidu.com/it/u=2265290985,2435372066&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500" },
									{ name: '选项七', value: '7', icon: "https://img2.baidu.com/it/u=2400134426,605051231&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=800" }
								],
								[
									{ name: '选项八', value: '8', icon: "https://img0.baidu.com/it/u=4206081356,667300244&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=500" },
									{ name: '选项九', value: '9', icon: "https://img0.baidu.com/it/u=2290976380,3655879079&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500" },
									{ name: '选项十', value: '10', icon: "https://img0.baidu.com/it/u=1901164914,2143836773&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=500" }
								]
							],
							cancelText: '取消',
							onSelect: (index1: number, index2?: number | string, value?: number | string, name?: string | number) => {
								IBestToast.show(`点击了第${index1}行第${index2}个选项，标识为${value}，名称为${name}`)
							}
						})
					}
				})
				IBestButton({
					text: '展示自定义内容',
					onBtnClick: () => {
						IBestActionSheet.show({
							customTitle: '琵琶行',
							height: 500,
							customContent: (): void => this.defaultContent()
						})
					}
				})
				IBestButton({
					text: '展示原生标题',
					onBtnClick: () => {
						IBestActionSheet.show({
							title: {
								title: "原生标题",
								subtitle: "原生副标题"
							},
							actions: [
								{ name: '选项一' },
								{ name: '选项二' },
								{ name: '选项三' }
							],
							cancelText: '取消'
						})
					}
				})
			}
			.width(CONTAINER_SIZE.FULL)
			.justifyContent(FlexAlign.Center)
			.layoutWeight(1)
			.padding({ top: SPACE.SM, left: SPACE.SM, right: SPACE.SM })
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}