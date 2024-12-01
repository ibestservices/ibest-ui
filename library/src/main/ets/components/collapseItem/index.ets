import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { convertDimensionsWidthUnit } from '../../utils/utils'
import { IBestIcon } from '../icon'

@Component
export struct IBestCollapseItem {
    /**
     * 全局公共样式
     */
    @StorageLink(IBEST_UI_NAMESPACE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 唯一标识符，默认为索引值
     */
    @Prop name: string = ""
    /**
     * 标题栏左侧图标
     */
    @Prop icon: ResourceStr = ""
    /**
     * 标题栏左侧图标颜色
     */
    // @Prop iconColor: ResourceStr = ""
    /**
     * 标题栏左侧图标大小
     */
    // @Prop iconSize: number | string = convertDimensionsWidthUnit(16)
    /**
     * 标题
     */
    @Prop title: string = ""
    /**
     * 标题栏右侧内容
     */
    @Prop value: string = ""
    /**
     * 是否显示内边框
     */
    @Prop isShowBorder: boolean = true
    /**
     * 是否禁用
     */
    @Prop disabled: boolean = false
    /**
     * 是否只读
     */
    @Prop readOnly: boolean = false
    /**
     * 默认内容
     */
    @BuilderParam defaultBuilder?: () => CustomBuilder

    @State isExpand: boolean = false
    @State contentHeight: number = 0


    build() {
        Column(){
            Row(){
                if(this.icon){
                    Image(this.icon).width(convertDimensionsWidthUnit(16)).margin({right: this.baseStyle.spaceBase})
                }
                Text(this.title).layoutWeight(1).fontSize(this.baseStyle.fontSizeMd).fontColor(GRAY_COLOR.GRAY_8)
                Text(this.value)
                    .layoutWeight(1)
                    .textAlign(TextAlign.End)
                    .fontColor(GRAY_COLOR.GRAY_6)
                IBestIcon({
                    name: "arrow-down",
                    iconSize: this.baseStyle.fontSizeMd,
                    color: GRAY_COLOR.GRAY_6
                })
                    .rotate({ z:1, angle: this.isExpand ? -180 : 0 })
                    .animation({ duration: 200 })
                Divider()
                    .height(1)
                    .color(GRAY_COLOR.GRAY_3)
                    .position({left: this.baseStyle.spaceMd as Dimension, right: this.baseStyle.spaceMd as Dimension, bottom: 0})
            }
            .padding({left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd, top: this.baseStyle.spaceSm, bottom: this.baseStyle.spaceSm})
            .stateStyles({
                pressed:{
                    .backgroundColor(GRAY_COLOR.GRAY_2)
                },
                normal:{
                    .backgroundColor(this.baseStyle.default)
                }
            })
            .onClick(() => {
                this.isExpand = !this.isExpand
            })
            Row(){
                if(this.defaultBuilder){
                    this.defaultBuilder()
                }
            }
            .padding({left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd, top: this.baseStyle.spaceSm, bottom: this.baseStyle.spaceSm, left: this.baseStyle.spaceMd, right: this.baseStyle.spaceMd})
        }
        .backgroundColor(this.baseStyle.default)
    }
}