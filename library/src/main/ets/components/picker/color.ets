interface IBestPickerColorType {
    textColor: ResourceColor
    cancelTextColor: ResourceColor
    bgColor: ResourceColor
    borderColor: ResourceColor
}

export const IBestPickerColor: IBestPickerColorType = {
    textColor: $r("app.color.ibest_text_color"),
    cancelTextColor: $r("app.color.ibest_text_color_2"),
    bgColor: $r("app.color.ibest_background_2"),
    borderColor: $r("app.color.ibest_border_color")
}