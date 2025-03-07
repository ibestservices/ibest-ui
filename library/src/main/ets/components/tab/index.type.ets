/**
 * tab宽度类型
 */
export interface TabWidthType{
    boxWidth: number
    boxLocalLeft: number
    textWidth: number
}

/**
 * tabItem类型
 */
export class IBestTabItemType{
    label: ResourceStr = ""
    name: string = ""
    number?: number
    icon?: ResourceStr
    isDisable?: boolean
}
@Observed
export class IBestTabItem extends IBestTabItemType{
    constructor(value: IBestTabItemType) {
        super()
        this.label = value.label
        this.name = value.name
        this.number = value.number ?? undefined
        this.icon = value.icon ?? undefined
        this.isDisable = value.isDisable ?? false
    }
}
/**
 * tabController类型
 */
export class IBestTabController{
    changeTab: (name: string) => void = () => {}
}