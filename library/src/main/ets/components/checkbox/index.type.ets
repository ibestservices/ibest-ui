import { CheckedItem } from '../checkboxGroup/store'

export interface MaxChangeArgs {
  max: number,
  checkedList: CheckedItem[]
}

export interface BuilderArgs {
  checked: boolean,
  disabled: boolean
}

export interface CustomerBuilderReturnData {
  onClick: (arg0: (event?: ClickEvent) => void) => void
}