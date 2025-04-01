interface IBestPaginationColorType {
    bgColor: ResourceColor
    activeBg: ResourceColor
    textColor: ResourceColor,
    activeTextColor: ResourceColor,
    itemDisabledColor: ResourceColor,
    itemDisabledBackground: ResourceColor,
    descColor: ResourceColor,
    borderColor: ResourceColor,
}

export const IBestPaginationColor: IBestPaginationColorType = {
    bgColor: $r("app.color.ibest_pagination_background"),
    activeBg: $r("app.color.ibest_pagination_active_background"),
    textColor: $r("app.color.ibest_pagination_text_color"),
    activeTextColor: $r("app.color.ibest_pagination_active_text_color"),
    itemDisabledColor: $r("app.color.ibest_pagination_item_disabled_color"),
    itemDisabledBackground: $r("app.color.ibest_pagination_item_disabled_background"),
    descColor: $r("app.color.ibest_pagination_desc_color"),
    borderColor: $r("app.color.ibest_pagination_border_color"),
}