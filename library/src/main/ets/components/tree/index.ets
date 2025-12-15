import { IBestTreeController, IBestTreeData, IBestTreeNodeData } from "./index.type"
import { unifiedDataChannel, uniformTypeDescriptor } from "@kit.ArkData"
import { findNodeByKey, getNodeData, moveNodeById, setCheckedByVal } from "./utils"
import { CONTAINER_SIZE } from "../../theme-chalk/src/container"
import { IBestTreeColor } from "./color"
import { IBestStorageKey, IBestStringNumber } from "../../model/Global.type"
import { IBestUIBaseStyleObjType } from "../../theme-chalk/src/index.type"
import { getDefaultBaseStyle } from "../../theme-chalk/src"
import { IBestRadioGroup } from "../radioGroup"
import { IBestIcon } from "../icon"
import { IBestCheckbox } from "../checkbox"
import { IBestRadio } from "../radio"
import { IBestLoading } from "../loading"

@Component
export struct IBestTree{
    /**
     * 全局公共样式
     */
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    /**
     * 节点数据
     */
    @Link @Watch("dataChange") data: IBestTreeData[]
    /**
     * 默认展开所有节点
     */
    @Provide({allowOverride: "defaultExpandAll"}) defaultExpandAll: boolean = false
    /**
     * 默认展开节点
     */
    @Provide({allowOverride: "defaultExpandKeys"}) defaultExpandKeys: IBestStringNumber[] = []
    /**
     * 可选择类型
     */
    @Provide({allowOverride: "selectType"}) selectType: "" | "single" | "multiple" = ""
    /**
     * 箭头图标
     */
    @Provide({allowOverride: "arrowIcon"}) arrowIcon: ResourceStr = "play"
    /**
     * 箭头图标大小
     */
    @Provide({allowOverride: "arrowIconSize"}) arrowIconSize: IBestStringNumber = this.baseStyle.fontSizeSm as string
    /**
     * 是否开启手风琴模式
     */
    @Provide({allowOverride: "accordion"}) accordion: boolean = false
    /**
     * 启用拖拽
     */
    @Provide({allowOverride: "enableDrag"}) enableDrag: boolean = false
    /**
     * 是否在点击节点的时候展开或者收起节点
     * @description 如果为 false，则只有点击箭头图标的时候才会展开或者收缩节点
     */
    @Provide({allowOverride: "expandOnClickNode"}) expandOnClickNode: boolean = true
    /**
     * 是否在点击节点的时候选中节点
     * @description 如果为 false，则只有点击单选/复选框的时候才会选中节点
     */
    @Provide({allowOverride: "selectOnClickNode"}) selectOnClickNode: boolean = false
    /**
     * 组件控制器
     */
    controller: IBestTreeController = new IBestTreeController()
    /**
     * 自定义节点内容
     */
    @BuilderParam nodeBuilder?: (node: IBestTreeNodeData) => void
    /**
     * 节点懒加载函数
     */
    lazyLoad?: (data: IBestTreeData, level: number, cb: (arr: IBestTreeData[]) => void) => void = undefined
    /**
     * 节点点击回调
     */
    onNodeClick: (data: IBestTreeData, level: number) => void = () => {}
    /**
     * 选择变化回调
     */
    onSelectChange: (data: IBestTreeData, level: number, selected?: boolean, indeterminate?: boolean) => void = () => {}
    /**
     * 拖拽回调
     */
    onNodeDrop: (dragNode: IBestTreeNodeData, dropNode: IBestTreeNodeData) => void = () => {}

    @Provide groupId: string = ""
    @Provide activeNode: IBestStringNumber = ""
    @State dataInstance: IBestTreeNodeData[] = []
    private flag: boolean = false
    private nodeId: number = 1

