import { componentUtils, ComponentUtils, window } from '@kit.ArkUI'
import { ComInfoType, ComAvoidAreaSize } from '../../utils/Global.type'
import { common } from '@kit.AbilityKit'
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
    width: px2lpx(info.size.width),
    height: px2lpx(info.size.height),
    localLeft: px2lpx(info.localOffset.x),
    localTop: px2lpx(info.localOffset.y),
    screenLeft: px2lpx(info.screenOffset.x),
    screenTop: px2lpx(info.screenOffset.y),
    windowLeft: px2lpx(info.windowOffset.x),
    windowTop: px2lpx(info.windowOffset.y)
  }
}
/**
 * 获取窗口域尺寸信息
 * */
export const getWindowAvoidSize = async (context: common.BaseContext): Promise<ComAvoidAreaSize> => {
  let topWindow: window.Window = await window.getLastWindow(context)
  let avoidArea = topWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
  return {
    topSize: px2lpx(avoidArea.topRect.height),
    bottomSize: px2lpx(avoidArea.bottomRect.height) || 60, // TODO 暂时没法获取 先写固定值
    leftSize: px2lpx(avoidArea.leftRect.width),
    rightSize: px2lpx(avoidArea.rightRect.width)
  }
}