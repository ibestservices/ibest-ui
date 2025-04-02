
export default class RouterUtil {
    public static navPathStackList: NavPathStack[] = []
    // 获取当前路由栈
    public static get navPathStack(): NavPathStack {
        return RouterUtil.navPathStackList.length ? RouterUtil.navPathStackList[RouterUtil.navPathStackList.length - 1] : new NavPathStack()
    }
    // 跳转页面
    public static push(name: string, param: Object | undefined = undefined, callback: Callback<PopInfo> | undefined = undefined) {
        RouterUtil.navPathStack.pushDestinationByName(name, param, callback, true)
    }
    // 替换当前页面
    public static replace(name: string, param: Object | undefined = undefined) {
        RouterUtil.navPathStack.pop()
        RouterUtil.navPathStack.replacePathByName(name, param, true)
    }
    // 返回页面
    public static pop(result?: Object) {
        if (result !== undefined) {
            RouterUtil.navPathStack.pop(result, true)
        } else {
            RouterUtil.navPathStack.pop(true)
        }
    }
    // 返回首页
    public static popHome(){
        RouterUtil.navPathStack.clear()
        RouterUtil.navPathStackList.pop()
    }
}