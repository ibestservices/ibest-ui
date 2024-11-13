

/**
 * 订阅发布模式
 * 为啥不用鸿蒙的？
 * 怕和业务影响 因为鸿蒙自带的是用事件id区分的。。。
 */
class EventEmitter {
  //用于存储事件及其处理函数
  events = {};

  // 订阅事件
  on(event, listener) {
    if (!this.events[event]) {
      this.events[event] = [];
    }
    this.events[event].push(listener);
  }

  // 取消订阅事件
  off(event, listener) {
    if (!this.events[event]) return;
    this.events[event] = this.events[event].filter(l => l !== listener);
  }

  // 发布事件
  emit(event, ...args) {
    if (!this.events[event]) return;
    this.events[event].forEach(listener => listener.apply(this, args));
  }
}

export const emitter = new EventEmitter()

// 使用示例
// const emitter = new EventEmitter();
//
// // 订阅事件
// const listener1 = (name: string) => console.log(`Hello, ${name}!`);
// emitter.on('greet', listener1);
//
// // 再订阅一个事件
// const listener2 = (name: string) => console.log(`Goodbye, ${name}!`);
// emitter.on('greet', listener2);
//
// // 发布事件emitter.emit('greet', 'Alice');
//
// // 取消订阅listener1emitter.off('greet', listener1);
//
// // 再次发布事件，这次只有listener2会被调用emitter.emit('greet', 'Bob');