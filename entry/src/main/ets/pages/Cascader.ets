import { IBestCascader, IBestCascaderOption, IBestCellGroup, IBestCell, IBestToast } from '@ibestservices/ibest-ui'
import TitleBar from '../components/TitleBar'
import { ComponentRouterParams } from '../assets/global.type'
import router from '@ohos.router'
import { CONTAINER_SIZE, SPACE } from '../assets/styles/BaseStyle'
import ComponentShowContainer from '../components/ComponentShowContainer'
@Entry
@Component
struct CascaderPage {
	@State title: string = (router.getParams() as ComponentRouterParams).title || ''
	@State visible: boolean = false
	@State fieldValue: string = '请选择地区'
	@State selectValue: string[] = []

	@State visible1: boolean = false
	@State fieldValue1: string = '请选择地区'
	@State selectValue1: string[] = []

	@State visible2: boolean = false
	@State fieldValue2: string = '江苏省,南京市,雨花台区'
	@State selectValue2: string[] = ["320000", "320100", "320114"]
	@State data: IBestCascaderOption[] = [
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

	@State visible3: boolean = false
	@State fieldValue3: string = '请选择地区'
	@State selectValue3: string[] = []
	@State data3: IBestCascaderOption[] = [
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
	@State data4: IBestCascaderOption[] = [
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

	build() {
		Column() {
			TitleBar({
				title: this.title
			}).backgroundColor('#FFF')
			List() {
				ListItem() {
					ComponentShowContainer({ title: '基础用法', titlePaddingLeft: SPACE.SMALL }) {
						IBestCellGroup() {
							Column() {
								IBestCell({
									title: '地区',
									value: this.fieldValue,
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.visible = true
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义颜色', titlePaddingLeft: SPACE.SMALL }) {
						IBestCellGroup() {
							Column() {
								IBestCell({
									title: '地区',
									value: this.fieldValue1,
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.visible1 = true
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义单项高度', titlePaddingLeft: SPACE.SMALL }) {
						IBestCellGroup() {
							Column() {
								IBestCell({
									title: '地区',
									value: this.fieldValue2,
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.visible2 = true
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '异步加载选项', titlePaddingLeft: SPACE.SMALL }) {
						IBestCellGroup() {
							Column() {
								IBestCell({
									title: '地区',
									value: this.fieldValue3,
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.visible3 = true
									}
								})
							}
						}
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '禁用选项', titlePaddingLeft: SPACE.SMALL }) {
						IBestCellGroup() {
							Column() {
								IBestCell({
									title: '地区',
									value: this.fieldValue4,
									isLink: true,
									hasBorder: false,
									onClickCell: () => {
										this.visible4 = true
									}
								})
							}
						}
					}
				}
			}
			.layoutWeight(1)
			// 基础用法
			IBestCascader({
				visible: $visible,
				options: this.data,
				value: $selectValue,
				onConfirm: (value: IBestCascaderOption[]) => {
					this.fieldValue = value.map(item => item.text).join(',')
				}
			})
			// 自定义颜色
			IBestCascader({
				visible: $visible1,
				options: this.data,
				activeColor: '#ee0a24',
				value: $selectValue1,
				onConfirm: (value: IBestCascaderOption[]) => {
					this.fieldValue1 = value.map(item => item.text).join(',')
				}
			})
			// 自定义高度
			IBestCascader({
				visible: $visible2,
				options: this.data,
				value: $selectValue2,
				itemHeight: 100,
				onConfirm: (value: IBestCascaderOption[]) => {
					this.fieldValue2 = value.map(item => item.text).join(',')
				}
			})
			// 异步加载
			IBestCascader({
				visible: $visible3,
				options: this.data3,
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
				options: this.data4,
				value: $selectValue4,
				onConfirm: (value: IBestCascaderOption[]) => {
					this.fieldValue4 = value.map(item => item.text).join(',')
				}
			})
		}
		.width(CONTAINER_SIZE.FULL)
		.height(CONTAINER_SIZE.FULL)
		.backgroundColor("#fff")
	}
}