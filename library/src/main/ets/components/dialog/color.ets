interface IBestDialogColorType{
    white: ResourceColor
    contentBg: ResourceColor
    titleColor: ResourceColor
    messageColor: ResourceColor
    textColor: ResourceColor
    cancelTextColor: ResourceColor
    borderColor: ResourceColor
    activeBg: ResourceColor
}

export const IBestDialogColor: IBestDialogColorType = {
    white: $r("app.color.ibest_white"),
    contentBg: $r("app.color.ibest_dialog_background"),
    titleColor: $r("app.color.ibest_dialog_title_color"),
    messageColor: $r("app.color.ibest_dialog_message_color"),
    textColor: $r("app.color.ibest_text_color"),
    cancelTextColor: $r("app.color.ibest_dialog_cancel_text_color"),
    borderColor: $r("app.color.ibest_dialog_border_color"),
    activeBg: $r("app.color.ibest_active_color")
}
