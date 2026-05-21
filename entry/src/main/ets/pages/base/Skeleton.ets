import { IBestSkeleton, IBestSkeletonParagraph, IBestSwitch } from '@ibestservices/ibest-ui'
import { modeColor, SPACE } from '../../assets/styles/BaseStyle'
import BasePage from '../../components/BasePage'
import ComponentShowContainer from '../../components/ComponentShowContainer'

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
		Column(){
			BasePage({ title: this.title, bgColor: modeColor.bg2 }) {
				List() {
					ListItem().height(84)
					ListItem() {
						ComponentShowContainer({ title: '基础用法' }) {
							IBestSkeleton()
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '显示头像' }) {
							IBestSkeleton({
								avatar: true
							})
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '自定义段落行数' }) {
							IBestSkeleton({ rows: 4, radius: 4 })
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '展示子组件', space: SPACE.SM }) {
							IBestSwitch({
								value: $loading
							})
							IBestSkeleton({
								avatar: true,
								loading: this.loading
							}) {
								Row({ space: SPACE.SM }) {
									Image($r("app.media.app_icon")).width(32).aspectRatio(1)
									Column({ space: SPACE.SM }) {
										Text("关于IBest-UI")
										Text($r("app.string.app_desc"))
									}
									.layoutWeight(1)
									.alignItems(HorizontalAlign.Start)
								}.alignItems(VerticalAlign.Top)
							}
						}
					}

					ListItem() {
						ComponentShowContainer({ title: '自定义排版' }) {
							Row({ space: 14 }) {
								IBestSkeletonParagraph({ type: "image" })
								Column({ space: 14 }) {
									IBestSkeletonParagraph({ type: "text", rowWidth: "60%" })
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
				.padding({ left: SPACE.SM, right: SPACE.SM })
			}
        }
    }
}