@Observed
export class IBestCanvasContent {
	/**
	 * 内容类型
     */
	type?: "image" | "text"
	/**
	 * 图片地址
     */
	url?: ResourceStr
	/**
	 * 文字
     */
	text?: ResourceStr
	/**
	 * 内容宽度
	 */
	width?: number
	/**
	 * 图片高度, 文字无效
	 */
	height?: number
	/**
	 * 内容左上角距离画布顶部距离
	 */
	top?: number
	/**
	 * 图片左上角距离画布底部距离, 文字无效
	 */
	bottom?: number
	/**
	 * 内容左上角距离画布左侧距离
	 */
	left?: number
	/**
	 * 内容右上角距离画布右侧距离, 优先级大于left
	 */
	right?: number
	/**
	 * 文字最大行数
	 */
	maxLineNumber?: number
	/**
	 * 文字字体大小
	 */
	fontSize?: number
	/**
	 * 文字行高
	 */
	lineHeight?: number
	/**
	 * 文字颜色
	 */
	fontColor?: string | number | CanvasGradient | CanvasPattern
	/**
	 * 文字字重 可选 'normal', 'bold', 'bolder', 'lighter', 100, 200, 300, 400, 500, 600, 700, 800, 900
	 */
	fontWeight?: string
	/**
	 * 文字 下划线，删除线
	 */
	textDecoration?: 'underline' | 'lineThrough'
	/**
	 * 文字对齐方式
     */
	textAlign?: CanvasTextAlign
	/**
	 * 图片圆角
	 */
	borderRadius?: number
	/**
	 * 图片旋转角度
     */
	deg?: number
}
