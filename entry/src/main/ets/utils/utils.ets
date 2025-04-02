import GlobalStore from './global'
import { window } from '@kit.ArkUI'
import { bundleManager, common } from '@kit.AbilityKit'
import { ComAvoidAreaSize } from '../assets/global.type'
import { image } from '@kit.ImageKit'
import fs from '@ohos.file.fs'
import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { systemShare } from '@kit.ShareKit'
import { fileUri } from '@kit.CoreFileKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData'
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
 * 获取随机id
 */
export function generateId() {
    return Math.random().toString(36).substring(2, 9)
}
/**
 * 获取应用版本
 */
export function getAppVersion(){
    return bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).versionName
}
/**
 * pixelMap 转 buffer
 */
export async function pixelMap2Buffer(pixelMap: PixelMap) {
    const imagePackerApi: image.ImagePacker = image.createImagePacker()
    let packOpts: image.PackingOption = { format: "image/jpeg", quality: 98 }
    return await imagePackerApi.packing(pixelMap, packOpts)
}
/**
 * 保存pixelMap 图片
 */
export async function savePixelMap(context: Context, pixelMap: PixelMap){
    let buffer = await pixelMap2Buffer(pixelMap)
    let helper = photoAccessHelper.getPhotoAccessHelper(context)
    let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg')
    let file = fs.openSync(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
    fs.writeSync(file.fd, buffer)
    fs.closeSync(file.fd)
    helper.release()
}

/**
 * 获取Resource字符串
 */
export function getResourceStr(res: ResourceStr): string {
    if(typeof res == 'string'){
        return res
    }
    return GlobalStore.context.resourceManager.getStringSync(res)
}

/**
 * 分享图片
 */
export function shareImage(context: common.UIAbilityContext, pixelMap: PixelMap){
	const imagePackerApi: image.ImagePacker = image.createImagePacker()
	imagePackerApi.packing(pixelMap, {
		format: "image/jpeg",
		quality: 70
	}).then((data: ArrayBuffer) => {
		let filePath = `${context.cacheDir}/1.jpg`
		try {
			fs.unlinkSync(filePath)
		} catch(err) {}
		let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
		fs.writeSync(file.fd, data)
		fs.closeSync(file.fd)
		let sharedData: systemShare.SharedData = new systemShare.SharedData({
			utd: utd.UniformDataType.IMAGE,
			uri: fileUri.getUriFromPath(filePath)
		})
		let controller: systemShare.ShareController = new systemShare.ShareController(sharedData)
		// 注册分享面板关闭监听
		// controller.on('dismiss', () => {
		// 	console.info('Share panel closed')
		// })
		// 进行分享面板显示
		controller.show(context, {
			selectionMode: systemShare.SelectionMode.SINGLE,
			previewMode: systemShare.SharePreviewMode.DETAIL
		}).then(() => {
			try {
				fs.unlinkSync(filePath)
			} catch(err) {}
		})
	})
}