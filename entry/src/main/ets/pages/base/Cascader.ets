import {
    IBestCascader,
    IBestCascaderContent,
    IBestCascaderOption,
    IBestCell,
    IBestNavBar,
    IBestToast
} from '@ibestservices/ibest-ui'
import { CONTAINER_SIZE, modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import { regionData } from '@ibestservices/area-data'
import CustomNavBar from '../../components/CustomNavBar'
@Builder
export function CascaderBuilder(_: string, title: string){
	CascaderPage({title})
}

@Entry
@Component
struct CascaderPage {
	@State title: string = ''
	@State visible: boolean = false
	@State fieldValue: string = '请选择地区'
	@State selectValue: string[] = []

	@State visible1: boolean = false
	@State fieldValue1: string = '请选择地区'
	@State selectValue1: string[] = []

	@State visible2: boolean = false
	@State fieldValue2: string = '江苏省,南京市,雨花台区'
	@State selectValue2: string[] = ["320000", "320100", "320114"]

	@State visible3: boolean = false
	@State fieldValue3: string = '请选择地区'
	@State selectValue3: string[] = []
	@State data1: IBestCascaderOption[] = [
		{
			text: "江苏省",
			value: "320000"
		},
		{
			text: "安徽省",
			value: "340000"
		}
	]
	lazyLoad(value: string | number, level: number, cb: (arr: IBestCascaderOption[]) => void){
		IBestToast.show({
			type: "loading"
		})
		setTimeout(() => {
			IBestToast.hide()
			cb(value == "320000" ? [
				{
					text: "南京市",
					value: "320100",
					isEnd: level >= 1
				},
				{
					text: "苏州市",
					value: "320500",
					isEnd: level >= 1
				}
			] : [
				{
					text: "合肥市",
					value: "340100",
					isEnd: level >= 1
				},
				{
					text: "黄山市",
					value: "341000",
					isEnd: level >= 1
				}
			])
		}, 2000)
	}

	@State visible4: boolean = false
	@State fieldValue4: string = '请选择地区'
	@State selectValue4: string[] = []
	@State data2: IBestCascaderOption[] = [
		{
			text: "江苏省",
			value: "320000",
			children: [
				{
					text: "南京市",
					value: "320100",
					children: [
						{
							text: "秦淮区",
							value: "320104"
						},
						{
							text: "雨花台区",
							value: "320114"
						}
					]
				},
				{
					text: "苏州市",
					value: "320500",
					disabled: true,
					children: [
						{
							text: "姑苏区",
							value: "320508"
						},
						{
							text: "昆山市",
							value: "320583"
						}
					]
				}
			]
		},
		{
			text: "安徽省",
			value: "340000",
			children: [
				{
					text: "合肥市",
					value: "340100",
					children: [
						{
							text: "蜀山区",
							value: "340104"
						},
						{
							text: "合肥高新技术产业开发区",
							value: "340171"
						}
					]
				},
				{
					text: "黄山市",
					value: "341000",
					disabled: true,
					children: [
						{
							text: "屯溪区",
							value: "341002"
						},
						{
							text: "黄山区",
							value: "341003"
						}
					]
				}
			]
		}
	]

	@State selectValue5: string[] = []

	build() {
		NavDestination() {
			CustomNavBar({title: this.title})
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.XS }) {
						IBestCell({
							title: '地区',
							value: this.fieldValue,
							isLink: true,
							hasBorder: false,
							onCellClick: () => {
								this.visible = true
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义颜色', titlePaddingLeft: SPACE.XS }) {
						IBestCell({
							title: '地区',
							value: this.fieldValue1,
							isLink: true,
							hasBorder: false,
							onCellClick: () => {
								this.visible1 = true
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义单项高度', titlePaddingLeft: SPACE.XS }) {
						IBestCell({
							title: '地区',
							value: this.fieldValue2,
							isLink: true,
							hasBorder: false,
							onCellClick: () => {
								this.visible2 = true
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '异步加载选项', titlePaddingLeft: SPACE.XS }) {
						IBestCell({
							title: '地区',
							value: this.fieldValue3,
							isLink: true,
							hasBorder: false,
							onCellClick: () => {
								this.visible3 = true
							}
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用选项', titlePaddingLeft: SPACE.XS }) {
						IBestCell({
							title: '地区',
							value: this.fieldValue4,
							isLink: true,
							hasBorder: false,
							onCellClick: () => {
								this.visible4 = true
							}
						})
					}
				}
				ListItem(){
					ComponentShowContainer({ title: '平铺展示', titlePaddingLeft: SPACE.XS }) {
						IBestCascaderContent({
							value: $selectValue5,
							options: regionData
						})
					}
				}
				ListItem().height(50)
			}
			.layoutWeight(1)
			.padding({ left: SPACE.SM, right: SPACE.SM })
			// 基础用法
			IBestCascader({
				visible: $visible,
				options: regionData,
				value: $selectValue,
				onConfirm: (value: IBestCascaderOption[]) => {
					this.fieldValue = value.map(item => item.text).join(',')
				}
			})
			// 自定义颜色
			IBestCascader({
				visible: $visible1,
				options: regionData,
				activeColor: '#ee0a24',
				value: $selectValue1,
				onConfirm: (value: IBestCascaderOption[]) => {
					this.fieldValue1 = value.map(item => item.text).join(',')
				}
			})
			// 自定义高度
			IBestCascader({
				visible: $visible2,
				options: regionData,
				value: $selectValue2,
				itemHeight: 50,
				onConfirm: (value: IBestCascaderOption[]) => {
					this.fieldValue2 = value.map(item => item.text).join(',')
				}
			})
			// 异步加载
			IBestCascader({
				visible: $visible3,
				options: this.data1,
				value: $selectValue3,
				lazy: true,
				lazyLoad: this.lazyLoad,
				onConfirm: (value: IBestCascaderOption[]) => {
					this.fieldValue3 = value.map(item => item.text).join(',')
				}
			})
			// 禁用选项
			IBestCascader({
				visible: $visible4,
				options: this.data2,
				value: $selectValue4,
				onConfirm: (value: IBestCascaderOption[]) => {
					this.fieldValue4 = value.map(item => item.text).join(',')
				}
			})
		}
		.hideTitleBar(true)
		.backgroundColor(modeColor.bg)
	}
}