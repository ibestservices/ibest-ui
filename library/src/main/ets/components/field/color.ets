interface IBestFieldColorType {
    labelColor: ResourceColor
    borderColor: ResourceColor
    activeColor: ResourceColor
    bg2: ResourceColor
}

export const IBestFieldColor: IBestFieldColorType = {
    labelColor: $r("app.color.ibest_text_color"),
    borderColor: $r("app.color.ibest_border_color"),
    activeColor: $r("app.color.ibest_active_color"),
    bg2: $r("app.color.ibest_background_2")
}