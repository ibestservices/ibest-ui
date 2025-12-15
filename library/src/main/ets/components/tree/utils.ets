import { IBestStringNumber } from "../../model/Global.type"
import { IBestTreeData, IBestTreeNodeData } from "./index.type"

export function moveNodeById(treeData: IBestTreeData[], fromId: number, toId: number): IBestTreeData[] {
    // 深拷贝数据，避免修改原数据
    let data: IBestTreeData[] = JSON.parse(JSON.stringify(treeData))
    let fromNode: IBestTreeData | null = null
    let toNode: IBestTreeData | null = null
    let parentNode: IBestTreeData | null = null
    // 查找源节点和目标节点，同时记录源节点的父节点
    const findNodes = (node: IBestTreeData, parent: IBestTreeData | null = null) => {
        if (node.$treeNodeId === fromId) {
            fromNode = node
            parentNode = parent as IBestTreeData
        }
        if (node.$treeNodeId === toId) {
            toNode = node
        }
        if(fromNode && toNode){
            return true
        }
        if (node.children && node.children.length > 0) {
            for (let i = 0; i < node.children.length; i++) {
                if (findNodes(node.children[i], node)) {
                    return true
                }
            }
        }
        return false
    }
    // 在整棵树中查找
    for (let i = 0; i < data.length; i++) {
        if (findNodes(data[i])) {
            break
        }
    }
    // 检查是否找到节点
    if (!fromNode) {
        console.error(`未找到id为${fromId}的拖拽节点`);
        return data;
    }
    if (!toNode) {
        console.error(`未找到id为${toId}的拖入节点`);
        return data;
    }
    // 从原位置移除源节点
    if (parentNode) {
        const index = (parentNode as IBestTreeData).children!.findIndex(e => e.$treeNodeId === fromNode!.$treeNodeId)
        if (index > -1) {
            (parentNode as IBestTreeData).children!.splice(index, 1)
        }
    } else {
        const index = data.findIndex(e => e.$treeNodeId === fromNode!.$treeNodeId)
        if (index > -1) {
            data.splice(index, 1)
        }
    }
    // 确保目标节点有children数组
    if (!(toNode as IBestTreeData).children) {
        (toNode as IBestTreeData).children = []
    }
    // 将源节点添加到目标节点的children中
    (toNode as IBestTreeData).children!.push(fromNode)
    return data
}

export function setCheckedByVal(data: IBestTreeNodeData[], checked: boolean) {
    data.forEach(e => {
        e.selected = checked
        e.isIndeterminate = false
        if(e.children?.length){
            setCheckedByVal(e.children, checked)
        }
    })
}

export function findNodeByKey(data: IBestTreeData[], key: IBestStringNumber): IBestTreeData | undefined{
    for (let i = 0; i < data.length; i++) {
        if(data[i].value === key){
            return data[i]
        }
    }
    for (let i = 0; i < data.length; i++) {
        if(data[i].children?.length){
            const result = findNodeByKey(data[i].children!, key)
            if(result){
                return result
            }
        }
    }
    return undefined
}

export function getNodeData(data: IBestTreeNodeData): IBestTreeData{
    return {
        label: data.label,
        value: data.value,
        isLeaf: data.isLeaf,
        disabled: data.disabled,
        children: data.children
    }
}