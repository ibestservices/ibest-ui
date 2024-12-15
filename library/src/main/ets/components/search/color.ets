interface IBestSearchColorType {
    outerBg: ResourceColor
    innerBg: ResourceColor
    textColor: ResourceColor
    activeBg: ResourceColor
}

export const IBestSearchColor: IBestSearchColorType = {
    outerBg: $r("app.color.ibest_background_2"),
    innerBg: $r("app.color.ibest_background"),
    textColor: $r("app.color.ibest_text_color"),
    activeBg: $r("app.color.ibest_active_color")
}