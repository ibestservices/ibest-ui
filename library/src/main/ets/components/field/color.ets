interface IBestFieldColorType {
    labelColor: ResourceColor
    inputColor: ResourceColor
    placeholderColor: ResourceColor
    rightIconColor: ResourceColor
    borderColor: ResourceColor
    activeColor: ResourceColor
    bg2: ResourceColor
}

export const IBestFieldColor: IBestFieldColorType = {
    labelColor: $r("app.color.ibest_field_label_color"),
    inputColor: $r("app.color.ibest_field_input_color"),
    placeholderColor: $r("app.color.ibest_field_placeholder_color"),
    rightIconColor: $r("app.color.ibest_field_right_icon_color"),
    borderColor: $r("app.color.ibest_field_border_color"),
    activeColor: $r("app.color.ibest_field_active_color"),
    bg2: $r("app.color.ibest_field_background")
}