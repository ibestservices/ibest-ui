interface IBestDropdownMenuColorType {
    bgColor: ResourceColor
    textColor: ResourceColor
    borderColor: ResourceColor
    disabledColor: ResourceColor
}

export const IBestDropdownMenuColor: IBestDropdownMenuColorType = {
    bgColor: $r("app.color.ibest_dropdown_menu_bg_color"),
    textColor: $r("app.color.ibest_dropdown_menu_text_color"),
    borderColor: $r("app.color.ibest_dropdown_menu_border_color"),
    disabledColor: $r("app.color.ibest_dropdown_menu_disabled_color")
}