/**
 * 休眠
 * @param {number} time 休眠时间
 * @returns
 */
export function sleep(time = 300){
  return new Promise((resolve)=>{
    setTimeout(()=>{
      resolve('')
    }, time)
  })
}

/**
 * 函数防抖
 * @param func
 * @param time
 * @param immediate
 * @returns
 */
export function debounce(func: Function, time = 300, immediate = false) {
  let timer: number | null = null;
  return (...args: any) => {
    if (timer) clearInterval(timer)
    if (immediate) {
      if (!timer) func.apply(this, args);
      timer = setTimeout(() => {
        timer = null
      }, time)
    } else {
      timer = setTimeout(() => {
        func.apply(this, args)
      }, time)
    }
  }
}

/**
 * 避免加减乘除失真
 */
export const acc = {
  /**
   * 解决加法失真
   * @param {Number} 两个数字
   * work.accAdd(1.1, 2)
   * */
  add: function (arg1, arg2) {
    let r1, r2, m;
    try {
      r1 = arg1.toString().split(".")[1].length
    } catch (e) {
      r1 = 0
    }
    try {
      r2 = arg2.toString().split(".")[1].length
    } catch (e) {
      r2 = 0
    }
    m = Math.pow(10, Math.max(r1, r2));
    //console.log(m)
    return (arg1 * m + arg2 * m) / m;
  },
  /**
   * 解决减法失真
   * @param {Number} 两个数字
   * work.accSub(1.1, 2)
   * */
  sub: function (arg1, arg2) {
    let r1, r2, m, n;
    try {
      r1 = arg1.toString().split(".")[1].length
    } catch (e) {
      r1 = 0
    }
    try {
      r2 = arg2.toString().split(".")[1].length
    } catch (e) {
      r2 = 0
    }
    m = Math.pow(10, Math.max(r1, r2));
    //last modify by deeka
    //动态控制精度长度
    n = (r1 >= r2) ? r1 : r2;
    return ((arg1 * m - arg2 * m) / m).toFixed(n);
  },
  /**
   * 解决乘法失真
   * @param {Number} 两个数字
   * work.accMul(1.1, 2)
   * */
  mul: function (arg1, arg2) {
    let m = 0,
      s1 = arg1.toString(),
      s2 = arg2.toString();
    try {
      m += s1.split(".")[1].length
    } catch (e) {}
    try {
      m += s2.split(".")[1].length
    } catch (e) {}
    return Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m)
  },
  /**
   * 解决除法失真
   * @param {Number} 两个数字
   * work.accDiv(1.1, 2)
   * */
  div: function (arg1, arg2) {
    let t1 = 0,
      t2 = 0,
      r1, r2;
    try {
      t1 = arg1.toString().split(".")[1].length
    } catch (e) {}
    try {
      t2 = arg2.toString().split(".")[1].length
    } catch (e) {}
    r1 = Number(arg1.toString().replace(".", ""));
    r2 = Number(arg2.toString().replace(".", ""));
    return (r1 / r2) * Math.pow(10, t2 - t1);
  }
}