interface IBestPopupColorType {
    bgColor: ResourceColor
    titleColor: ResourceColor
    closeIconColor: ResourceColor
}

export const IBestPopupColor: IBestPopupColorType = {
    bgColor: $r("app.color.ibest_popup_background"),
    titleColor: $r("app.color.ibest_popup_title_color"),
    closeIconColor: $r("app.color.ibest_popup_close_icon_color")
}