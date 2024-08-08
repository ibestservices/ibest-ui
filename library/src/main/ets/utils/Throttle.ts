type ThrottleOptions = {
	noTrailing?: boolean;
	noLeading?: boolean;
	debounceMode?: boolean;
}

export type AnyRetFunc = (...args: any) => void

export interface ThrottleFuncInterface<T extends AnyRetFunc> {
	(...param: Parameters<T>): void,
	cancel(p:{upcomingOnly:boolean}):void
}

/* eslint-disable no-undefined,no-param-reassign,no-shadow */

/**
 * Throttle execution of a function. Especially useful for rate limiting
 * execution of handlers on events like resize and scroll.
 *
 * @param {number} delay -                  以毫秒为单位的零或更大延迟
 * @param {Function} callback -             函数
 * @param {object} [options] -              配置项
 * 
 * @param {boolean} [options.noTrailing] -  可选，默认为false。如果noTrailing为真，回调将仅每“延迟”毫秒执行一次
 *同时调用节流函数。如果noTrailing为false或未指定，将执行回调
 *在最后一次被限制的函数调用后的最后一次。（在未调用节流功能后
 *“延迟”毫秒，内部计数器重置）。
 *
 * @param {boolean} [options.noLeading] -   可选，默认为false。如果noLeading为false，则第一个被限制的函数调用将执行回调
 *立即。如果noLeading为true，则将跳过第一次回调执行。应当指出
 *如果noLeading=true和noTrailing=true，则永远不会执行回调
 *
 * @param {boolean} [options.debounceMode] - 如果“debounceMode”为真（在开始时），则安排“clear”在“delay”ms后执行。如果“debounceMode”为
 *false（结束时），安排`callback`在`delay`毫秒后执行。
 */
export function throttle<T extends AnyRetFunc>(delay: number, callback: T, options?: ThrottleOptions):ThrottleFuncInterface<T> {
	const {
		noTrailing = false,
		noLeading = false,
		debounceMode = undefined
	} = options || {};
	/*
	 * After wrapper has stopped being called, this timeout ensures that
	 * `callback` is executed at the proper times in `throttle` and `end`
	 * debounce modes.
	 */
	let timeoutID;
	let cancelled = false;

	// Keep track of the last time `callback` was executed.
	let lastExec = 0;

	// Function to clear existing timeout
	function clearExistingTimeout() {
		if (timeoutID) {
			clearTimeout(timeoutID);
		}
	}

	// Function to cancel next exec
	function cancel(options) {
		const { upcomingOnly = false } = options || {};
		clearExistingTimeout();
		cancelled = !upcomingOnly;
	}

	/*
	 * The `wrapper` function encapsulates all of the throttling / debouncing
	 * functionality and when executed will limit the rate at which `callback`
	 * is executed.
	 */
	function wrapper(...arguments_) {
		let self = this;
		let elapsed = Date.now() - lastExec;

		if (cancelled) {
			return;
		}

		// Execute `callback` and update the `lastExec` timestamp.
		function exec() {
			lastExec = Date.now();
			callback.apply(self, arguments_);
		}

		/*
		 * If `debounceMode` is true (at begin) this is used to clear the flag
		 * to allow future `callback` executions.
		 */
		function clear() {
			timeoutID = undefined;
		}

		if (!noLeading && debounceMode && !timeoutID) {
			/*
			 * Since `wrapper` is being called for the first time and
			 * `debounceMode` is true (at begin), execute `callback`
			 * and noLeading != true.
			 */
			exec();
		}

		clearExistingTimeout();

		if (debounceMode === undefined && elapsed > delay) {
			if (noLeading) {
				/*
				 * In throttle mode with noLeading, if `delay` time has
				 * been exceeded, update `lastExec` and schedule `callback`
				 * to execute after `delay` ms.
				 */
				lastExec = Date.now();
				if (!noTrailing) {
					timeoutID = setTimeout(debounceMode ? clear : exec, delay);
				}
			} else {
				/*
				 * In throttle mode without noLeading, if `delay` time has been exceeded, execute
				 * `callback`.
				 */
				exec();
			}
		} else if (noTrailing !== true) {
			/*
			 * In trailing throttle mode, since `delay` time has not been
			 * exceeded, schedule `callback` to execute `delay` ms after most
			 * recent execution.
			 *
			 * If `debounceMode` is true (at begin), schedule `clear` to execute
			 * after `delay` ms.
			 *
			 * If `debounceMode` is false (at end), schedule `callback` to
			 * execute after `delay` ms.
			 */
			timeoutID = setTimeout(
				debounceMode ? clear : exec,
				debounceMode === undefined ? delay - elapsed : delay
			);
		}
	}

	wrapper.cancel = cancel;

	// Return the wrapper function.
	return wrapper;
}

export function Throttle(wait: number, options?: ThrottleOptions): MethodDecorator {
	return function (_target: Object, _propertyKey: string | symbol, descriptor: PropertyDescriptor) {
		const originalMethod = descriptor.value;
		const throttledMethod = throttle(wait, originalMethod, options);
		descriptor.value = throttledMethod;
		return descriptor;
	};
}