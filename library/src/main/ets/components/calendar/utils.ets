import dayjs from '@hview/dayjs'

export function getPrevDay(dateStr: string): string{
    return dayjs(dateStr).subtract(1, 'day').format('YYYY-MM-DD')
}
export function getNextDay(dateStr: string){
    return dayjs(dateStr).add(1, 'day').format('YYYY-MM-DD')
}
// 16进制转rgb
export function set16ToRgb(str:string): string{
    let reg = /^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$/
    if(!reg.test(str)) return set16ToRgb("#999999")
    let newStr = (str.toLowerCase()).replace(/\#/g,'')
    let len = newStr.length
    if(len == 3){
        let t = ''
        for(let i = 0; i < len; i++){
            t += newStr.slice(i,i+1).concat(newStr.slice(i,i+1))
        }
        newStr = t
    }
    let arr: Array<number> = []
    for(let i = 0; i < 6; i = i + 2){
        let s = newStr.slice(i,i+2)
        arr.push(parseInt("0x" + s))
    }
    return 'rgba(' + arr.join(",")  + ', 0.2)'
}