    aboutToAppear(): void {
        this.groupId = `IBest_Tree_${this.getUniqueId()}`
        if(this.selectType !== ''){
            this.controller.setCheckedNodes = (keys: IBestStringNumber[]): void => this.setCheckedNodes(keys)
            this.controller.getCheckedNodes = (): IBestTreeData[] => this.getCheckedNodes()
            this.controller.reset = (): void => this.reset()
        }
        this.init()
    }
    dataChange(){
        if(this.flag){
            this.flag = false
            return
        }
        this.nodeId = 1
        this.makeListData(this.data)
    }
    // 初始化
    init(){
        let data: IBestTreeData[] = this.formatData(this.data)
        this.data = data
        this.makeListData(data)
    }
    formatData(data: IBestTreeData[]){
        const dealData = (data: IBestTreeData[]) => {
            data.forEach(e => {
                e.$treeNodeId = this.nodeId++
                if(e.children){
                    dealData(e.children)
                }
            })
        }
        dealData(data)
        return data
    }
    makeListData(data: IBestTreeData[]){
        this.dataInstance = data.map(e => new IBestTreeNodeData(e))
    }
    // 节点展开
    nodeExpand(_data: IBestTreeData, _level: number, index: number){
        if(this.accordion){
            this.dataInstance.forEach((e, i) => {
                if(i !== index){
                    e.switchExpand(false)
                }
            })
        }
    }
    // 节点拖拽
    nodeDrop(dragNode: IBestTreeNodeData, dropNode: IBestTreeNodeData): void {
        this.flag = true
        this.data = moveNodeById(this.data, dragNode.$treeNodeId, dropNode.$treeNodeId)
        this.onNodeDrop(dragNode, dropNode)
    }
    // 单选
    onRadioChange(name: IBestStringNumber){
        let node = findNodeByKey(this.dataInstance, name)
        if(node){
            this.onSelectChange(getNodeData(node as IBestTreeNodeData), (node as IBestTreeNodeData)?.level)
        }
    }
    // 移除节点
    removeNode(dragNode: IBestTreeNodeData){
        let index = this.dataInstance.findIndex(e => e.$treeNodeId == dragNode.$treeNodeId)
        if(index > -1){
            this.dataInstance.splice(index, 1)
        }
    }
    // 通过key设置选中
    setCheckedNodes(keys: IBestStringNumber[]){
        if(!this.selectType){
            console.warn("请先设置selectType")
            return
        }
        if(this.selectType == 'multiple'){
            const setCheckedByKeys = (data: IBestTreeNodeData[]) => {
                data.forEach(e => {
                    e.selected = e.value != undefined && keys.includes(e.value)
                    if(e.children?.length){
                        if(e.selected){
                            setCheckedByVal(e.children, true)
                        }else {
                            setCheckedByKeys(e.children)
                            e.selected = e.children?.every(e => e.selected)
                            e.isIndeterminate = !e.selected && e.children?.some(e => e.selected)
                        }
                    }
                })
            }
            setCheckedByKeys(this.dataInstance)
        }else {
            this.activeNode = keys[0]
        }
    }
    // 通过key获取选中的节点
    getCheckedNodes(): IBestTreeData[]{
        if(!this.selectType){
            console.warn("请先设置selectType")
            return []
        }
        const result: IBestTreeData[] = []
        const traverse = (nodes: IBestTreeNodeData[]) => {
            for (const node of nodes) {
                if (this.selectType == 'multiple' && node.selected === true || this.selectType == 'single' && node.value === this.activeNode) {
                    result.push({
                        label: node.label,
                        value: node.value,
                        children: node.children
                    })
                }
                if (node.children?.length) {
                    traverse(node.children)
                }
                if(this.selectType == 'single' && result.length){
                    break
                }
            }
        }
        traverse(this.dataInstance)
        return result
    }
    // 重置
    reset(){
        if(!this.selectType){
            console.warn("请先设置selectType")
            return
        }
        if(this.selectType == 'multiple'){
            setCheckedByVal(this.dataInstance, false)
        }else {
            this.activeNode = ""
        }
    }

    build() {
        Scroll(){
            Column() {
                if (this.selectType == 'single'){
                    IBestRadioGroup({
                        group: this.groupId,
                        active: $activeNode,
                        onChange: (name: boolean | IBestStringNumber) => {
                            this.onRadioChange(name as IBestStringNumber)
                        }
                    })
                }
                ForEach(this.dataInstance, (item: IBestTreeNodeData, index: number) => {
                    IBestTreeNode({
                        data: item,
                        index: index,
                        nodeBuilder: this.nodeBuilder,
                        lazyLoad: this.lazyLoad,
                        onNodeClick: this.onNodeClick,
                        onSelectChange: this.onSelectChange,
                        onNodeExpand: (data: IBestTreeData, level: number, index: number): void => this.nodeExpand(data, level, index),
                        onNodeDrop: (dragNode: IBestTreeNodeData, dropNode: IBestTreeNodeData): void => this.nodeDrop(dragNode, dropNode),
                        onNodeDragEndSuccess: (dragNode: IBestTreeNodeData): void => this.removeNode(dragNode),
                        onRemoveNode: (node: IBestTreeNodeData): void => this.removeNode(node)
                    })
                }, (item: IBestTreeNodeData) => `${item.label}_${item.$treeNodeId}`)
            }
            .constraintSize({minWidth: CONTAINER_SIZE.FULL})
            .alignItems(HorizontalAlign.Start)
        }
        .width(CONTAINER_SIZE.FULL)
        .scrollable(ScrollDirection.Horizontal)
        .nestedScroll({
            scrollForward: NestedScrollMode.SELF_FIRST,
            scrollBackward: NestedScrollMode.SELF_FIRST
        })
        .backgroundColor(IBestTreeColor.bgColor)
    }
}

