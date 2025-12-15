import { componentUtils, LengthUnit, MeasureOptions } from '@kit.ArkUI'
import { ComInfoType, IBestAwaitable, IBestStorageKey, IBestStringNumber } from '../model/Global.type'
import { AnyType } from '../model/AnyType'
import GlobalStore from './globalStore'
import { util } from '@kit.ArkTS'
import { image } from '@kit.ImageKit'
import { IBestGlobalConfig } from '../model/GlobalConfig'

/**
 * 休眠
 * @param {number} time 休眠时间
 * @returns
 */
export function sleep(time = 300): Promise<void> {
	return new Promise((resolve) => {
		setTimeout(() => {
			resolve()
		}, time)
	})
}
/**
 * 解决加法失真
 * @param {Number} 两个数字
 * work.accAdd(1.1, 2)
 * */
export const accAdd = (arg1: number, arg2: number) => {
	let r1: IBestStringNumber, r2: IBestStringNumber, m: number;
	try {
		r1 = arg1.toString().split(".")[1].length;
	} catch (e) {
		r1 = 0;
	}
	try {
		r2 = arg2.toString().split(".")[1].length;
	} catch (e) {
		r2 = 0;
	}
	m = Math.pow(10, Math.max(r1, r2));
	return (arg1 * m + arg2 * m) / m;
}
/**
 * 解决减法失真
 * @param {Number} 两个数字
 * work.accSub(1.1, 2)
 * */
export const accSub = (arg1: number, arg2: number) => {
	let r1: IBestStringNumber, r2: IBestStringNumber, m: number, n: number;
	try {
		r1 = arg1.toString().split(".")[1].length;
	} catch (e) {
		r1 = 0;
	}
	try {
		r2 = arg2.toString().split(".")[1].length;
	} catch (e) {
		r2 = 0;
	}
	m = Math.pow(10, Math.max(r1, r2));
	//last modify by deeka
	//动态控制精度长度
	n = (r1 >= r2) ? r1 : r2;
	return ((arg1 * m - arg2 * m) / m).toFixed(n);
}
/**
 * 解决乘法失真
 * @param {Number} 两个数字
 * work.accMul(1.1, 2)
 * */
export const accMul = (arg1: number, arg2: number) => {
	let m = 0, s1 = arg1.toString(), s2 = arg2.toString();
	try {
		m += s1.split(".")[1].length;
	} catch (e) {}
	try {
		m += s2.split(".")[1].length;
	} catch (e) {}
	return Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m);
}
/**
 * 解决除法失真
 * @param {Number} 两个数字
 * work.accDiv(1.1, 2)
 * */
export const accDiv = (arg1: number, arg2: number) => {
	let t1 = 0, t2 = 0, r1: number, r2: number;
	try {
		t1 = arg1.toString().split(".")[1].length;
	} catch (e) {}
	try {
		t2 = arg2.toString().split(".")[1].length;
	} catch (e) {}
	r1 = Number(arg1.toString().replace(".", ""));
	r2 = Number(arg2.toString().replace(".", ""));
	return (r1 / r2) * Math.pow(10, t2 - t1);
}
/**
 * 根据targetLength 补0
 * @param num
 * @param targetLength
 * @returns
 */
export function padZero(num: number, targetLength = 2): string {
	let str = num + ''
	while (str.length < targetLength) {
		str = '0' + str
	}
	return str
}
/**
 * 取一个区间数
 * @param {Number} min 最小值
 * @param {Number} max 最大值
 */
export function random(min: number, max: number) {
	if (min >= 0 && max > 0 && max >= min) {
		const gab = max - min + 1
		return Math.floor(Math.random() * gab + min)
	}
	return 0
}
/**
 * 获取组件信息
 * @param {context} UIContext
 * @param {key} 组件id
 * */
export const getComponentsInfo = (context: UIContext, key: string): ComInfoType => {
	let info: componentUtils.ComponentInfo = context.getComponentUtils().getRectangleById(key)
	return {
		width: context.px2vp(info.size.width),
		height: context.px2vp(info.size.height),
		localLeft: context.px2vp(info.localOffset.x),
		localTop: context.px2vp(info.localOffset.y),
		screenLeft: context.px2vp(info.screenOffset.x),
		screenTop: context.px2vp(info.screenOffset.y),
		windowLeft: context.px2vp(info.windowOffset.x),
		windowTop: context.px2vp(info.windowOffset.y)
	}
}
/**
 * 组件截图
 * @param {context} UIContext
 * @param {key} 组件id
 */
