interface IBestPaginationColorType {
    bgColor: ResourceColor
    activeBg: ResourceColor
    textColor: ResourceColor
}

export const IBestPaginationColor: IBestPaginationColorType = {
    bgColor: $r("app.color.ibest_sidebar_background"),
    activeBg: $r("app.color.ibest_background_2"),
    textColor: $r("app.color.ibest_text_color"),
}