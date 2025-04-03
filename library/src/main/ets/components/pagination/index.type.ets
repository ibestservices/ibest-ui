import { IBestStringNumber } from '../../model/Global.type'

// 定义PageItem接口
export interface IBestPageItem {
  text: IBestStringNumber
  number: number
  active?: boolean
}

// 定义PaginationMode类型
export type IBestPaginationMode = 'simple' | 'multi'

export type IBestTurnBtnType = 'prev' | 'next'