@Component
struct IBestTreeNode{
    @StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
    @Prop firstLevelId: number = 0
    @ObjectLink data: IBestTreeNodeData
    @Prop @Require index: number
    @Prop level: number = 0
    @Consume groupId: string = ""
    @Consume activeNode: IBestStringNumber = ""
    @Consume defaultExpandAll: boolean
    @Consume defaultExpandKeys: IBestStringNumber[]
    @Consume selectType: "" | "single" | "multiple"
    @Consume arrowIcon: ResourceStr
    @Consume arrowIconSize: IBestStringNumber
    @Consume accordion: boolean
    @Consume enableDrag: boolean
    @Consume expandOnClickNode: boolean
    @Consume selectOnClickNode: boolean
    @BuilderParam nodeBuilder?: (node: IBestTreeNodeData) => void
    lazyLoad?: (data: IBestTreeData, level: number, cb: (arr: IBestTreeData[]) => void) => void = undefined
    onNodeClick: (data: IBestTreeData, level: number) => void = () => {}
    onSelectChange: (data: IBestTreeData, level: number, selected?: boolean, indeterminate?: boolean) => void = () => {}
    onNodeExpand: (data: IBestTreeData, level: number, index: number) => void = () => {}
    onNodeDrop: (dragNode: IBestTreeNodeData, dropNode: IBestTreeNodeData) => void = () => {}
    onNodeDragEndSuccess: (dragNode: IBestTreeNodeData) => void = () => {}
    onRemoveNode: (data: IBestTreeNodeData) => void = () => {}

    @State isReady: boolean = false
    @State isExpand: boolean = false
    @State isLoading: boolean = false
    @State isDragEnter: boolean = false
    private uniId: number = 0

