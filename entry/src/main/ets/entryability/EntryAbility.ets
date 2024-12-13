import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import { IBestInit, IBestSetGlobalConfig } from '@ibestservices/ibest-ui';
import { Configuration, ConfigurationConstant } from '@kit.AbilityKit';
export default class EntryAbility extends UIAbility {
	onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
		let applicationContext = this.context.getApplicationContext()
		applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET)
	}
	// onDestroy(): void {
		// hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
	// }
	onWindowStageCreate(windowStage: window.WindowStage): void {
		// Main window is created, set main page for this ability
		windowStage.loadContent('pages/Index', (err, data) => {
			// 组件库初始化
			IBestInit(windowStage, this.context)
			// IBestSetGlobalConfig({
			//   unit: "lpx",
			//   fontUnit: "lpx"
			// })
		});
	}

	onConfigurationUpdate(newConfig: Configuration): void {
		console.log("onConfigurationUpdate", newConfig.colorMode)
	}
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
