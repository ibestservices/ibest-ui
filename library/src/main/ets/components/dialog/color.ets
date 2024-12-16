interface IBestDialogColorType{
    white: ResourceColor
    contentBg: ResourceColor
    textColor: ResourceColor
    borderColor: ResourceColor
    activeBg: ResourceColor
}

export const IBestDialogColor: IBestDialogColorType = {
    white: $r("app.color.ibest_white"),
    contentBg: $r("app.color.ibest_background_2"),
    textColor: $r("app.color.ibest_text_color"),
    borderColor: $r("app.color.ibest_border_color"),
    activeBg: $r("app.color.ibest_active_color")
}
