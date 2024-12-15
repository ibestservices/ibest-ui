interface IBestCheckboxColorType {
    whiteColor: ResourceColor
    labelColor: ResourceColor
    disabledLabelColor: ResourceColor
    borderColor: ResourceColor
}

export const IBestCheckboxColor: IBestCheckboxColorType = {
    whiteColor: $r("app.color.ibest_white"),
    labelColor: $r("app.color.ibest_text_color"),
    disabledLabelColor: $r("app.color.ibest_text_color_3"),
    borderColor: $r("app.color.ibest_border_color")
}