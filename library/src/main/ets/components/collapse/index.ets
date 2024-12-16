import { GRAY_COLOR } from '../../theme-chalk/src/color'
import { emitter } from '../../utils/EventEmitter'
import { getEventName } from '../../utils/utils'
import { IBestCollapseColor } from './color'
import { CollapseItem, COLLAPSE_EVENT_NAME, COMPONENT_NAME, IBestCollapseController, ToggleOption } from './index.type'
@Component
export struct IBestCollapse {
    /**
     * 分组id
     */
    @Prop groupId: string = ""
    /**
     * 当前展开面板的name
     */
    @Link activeName: string | string[]
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
    @BuilderParam defaultBuilder?: CustomBuilder
    /**
     * 监听面板状态变化
     */
    onChange: (name: string | string[]) => void = () => {}
    /**
     * 组件实例
     */
    controller: IBestCollapseController = new IBestCollapseController()

    @State allCollapseItem: CollapseItem[] = []

    aboutToAppear(): void {
        this.controller.toggleAll = (option?: boolean | ToggleOption): void => this.toggleAll(option)
        emitter.on(getEventName(COMPONENT_NAME, this.groupId, COLLAPSE_EVENT_NAME.GET_ALL_ITEM_NAME), (name: string, disabled: boolean): void => this.getAllNames(name, disabled))
        emitter.on(getEventName(COMPONENT_NAME, this.groupId, COLLAPSE_EVENT_NAME.ITEM_STATE_CHANGE), (name: string, isExpand: boolean): void => this.setName(name, isExpand))
    }
    onDidBuild(): void {
        setTimeout(() => {
            this.initItem()
        }, 0)
    }
    aboutToDisappear(): void {
        emitter.off(getEventName(COMPONENT_NAME, this.groupId, COLLAPSE_EVENT_NAME.GET_ALL_ITEM_NAME), (name: string, disabled: boolean): void => this.getAllNames(name, disabled))
        emitter.off(getEventName(COMPONENT_NAME, this.groupId, COLLAPSE_EVENT_NAME.ITEM_STATE_CHANGE), (name: string, isExpand: boolean): void => this.setName(name, isExpand))
    }

    initItem(){
        emitter.emit(getEventName(COMPONENT_NAME, this.groupId, COLLAPSE_EVENT_NAME.INIT_ITEM), this.activeName)
    }

    getAllNames(name: string, disabled: boolean){
        if(!this.allCollapseItem.some(e => e.name == name)){
            this.allCollapseItem.push({name, disabled})
        }
    }

    setName(name: string, isExpand: boolean){
        if(this.accordion){ // 手风琴模式
            this.activeName = this.activeName && !isExpand ? "" : name
            this.initItem()
        }else{
            if(typeof this.activeName == 'string'){
                this.activeName = this.activeName.split(" ")
            }
            let index = this.activeName.indexOf(name)
            if(index > -1){
                this.activeName.splice(index, 1)
            }else{
                this.activeName.push(name)
            }
        }
        this.onChange(this.activeName)
    }

    toggleAll(option?: boolean | ToggleOption){
        if(this.accordion){
            return
        }
        if(option == undefined){    // 切换
            this.activeName = this.allCollapseItem.filter((e: CollapseItem) => !this.activeName.includes(e.name)).map((e: CollapseItem) => e.name)
        }else if(typeof option == 'boolean'){
            this.activeName = option ? this.allCollapseItem.map((e: CollapseItem) => e.name) : []
        }else{
            let disabledArr = this.allCollapseItem.filter(e => this.activeName.includes(e.name) && e.disabled)
            let arr: CollapseItem[] = []
            if(option.skipDisabled){
                arr = this.allCollapseItem.filter((e: CollapseItem) => !e.disabled)
            }
            arr = option.expanded == undefined ? arr.filter((e: CollapseItem) => !this.activeName.includes(e.name)) : option.expanded ? arr : []
            if(option.skipDisabled){
                arr = arr.concat(disabledArr)
            }
            this.activeName = arr.map((e: CollapseItem) => e.name)
        }
        this.onChange(this.activeName)
        this.initItem()
    }
    build() {
        Column(){
            if(this.defaultBuilder){
                this.defaultBuilder()
            }
        }
        .border(this.isShowBorder ? { width:{top: 1, bottom: 1}, color: IBestCollapseColor.borderColor } : {})
    }
}