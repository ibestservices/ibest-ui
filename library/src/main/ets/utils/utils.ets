import { componentUtils, ComponentUtils, LengthUnit, window } from '@kit.ArkUI'
import { ComAvoidAreaSize, ComInfoType, IBestGlobalConfig } from '../model/Global.type'
import { common } from '@kit.AbilityKit'
import { AnyType } from '../model/AnyType'
import { resourceManager } from '@kit.LocalizationKit'
import GlobalStore from './GlobalStore'
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
  let r1: string | number, r2: string | number, m: number;
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
  //console.log(m)
  return (arg1 * m + arg2 * m) / m;
}

/**
 * 解决减法失真
 * @param {Number} 两个数字
 * work.accSub(1.1, 2)
 * */
export const accSub = (arg1: number, arg2: number) => {
  let r1: number | string, r2: number | string, m: number, n: number;
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
  } catch (e) {
  }
  try {
    m += s2.split(".")[1].length;
  } catch (e) {
  }
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
  } catch (e) {
  }
  try {
    t2 = arg2.toString().split(".")[1].length;
  } catch (e) {
  }
  r1 = Number(arg1.toString().replace(".", ""));
  r2 = Number(arg2.toString().replace(".", ""));
  return (r1 / r2) * Math.pow(10, t2 - t1);
}

/**
 * 获取组件信息
 * @param {context} UIContext
 * @param {key} 组件id
 * */
export const getComponentsInfo = (context: UIContext, key: string): ComInfoType => {
  let comUtils: ComponentUtils = context.getComponentUtils()
  let info:componentUtils.ComponentInfo = comUtils.getRectangleById(key)
  return {
    width: px2vp(info.size.width),
    height: px2vp(info.size.height),
    localLeft: px2vp(info.localOffset.x),
    localTop: px2vp(info.localOffset.y),
    screenLeft: px2vp(info.screenOffset.x),
    screenTop: px2vp(info.screenOffset.y),
    windowLeft: px2vp(info.windowOffset.x),
    windowTop: px2vp(info.windowOffset.y)
  }
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
 * 获取是否横屏
 */
export const getIsLandscape = (context: Context): boolean => {
  return context.resourceManager.getConfigurationSync().direction == resourceManager.Direction.DIRECTION_HORIZONTAL
}
/**
 * 生成随机id
 */
export function generateId(){
  return Math.random().toString(36).substring(2, 9)
}

/**
 * 加法避免浮点数
 */
export function addNumber(num1: number, num2: number) {
  const cardinal = 10 ** 10
  return Math.round((num1 + num2) * cardinal) / cardinal
}

/**
 * 生成事件名称
 */
export function getEventName(id: string, eventName: string) {
  return `${id}_${eventName}`
}

/**
 * 根据类型和单位拼接尺寸 用于组件尺寸类属性格式化
 */
export function getSizeByUnit(val: string | number, isFont?: boolean): string {
  if(typeof val == "string") return val
  let config: IBestGlobalConfig = AppStorage.get("iBestGlobalConfig") as IBestGlobalConfig
  let unit = isFont ? config.fontUnit : config.unit
  return `${val}${unit}`
}
/**
 * 根据配置获取LengthUnit
 */
export function getLengthUnit(): LengthUnit{
  let config: IBestGlobalConfig = AppStorage.get("iBestGlobalConfig") as IBestGlobalConfig
  return config.unit == "lpx" ? LengthUnit.LPX : config.unit == "vp" ? LengthUnit.VP : LengthUnit.PX
}
/**
 * 根据单位转换尺寸 用于框架固定尺寸格式化
 */
export function convertDimensionsByUnit(val: number, isFont?: boolean): string{
  let config: IBestGlobalConfig = AppStorage.get("iBestGlobalConfig") as IBestGlobalConfig
  if(config){
    let unit = isFont ? config.fontUnit : config.unit
    switch (unit){
      case "lpx":
        return `${val*GlobalStore.screenWidth/(config.designWidth as number)}${unit}`
      case "px":
        return `${vp2px(val)}${unit}`
      default :
        return `${val}${unit}`
    }
  }
  return val + "vp"
}