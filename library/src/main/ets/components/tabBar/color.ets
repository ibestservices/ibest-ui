interface IBestTabBarColorType {
    bdColor: ResourceColor
    bgColor: ResourceColor
    textColor: ResourceColor
}

export const IBestTabBarColor: IBestTabBarColorType = {
    bdColor: $r("app.color.ibest_border_color"),
    bgColor: $r("app.color.ibest_tabBar_background"),
    textColor: $r("app.color.ibest_tabBar_text_color")
}