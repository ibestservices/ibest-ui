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
    contentBg: $r("app.color.ibest_action_sheet_background"),
    buttonBg: $r("app.color.ibest_action_sheet_item_background"),
    textColor: $r("app.color.ibest_text_color"),
    descriptionColor: $r("app.color.ibest_action_sheet_item_description_color"),
    disabledTextColor: $r("app.color.ibest_action_sheet_item_disabled_text_color"),
    borderColor: $r("app.color.ibest_action_sheet_border_color"),
    activeBg: $r("app.color.ibest_active_color"),
    whiteColor: $r("app.color.ibest_white")
}