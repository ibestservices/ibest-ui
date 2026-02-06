/**
 * 刻度选项
 */
export interface IBestCaliperScale {
    /**
     * 刻度值
     */
    value: number
    /**
     * 是否是大刻度
     */
    isBig: boolean
}

export class IBestCaliperScaleSource implements IDataSource {
    private list: IBestCaliperScale[] = []

    constructor(list: IBestCaliperScale[]) {
        this.list = list
    }
    totalCount(): number {
        return this.list.length
    }
    getData(index: number) {
        return this.list[index]
    }
    getAll(){
        return this.list
    }
    registerDataChangeListener(): void {}
    unregisterDataChangeListener(): void {}
}