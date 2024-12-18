interface IBestRadioColorType {
    whiteColor: ResourceColor
    labelColor: ResourceColor
    checkedColor: ResourceColor
    disabledLabelColor: ResourceColor
    disabledIconColor: ResourceColor
    borderColor: ResourceColor
}

export const IBestRadioColor: IBestRadioColorType = {
    whiteColor: $r("app.color.ibest_white"),
    labelColor: $r("app.color.ibest_radio_label_color"),
    checkedColor: $r("app.color.ibest_radio_checked_color"),
    disabledLabelColor: $r("app.color.ibest_radio_disabled_label_color"),
    disabledIconColor: $r("app.color.ibest_radio_disabled_icon_color"),
    borderColor: $r("app.color.ibest_radio_border_color")
}