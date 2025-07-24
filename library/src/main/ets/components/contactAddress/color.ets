interface IBestContactAddressColorType {
  bgColor: ResourceColor
  labelColor: ResourceColor
  inputColor: ResourceColor
  placeholderColor: ResourceColor
}

export const IBestContactAddressColor: IBestContactAddressColorType = {
  bgColor: $r("app.color.ibest_background_2"),
  labelColor: $r("app.color.ibest_text_color"),
  inputColor: $r("app.color.ibest_text_color"),
  placeholderColor: $r("app.color.ibest_text_color_3")
}