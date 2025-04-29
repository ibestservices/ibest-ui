import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src'
import { getResourceStr, getSizeByUnit } from '../../utils/utils'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { Chunk, Chunks } from './index.type'
import { IBestStringNumber } from '../../model/Global.type'
import { IBestHighlightColor } from './color'
@Component
export struct IBestHighlight {
	/**
	 * 全局公共样式
	 */
	@StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 是否自动转义
	 */
	@Prop autoEscape: boolean = true
	/**
	 * 是否区分大小写
	 */
	@Prop caseSensitive: boolean = false
	/**
	 * 高亮关键字
	 */
	@Prop keywords: ResourceStr | ResourceStr[] = ''
	/**
	 * 源文本
	 */
	@Prop sourceString: ResourceStr = ''
	/**
	 * 文字颜色 默认 "#969799"
	 */
	@Prop textColor: ResourceColor = IBestHighlightColor.textColor
	/**
	 * 高亮文字颜色 默认 "#1989fa"
	 */
	@Prop highLightColor: ResourceColor = IBestHighlightColor.highColor
	/**
	 * 文字大小
	 */
	@Prop textFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
	/**
	 * 高亮文字大小
	 */
	@Prop highLightFontSize: IBestStringNumber = this.baseStyle.fontSizeMd as string
	/**
	 * 最大行数
	 * @since 2.0.8
	 */
	@Prop maxLines?: number = undefined
	/**
	 * 超出隐藏
	 * @since 2.0.8
  	 */
	@Prop overflow: TextOverflow = TextOverflow.None

	highlightChunks(): Chunk[] {
		const flags = this.caseSensitive ? 'g' : 'gi'
		let sourceStr = this.getRealSourceString()
		let _keywords: string[] = []
		if(Array.isArray(this.keywords)){
			_keywords = this.keywords.map(e => getResourceStr(e))
		}else{
			_keywords = [getResourceStr(this.keywords)]
		}
		// generate chunks
		let chunks = _keywords.filter((keyword: string) => keyword).reduce<Chunks>((chunks, keyword: string) => {
			if (this.autoEscape) {
				keyword = keyword.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
			}
			const regex = new RegExp(keyword, flags)
			let match: RegExpExecArray | null
			while ((match = regex.exec(sourceStr))) {
				const start = match.index
				const end = regex.lastIndex
				if (start >= end) {
					regex.lastIndex++
					continue
				}
				chunks.push({
					start,
					end,
					highlight: true
				})
			}
			return chunks
		}, [])
		// merge chunks
		chunks = chunks
			.sort((a, b) => a.start - b.start)
			.reduce<Chunks>((chunks, currentChunk) => {
				const prevChunk = chunks[chunks.length - 1]
				if (!prevChunk || currentChunk.start > prevChunk.end) {
					const unHighlightStart = prevChunk ? prevChunk.end : 0
					const unHighlightEnd = currentChunk.start
					if (unHighlightStart !== unHighlightEnd) {
						chunks.push({
							start: unHighlightStart,
							end: unHighlightEnd,
							highlight: false
						})
					}
					chunks.push(currentChunk)
				} else {
					prevChunk.end = Math.max(prevChunk.end, currentChunk.end)
				}
				return chunks
			}, [])
		const lastChunk = chunks[chunks.length - 1]
		if (!lastChunk) {
			chunks.push({
				start: 0,
				end: sourceStr.length,
				highlight: false
			})
		}
		if (lastChunk && lastChunk.end < sourceStr.length) {
			chunks.push({
				start: lastChunk.end,
				end: sourceStr.length,
				highlight: false
			})
		}
		return chunks
	}
	getRealSourceString(){
		return getResourceStr(this.sourceString)
	}
	build() {
		Text() {
			ForEach(this.highlightChunks(), (item: Chunk) => {
				if (item.highlight) {
					Span(this.getRealSourceString().slice(item.start, item.end))
						.fontColor(this.highLightColor)
						.fontSize(this.highLightFontSize)
				} else {
					Span(this.getRealSourceString().slice(item.start, item.end))
				}
			}, (_: Chunk, index: number) => index.toString())
		}
		.fontSize(getSizeByUnit(this.textFontSize, true))
		.fontColor(this.textColor)
		.maxLines(this.maxLines)
		.textOverflow({overflow: this.overflow})
	}
}