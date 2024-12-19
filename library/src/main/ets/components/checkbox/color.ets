interface IBestCheckboxColorType {
    whiteColor: ResourceColor
    labelColor: ResourceColor
    disabledLabelColor: ResourceColor
    disabledIconColor: ResourceColor
    borderColor: ResourceColor
}

export const IBestCheckboxColor: IBestCheckboxColorType = {
    whiteColor: $r("app.color.ibest_white"),
    labelColor: $r("app.color.ibest_checkbox_label_color"),
    disabledLabelColor: $r("app.color.ibest_checkbox_disabled_label_color"),
    disabledIconColor: $r("app.color.ibest_checkbox_disabled_icon_color"),
    borderColor: $r("app.color.ibest_checkbox_border_color")
}