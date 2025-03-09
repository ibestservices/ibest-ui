import { getComponentsInfo } from '@ibestservices/ibest-ui/src/main/ets/utils/utils'
import { AnyType } from '../../model/AnyType'

interface header {
    title: string
    prop: string
    width?: number
    align?: 'left' | 'center' | 'right'
}

@Component
export struct IBestTable {
    @Prop maxHeight: string | number = "auto"
    @Prop data: AnyType[] = []
    @State columnList: header[] = [
        {
            title: "姓名",
            prop: "name",
            width: 80
        },
        {
            title: "年龄",
            prop: "age",
            width: 80
        },
        {
            title: "性别",
            prop: "sex",
            width: 80
        },
        {
            title: "地址",
            prop: "address"
        }
    ]
    private uiContext = this.getUIContext()
    aboutToAppear() {
        setTimeout(() => {
            let width = getComponentsInfo(this.uiContext, "table").width
            console.log("table width: ", width)
        }, 50)
    }
    build() {
        Column(){
            // 头部
            Row(){
                ForEach(this.columnList, (item: header, index: number) => {
                    Row(){
                        Text(item.title)
                            .textAlign(TextAlign.Center)
                    }
                    .width(item.width || '')
                    .layoutWeight(item.width ? 0 : 1)
                    .padding({left: 6, right: 6, top: 8, bottom: 8})
                    .border({width: {right: 1, bottom: 1}, color: "#000000"})
                }, (item: header, index: number) => index + "")
            }
            // 数据
            ForEach(this.data, (item: AnyType, index: number) => {
                Row(){
                    ForEach(this.columnList, (item1: header, index1: number) => {
                        Row(){
                            Text(item[item1.prop].toString())
                        }
                        .width(item1.width || '')
                        .layoutWeight(item1.width ? 0 : 1)
                        .padding({left: 6, right: 6, top: 8, bottom: 8})
                        .border({width: {right: 1, bottom: 1}, color: "#000000"})
                    }, (item1: header, index1: number) => index1 + "")
                }
            }, (item: AnyType, index: number) => index + "")
        }
        .width('100%')
        .border({width: {left: 1, top: 1}, color: "#000000"})
        .constraintSize({maxHeight: this.maxHeight})
        .id("table")
    }
}