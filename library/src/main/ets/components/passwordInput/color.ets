interface IBestPasInputColorType {
    textColor: ResourceColor
    borderColor: ResourceColor
    bg: ResourceColor
}

export const IBestPasInputColor: IBestPasInputColorType = {
    textColor: $r("app.color.ibest_password_input_text_color"),
    borderColor: $r("app.color.ibest_password_input_border_color"),
    bg: $r("app.color.ibest_password_input_background")
}