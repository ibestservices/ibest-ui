import { image } from "@kit.ImageKit";
/**
 * IBestImageCropper 控制器
 */
export class IBestImageCropperController{
	/**
	 * 获取截取结果
     */
	getResult: (callBack?: (result: PixelMap) => void) => Promise<PixelMap> = () => Promise.resolve(image.createImageSource("").createPixelMap())
}