import { IBestStringNumber } from "../../model/Global.type"

/**
 * 选项类型
 */
export class IBestSegmentedOption{
    label?: ResourceStr
    value: IBestStringNumber = ''
    icon?: ResourceStr
    iconPosition?: 'left' | 'right'
    disabled?: boolean
}
@Observed
export class IBestSegmentedItem extends IBestSegmentedOption{
    constructor(value: IBestSegmentedOption) {
        super()
        this.label = value.label
        this.value = value.value
        this.icon = value.icon
        this.iconPosition = value.iconPosition
        this.disabled = value.disabled
    }
}