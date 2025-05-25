import { IBestStringNumber } from "../../../../../Index"

/**
 * 下拉菜单选项
 */
export interface IBestDropdownOption {
    /**
     * 文字
     */
    text: ResourceStr
    /**
     * 标识符
     */
    value: IBestStringNumber
    /**
     * 是否禁用
     */
    disabled?: boolean
    /**
     * 图标
     */
    icon?: ResourceStr
}
export class MenuContentController{
    hide: () => void = () => {}
}

@ObservedV2
class IBestDropdownMenuOptionType{
    value: IBestStringNumber = ''
    @Trace title: string = ''
    option: IBestDropdownOption[] = []
    disabled: boolean = false
}
export class IBestDropdownMenuOption extends IBestDropdownMenuOptionType{
    constructor(val: IBestDropdownMenuOptionType) {
        super()
        this.value = val.value
        this.title = val.title
        this.option = val.option
        this.disabled = val.disabled
    }
}