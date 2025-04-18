import window from '@ohos.window';
import font from '@ohos.font';
import { getWindowAvoidSize } from './utils';
import { bundleManager, common } from '@kit.AbilityKit';
import { IBestGlobalConfig, IBestGlobalConfigType } from '../model/Global.type';
import { setIBestUIBaseStyle } from '../theme-chalk/src';
import { display } from '@kit.ArkUI';

// 全局存储中心
export default class GlobalStore {
	// windowStage
	public static windowStage: window.WindowStage
	// context
	public static context: common.UIAbilityContext
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
		// 获取是否是应用
		GlobalStore.getBundleType()
		// 设置旋转监听
		GlobalStore.screenRotateListener()
		// 监听颜色模式变化
		GlobalStore.setColorModeListener()
		// 注册字体
		font.registerFont({
			familyName: 'ibestFont',
			familySrc: $rawfile('vant_font.woff')
		})
	}
	/**
	 * 获取规避尺寸
     */
	private static getAvoidSize(){
		let res = getWindowAvoidSize()
		AppStorage.setOrCreate("IBestTopAvoidHeight", res.topSize)
		AppStorage.setOrCreate("IBestBottomBarHeight", res.navigationSize)
	}
	/**
	 * 获取屏幕尺寸
     */
	private static getScreenSize(){
		try {
			let mainWindow = GlobalStore.windowStage.getMainWindowSync()
			let screenInfo: window.WindowProperties = mainWindow.getWindowProperties()
			let o = display.getDefaultDisplaySync().orientation
			let screenWidth = screenInfo.windowRect.width
			let screenHeight = screenInfo.windowRect.height
			GlobalStore.screenWidth = screenInfo.windowRect.width
			GlobalStore.screenHeight = screenInfo.windowRect.height
			AppStorage.setOrCreate("IBestIsLandscape", o == 1 || o == 3)
			AppStorage.setOrCreate("IBestScreenWidth", px2vp(screenWidth))
			AppStorage.setOrCreate("IBestScreenHeight", px2vp(screenHeight))
			mainWindow.on("avoidAreaChange", data => {
				if (data.type == window.AvoidAreaType.TYPE_KEYBOARD) {
					AppStorage.setOrCreate("IBestKeyBoardHeight", px2vp(data.area.bottomRect.height))
				}
			})
		}catch (e) {
			throw new Error(e)
		}
	}
	/**
	 * 监听屏幕旋转
	 */
	private static screenRotateListener() {
		display.on("change", () => {
			setTimeout(() => {
				GlobalStore.getScreenSize()
				GlobalStore.getAvoidSize()
			}, 300)
		})
	}
	/**
	 * 监听颜色模式变化
     */
	private static setColorModeListener(){
		let appContext = GlobalStore.context.getApplicationContext()
		AppStorage.setOrCreate("IBestColorMode", GlobalStore.context.config.colorMode)
		AppStorage.setOrCreate("IBestLanguage", GlobalStore.context.config.language)
		appContext.on('environment', {
			onConfigurationUpdated(config) {
				// console.log("onConfigurationUpdated", config.language)
				// 0 深色  1 浅色
				AppStorage.setOrCreate("IBestColorMode", config.colorMode)
				AppStorage.setOrCreate("IBestLanguage", config.language)
			},
			onMemoryLevel() {}
		})
	}
	/**
	 * 获取是否是元服务
	 */
	private static getBundleType(){
		AppStorage.setOrCreate("IBestIsApp", bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION).appInfo.bundleType == bundleManager.BundleType.APP)
	}
	/**
	 * 设置全局配置
	 */
	public static setGlobalConfig(option?: IBestGlobalConfigType){
		AppStorage.setOrCreate("IBestGlobalConfig", new IBestGlobalConfig(option))
		setIBestUIBaseStyle()
	}
}