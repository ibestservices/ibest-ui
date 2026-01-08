import { IBestStringNumber } from "../../model/Global.type"

/**
 * 选项类型
 */
export interface IBestSegmentedOption{
    label?: ResourceStr
    value: IBestStringNumber
    icon?: ResourceStr
    iconPosition?: 'left' | 'right'
    disabled?: boolean
}