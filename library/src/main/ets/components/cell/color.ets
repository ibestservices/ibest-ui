interface IBestCellColorType {
    titleColor: ResourceColor
    labelColor: ResourceColor
    valueColor: ResourceColor
    bgColor: ResourceColor
    activeBgColor: ResourceColor
    borderColor: ResourceColor
}

export const IBestCellColor: IBestCellColorType = {
    titleColor: $r("app.color.ibest_cell_title_color"),
    labelColor: $r("app.color.ibest_cell_label_color"),
    valueColor: $r("app.color.ibest_cell_value_color"),
    bgColor: $r("app.color.ibest_cell_background"),
    activeBgColor: $r("app.color.ibest_cell_active_color"),
    borderColor: $r("app.color.ibest_cell_border_color")
}