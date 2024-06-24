export interface CheckedItem {
  name: string,
  checked: boolean
}

type ChangeFuc = (checkedList: CheckedItem) => void
interface CheckBoxStoreItem {
  checkedItem: CheckedItem | null,
  onChange: ChangeFuc
}
const radioGroupStore: Record<string, CheckBoxStoreItem | null> = {};

export function initRadioGroupStore(key: string, onChange: ChangeFuc = () => {
}) {
  if (isRadioGroupStoreHasSameKey(key)) {
    console.warn('具有相同的Radio的group: ' + key)
    return
  }
  radioGroupStore[key] = { checkedItem: null, onChange }
}

export function removeRadioGroupStore(key: string) {
   radioGroupStore[key] = null;
}

export function isRadioGroupStoreHasSameKey(key: string) {
  return !!radioGroupStore[key]
}

export function getCheckedListFromRadioGroupStore(key: string) {
  return radioGroupStore[key] || []
}


export function updateRadioGroupStoreByKey(key: string, data: CheckedItem) {
  const checkedData = radioGroupStore[key];
  if (!checkedData) {
    return
  }
  const onChange = checkedData.onChange;
  checkedData.checkedItem = data.checked ? data : null
  checkedData.checkedItem && onChange(checkedData.checkedItem)

}