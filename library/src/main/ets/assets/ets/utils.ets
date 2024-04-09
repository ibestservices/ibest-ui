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