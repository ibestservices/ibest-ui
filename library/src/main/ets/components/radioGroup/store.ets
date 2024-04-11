export type CheckedItem = {
  name: string,
  checked: boolean
}

type ChangeFuc = (checkedList: CheckedItem) => void

const radioGroupStore: {
  [key: string]: {
    checkedItem: CheckedItem | null,
    onChange: ChangeFuc
  }
} = {};

export function initRadioGroupStore(key: string, onChange: ChangeFuc = () => {
}) {
  if (isRadioGroupStoreHasSameKey(key)) {
    console.warn('具有相同的Radio的group: ' + key)
    return
  }
  radioGroupStore[key] = { checkedItem: null, onChange }
}

export function removeRadioGroupStore(key: string) {
  delete radioGroupStore[key]
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
  const {onChange} = checkedData;
  checkedData.checkedItem = data.checked ? data : null
  onChange(checkedData.checkedItem)

}