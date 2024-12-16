interface IBestNavbarColorType {
    bgColor: ResourceColor
    textColor: ResourceColor
    subTitleColor: ResourceColor
    borderColor: ResourceColor
}

export const IBestNavbarColor: IBestNavbarColorType = {
    bgColor: $r("app.color.ibest_background_2"),
    textColor: $r("app.color.ibest_text_color"),
    subTitleColor: $r("app.color.ibest_text_color_2"),
    borderColor: $r("app.color.ibest_border_color")
}