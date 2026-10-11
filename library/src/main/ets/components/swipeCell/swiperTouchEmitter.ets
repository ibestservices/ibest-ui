interface PageTouchListener {
    listenerId: number
    callback: (event: TouchEvent) => void
}

interface PageEntry {
    pageId: number
    listeners: PageTouchListener[]
}

class IBestSwipeCellEmitter {
    private pages: PageEntry[] = []
    /**
     * 根据 UIContext 获取页面根节点 ID，如果根节点不存在则返回 -1
     */
    private getPageId(uiContext: UIContext): number {
        const rootFrameNode = uiContext.getPageRootNode()
        return rootFrameNode ? rootFrameNode.getUniqueId() : -1
    }
    /**
     * 确保根节点只绑定一次 setOnTouch
     */
    ensureInstalled(uiContext: UIContext): void {
        const pageId = this.getPageId(uiContext)
        if (pageId === -1 || this.pages.some(e => e.pageId === pageId)) {
            return
        }
        this.pages.push({ pageId, listeners: [] })
        const rootFrameNode = uiContext.getPageRootNode()!
        rootFrameNode.commonEvent.setOnTouch((event: TouchEvent) => {
            const page = this.pages.find(e => e.pageId === pageId)
            if (!page) {
                return
            }
            const snapshot = page.listeners.slice()
            for (let i = 0; i < snapshot.length; i++) {
                snapshot[i].callback(event)
            }
        })
    }
    /**
     * 子组件注册自己的触摸回调
     */
    add(uiContext: UIContext, id: number, callback: (event: TouchEvent) => void): void {
        const pageId = this.getPageId(uiContext)
        if (pageId === -1) {
            return
        }
        const page = this.pages.find(e => e.pageId === pageId)
        if (!page) {
            return
        }
        const existIndex = page.listeners.findIndex(e => e.listenerId === id)
        if (existIndex > -1) {
            page.listeners.splice(existIndex, 1)
        }
        page.listeners.push({ listenerId: id, callback })
    }
    /**
     * 子组件销毁时移除自己的回调
     */
    remove(uiContext: UIContext, id: number): void {
        const pageId = this.getPageId(uiContext)
        if (pageId === -1) {
            return
        }
        const page = this.pages.find(e => e.pageId === pageId)
        if (!page) {
            return
        }
        const index = page.listeners.findIndex(e => e.listenerId === id)
        if (index > -1) {
            page.listeners.splice(index, 1)
        }
    }
    /**
     * 页面销毁时清理该页面所有监听器，防止内存泄漏
     */
    removePage(uiContext: UIContext): void {
        const pageId = this.getPageId(uiContext)
        if (pageId === -1) {
            return
        }
        const index = this.pages.findIndex(e => e.pageId === pageId)
        if (index > -1) {
            this.pages.splice(index, 1)
        }
    }
}

const ibestSwipeCellEmitter = new IBestSwipeCellEmitter()
export default ibestSwipeCellEmitter