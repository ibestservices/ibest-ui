import { IBestPrice } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function PriceBuilder(_: string, title: string){
    PricePage({title})
}

@Entry
@Component
struct PricePage {
    @State title: string = ''
    @State value: number = 0
    @State value1: number = 8888
    @State value2: number = 8888.68
    @State value3: number = 8888.6888

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }) {
                        IBestPrice({
                            value: this.value
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '小数点位数' }) {
                        IBestPrice({
                            value: this.value1,
                            decimal: 0
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '划线价' }) {
                        IBestPrice({
                            value: this.value1,
                            decimal: 0,
                            strikeThrough: true
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '货币符号' }) {
                        IBestPrice({
                            value: this.value2,
                            symbol: "$"
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '货币符号位置' }) {
                        IBestPrice({
                            value: this.value2,
                            symbol: "RMB",
                            symbolPosition: "right"
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '千位分隔' }) {
                        IBestPrice({
                            value: this.value3,
                            decimal: 3,
                            thousand: true
                        })
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '自定义样式' }) {
                        IBestPrice({
                            value: this.value2,
                            symbolFontSize: 20,
                            integerFontSize: 20,
                            decimalPointFontSize: 18,
                            decimalFontSize: 18,
                            color: "#1989fa"
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