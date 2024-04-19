import { emitter } from '../../assets/ets/EventEmitter';
import { sleep } from '../../assets/ets/utils';
import { CheckedItem, initRadioGroupStore, removeRadioGroupStore } from './store';
import { getRadioGroupNamespace, RADIO_GROUP_EVENT_NAME } from './utils';


@Component
export struct IBestRadioGroup {
  /**
   * 多个相同群组名称的CheckboxGroup，仅第一个CheckboxGroup生效。
   */
  @Prop private group: string;
  // /**
  //  * 默认选中的
  //  */
  // @Prop value: string | number = undefined
  /**
   * 选中的数据
   */
  private checkedItem: CheckedItem | null = null;
  /**
   * 选中变化的回调
   * 参数是radio子组件的的name值
   */
  private onChange?: (radioName: string) => void;

  handleInitRadio(radioName: string | number){
    emitter.emit(getRadioGroupNamespace(this.group, RADIO_GROUP_EVENT_NAME.ON_INIT), radioName)
  }


  aboutToAppear() {
    this.initStorage();
    // 这时候子组件还没有初始化 需要等待子组件初始化
    // sleep().then(() => {
    //   // 设置默认选中项
    //   // this.handleInitRadio(this.value)
    // })
  }

  aboutToDisappear() {
    removeRadioGroupStore(this.group)
  }

  private initStorage() {
    initRadioGroupStore(this.group, (checkedItem) => {
      this.checkedItem = checkedItem;
      this.handleInitRadio(checkedItem?.name)
      typeof this.onChange === 'function' && this.onChange(checkedItem?.name)
    })
  }


  build() {

  }
}