import { GRAY_COLOR } from '../../theme-chalk/src/color'

@Component
export struct IBestCollapse {
    /**
     * 当前展开面板的name
     */
    @Link activeName: string
    /**
     * 是否开启手风琴模式
     */
    @Prop accordion: boolean = false
    /**
     * 是否显示外边框
     */
    @Prop isShowBorder: boolean = true
    /**
     * 默认内容
     */
    @BuilderParam defaultBuilder?: () => CustomBuilder

    onChange: () => void = () => {}


    build() {
        Column(){
            if(this.defaultBuilder){
                this.defaultBuilder()
            }
        }
        .border(this.isShowBorder ? { width:{top: 1, bottom: 1}, color: GRAY_COLOR.GRAY_3 } : {})
    }
}