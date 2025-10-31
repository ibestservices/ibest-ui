import { getDefaultBaseStyle } from '../../theme-chalk/src'
import { getResourceStr, getSizeByUnit } from '../../utils/utils'
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type'
import { Chunk, Chunks, IBestHighlightKeywords } from './index.type'
import { IBestStorageKey, IBestStringNumber } from '../../model/Global.type'
import { IBestHighlightColor } from './color'
@Component
export struct IBestHighlight {
	/**
	 * 全局公共样式
	 */
	@StorageProp(IBestStorageKey.BASE_STYLE) baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
	/**
	 * 源文本
	 */
	@Prop @Require sourceString: ResourceStr = ''
	/**
	 * 高亮关键字
	 */
	@Prop keywords: ResourceStr | ResourceStr[] | IBestHighlightKeywords[] = ''
	/**
	 * 是否自动转义
	 */
	@Prop autoEscape: boolean = true
	/**
	 * 是否区分大小写
	 */
	@Prop caseSensitive: boolean = false
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
	/**
	 * 行高
	 * @since 2.2.0
     */
	@Prop lineHeight: IBestStringNumber | Resource = ''
	/**
	 * 高亮词点击事件
	 * @since 2.1.8
	 */
	onKeywordClick: (text: string) => void = () => {}

	highlightChunks(): Chunk[] {
		if(!this.sourceString){
			return []
		}
		const flags = this.caseSensitive ? 'g' : 'gi'
		let sourceStr = this.getRealSourceString()
		let _keywords: IBestHighlightKeywords[] = []
		if(Array.isArray(this.keywords)){
			if(typeof this.keywords[0] == 'string'){
				_keywords = (this.keywords as ResourceStr[]).map((e) => {
					let obj: IBestHighlightKeywords = {
						text: getResourceStr(e),
						color: this.highLightColor,
						fontSize: this.highLightFontSize
					}
					return obj
				})
			}else {
				_keywords = (this.keywords as IBestHighlightKeywords[]).map((e) => {
					let obj: IBestHighlightKeywords = {
						text: getResourceStr(e.text),
						color: e.color || this.highLightColor,
						fontSize: e.fontSize || this.highLightFontSize
					}
					return obj
				})
			}
		}else{
			_keywords = [{
				text: getResourceStr(this.keywords),
				color: this.highLightColor,
				fontSize: this.highLightFontSize
			}]
		}
		_keywords = _keywords.filter(e => e.text)
		// generate chunks
		let chunks = _keywords.reduce<Chunks>((chunks, item: IBestHighlightKeywords) => {
			if (this.autoEscape) {
				item.text = (item.text as string).replace(/[.*+?^${}()|[\]\\]/g, '\\$&')
			}
			const regex = new RegExp(item.text as string, flags)
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
					highlight: true,
					color: item.color,
					fontSize: item.fontSize
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
							highlight: false,
							color: this.textColor,
							fontSize: this.textFontSize
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
				highlight: false,
				color: this.textColor,
				fontSize: this.textFontSize
			})
		}
		if (lastChunk && lastChunk.end < sourceStr.length) {
			chunks.push({
				start: lastChunk.end,
				end: sourceStr.length,
				highlight: false,
				color: this.textColor,
				fontSize: this.textFontSize
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
						.fontColor(item.color)
						.fontSize(item.fontSize)
						.onClick(() => {
							this.onKeywordClick(this.getRealSourceString().slice(item.start, item.end))
						})
				} else {
					Span(this.getRealSourceString().slice(item.start, item.end))
				}
			})
		}
		.fontSize(getSizeByUnit(this.textFontSize, true))
		.fontColor(this.textColor)
		.lineHeight(getSizeByUnit(this.lineHeight))
		.maxLines(this.maxLines)
		.textOverflow({overflow: this.overflow})
	}
}