export const getComponentSnapshot = (context: UIContext, key: string): PixelMap => {
	let componentSnapshot = context.getComponentSnapshot()
	return componentSnapshot.getSync(key)
}
/**
 * 测量文字尺寸
 */
export const measureTextSize = (context: UIContext, option: MeasureOptions): Size => {
	let measureUtils = context.getMeasureUtils()
	return {
		width: context.px2vp(measureUtils.measureTextSize(option).width as number),
		height: context.px2vp(measureUtils.measureTextSize(option).height as number)
	}
}
/**
 * 获取区间值
 */
export const clamp = (num: number, min: number, max: number): number => Math.min(Math.max(num, min), max)
/**
 * 是否是对象
 */
export const isObject = (val: AnyType): boolean => val !== null && typeof val === 'object'
/**
 * 是否是函数
 */
export const isFunction = (val: AnyType): boolean => typeof val === 'function'
/**
 * 是否是Promise
 */
export const isPromise = (val: AnyType): boolean => isObject(val) && isFunction(val.then) && isFunction(val.catch)
/**
 * 生成随机id
 */
export function generateId() {
	return Math.random().toString(36).substring(2, 9)
}
/**
 * 加法避免浮点数
 */
export function addNumber(num1: number, num2: number) {
	const cardinal = 10**10
	return Math.round((num1 + num2) * cardinal) / cardinal
}
/**
 * 生成事件名称
 */
export function getEventName(componentName: string, eventName: string, groupId?: IBestStringNumber) {
	let arr = ['IBest', componentName, eventName, groupId]
	return arr.filter(e => e).join("_")
}
/**
 * 根据类型和单位拼接尺寸 用于组件尺寸类属性格式化
 */
export function getSizeByUnit(val: AnyType, isFont?: boolean): string {
	if (typeof val == "number") {
		let config: IBestGlobalConfig = AppStorage.get(IBestStorageKey.GLOBAL_CONFIG)!
		let unit = isFont ? config.fontUnit : config.unit
		return `${val}${unit}`
	}
	return val
}
/**
 * 根据配置获取LengthUnit
 */
export function getLengthUnit(): LengthUnit {
	let config: IBestGlobalConfig = AppStorage.get(IBestStorageKey.GLOBAL_CONFIG)!
	return config.unit == "lpx" ? LengthUnit.LPX : config.unit == "px" ? LengthUnit.PX : LengthUnit.VP
}
/**
 * 根据单位转换尺寸 用于框架固定尺寸格式化 带单位
 */
export function convertDimensionsWidthUnit(val: number, isFont?: boolean): string {
	let config: IBestGlobalConfig = AppStorage.get(IBestStorageKey.GLOBAL_CONFIG)!
	let unit = isFont ? "fp" : "vp"
	let value = val
	if (config) {
		unit = isFont ? config.fontUnit : config.unit
		switch (unit) {
			case "lpx":
				value = val * GlobalStore.screenWidth / config.designWidth
				break
			case "px":
				value = GlobalStore.vp2px(val)
				break
		}
	}
	return value + unit
}
/**
 * base64 转 pixelMap
 */
export async function base64ToPixelMap(base64: string): Promise<PixelMap> {
	const reg = new RegExp('data:image/\\w+;base64,')
	const base64Str = base64.replace(reg, '')
	let base64Helper = new util.Base64Helper()
	let arrayBuffer = base64Helper.decodeSync(base64Str).buffer as ArrayBuffer
	let imageSource = image.createImageSource(arrayBuffer)
	return await imageSource.createPixelMap()
}
/**
 * 获取Resource字符串
 */
export function getResourceStr(res: ResourceStr): string {
	if(typeof res == 'string'){
		return res
	}
	let params: string[] = res.params || []
	if(params.length){
		return GlobalStore.context.resourceManager.getStringByNameSync(params[0].split('.')[2])
	}else {
		return GlobalStore.context.resourceManager.getStringSync(res.id)
	}
}
/**
 * 处理异步函数
 */
export async function handleBeforeFunction(fn?: (...funArgs: AnyType[]) => IBestAwaitable, ...args: AnyType[]) {
	let status = true
	try {
		if (fn) {
			status = await fn(...args)
		}
	} catch (e) {
		status = false
	}
	return status
}