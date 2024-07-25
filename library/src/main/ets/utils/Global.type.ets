/*
 * 加载图标类型
 */
export type LoadingIconType = 'circular' | 'spinner'
/*
 * 文字换行类型
 */
export type WordBreakType = 'normal' | 'break-all' | 'break-word'
/*
 * 组件信息类型
 */
export interface ComInfoType {
    width: number
    height: number
    localLeft: number
    localTop: number
    screenLeft: number
    screenTop: number
    windowTop: number
    windowLeft: number
}
/*
 * 窗口规避尺寸信息
 */
export interface ComAvoidAreaSize{
    topSize: number
    bottomSize: number
    leftSize: number
    rightSize: number
}