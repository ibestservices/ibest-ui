interface IBestFieldColorType {
    labelColor: ResourceColor
    inputColor: ResourceColor
    placeholderColor: ResourceColor
    rightIconColor: ResourceColor
    borderColor: ResourceColor
    activeColor: ResourceColor
    bgColor: ResourceColor
    prefixFontColor: ResourceColor,
    suffixFontColor: ResourceColor
}

export const IBestFieldColor: IBestFieldColorType = {
    labelColor: $r("app.color.ibest_field_label_color"),
    inputColor: $r("app.color.ibest_field_input_color"),
    placeholderColor: $r("app.color.ibest_field_placeholder_color"),
    rightIconColor: $r("app.color.ibest_field_right_icon_color"),
    borderColor: $r("app.color.ibest_field_border_color"),
    activeColor: $r("app.color.ibest_field_active_color"),
	bgColor: $r("app.color.ibest_field_background"),
    prefixFontColor: $r("app.color.ibest_field_prefix_font_color"),
    suffixFontColor: $r("app.color.ibest_field_suffix_font_color")
}