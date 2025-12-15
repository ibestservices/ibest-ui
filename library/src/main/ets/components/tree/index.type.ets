import { IBestStringNumber } from "../../model/Global.type"

export class IBestTreeData{
    $treeNodeId?: number
    /**
     * 节点名称
     */
    label: ResourceStr = ''
    /**
     * 节点值
     */
    value?: IBestStringNumber
    /**
     * 是否是叶子节点，仅在传入了lazyLoad函数时有效
     */
    isLeaf?: boolean
    /**
     * 当前节点是否禁用，仅selectType不为空时生效
     */
    disabled?: boolean
    /**
     * 子节点数据
     */
    children?: IBestTreeData[]
}

@Observed
export class IBestTreeNodeData extends IBestTreeData{
    groupId: string = ''
    firstLevelId: number = 0
    $treeNodeId: number
    level: number = 0
    selected: boolean = false
    isIndeterminate: boolean = false
    children: IBestTreeNodeData[]
    switchExpand: (val: boolean) => void = () => {}
    append: (data: IBestTreeData) => void = () => {}
    remove: () => void = () => {}
    constructor(data: IBestTreeData) {
        super()
        this.label = data.label
        this.$treeNodeId = data.$treeNodeId ?? 0
        this.value = data.value ?? ''
        this.disabled = data.disabled ?? false
        this.isLeaf = data.isLeaf ?? false
        this.selected = false
        this.isIndeterminate = false
        this.children = data.children ? data.children.map(item => new IBestTreeNodeData(item)) : []
    }
}

export class IBestTreeController{
    /**
     * 设置选中节点，仅selectType不为空时可用
     */
    setCheckedNodes: (keys: IBestStringNumber[]) => void = () => {}
    /**
     * 获取选中节点，仅selectType不为空时可用
     */
    getCheckedNodes: () => IBestTreeData[] = () => []
    /**
     * 重置选中，仅selectType不为空时可用
     */
    reset: () => void = () => {}
}