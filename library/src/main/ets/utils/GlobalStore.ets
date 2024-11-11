import window from '@ohos.window'
import font from '@ohos.font';
import { getWindowAvoidSize } from '../assets/ets/utils'
import { common } from '@kit.AbilityKit'
// 全局存储中心
export default class GlobalStore {
	// windowStage
	public static windowStage: window.WindowStage | null = null
	// 顶部规避尺寸
	public static topAvoidHeight: number = 0
	// 底部导航条高度
	public static bottomBarHeight: number = 0
	// 屏幕信息
	public static screenWidth: number = 0
	public static screenHeight: number = 0
	// 初始化
	public static init(windowStage: window.WindowStage, context: common.BaseContext){
		let mainWindow = windowStage.getMainWindowSync()
		let screenInfo: window.WindowProperties = mainWindow.getWindowProperties()
		// console.log('screenInfo: ' + JSON.stringify(screenInfo))
		GlobalStore.windowStage = windowStage
		getWindowAvoidSize(context).then(res => {
			GlobalStore.topAvoidHeight = res.topSize
			GlobalStore.bottomBarHeight = res.navigationSize
		})
		GlobalStore.screenWidth = screenInfo.windowRect.width
		GlobalStore.screenHeight = screenInfo.windowRect.height
		font.registerFont({
			familyName: 'ibestFont',
			familySrc: $rawfile('vant_font.woff')
		})
	}
}