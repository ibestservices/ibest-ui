import GlobalStore from './global'
import { window } from '@kit.ArkUI'
import { bundleManager, common } from '@kit.AbilityKit'
import { ComAvoidAreaSize } from '../assets/global.type'

/**
 * 获取随机色
 */
export function getRandomColor(): string {
    return '#' + Math.floor(Math.random()*16777215).toString(16).padStart(6, '0')
}
/**
 * 获取窗口域尺寸信息
 * */
export const getWindowAvoidSize = async (context: common.BaseContext): Promise<ComAvoidAreaSize> => {
    let windowStage = GlobalStore.windowStage
    let mainWindow: window.Window = windowStage ? windowStage.getMainWindowSync() : await window.getLastWindow(context)
    let avoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
    let systemDht = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
    // console.log("avoidArea", JSON.stringify(avoidArea))
    // console.log("systemDht.bottomRect", JSON.stringify(systemDht))
    return {
        topSize: px2vp(avoidArea.topRect.height),
        bottomSize: px2vp(avoidArea.bottomRect.height),
        leftSize: px2vp(avoidArea.leftRect.width),
        rightSize: px2vp(avoidArea.rightRect.width),
        navigationSize: px2vp(systemDht.bottomRect.height)
    }
}
/**
 * 获取应用版本
 */
export function getAppVersion(){
    return bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).versionName
}