    aboutToAppear(){
        this.uniId = this.getUniqueId()
    }
    onDidBuild(): void {
        this.data.groupId = this.groupId
        this.data.level = this.level
        this.data.switchExpand = (val: boolean): void => this.switchExpand(val)
        this.data.append = (data: IBestTreeData): void => this.appendNode(data)
        this.data.remove = (): void => this.remove()
        if(this.defaultExpandAll){
            this.isExpand = true
        }else if(this.defaultExpandKeys.length && this.data.value){
            this.isExpand = this.defaultExpandKeys.includes(this.data.value)
        }
        this.data.firstLevelId = this.level == 0 ? this.uniId : this.firstLevelId
        setTimeout(() => {
            this.isReady = true
        }, 220)
    }
    // 节点点击
    nodeClick(type: "node" | "icon"){
        this.onNodeClick(getNodeData(this.data), this.level)
        if(type == "icon" || this.expandOnClickNode){
            this.changeExpand()
        }
        if(this.selectOnClickNode && !this.data.disabled){
            if(this.selectType == "multiple"){
                this.selectedChange(!this.data.selected)
            }else if(this.data.value) {
                this.activeNode = this.data.value
            }
        }
    }
    // 展开/折叠
    changeExpand(){
        const isExpand = this.isExpand
        if(isExpand){   // 收起
            this.switchExpand(false)
        }else if(!this.data.children?.length && !(this.data.isLeaf === true) && this.lazyLoad){   // 展开
            this.isLoading = true
            this.lazyLoad(getNodeData(this.data), this.level, (arr: IBestTreeData[]) => {
                if(arr.length){
                    this.data.children = arr.map(e => new IBestTreeNodeData(e))
                    this.switchExpand(true)
                    this.onNodeExpand(getNodeData(this.data), this.level, this.index)
                }else {
                    this.data.isLeaf = true
                }
                this.isLoading = false
            })
        }else {
            this.switchExpand(true)
            this.onNodeExpand(getNodeData(this.data), this.level, this.index)
        }
    }
    // 折叠
    switchExpand(val: boolean){
        this.isExpand = val
    }
    // 节点展开
    nodeExpand(_data: IBestTreeData, _level: number, index: number){
        if(this.accordion){
            this.data.children!.forEach((e, i) => {
                if(i !== index){
                    e.switchExpand(false)
                }
            })
        }
    }
    // 选中切换
    selectedChange(val: boolean){
        if(this.data.children?.length){    // 有子节点
            this.dealChildren(this.data.children, this.data.isIndeterminate ? false : val)
            this.data.selected = this.data.children?.every(e => e.selected)
            this.data.isIndeterminate = !this.data.selected && this.data.children!.some(e => e.selected || e.isIndeterminate)
        }else{  // 无子节点
            this.data.isIndeterminate = false
            this.data.selected = val
        }
        this.onSelectChange(getNodeData(this.data), this.level, this.data.selected as boolean, this.data.isIndeterminate)
    }
    // 递归处理子节点选中状态
    dealChildren(children: IBestTreeNodeData[], selected: boolean){
        children.forEach(e => {
            if(!selected || !e.disabled){
                e.selected = selected
            }
            if(e.children){
                this.dealChildren(e.children, selected)
            }
        })
    }
    // 子节点选中切换
    onCheckedChange(data: IBestTreeData, level: number, selected?: boolean, indeterminate?: boolean){
        this.data.selected = this.data.children?.every(e => e.selected)
        this.data.isIndeterminate = !this.data.selected && this.data.children!.some(e => e.selected || e.isIndeterminate)
        this.onSelectChange(data, level, selected, indeterminate)
    }
    // 添加节点
    appendNode(data: IBestTreeData){
        let children: IBestTreeNodeData[] = JSON.parse(JSON.stringify(this.data.children))
        children.push(new IBestTreeNodeData(data))
        this.data.children = children
    }
    // 删除当前节点
    remove(){
        this.onRemoveNode(this.data)
    }
    // 删除指定节点
    removeNode(node: IBestTreeNodeData){
        let children: IBestTreeNodeData[] = JSON.parse(JSON.stringify(this.data.children))
        let index = children.findIndex(e => e.$treeNodeId == node.$treeNodeId)
        if(index > -1){
            children.splice(index, 1)
            this.data.children = children
        }
    }
    // 获取拖拽数据
    getDragData(event: DragEvent){
        let treeData: IBestTreeNodeData | undefined
        try {
            let data: UnifiedData = event.getData()
            if (data) {
                let records: Array<unifiedDataChannel.UnifiedRecord> = data.getRecords()
                if (records && records.length) {
                    let plainText: unifiedDataChannel.PlainText = records[0] as unifiedDataChannel.PlainText
                    treeData = JSON.parse(plainText.textContent)
                }
            }
        } catch (e) {
            console.error("getData failed" + (e as BusinessError).code + ", message: " + (e as BusinessError).message);
        }
        return treeData
    }
    dragStart(event: DragEvent){
        if(!this.enableDrag){
            return
        }
        // console.log("onDragStart")
        let data = new unifiedDataChannel.PlainText()
        data.textContent = JSON.stringify(this.data)
        event.setData(new unifiedDataChannel.UnifiedData(data))
    }
    dragEnter(event: DragEvent){
        if(!this.enableDrag){
            return
        }
        // console.log("onDragEnter")
        this.isDragEnter = true
        event.setResult(DragResult.DROP_ENABLED)
        event.dragBehavior = DragBehavior.MOVE
    }
    dragMove(event: DragEvent){
        if(!this.enableDrag){
            return
        }
        event.setResult(DragResult.DROP_ENABLED)
        event.dragBehavior = DragBehavior.MOVE
    }
    dragLeave(){
        if(!this.enableDrag){
            return
        }
        // console.log("onDragLeave", this.data.label)
        this.isDragEnter = false
    }
    drop(event: DragEvent){
        if(!this.enableDrag){
            return
        }
        // console.log("onDrop")
        let dragData = this.getDragData(event)
        this.isDragEnter = false
        if(!dragData){
            event.setResult(DragResult.DRAG_FAILED)
            return
        }
        if(dragData.groupId != this.data.groupId){
            event.setResult(DragResult.DRAG_FAILED)
            return
        }
        if(dragData.$treeNodeId == this.data.$treeNodeId) {
            event.setResult(DragResult.DRAG_FAILED)
            return
        }
        if(dragData.firstLevelId == this.data.firstLevelId && dragData.level < this.data.level){
            event.setResult(DragResult.DRAG_FAILED)
            return
        }
        event.setResult(DragResult.DRAG_SUCCESSFUL)
        let children: IBestTreeNodeData[] = JSON.parse(JSON.stringify(this.data.children))
        children.push(new IBestTreeNodeData(dragData as IBestTreeData))
        this.data.children = children
        this.onNodeDrop(dragData, this.data)
        setTimeout(() => {
            this.isExpand = true
        }, 50)
    }
    dragEnd(event: DragEvent){
        let result = event.getResult()
        this.isDragEnter = false
        if(result == DragResult.DRAG_SUCCESSFUL){
            // console.log("onDragEnd")
            this.onNodeDragEndSuccess(this.data)
        }
    }

