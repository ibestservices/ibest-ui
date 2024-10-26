import router from '@ohos.router';
import TitleBar from '../components/TitleBar'
import { CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle';
import { IBestPullRefresh, IBestRefreshContentParams, IBestTabItemType, IBestTabs } from '@ibestservices/ibest-ui';
import { ComponentRouterParams } from '../assets/global.type';
@Entry
@Component
struct PullRefresh {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State tabsList: Array<IBestTabItemType> = [
		{
			name: "1",
			label: '基础用法'
		},
		{
			name: "2",
			label: '成功提示'
		},
		{
			name: "3",
			label: '滚动区域'
		},
		{
			name: "4",
			label: '自定义提示'
		}
	]
	@State currentTab: string = "1"
	@State isLoading: boolean = false

	@Builder customContent() {
		Column(){
			Text("这是一些自定义内容")
		}
		.height(200)
		.padding(SPACE.BASE)
	}

	@Builder customContent1(){
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
		.padding(SPACE.BASE)
	}

	@Builder customPullingContent($$: IBestRefreshContentParams){
		Text($$.distance + "")
	}

	onRefresh(){
		// 此处模拟请求 延时关闭
		setTimeout(() => {
			this.isLoading = false
		}, 1500)
	}

	build() {
		Column(){
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			IBestTabs({
				tabsList: this.tabsList,
				currentName: $currentTab
			})
			if(this.currentTab == "1"){
				IBestPullRefresh({
					loading: $isLoading,
					defaultContent: (): void => this.customContent(),
					onRefresh: (): void => this.onRefresh()
				})
			}
			if(this.currentTab == "2"){
				IBestPullRefresh({
					loading: $isLoading,
					successText: "加载成功",
					defaultContent: (): void => this.customContent(),
					onRefresh: (): void => this.onRefresh()
				})
			}
			if(this.currentTab == "3"){
				IBestPullRefresh({
					loading: $isLoading,
					defaultContent: (): void => this.customContent1(),
					onRefresh: (): void => this.onRefresh()
				})
			}
			if(this.currentTab == "4"){
				IBestPullRefresh({
					loading: $isLoading,
					defaultContent: (): void => this.customContent(),
					pullingContent: this.customPullingContent,
					onRefresh: (): void => this.onRefresh()
				})
			}
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
	}
}