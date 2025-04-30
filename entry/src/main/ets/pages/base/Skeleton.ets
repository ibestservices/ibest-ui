import { IBestSkeleton, IBestSkeletonParagraph, IBestSwitch } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import ComponentShowContainer from '../../components/ComponentShowContainer'
import CustomNavBar from '../../components/CustomNavBar'

@Builder
export function SkeletonBuilder(_: string, title: string){
    SkeletonPage({title})
}

@Entry
@Component
struct SkeletonPage {
    @State title: string = ''
	@State loading: boolean = true

    build() {
        NavDestination() {
            CustomNavBar({title: this.title})
            List() {
                ListItem() {
                    ComponentShowContainer({ title: '基础用法' }){
                        IBestSkeleton()
                    }
                }
				ListItem() {
					ComponentShowContainer({ title: '显示头像' }){
						IBestSkeleton({
							avatar: true
						})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义段落行数' }){
						IBestSkeleton({rows: 4, radius: 4})
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '展示子组件' }){
						Column({ space: SPACE.SM}){
							IBestSwitch({
								value: $loading
							})
							IBestSkeleton({
								avatar: true,
								loading: this.loading
							}){
								Row({space: SPACE.SM}){
									Image($r("app.media.app_icon")).width(32).aspectRatio(1)
									Column({space: SPACE.SM}){
										Text("关于IBest-UI")
										Text($r("app.string.app_desc"))
									}
									.layoutWeight(1)
									.alignItems(HorizontalAlign.Start)
								}.alignItems(VerticalAlign.Top)
							}
						}
						.alignItems(HorizontalAlign.Start)
					}
				}
				ListItem() {
					ComponentShowContainer({ title: '自定义排版' }){
						Row({space: 14}){
							IBestSkeletonParagraph({type: "image"})
							Column({space: 14}){
								IBestSkeletonParagraph({type: "text", rowWidth: "60%"})
								IBestSkeletonParagraph()
								IBestSkeletonParagraph()
								IBestSkeletonParagraph()
							}
							.layoutWeight(1)
							.alignItems(HorizontalAlign.Start)
						}
						.alignItems(VerticalAlign.Top)
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