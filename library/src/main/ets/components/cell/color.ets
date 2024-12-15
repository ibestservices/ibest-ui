interface IBestCellColorType {
    titleColor: ResourceColor
    labelColor: ResourceColor
    valueColor: ResourceColor
}

export const IBestCellColor: IBestCellColorType = {
    titleColor: $r("app.color.ibest_text_color"),
    labelColor: $r("app.color.ibest_text_color_2"),
    valueColor: $r("app.color.ibest_text_color_2")
}