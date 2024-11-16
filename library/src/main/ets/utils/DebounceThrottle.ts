/**
 * 防抖函数
 * @param func
 * @param wait
 * @returns
 */
export function debounce<T extends (...args: any[]) => void>(func: T, wait: number): (...args: Parameters<T>) => void {
	let timeoutId: number | undefined;

	return function(...args: Parameters<T>): void {
		if (timeoutId !== undefined) {
			clearTimeout(timeoutId);
		}
		timeoutId = setTimeout(() => {
			func.apply(this, args);
		}, wait);
	};
}

/**
 * 节流函数
 * @param func
 * @param limit
 * @returns
 */
export function throttle<T extends (...args: any[]) => void>(func: T, limit: number): (...args: Parameters<T>) => void {
	let inThrottle: boolean = false;
	let lastArgs: Parameters<T> | undefined;
	let lastContext: ThisParameterType<T> | undefined;

	return function(this: ThisParameterType<T>, ...args: Parameters<T>): void {
		if (!inThrottle) {
			inThrottle = true;
			lastArgs = args;
			lastContext = this;

			setTimeout(() => {
				if (lastArgs && lastContext) {
					func.apply(lastContext, lastArgs);
				}
				inThrottle = false;
				lastArgs = undefined;
				lastContext = undefined;
			}, limit);
		}
	};
}