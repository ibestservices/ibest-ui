interface IBestCollapseColorType {
    textColor: ResourceColor
    valueColor: ResourceColor
    bgColor: ResourceColor
    activeBg: ResourceColor
    borderColor: ResourceColor
}

export const IBestCollapseColor: IBestCollapseColorType = {
    textColor: $r("app.color.ibest_text_color"),
    valueColor: $r("app.color.ibest_text_color_2"),
    bgColor: $r("app.color.ibest_background_2"),
    activeBg: $r("app.color.ibest_active_color"),
    borderColor: $r("app.color.ibest_border_color")
}