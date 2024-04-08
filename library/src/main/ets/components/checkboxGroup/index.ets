import { initCheckboxStore, removeCheckboxStore } from './store';


@Component
export struct IBestCheckboxGroup {
  localStorage: LocalStorage | null = null
  // @BuilderParam defaultBuilder: () => any  = null;
  //  猜测源码实现方式是使用一个统一池子管理
  /**
   * 多个相同群组名称的CheckboxGroup，仅第一个CheckboxGroup生效。
   */
  @Prop group: string;
  @Prop max:number = 1;

  aboutToAppear(){
    this.initStorage()
  }

  aboutToDisappear(){
    removeCheckboxStore(this.group)
  }

  initStorage(){
    initCheckboxStore(this.group, (checkedList)=>{
      console.log(JSON.stringify(checkedList))
    })
  }


  build(){

  }
}