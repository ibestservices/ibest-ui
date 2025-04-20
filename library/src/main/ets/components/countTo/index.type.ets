/**
 * 倒计时controller
 */
export class IBestCountToController {
    /**
     * 开始滚动
     */
    start: () => void = () => {}
    /**
     * 暂停滚动
     */
    pause: () => void = () => {}
    /**
     * 重新开始滚动
     */
    reStart: () => void = () => {}
    /**
     * 重置滚动
     */
    reset: (time?: number) => void = () => {}
}
