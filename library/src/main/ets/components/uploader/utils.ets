import { IBestUploaderFile } from "./index.type";

/*
 * 判断是否是图片
 */
const IMAGE_REGEXP = /\.(jpeg|jpg|gif|png|svg|webp|jfif|bmp|dpg|avif)/i
// 是否是图片地址
export const isImageUrl = (url: string): boolean => IMAGE_REGEXP.test(url)

// 是否是图片
export function isImageFile(item: IBestUploaderFile): boolean {
    if (item.isImage) {
        return true;
    }
    if (item.url) {
        return isImageUrl(item.url)
    }
    return false
}