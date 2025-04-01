import { IBestStringNumber } from '../../model/Global.type'

// 定义PageItem接口
export interface PageItem {
  text: IBestStringNumber;
  number: number;
  active?: boolean;
}

// 定义PaginationMode类型
export type PaginationMode = 'simple' | 'multi';