interface IBestInputTagColorType {
    bgColor: ResourceColor
    tagBgColor: ResourceColor
    borderColor: ResourceColor
    tagFontColor: ResourceColor
    inputColor: ResourceColor
}

export const IBestInputTagColor: IBestInputTagColorType = {
    bgColor: $r("app.color.ibest_inputTag_bg_color"),
    tagBgColor: $r("app.color.ibest_inputTag_tag_bg_color"),
    borderColor: $r("app.color.ibest_border_color"),
    tagFontColor: $r("app.color.ibest_text_color_2"),
    inputColor: $r("app.color.ibest_text_color")
}