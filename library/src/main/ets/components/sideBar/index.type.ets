/**
 * SideBar事件名称
 */

export enum SIDEBAR_EVENT_NAME {
	/**
	 * 初始化子组件状态
	 */
	INIT_ITEM = "INIT_ITEM",
   	/**
	 * 子组件切换
     */
	CHANGE_ACTIVE = "CHANGE_ACTIVE"
}

/**
 * 侧边导航配置
 */
export interface SideBarConfig {
	/**
	 * 文字颜色
     */
	titleColor: ResourceColor
	/**
	 * 文字大小
     */
	titleFontSize: number | string
	/**
	 * 激活态背景色
     */
	activeBgColor: ResourceColor
	/**
	 * 是否显示左侧颜色条
	 */
	showLeftBar: boolean
	/**
	 * 左侧颜色条尺寸
     */
	leftBarSize: LeftBarSize
	/**
	 * 左侧颜色条颜色
	 */
	leftBarColor: ResourceColor
	/**
	 * 激活态文字颜色
	 */
	activeFontColor: ResourceColor
	/**
	 * 激活态字重
	 */
	activeFontWeight: FontWeight
}

/**
 * 左侧颜色条尺寸类型
 */
export interface LeftBarSize {
	width: number | string
	height: number | string
}