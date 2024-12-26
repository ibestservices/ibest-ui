interface IBestCellGroupColorType {
    borderColor: ResourceColor,
    textColor: ResourceColor
}

export const IBestCellGroupColor: IBestCellGroupColorType = {
    borderColor: $r("app.color.ibest_border_color"),
    textColor: $r("app.color.ibest_text_color_2")
}