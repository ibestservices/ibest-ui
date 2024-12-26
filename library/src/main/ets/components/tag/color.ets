interface IBestTagColorType {
    textColor: ResourceColor
    whiteColor: ResourceColor
    blackColor: ResourceColor
    defaultBg: ResourceColor
}

export const IBestTagColor: IBestTagColorType = {
    textColor: $r("app.color.ibest_text_color"),
    whiteColor: $r("app.color.ibest_white"),
    blackColor: $r("app.color.ibest_black"),
    defaultBg: $r("app.color.ibest_background_2")
}