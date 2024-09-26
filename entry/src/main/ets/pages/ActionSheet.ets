import router from '@ohos.router';
import { IBestActionSheet, IBestButton, IBestToast } from '@ibestservices/ibest-ui'
import { BACKGROUND_COLOR, CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import TitleBar from '../components/TitleBar'
import { ComponentRouterParams } from '../assets/global.type';

@Entry
@Component
struct ActionSheetPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
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
				Text("大弦嘈嘈如急雨，小弦切切如私语")
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
			.padding(SPACE.BASE)
		}
		.layoutWeight(1)
	}

	build() {
		Column() {
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					Column({ space: 20 }){
						IBestButton({
							text: '基础用法',
							onClickBtn: () => {
								IBestActionSheet.show({
									actions: ["选项一", "选项二", "选项三"],
									onSelect: (index: number) => {
										IBestToast.show(`点击了第${index}个选项`)
									}
								})
							}
						})
						IBestButton({
							text: '展示图标',
							onClickBtn: () => {
								IBestActionSheet.show({
									actions: [
										{ name: '选项一', icon: $r("app.media.icon_like") },
										{ name: '选项二', icon: "https://ibestui.ibestservices.com/favicon.ico" },
										{ name: '选项三', icon: $r("app.media.icon_star_o") }
									],
									onSelect: (index: number) => {
										IBestToast.show(`点击了第${index}个选项`)
									}
								})
							}
						})
						IBestButton({
							text: '展示取消按钮',
							onClickBtn: () => {
								IBestActionSheet.show({
									actions: [
										{ name: '选项一' },
										{ name: '选项二' },
										{ name: '选项三' }
									],
									cancelText: '取消',
									onSelect: (index: number) => {
										IBestToast.show(`点击了第${index}个选项`)
									},
									onCancel: () => {
										IBestToast.show(`取消`)
									}
								})
							}
						})
						IBestButton({
							text: '展示标题、描述信息',
							onClickBtn: () => {
								IBestActionSheet.show({
									customTitle: '标题文字',
									description: '这是一段描述信息',
									actions: [
										{ name: '选项一' },
										{ name: '选项二', subName: '描述信息' },
										{ name: '选项三' }
									],
									cancelText: '取消'
								})
							}
						})
						IBestButton({
							text: '选项状态',
							onClickBtn: () => {
								IBestActionSheet.show({
									description: '这是一段描述信息',
									actions: [
										{ name: '选项一', color: '#ff0000' },
										{ name: '选项二', isDisabled: true },
										{ name: '选项三' }
									],
									cancelText: '取消'
								})
							}
						})
						IBestButton({
							text: '指定选项标识',
							onClickBtn: () => {
								IBestActionSheet.show({
									actions: [
										{ name: '选项一', value: '1' },
										{ name: '选项二', value: '2' },
										{ name: '选项三', value: '3' }
									],
									onSelect: (index: number, value?: string | number) => {
										IBestToast.show(`点击了第${index}个选项，标识为${value}`)
									}
								})
							}
						})
						IBestButton({
							text: '多行选项',
							onClickBtn: () => {
								IBestActionSheet.show({
									actions: [
										[
											{ name: '选项一', value: '1', icon: "https://img0.baidu.com/it/u=3543009939,2144310597&fm=253&fmt=auto&app=138&f=JPEG?w=704&h=500", isDisabled: true },
											{ name: '选项二', value: '2', icon: "https://img0.baidu.com/it/u=2123036823,827931345&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800" },
											{ name: '选项三', value: '3', icon: "https://img0.baidu.com/it/u=180300320,2476402890&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800" },
											{ name: '选项四', value: '4', icon: "https://img0.baidu.com/it/u=3335548191,973645921&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500" },
											{ name: '选项五', value: '5', icon: "https://img0.baidu.com/it/u=2138148539,1764238981&fm=253&fmt=auto&app=138&f=JPEG?w=889&h=500" },
											{ name: '选项六', value: '6', icon: "https://img1.baidu.com/it/u=733418214,3903491350&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=313" },
											{ name: '选项七', value: '7', icon: "https://img1.baidu.com/it/u=1718642830,3610884461&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500" }
										],
										[
											{ name: '选项八', value: '8', icon: "https://img0.baidu.com/it/u=145395842,2013084776&fm=253&fmt=auto&app=120&f=JPEG?w=889&h=500" },
											{ name: '选项九', value: '9', icon: "https://img2.baidu.com/it/u=840413173,1942127153&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500" },
											{ name: '选项十', value: '10', icon: "https://img0.baidu.com/it/u=863503243,1550253516&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800" }
										]
									],
									cancelText: '取消',
									onSelect: (index1: number, index2?: number | string, value?: string) => {
										IBestToast.show(`点击了第${index1}行第${index2}个选项，标识为${value}`)
									}
								})
							}
						})
						IBestButton({
							text: '展示自定义内容',
							onClickBtn: () => {
								IBestActionSheet.show({
									customTitle: '琵琶行',
									height: 500,
									customContent: (): void => this.defaultContent()
								})
							}
						})
						IBestButton({
							text: '展示原生标题',
							onClickBtn: () => {
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
					.alignItems(HorizontalAlign.Center)
				}
			}
			.layoutWeight(1)
			.padding({
				top: SPACE.BASE,
				left: SPACE.BASE,
				right: SPACE.BASE
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor(BACKGROUND_COLOR.BASE)
	}
}