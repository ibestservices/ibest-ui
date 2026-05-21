import { hdsMaterial, HdsNavDestination, ScrollEffectType } from '@kit.UIDesignKit';

@Component
export default struct BasePage {
    @Prop title: string = ''
    @Prop bgColor: ResourceColor = ''
    @Prop comId: string = ''
    @BuilderParam defaultBuilder: CustomBuilder
    build() {
        HdsNavDestination() {
            if(this.defaultBuilder){
                this.defaultBuilder()
            }
        }
        .titleBar({
            content: {
                title: {
                    mainTitle: this.title
                }
            },
            style: {
                scrollEffectOpts: {
                    scrollEffectType: ScrollEffectType.IMMERSIVE_GRADIENT_BLUR
                },
                originalStyle: {
                    contentStyle: {
                        titleStyle: {
                            mainTitleColor: "#000"
                        },
                        backIconStyle: {
                            backgroundColor: "#fff",
                            iconColor: "#000"
                        }
                    },
                },
                scrollEffectStyle: {
                    backgroundStyle: {
                        backgroundColor: "#99000000"
                    },
                    contentStyle: {
                        titleStyle: {
                            mainTitleColor: "#fff"
                        },
                        backIconStyle: {
                            backgroundColor: $r('sys.color.comp_background_tertiary'),
                            iconColor: "#fff"
                        }
                    }
                },
                systemMaterialEffect: {
                    materialType: hdsMaterial.MaterialType.IMMERSIVE,
                    materialLevel: hdsMaterial.MaterialLevel.ADAPTIVE
                }
            }
        })
        .id(this.comId)
        .backgroundColor(this.bgColor)
        .ignoreLayoutSafeArea([LayoutSafeAreaType.SYSTEM], [LayoutSafeAreaEdge.TOP, LayoutSafeAreaEdge.BOTTOM])
    }
}