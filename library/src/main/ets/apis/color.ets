interface IBestActionSheetColorType{
    contentBg: ResourceColor
    buttonBg: ResourceColor
    textColor: ResourceColor
    descriptionColor: ResourceColor
    disabledTextColor: ResourceColor
    borderColor: ResourceColor
    activeBg: ResourceColor
    whiteColor: ResourceColor
}

export const IBestActionSheetColor: IBestActionSheetColorType = {
    contentBg: $r("app.color.ibest_background"),
    buttonBg: $r("app.color.ibest_background_2"),
    textColor: $r("app.color.ibest_text_color"),
    descriptionColor: $r("app.color.ibest_text_color_2"),
    disabledTextColor: $r("app.color.ibest_text_color_3"),
    borderColor: $r("app.color.ibest_border_color"),
    activeBg: $r("app.color.ibest_active_color"),
    whiteColor: $r("app.color.ibest_white")
}