import { emitter } from '../../assets/ets/EventEmitter';
import { sleep } from '../../assets/ets/utils';
import { CheckedItem, initCheckboxStore, removeCheckboxStore } from './store';
import { CHECKBOX_GROUP_EVENT_NAME, getCheckboxNamespace } from './utils';

export interface CheckboxGroupContext {
  /**
   * 切换全选反选
   * @param { boolean } [isSelectedAll] 切换所有复选框，传 true 为选中，false 为取消选中，不传参为取反
   */
  toggleAll: (isSelectedAll?: boolean) => void
}

@Component
export struct IBestCheckboxGroup {
  /**
   * 多个相同群组名称的CheckboxGroup，仅第一个CheckboxGroup生效。
   */
  @Prop group: string;
  /**
   * 最大可选数量 默认0是都可选
   */
  @Prop @Watch('handleMaxChange') max: number = 0;
  /**
   * 选中的数据
   */
  checkedList: CheckedItem[] = [];
  /**
   * 选中变化的回调
   * 参数是checkbox子组件的的name值
   */
  onChange?: (checkedItemNames: string[]) => void;
  /**
   * 初始化的回调
   */
  onReady?: (checkboxGroupContext: CheckboxGroupContext) => void;
  /**
   * 子组件是否初始化了
   */
  isChildReady: boolean = false

  aboutToAppear() {
    this.initStorage();
    // 这时候子组件还没有初始化 需要等待子组件初始化
    sleep().then(() => {
      this.isChildReady = true
      this.handleMaxChange()
      typeof this.onReady === 'function' && this.onReady(this)
    })
  }

  aboutToDisappear() {
    removeCheckboxStore(this.group)
  }

  initStorage() {
    initCheckboxStore(this.group, (checkedList) => {
      this.checkedList = checkedList;
      this.handleMaxChange();
      typeof this.onChange === 'function' && this.onChange(checkedList.map(item => item.name))
    })
  }

  /**
   * 当最大数量变化时
   * 当选中的变化时
   * 通过emitter通知相同group的子组件更新disabled状态
   */
  handleMaxChange() {
    this.max > 0 && emitter.emit(getCheckboxNamespace(this.group, CHECKBOX_GROUP_EVENT_NAME.ON_MAX_CHANGE), {
      max: this.max,
      checkedList: this.checkedList
    })
  }

  /**
   * 全选与反选
   * @param {boolean} [isSelectAll] 切换所有复选框，传 true 为选中，false 为取消选中，不传参为取反
   */
  public async toggleAll(isSelectAll?: boolean) {
    emitter.emit(getCheckboxNamespace(this.group, CHECKBOX_GROUP_EVENT_NAME.ON_TOGGLE_ALL), isSelectAll)
  }

  build() {

  }
}