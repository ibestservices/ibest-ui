import { IBestCard, IBestToast } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import BasePage from '../../components/BasePage'
import ComponentShowContainer from '../../components/ComponentShowContainer'

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
        Column(){
            BasePage({ title: this.title, bgColor: modeColor.bg2 }) {
                List() {
                    ListItem().height(84)
                    ListItem() {
                        ComponentShowContainer({ title: '基础用法' }) {
                            IBestCard() {
                                this.cardContent()
                            }
                        }
                    }

                    ListItem() {
                        ComponentShowContainer({ title: '显示标题' }) {
                            IBestCard({
                                title: '标题',
                                leftIcon: $r('app.media.app_icon'),
                                value: "内容",
                                titleClickable: true,
                                onTitleClick: () => {
                                    IBestToast.show('点击了标题')
                                }
                            }) {
                                this.cardContent()
                            }
                        }
                    }

                    ListItem() {
                        ComponentShowContainer({ title: '背景图片' }) {
                            IBestCard({
                                bgImage: "https://img.shetu66.com/2023/08/01/1690856871895889.png"
                            }) {
                                this.cardContent()
                            }
                        }
                    }

                    ListItem().height(50)
                }
                .padding({ left: SPACE.SM, right: SPACE.SM })
            }
        }
    }
}