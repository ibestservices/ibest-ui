interface IBestBadgeColorType {
    badgeBgColor: ResourceColor
    textColor: ResourceColor
}

export const IBestBadgeColor: IBestBadgeColorType = {
    badgeBgColor: $r("app.color.ibest_badge_background"),
    textColor: $r("app.color.ibest_badge_text_color")
}