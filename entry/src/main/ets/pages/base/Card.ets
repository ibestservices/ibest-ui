import { IBestCard, IBestToast } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function CardBuilder(_: string, title: string){
    CardPage({title})
}

@Entry
@Component
struct CardPage {
    @State title: string = ''
    @Builder cardContent(){
        Column(){
            ForEach([1, 2, 3, 4], (item: number) => {
                Row(){
                    Text('内容' + item)
                }
                .height(30)
            })
        }
    }

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }){
                        IBestCard(){
                            this.cardContent()
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '显示标题' }){
                        IBestCard({
                            title: '标题',
                            titleClickable: true,
                            onTitleClick: () => {
                                IBestToast.show('点击了标题')
                            }
                        }){
                            this.cardContent()
                        }
                    }
                }
                ListItem() {
                    ComponentShowContainer({ title: '背景图片' }){
                        IBestCard({
                            bgImage: "https://uploadfile.bizhizu.cn/2017/0731/20170731103322735.jpg"
                        }){
                            this.cardContent()
                        }
                    }
                }
                ListItem().height(50)
            }
            .layoutWeight(1)
            .padding({ left: SPACE.SM, right: SPACE.SM })
        }
        .hideTitleBar(true)
        .backgroundColor(modeColor.bg2)
    }
}