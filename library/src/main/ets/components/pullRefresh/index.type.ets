/**
 * 刷新状态
 */
export type PullRefreshStatus = 'normal' | 'loosing' | 'pulling' | 'loading' | 'success'

/**
 * 自定义加载内容参数类型
 */
export interface IBestRefreshContentParams{
	distance: number
}