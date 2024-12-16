interface IBestPopoverColorType {
    bgColor: ResourceColor
    textColor: ResourceColor
    borderColor: ResourceColor
    activeBg: ResourceColor
}

export const IBestPopoverColor: IBestPopoverColorType = {
    bgColor: $r("app.color.ibest_background_2"),
    textColor: $r("app.color.ibest_text_color"),
    borderColor: $r("app.color.ibest_border_color"),
    activeBg: $r("app.color.ibest_active_color")
}