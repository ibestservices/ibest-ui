export interface CheckedItem  {
  name: string,
  checked: boolean
}

type ChangeFuc = (checkedList: CheckedItem[]) => void

interface CheckBoxStoreItem {
  checkedList: CheckedItem[],
  onChange: ChangeFuc
}

const checkboxStore: Record<string,  CheckBoxStoreItem | null> = {};

export function initCheckboxStore(key: string, onChange: ChangeFuc = () => {
}) {
  if (isCheckboxStoreHasSameKey(key)) {
    console.warn('具有相同的checkbox的group: ' + key)
    return
  }
  checkboxStore[key] = { checkedList: [], onChange }
}

export function removeCheckboxStore(key: string) {
  checkboxStore[key] = null
}

export function isCheckboxStoreHasSameKey(key: string) {
  return !!checkboxStore[key]
}

export function getCheckedListFromCheckboxStore(key: string) {
  return checkboxStore[key] || []
}


export function updateCheckboxStoreByKey(key: string, data: CheckedItem) {
  const checkedData = checkboxStore[key];
  if (!checkedData) {
    return
  }
  const checkedList = checkedData.checkedList;
  const onChange = checkedData.onChange
  if (Array.isArray(checkedList)) {
    const index = checkedList.findIndex(item => item.name === data.name);
    if (index > -1) {
      if(data.checked){
        checkedList[index].checked = true
      }else{
        checkedList.splice(index, 1)
      }
    } else {
      data.checked && checkedList.push(data)
    }
  }

  onChange(checkedList)

}