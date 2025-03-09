import { getDefaultBaseStyle, IBEST_UI_NAMESPACE } from '../../theme-chalk/src';
import { getSizeByUnit } from '../../utils/utils';
import { IBestUIBaseStyleObjType } from '../../theme-chalk/src/index.type';
import { Chunks, Chunk } from './index.type';
import { IBestStringNumber } from '../../model/Global.type';
import { convertDimensionsWidthUnit } from '../../utils/utils';
import { IBestHighlightColor } from './color';

@Component
export struct IBestHighlight {
  /**
   * 全局公共样式
   */
  @StorageLink(IBEST_UI_NAMESPACE) private baseStyle: IBestUIBaseStyleObjType = getDefaultBaseStyle()
  /**
   * 是否自动转义
   */
  @Prop autoEscape: boolean = true;
  /**
   * 是否区分大小写
   */
  @Prop caseSensitive: boolean = false;
  /**
   * 期望高亮的文本
   */
  @Prop keywords: string | string[] = ''
  /**
   * 源文本
   */
  @Prop sourceString: string = ''
  /**
   * 文字颜色 默认 "#969799"
   */
  @Prop textColor: ResourceColor = IBestHighlightColor.textColor
  /**
   * 文字大小
   */
  @Prop textFontSize: IBestStringNumber = convertDimensionsWidthUnit(14)
  /**
   * 高亮文字颜色 默认 "#1989fa"
   */
  @Prop highColor: ResourceColor = IBestHighlightColor.highColor
  /**
   * 高亮文字大小
   */
  @Prop highFontSize: IBestStringNumber = convertDimensionsWidthUnit(14)

  highlightChunks() {
    const flags = this.caseSensitive ? 'g' : 'gi';
    const _keywords = Array.isArray(this.keywords) ? this.keywords : [this.keywords];

    // generate chunks
    let chunks = _keywords
      .filter((keyword: string) => keyword)
      .reduce<Chunks>(
        (chunks, keyword: string) => {
          if (this.autoEscape) {
            keyword = keyword.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
          }

          const regex = new RegExp(keyword, flags);

          let match: RegExpExecArray | null;
          while ((match = regex.exec(this.sourceString))) {
            const start = match.index;
            const end = regex.lastIndex;

            if (start >= end) {
              regex.lastIndex++;
              continue;
            }

            chunks.push({
              start,
              end,
              highlight: true,
            });
          }

          return chunks;
        },
        [],
      );

    // merge chunks
    chunks = chunks
      .sort((a, b) => a.start - b.start)
      .reduce<Chunks>((chunks, currentChunk) => {
        const prevChunk = chunks[chunks.length - 1];

        if (!prevChunk || currentChunk.start > prevChunk.end) {
          const unhighlightStart = prevChunk ? prevChunk.end : 0;
          const unhighlightEnd = currentChunk.start;

          if (unhighlightStart !== unhighlightEnd) {
            chunks.push({
              start: unhighlightStart,
              end: unhighlightEnd,
              highlight: false,
            });
          }

          chunks.push(currentChunk);
        } else {
          prevChunk.end = Math.max(prevChunk.end, currentChunk.end);
        }

        return chunks;
      }, []);

    const lastChunk = chunks[chunks.length - 1];

    if (!lastChunk) {
      chunks.push({
        start: 0,
        end: this.sourceString.length,
        highlight: false,
      });
    }

    if (lastChunk && lastChunk.end < this.sourceString.length) {
      chunks.push({
        start: lastChunk.end,
        end: this.sourceString.length,
        highlight: false,
      });
    }

    return chunks;
  }

  build() {
    Text() {
      ForEach(this.highlightChunks(), (item: Chunk, index: number) => {
        if (item.highlight) {
          Span(this.sourceString.slice(item.start, item.end)).fontColor(this.highColor).fontSize(this.highFontSize)
        } else {
          Span(this.sourceString.slice(item.start, item.end))
        }
      })
    }
    .fontSize(getSizeByUnit(this.textFontSize, true))
    .fontColor(this.textColor)
  }
}