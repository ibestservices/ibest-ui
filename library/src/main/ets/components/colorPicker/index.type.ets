export interface IBestRgba{
    r: number
    g: number
    b: number
	a: number
}

export class IBestHsv{
    h: number = 0
    s: number = 0
    v: number = 1
}
/**
 * hsva 类型
 */
export class IBestHsva extends IBestHsv{
    a: number = 1
}
/**
 * 颜色格式
 */
export type IBestColorFormat = 'rgb' | 'hex'

/**
 * 格式化预定颜色
 */
export interface IBestFormatPredefineColor{
	origin: string
	format: string
}