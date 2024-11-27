import window from '@ohos.window';
import font from '@ohos.font';
import { getWindowAvoidSize } from './utils';
import { common } from '@kit.AbilityKit';
import { IBestGlobalConfig, IBestGlobalConfigType } from '../model/Global.type';
import { setIBestUIBaseStyle } from '../theme-chalk/src';
import { display } from '@kit.ArkUI';
import mediaquery from '@ohos.mediaquery';
import { emitter } from './EventEmitter';
// 全局存储中心
export default class GlobalStore {
	// windowStage
	public static windowStage: window.WindowStage
	// context
	public static context: common.BaseContext
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
		GlobalStore.context = context
		// 获取顶部和底部规避尺寸
		GlobalStore.getAvoidSize()
		// 获取屏幕尺寸
		GlobalStore.getScreenSize()
		// 设置旋转监听
		GlobalStore.screenRotateListener()
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
		AppStorage.setOrCreate("isLandscape", o == 1 || o == 3)
	}
	/**
	 * 监听屏幕旋转
	 */
	private static screenRotateListener() {
		let listener = mediaquery.matchMediaSync('(orientation: landscape)')
		listener.on('change', () => {
			GlobalStore.getAvoidSize()
			GlobalStore.getScreenSize()
		})
	}
	/**
	 * 设置全局配置
	 */
	public static setGlobalConfig(option?: IBestGlobalConfigType){
		AppStorage.setOrCreate("iBestGlobalConfig", new IBestGlobalConfig(option))
		setIBestUIBaseStyle()
	}
}