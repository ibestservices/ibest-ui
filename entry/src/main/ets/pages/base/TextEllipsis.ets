import { modeColor, SPACE } from '../../assets/styles/BaseStyle';
import ComponentShowContainer from '../../components/ComponentShowContainer';
import { IBestTextEllipsis } from '@ibestservices/ibest-ui';
import CustomNavBar from '../../components/CustomNavBar';
@Builder
export function TextEllipsisBuilder(_: string, title: string){
	TextEllipsisPage({title})
}

@Entry
@Component
struct TextEllipsisPage {
    @State title: string = ''
    @State text: string = '人一生的大部分时间都是平淡无奇的🌟。这也是我们身体养精蓄锐的必要条件。⚡ 因为只有身心在泛起涟漪的生活中得到充分的修正，🍭才能圆满的迎接人生的下一次高峰。🍓'
    @State text1: string = "那一天我二十一岁🎂，在我一生的黄金时代。我有好多奢望。我想爱，想吃🍵，还想在一瞬间变成天上半明半暗的云🍊。后来我才知道，生活就是个缓慢受锤的过程，人一天天老下去🌛，奢望也一天天消失，最后变得像挨了锤的牛一样。❄可是我过二十一岁生日时没有预见到这一点🍻。我觉得自己会永远生猛下去，什么也锤不了我。🌈"
    build() {
		NavDestination() {
			CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }) {
                        IBestTextEllipsis({
                            text: this.text
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '展开/收起' }) {
                        IBestTextEllipsis({
                            text: this.text1,
                            showAction: true
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义展示行数', space: SPACE.SM }) {
                        IBestTextEllipsis({
                            text: this.text1,
                            showAction: true,
                            rows: 3
                        })
                        Row(){
                            IBestTextEllipsis({
                                text: this.text1,
                                showAction: true,
                                rows: 3
                            })
                        }.width(200)
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义省略位置' }){
                        ComponentShowContainer({ title: '头部省略' }) {
                            IBestTextEllipsis({
                                text: this.text1,
                                showAction: true,
                                omitPosition: 'start'
                            })
                        }
                        ComponentShowContainer({ title: '中部省略' }) {
                            IBestTextEllipsis({
                                text: this.text1,
                                omitPosition: 'middle',
                                showAction: true,
                                rows: 2
                            })
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义省略内容' }) {
                        IBestTextEllipsis({
                            text: this.text,
                            omitContent: "•••"
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义操作样式' }) {
                        IBestTextEllipsis({
                            text: this.text,
                            showAction: true,
                            expandText: "平铺",
                            collapseText: "折叠",
                            actionColor: "#DB3131"
                        })
                    }
                }
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg2)
    }
}