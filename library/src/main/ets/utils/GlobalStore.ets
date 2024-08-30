import window from '@ohos.window'

// 全局存储中心
export default class GlobalStore {
	// windowStage
	public static windowStage: window.WindowStage | null = null
	// 初始化
	public static init(windowStage: window.WindowStage){
		GlobalStore.windowStage = windowStage
	}
}