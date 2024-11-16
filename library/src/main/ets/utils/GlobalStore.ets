import window from '@ohos.window';
import font from '@ohos.font';
import { getWindowAvoidSize } from './utils';
import { common } from '@kit.AbilityKit';
import { IBestGlobalConfig, IBestGlobalConfigType } from '../model/Global.type';
import { setIBestUIBaseStyle } from '../theme-chalk/src';

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
	/**
	 * 初始化
	 */
	public static init(windowStage: window.WindowStage, context: common.BaseContext){
		GlobalStore.windowStage = windowStage
		// 获取顶部和底部规避尺寸
		getWindowAvoidSize(context).then(res => {
			GlobalStore.topAvoidHeight = res.topSize
			GlobalStore.bottomBarHeight = res.navigationSize
		})
		GlobalStore.getScreenSize(windowStage)
		// 注册字体
		font.registerFont({
			familyName: 'ibestFont',
			familySrc: $rawfile('vant_font.woff')
		})
	}
	/**
	 * 获取屏幕尺寸
     */
	private static getScreenSize(windowStage: window.WindowStage){
		let mainWindow = windowStage.getMainWindowSync()
		let screenInfo: window.WindowProperties = mainWindow.getWindowProperties()
		GlobalStore.screenWidth = screenInfo.windowRect.width
		GlobalStore.screenHeight = screenInfo.windowRect.height
		console.log("屏幕宽度", GlobalStore.screenWidth)
	}
	/**
	 * 设置全局配置
	 */
	public static setGlobalConfig(option?: IBestGlobalConfigType){
		AppStorage.setOrCreate("iBestGlobalConfig", new IBestGlobalConfig(option))
		setIBestUIBaseStyle()
	}
}