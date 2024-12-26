interface IBestPickerGroupColorType {
    textColor: ResourceColor
    textColor2: ResourceColor
    bg2: ResourceColor
}

export const IBestPickerGroupColor: IBestPickerGroupColorType = {
    textColor: $r("app.color.ibest_text_color"),
    textColor2: $r("app.color.ibest_text_color_2"),
    bg2: $r("app.color.ibest_background_2")
}