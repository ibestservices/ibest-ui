import window from '@ohos.window';
import { getWindowAvoidSize } from './utils';
import { common } from '@kit.AbilityKit';
import { display } from '@kit.ArkUI';
// 全局存储中心
export default class GlobalStore {
    // windowStage
    public static windowStage: window.WindowStage
    // context
    public static context: common.UIAbilityContext
    // 顶部规避尺寸
    public static topAvoidHeight: number = 0
    // 底部导航条高度
    public static bottomBarHeight: number = 0
    // 屏幕信息
    public static screenWidth: number = 0
    public static screenHeight: number = 0
    /**
     * 初始化
     */
    public static init(windowStage: window.WindowStage, context: common.UIAbilityContext){
        GlobalStore.windowStage = windowStage
        GlobalStore.context = context
        // 获取顶部和底部规避尺寸
        GlobalStore.getAvoidSize()
        // 获取屏幕尺寸
        GlobalStore.getScreenSize()
    }
    /**
     * 获取规避尺寸
     */
    private static getAvoidSize(){
        getWindowAvoidSize(GlobalStore.context).then(res => {
            // console.log('getWindowAvoidSize', res.topSize, res.navigationSize)
            GlobalStore.topAvoidHeight = res.topSize
            GlobalStore.bottomBarHeight = res.navigationSize
        })
    }
    /**
     * 获取屏幕尺寸
     */
    private static getScreenSize(){
        let mainWindow = GlobalStore.windowStage.getMainWindowSync()
        let screenInfo: window.WindowProperties = mainWindow.getWindowProperties()
        let o = display.getDefaultDisplaySync().orientation
        GlobalStore.screenWidth = o == 1 || o == 3 ? screenInfo.windowRect.height : screenInfo.windowRect.width
        GlobalStore.screenHeight = o == 1 || o == 3 ? screenInfo.windowRect.width : screenInfo.windowRect.height
    }
}