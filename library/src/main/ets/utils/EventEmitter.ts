/**
 * 订阅发布模式
 * 为啥不用鸿蒙的？
 * 怕和业务影响 因为鸿蒙自带的是用事件id区分的。。。
 */
class EventEmitter {
	//用于存储事件及其处理函数
	events = {};
	// 订阅事件
	on(event, id, listener) {
		if (!this.events[event]) {
			this.events[event] = []
		}
		this.events[event].push({
			id,
			listener
		})
	}
	// 取消订阅事件
	off(event, id) {
		if (!this.events[event]) {
			return
		}
		this.events[event] = this.events[event].filter(e => e.id != id)
	}
	// 发布事件
	emit(event, ...args) {
		if (!this.events[event]) {
			return
		}
		this.events[event].forEach(e => e.listener.apply(this, args))
	}
}
export const emitter = new EventEmitter()