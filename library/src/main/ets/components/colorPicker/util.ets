import { IBestHsv, IBestHsva, IBestRGB } from "./index.type"

/**
 * 将色相值转为 rgb
 */
export function hue2Rgb(h: number): IBestRGB {
    let s = 1, l = 0.5
    let r = 0, g = 0, b = 0

    const hue2rgb = (p: number, q: number, t: number): number => {
        if (t < 0) t += 1
        if (t > 1) t -= 1
        if (t < 1/6) return p + (q - p) * 6 * t
        if (t < 1/2) return q
        if (t < 2/3) return p + (q - p) * (2/3 - t) * 6
        return p
    }

    const q = l + s - l * s
    const p = 2 * l - q

    r = Math.round(hue2rgb(p, q, h + 1/3) * 255)
    g = Math.round(hue2rgb(p, q, h) * 255)
    b = Math.round(hue2rgb(p, q, h - 1/3) * 255)

    return { r, g, b }
}
/**
 * 通过color获取h s v a
 */
export function color2Hsva(value: string): IBestHsva {
    let a = 1
    if (value.includes('rgb')) {
        const parts = value
            .replace(/rgba|rgb|\(|\)/gm, '')
            .split(/\s|,/g)
            .filter((val) => val !== '')
            .map((val, index) => index > 2 ? Number.parseFloat(val) : Number.parseInt(val, 10))
        if (parts.length < 3) {
            throw new Error('Invalid rgb color format')
        }
        if (parts.length === 4) {
            a = parts[3]
        }
        const hsv = rgb2hsv(parts[0], parts[1], parts[2])
        return {
            h: hsv.h,
            s: hsv.s,
            v: hsv.v,
            a: a
        }
    }else if (value.includes('#')) {
        let IBestHsva = hex2hsva(value)
        return {
            h: IBestHsva.h,
            s: IBestHsva.s,
            v: IBestHsva.v,
            a: IBestHsva.a
        }
    }else {
        throw new Error('Unsupported color format')
    }
}
/**
 * rgb 转 hsv
 */
export function rgb2hsv(r: number, g: number, b: number): IBestHsv {
    // 归一化 RGB 值到 [0, 1] 范围
    r /= 255;
    g /= 255;
    b /= 255;
    // 找到最大值和最小值
    const max = Math.max(r, g, b);
    const min = Math.min(r, g, b);

    let h = 0, s = 0, v = max;

    const d = max - min;
    s = max === 0 ? 0 : d / max;

    if (max === min) {
        h = 0; // achromatic
    } else {
        switch (max) {
            case r:
                h = (g - b) / d + (g < b ? 6 : 0);
                break;
            case g:
                h = (b - r) / d + 2;
                break;
            case b:
                h = (r - g) / d + 4;
                break;
        }
        h /= 6;
    }
    // 转换为常用的百分比表示
    let obj: IBestHsv = {
        h,
        s,
        v
    }
    return obj
}
/**
 * hex 转 hsv
 */
export function hex2hsva(hex: string): IBestHsva {
    hex = hex.replace(/^#/, '');
    if (hex.length === 3) {
        hex = hex.split('').map(char => char + char).join('');
    }
    if (hex.length === 6) {
        hex += 'FF'; // 默认 alpha 为 FF（完全不透明）
    }
    // 提取 RGBA 分量
    const r = parseInt(hex.slice(0, 2), 16) / 255;
    const g = parseInt(hex.slice(2, 4), 16) / 255;
    const b = parseInt(hex.slice(4, 6), 16) / 255;
    const a = parseInt(hex.slice(6, 8), 16) / 255;

    // RGB 转 HSV
    let max = Math.max(r, g, b);
    let min = Math.min(r, g, b);
    let h = 0, s = 0, v = max;
    const d = max - min;
    s = max === 0 ? 0 : d / max;
    if (max === min) {
        h = 0; // achromatic
    } else {
        switch (max) {
            case r:
                h = (g - b) / d + (g < b ? 6 : 0);
                break;
            case g:
                h = (b - r) / d + 2;
                break;
            case b:
                h = (r - g) / d + 4;
                break;
        }
        h /= 6;
    }
    return { h, s, v, a }
}
/**
 * IBestHsva 转 rgb Color
 */
export function hsva2RgbColor(hsva: IBestHsva, enableAlpha: boolean) {
    let h = hsva.h, s = hsva.s, v = hsva.v, a = hsva.a
    let r = 0, g = 0, b = 0
    const i = Math.floor(h * 6)
    const f = h * 6 - i
    const p = v * (1 - s)
    const q = v * (1 - f * s)
    const t = v * (1 - (1 - f) * s)
    switch (i % 6) {
        case 0: r = v; g = t; b = p; break;
        case 1: r = q; g = v; b = p; break;
        case 2: r = p; g = v; b = t; break;
        case 3: r = p; g = q; b = v; break;
        case 4: r = t; g = p; b = v; break;
        case 5: r = v; g = p; b = q; break;
    }
    // 将 RGB 转换为 0-255 范围
    r = Math.round(r * 255);
    g = Math.round(g * 255);
    b = Math.round(b * 255);
    a = Math.round(a * 100) / 100; // 保留两位小数
    // 构造 rgba 字符串
    return enableAlpha ? `rgba(${r}, ${g}, ${b}, ${a})` : `rgb(${r}, ${g}, ${b})`
}
/**
 * IBestHsva 转 hex Color
 */
export function hsva2HexColor(hsva: IBestHsva, enableAlpha: boolean) {
    let h = hsva.h, s = hsva.s, v = hsva.v, a = hsva.a
    let r = 0, g = 0, b = 0
    const i = Math.floor(h * 6);
    const f = h * 6 - i;
    const p = v * (1 - s);
    const q = v * (1 - f * s);
    const t = v * (1 - (1 - f) * s);
    switch (i % 6) {
        case 0: r = v; g = t; b = p; break;
        case 1: r = q; g = v; b = p; break;
        case 2: r = p; g = v; b = t; break;
        case 3: r = p; g = q; b = v; break;
        case 4: r = t; g = p; b = v; break;
        case 5: r = v; g = p; b = q; break;
    }
    // 将 RGB 转换为 0-255 范围
    r = Math.round(r * 255);
    g = Math.round(g * 255);
    b = Math.round(b * 255);
    a = Math.round(a * 255);
    // 格式化为两位十六进制字符串
    const toHex = (value: number) => value.toString(16).padStart(2, '0')
    return `#${toHex(r)}${toHex(g)}${toHex(b)}${enableAlpha ? toHex(a) : ''}`
}