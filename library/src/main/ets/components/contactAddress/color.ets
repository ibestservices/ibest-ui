interface IBestContactAddressColorType {
  labelColor: ResourceColor
  inputColor: ResourceColor
  placeholderColor: ResourceColor
}

export const IBestContactAddressColor: IBestContactAddressColorType = {
  labelColor: '#ff5d5d5d',
  inputColor: $r("app.color.ibest_field_input_color"),
  placeholderColor: $r("app.color.ibest_field_placeholder_color"),
}