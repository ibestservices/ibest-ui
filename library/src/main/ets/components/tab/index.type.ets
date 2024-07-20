import { emitter } from '../../assets/ets/EventEmitter'

/*
 * tab宽度类型
 */
export interface TabWidthType{
    boxWidth: number
    boxLocalLeft: number
    textWidth: number
}

/*
 * tabItem类型
 */
class TabItemObj{
    label: string = ""
    name: string = ""
    number?: number
    icon?: string | Resource
    isDisable?: boolean = false
}
@Observed
export class IBestTabItem extends TabItemObj{
    constructor(value: TabItemObj) {
        super()
        this.label = value.label
        this.name = value.name
        this.number = value.number
        this.icon = value.icon
        this.isDisable = value.isDisable
    }
}
/*
 * tabController类型
 */
export class IBestTabController{
    uniId: string = ""
    changeTab: (name: string) => void = () => {}
    constructor() {
        this.changeTab = (name: string) => {
            emitter.emit(`nameChange_${this.uniId}`, name)
        }
    }
}