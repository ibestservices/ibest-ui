interface IBestTabColorType {
    bgColor: ResourceColor
    inactiveTextColor: ResourceColor
    activeTextColor: ResourceColor
}

export const IBestTabColor: IBestTabColorType = {
    bgColor: $r("app.color.ibest_tab_background"),
    inactiveTextColor: $r("app.color.ibest_tab_inactive_text_color"),
    activeTextColor: $r("app.color.ibest_tab_active_text_color")
}