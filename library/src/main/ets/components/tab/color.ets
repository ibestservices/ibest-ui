interface IBestTabColorType {
    bgColor: ResourceColor
    activeTextColor: ResourceColor
}

export const IBestTabColor: IBestTabColorType = {
    bgColor: $r("app.color.ibest_background_2"),
    activeTextColor: $r("app.color.ibest_text_color")
}