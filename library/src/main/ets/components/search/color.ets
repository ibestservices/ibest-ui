interface IBestSearchColorType {
    outerBg: ResourceColor
    innerBg: ResourceColor
    labelColor: ResourceColor
    leftIconColor: ResourceColor
    textColor: ResourceColor
    activeBg: ResourceColor
}

export const IBestSearchColor: IBestSearchColorType = {
    outerBg: $r("app.color.ibest_search_outer_background"),
    innerBg: $r("app.color.ibest_search_inner_background"),
    labelColor: $r("app.color.ibest_search_label_color"),
    leftIconColor: $r("app.color.ibest_search_left_icon_color"),
    textColor: $r("app.color.ibest_text_color"),
    activeBg: $r("app.color.ibest_active_color")
}