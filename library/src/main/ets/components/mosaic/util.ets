import { buffer } from '@kit.ArkTS'
import { image } from '@kit.ImageKit'

export function applyMosaicToImage(pixel: PixelMap, blockSize: number): PixelMap {
    const imageInfo = pixel.getImageInfoSync()
    const mosaicPixelMap = applyMosaic(pixel, imageInfo, blockSize)
    return mosaicPixelMap
}

function applyMosaic(pixelMap: image.PixelMap, imageInfo: image.ImageInfo, blockSize: number): PixelMap {
    const mosaicPixelMap = image.createPixelMapSync({
        size: imageInfo.size
    })
    const bufferSize = pixelMap.getPixelBytesNumber()
    const readBuffer = new ArrayBuffer(bufferSize)
    pixelMap.readPixelsToBufferSync(readBuffer)
    const data = new Uint8Array(readBuffer)
    const processedData = processMosaic(data, imageInfo.size.width, imageInfo.size.height, blockSize)
    mosaicPixelMap.writeBufferToPixelsSync(buffer.from(processedData).buffer)
    return mosaicPixelMap
}

function processMosaic(data: Uint8Array, width: number, height: number, blockSize: number): Uint8Array {
    const result = new Uint8Array(data.length)
    for (let y = 0; y < height; y += blockSize) {
        for (let x = 0; x < width; x += blockSize) {
            const blockEndX = Math.min(x + blockSize, width)
            const blockEndY = Math.min(y + blockSize, height)
            const avgColor = calculateBlockAverageColor(data, x, y, blockEndX, blockEndY, width)
            for (let blockY = y; blockY < blockEndY; blockY++) {
                for (let blockX = x; blockX < blockEndX; blockX++) {
                    const index = (blockY * width + blockX) * 4
                    result[index] = avgColor.r
                    result[index + 1] = avgColor.g
                    result[index + 2] = avgColor.b
                    result[index + 3] = avgColor.a
                }
            }
        }
    }
    return result
}

interface RgbaColor {
    r: number
    g: number
    b: number
    a: number
}

function calculateBlockAverageColor(data: Uint8Array, startX: number, startY: number, endX: number, endY: number, width: number): RgbaColor {
    let r = 0, g = 0, b = 0, a = 0
    let count = 0

    for (let y = startY; y < endY; y++) {
        for (let x = startX; x < endX; x++) {
            const index = (y * width + x) * 4
            r += data[index]
            g += data[index + 1]
            b += data[index + 2]
            a += data[index + 3]
            count++
        }
    }

    return {
        r: Math.round(r / count),
        g: Math.round(g / count),
        b: Math.round(b / count),
        a: Math.round(a / count)
    }
}