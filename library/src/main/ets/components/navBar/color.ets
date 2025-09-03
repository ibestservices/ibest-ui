interface IBestNavbarColorType {
    bgColor: ResourceColor
    textColor: ResourceColor
    subTitleColor: ResourceColor
    borderColor: ResourceColor
}

export const IBestNavbarColor: IBestNavbarColorType = {
    bgColor: $r("app.color.ibest_navbar_background"),
    textColor: $r("app.color.ibest_text_color"),
    subTitleColor: $r("app.color.ibest_navbar_sub_title_text_color"),
    borderColor: $r("app.color.ibest_navbar_border_color")
}