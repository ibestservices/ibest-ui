interface IBestBadgeColorType {
    textColor: ResourceColor
    borderColor: ResourceColor
}

export const IBestBadgeColor: IBestBadgeColorType = {
    textColor: $r("app.color.ibest_white"),
    borderColor: $r("app.color.ibest_background_2")
}