interface IBestPasInputColorType {
    textColor: ResourceColor
    borderColor: ResourceColor
    bg: ResourceColor
}

export const IBestPasInputColor: IBestPasInputColorType = {
    textColor: $r("app.color.ibest_text_color"),
    borderColor: $r("app.color.ibest_border_color"),
    bg: $r("app.color.ibest_background_2")
}