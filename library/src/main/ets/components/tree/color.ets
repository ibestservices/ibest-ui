interface IBestTreeColorType {
    textColor: ResourceColor
    bgColor: ResourceColor
    activeBgColor: ResourceColor
}

export const IBestTreeColor: IBestTreeColorType = {
    textColor: $r("app.color.ibest_text_color"),
    bgColor: $r("app.color.ibest_tree_background"),
    activeBgColor: $r("app.color.ibest_tree_active_background")
}