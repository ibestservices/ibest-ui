interface IBestDividerColorType {
    textColor: ResourceColor
    borderColor: ResourceColor
}

export const IBestDividerColor: IBestDividerColorType = {
    textColor: $r("app.color.ibest_text_color"),
    borderColor: $r("app.color.ibest_divider_border_color")
}