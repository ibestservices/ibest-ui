interface IBestCardColorType {
    shadowColor: ResourceColor
    bgColor: ResourceColor
    titleFontColor: ResourceColor
    borderColor: ResourceColor
}

export const IBestCardColor: IBestCardColorType = {
    shadowColor: $r("app.color.ibest_card_shadow_color"),
    bgColor: $r("app.color.ibest_card_background_color"),
    titleFontColor: $r("app.color.ibest_card_title_font_color"),
    borderColor: $r("app.color.ibest_border_color")
}