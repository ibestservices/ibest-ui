export interface IBestRGB{
    r: number
    g: number
    b: number
}

export class IBestHsv{
    h: number = 0
    s: number = 100
    v: number = 100
}
/**
 * hsva 类型
 */
export class IBestHsva extends IBestHsv{
    a: number = 100
}
/**
 * 颜色格式
 */
export type IBestColorFormat = 'rgb' | 'hex'