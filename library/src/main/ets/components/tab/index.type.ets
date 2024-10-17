import { emitter } from '../../assets/ets/EventEmitter'

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
export interface IBestTabItemType{
    label: string
    name: string
    number?: number
    icon?: string | Resource
    isDisable?: boolean
}
@Observed
export class IBestTabItem implements IBestTabItemType{
    label: string
    name: string
    number?: number
    icon?: string | Resource
    isDisable?: boolean
    constructor(value: IBestTabItemType) {
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