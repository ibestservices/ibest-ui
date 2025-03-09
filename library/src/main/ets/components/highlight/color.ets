interface IBestHighlightColorType {
  textColor: ResourceColor
  highColor: ResourceColor
}

export const IBestHighlightColor: IBestHighlightColorType = {
  textColor: $r("app.color.ibest_text_color_2"),
  highColor: $r('app.color.ibest_primary_color')
}