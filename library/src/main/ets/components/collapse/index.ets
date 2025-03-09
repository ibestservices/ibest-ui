import { IBestStringNumber } from '../../model/Global.type'
import { emitter } from '../../utils/EventEmitter'
import { getEventName } from '../../utils/utils'
import { IBestCollapseColor } from './color'
import { COLLAPSE_EVENT_NAME, CollapseItem, COMPONENT_NAME, IBestCollapseController, ToggleOption } from './index.type'
@Component
export struct IBestCollapse {
    @State uniId: number = 0
    /**
     * 分组id
     */
    @Prop groupId: string = ""
    /**
     * 当前展开面板的name
     */
    @Link activeName: IBestStringNumber | IBestStringNumber[]
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
    onChange: (name: IBestStringNumber | IBestStringNumber[]) => void = () => {}
    /**
     * 组件实例
     */
    controller: IBestCollapseController = new IBestCollapseController()

    @State allCollapseItem: CollapseItem[] = []

    aboutToAppear(): void {
        this.uniId = this.getUniqueId()
        this.controller.toggleAll = (option?: boolean | ToggleOption): void => this.toggleAll(option)
        emitter.on(getEventName(COMPONENT_NAME, COLLAPSE_EVENT_NAME.GET_ALL_ITEM_NAME, this.groupId), this.uniId, (name: IBestStringNumber, disabled: boolean): void => this.getAllNames(name, disabled))
        emitter.on(getEventName(COMPONENT_NAME, COLLAPSE_EVENT_NAME.ITEM_STATE_CHANGE, this.groupId), this.uniId, (name: IBestStringNumber, isExpand: boolean): void => this.setName(name, isExpand))
    }
    onDidBuild(): void {
        setTimeout(() => {
            this.initItem()
        }, 0)
    }
    aboutToDisappear(): void {
        emitter.off(getEventName(COMPONENT_NAME, COLLAPSE_EVENT_NAME.GET_ALL_ITEM_NAME, this.groupId), this.uniId)
        emitter.off(getEventName(COMPONENT_NAME, COLLAPSE_EVENT_NAME.ITEM_STATE_CHANGE, this.groupId), this.uniId)
    }

    initItem(){
        emitter.emit(getEventName(COMPONENT_NAME, COLLAPSE_EVENT_NAME.INIT_ITEM, this.groupId), this.activeName)
    }

    getAllNames(name: IBestStringNumber, disabled: boolean){
        if(!this.allCollapseItem.some(e => e.name == name)){
            this.allCollapseItem.push({name, disabled})
        }
    }

    setName(name: IBestStringNumber, isExpand: boolean){
        if(this.accordion){ // 手风琴模式
            this.activeName = this.activeName != undefined && !isExpand ? "" : name
            this.initItem()
        }else{
            if(typeof this.activeName == 'string'){
                this.activeName = this.activeName.split(" ")
            }else if(typeof this.activeName == 'number'){
                this.activeName = [this.activeName]
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
        let actives = typeof this.activeName == 'number' ? this.activeName.toString() : this.activeName
        if(option == undefined){    // 切换
            this.activeName = this.allCollapseItem.filter((e: CollapseItem) => !actives.includes(e.name.toString())).map((e: CollapseItem) => e.name)
        }else if(typeof option == 'boolean'){
            this.activeName = option ? this.allCollapseItem.map((e: CollapseItem) => e.name) : []
        }else{
            let disabledArr = this.allCollapseItem.filter(e => actives.includes(e.name.toString()) && e.disabled)
            let arr: CollapseItem[] = []
            if(option.skipDisabled){
                arr = this.allCollapseItem.filter((e: CollapseItem) => !e.disabled)
            }
            arr = option.expanded == undefined ? arr.filter((e: CollapseItem) => !actives.includes(e.name.toString())) : option.expanded ? arr : []
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