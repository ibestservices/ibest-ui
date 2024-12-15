interface IBestPickerColorType {
    textColor: ResourceColor
    textColor2: ResourceColor
    bg2: ResourceColor
    borderColor: ResourceColor
}

export const IBestPickerColor: IBestPickerColorType = {
    textColor: $r("app.color.ibest_text_color"),
    textColor2: $r("app.color.ibest_text_color_2"),
    bg2: $r("app.color.ibest_background_2"),
    borderColor: $r("app.color.ibest_border_color")
}