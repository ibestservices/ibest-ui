import { IBestAwaitable, IBestStringNumber } from '../../model/Global.type';

/**
 * 组件名称
 */
export const COMPONENT_NAME = 'DROPDOWN_MENU';
/**
 * dropDownMenu事件名称
 */
export enum DROPDOWN_MENU_EVENT_NAME {
    /**
     * 选择
     */
    OPTION_CLICK = 'OPTION_CLICK',
    /**
     * 配置变化
     */
    OPTION_CHANGE = 'OPTION_CHANGE'
}

/**
 * 下拉菜单选项
 */
export interface IBestDropdownMenuOption {
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
    /**
     * 图标位置
     * @since 2.1.8
     */
    iconPosition?: 'left' | 'right'
}
export class MenuContentController{
    hide: () => void = () => {}
}

export class IBestDropdownMenuContentType{
    index?: number = 0
    value?: IBestStringNumber = ''
    title?: ResourceStr = ''
    options?: IBestDropdownMenuOption[] = []
    maxHeight?: IBestStringNumber = ''
    disabled?: boolean = false
    defaultBuilder?: CustomBuilder
    onOpen?: () => void = () => {}
    onClose?: () => void = () => {}
    onChange?: (value: IBestStringNumber) => void = () => {}
    beforeOpen?: () => IBestAwaitable
}
@Observed
export class IBestDropdownMenuContentParams extends IBestDropdownMenuContentType{
    dialogId?: IBestStringNumber = ''
    constructor(val?: IBestDropdownMenuContentType) {
        super()
        if(val){
            this.value = val.value
            this.title = val.title
            this.options = val.options
            this.maxHeight = val.maxHeight
            this.disabled = val.disabled
            this.defaultBuilder = val.defaultBuilder
            this.onOpen = val.onOpen
            this.onClose = val.onClose
            this.onChange = val.onChange
            this.beforeOpen = val.beforeOpen
        }
    }
}
/**
 * 下拉菜单控制器
 */
export class IBestDropdownMenuController {
    /**
     * 关闭所有菜单
     */
    close: () => void = () => {}
}