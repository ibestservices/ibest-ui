import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import { IBestInit, IBestSetGlobalConfig } from '@ibestservices/ibest-ui';
import { ConfigurationConstant } from '@kit.AbilityKit';
import GlobalStore from '../utils/global';

export default class EntryAbility extends UIAbility {
	onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
		let applicationContext = this.context.getApplicationContext()
		applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
	}
	onWindowStageCreate(windowStage: window.WindowStage): void {
		let mainWindow = windowStage.getMainWindowSync()
		mainWindow.setWindowLayoutFullScreen(true)
		windowStage.loadContent('pages/Splash', (err, data) => {
			GlobalStore.init(windowStage, this.context)
			// 组件库初始化
			IBestInit(windowStage, this.context)
			// 注册自定义字体图标
			mainWindow.getUIContext().getFont().registerFont({
				familyName: 'testFont',
				familySrc: $rawfile('iconfont.woff')
			})
		})
	}

	// onConfigurationUpdate(newConfig: Configuration): void {
	// 	console.log("onConfigurationUpdate", newConfig.colorMode)
	// }
	// onWindowStageDestroy(): void {
	// Main window is destroyed, release UI related resources
	// }

	// onForeground(): void {
	// Ability has brought to foreground
	// }

	// onBackground(): void {
	// Ability has back to background
	// }
}
