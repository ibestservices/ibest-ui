import window from '@ohos.window'
import { getWindowAvoidSize } from '../assets/ets/utils'
import { common } from '@kit.AbilityKit'
// 全局存储中心
export default class GlobalStore {
	// windowStage
	public static windowStage: window.WindowStage | null = null
	// 底部导航条高度
	public static bottomBarHeight: number = 0
	// 初始化
	public static init(windowStage: window.WindowStage, context: common.BaseContext){
		GlobalStore.windowStage = windowStage
		getWindowAvoidSize(context).then(res => {
			GlobalStore.bottomBarHeight = res.navigationSize
		})
	}
}