    build() {
        Column(){
            Row(){
                Row(){
                    IBestIcon({ name: this.arrowIcon, iconSize: this.arrowIconSize, color: "#c8c9cc" })
                }
                .padding({left: this.baseStyle.spaceX, right: this.baseStyle.spaceX})
                .rotate({z: 1, angle: this.isExpand ? 90 : 0})
                .animation({duration: this.isReady ? 200 : 0})
                .visibility(this.lazyLoad && !(this.data.isLeaf === true) || this.data.children?.length ? Visibility.Visible : Visibility.Hidden)
                .onClick(() => {
                    this.nodeClick("icon")
                })
                if(this.selectType == 'multiple'){
                    IBestCheckbox({
                        value: this.data.selected,
                        shape: "square",
                        radius: 2,
                        iconSize: this.baseStyle.fontSizeMd as string,
                        indeterminate: this.data.isIndeterminate,
                        disabled: this.data.disabled,
                        onChange: checked => {
                            this.selectedChange(checked as boolean)
                        }
                    }).margin({right: this.baseStyle.spaceXs})
                }
                if(this.selectType == 'single'){
                    IBestRadio({
                        group: this.groupId,
                        name: this.data.value,
                        iconSize: this.baseStyle.fontSizeMd as string,
                        disabled: this.data.disabled
                    }).margin({right: this.baseStyle.spaceXs})
                }
                if(this.isLoading){
                    IBestLoading({
                        loadingIconType: "spinner",
                        loadingSize: this.baseStyle.fontSizeMd as string,
                        loadingStrokeWidth: 1,
                        spinnerStrokeHeight: 4
                    }).margin({right: this.baseStyle.spaceXs})
                }
                if(this.nodeBuilder){
                    this.nodeBuilder(this.data)
                }else {
                    Text(this.data.label)
                        .fontSize(this.baseStyle.fontSizeMd)
                        .fontColor(IBestTreeColor.textColor)
                        .draggable(false)
                }
            }
            .constraintSize({minWidth: CONTAINER_SIZE.FULL, minHeight: 30})
            .padding({left: `calc(${this.level} * ${this.baseStyle.spaceSm})`, right: this.baseStyle.spaceSm})
            .stateStyles({
                normal: {
                    .backgroundColor(this.isDragEnter ? IBestTreeColor.activeBgColor : Color.Transparent)
                },
                pressed: {
                    .backgroundColor(IBestTreeColor.activeBgColor)
                }
            })
            .onClick(() => {
                this.nodeClick("node")
            })
            .allowDrop(this.enableDrag ? [uniformTypeDescriptor.UniformDataType.PLAIN_TEXT] : null)
            .onDragEnter((event: DragEvent): void => this.dragEnter(event))
            .onDragMove((event): void => this.dragMove(event))
            .onDragLeave((): void => this.dragLeave())
            .onDrop((event: DragEvent): void => this.drop(event))
            if(this.data.children?.length){
                Column(){
                    ForEach(this.data.children, (item: IBestTreeNodeData, index: number) => {
                        IBestTreeNode({
                            firstLevelId: this.uniId,
                            data: item,
                            index: index,
                            level: this.level + 1,
                            nodeBuilder: this.nodeBuilder,
                            lazyLoad: this.lazyLoad,
                            onNodeClick: this.onNodeClick,
                            onSelectChange: (data: IBestTreeData, level: number, selected?: boolean, indeterminate?: boolean): void => this.onCheckedChange(data, level, selected, indeterminate),
                            onNodeExpand: (data: IBestTreeData, level: number, index: number): void => this.nodeExpand(data, level, index),
                            onNodeDrop: this.onNodeDrop,
                            onNodeDragEndSuccess: (dragNode: IBestTreeNodeData): void => this.removeNode(dragNode),
                            onRemoveNode: (node: IBestTreeNodeData): void => this.removeNode(node)
                        })
                    }, (item: IBestTreeNodeData) => `${item.label}_${item.$treeNodeId}`)
                }
                .constraintSize({minWidth: CONTAINER_SIZE.FULL})
                .alignItems(HorizontalAlign.Start)
                .visibility(this.isExpand ? Visibility.Visible : Visibility.None)
                .animation({duration: this.isReady ? 200 : 0})
            }
        }
        .constraintSize({minWidth: CONTAINER_SIZE.FULL})
        .alignItems(HorizontalAlign.Start)
        .draggable(this.enableDrag)
        .onDragStart((event: DragEvent): void => this.dragStart(event))
        .onDragEnd((event: DragEvent): void => this.dragEnd(event))
    }
}