import window from '@ohos.window';
import font from '@ohos.font';
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
		// 获取屏幕尺寸 顶部和底部规避尺寸
		GlobalStore.getScreenAndAvoidSize()
		// 获取是否是应用
		GlobalStore.getBundleType()
		// 设置旋转监听
		GlobalStore.screenRotateListener()
		// 监听颜色模式变化
		GlobalStore.setColorModeListener()
		// 注册字体
		windowStage.getMainWindowSync().getUIContext().getFont().registerFont({
			familyName: 'ibestFont',
			familySrc: $rawfile('ibest_font.woff')
		})
	}
	/**
	 * 获取规避尺寸
     */
	private static getScreenAndAvoidSize(){
		try {
			const mainWindow: window.Window = GlobalStore.getMainWindow()
			const screenInfo: window.WindowProperties = mainWindow.getWindowProperties()
			const avoidArea = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
			const systemDht = mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
			const topSize = GlobalStore.px2vp(avoidArea.topRect.height)
			const navigationSize = GlobalStore.px2vp(systemDht.bottomRect.height)
			const o = display.getDefaultDisplaySync().orientation
			const screenWidth = screenInfo.windowRect.width
			const screenHeight = screenInfo.windowRect.height
			GlobalStore.screenWidth = screenInfo.windowRect.width
			GlobalStore.screenHeight = screenInfo.windowRect.height
			AppStorage.setOrCreate("IBestIsLandscape", o == 1 || o == 3)
			AppStorage.setOrCreate("IBestScreenWidth", GlobalStore.px2vp(screenWidth))
			AppStorage.setOrCreate("IBestScreenHeight", GlobalStore.px2vp(screenHeight))
			AppStorage.setOrCreate("IBestTopAvoidHeight", topSize)
			AppStorage.setOrCreate("IBestBottomBarHeight", navigationSize)
			mainWindow.on("avoidAreaChange", data => {
				if (data.type == window.AvoidAreaType.TYPE_KEYBOARD) {
					AppStorage.setOrCreate("IBestKeyBoardHeight", GlobalStore.px2vp(data.area.bottomRect.height))
				}
			})
		}catch (e) {
			console.error(e.code, e.message)
		}
	}
	/**
	 * 监听屏幕旋转
	 */
	private static screenRotateListener() {
		display.on("change", () => {
			setTimeout(() => {
				GlobalStore.getScreenAndAvoidSize()
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
	/**
	 * 获取mainWindow
     */
	public static getMainWindow(){
		return GlobalStore.windowStage.getMainWindowSync()
	}
	/**
	 * 尺寸转换
     */
	public static px2vp(value: number){
		return GlobalStore.getMainWindow().getUIContext().px2vp(value)
	}
	public static vp2px(value: number){
		return GlobalStore.getMainWindow().getUIContext().vp2px(value)
	}
}