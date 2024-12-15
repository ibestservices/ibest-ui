interface IBestStepperColorType {
    bg: ResourceColor
    disabledBg: ResourceColor
    textColor: ResourceColor
    disabledTextColor: ResourceColor
}

export const IBestStepperColor: IBestStepperColorType = {
    bg: $r("app.color.ibest_active_color"),
    disabledBg: $r("app.color.ibest_background"),
    textColor: $r("app.color.ibest_text_color"),
    disabledTextColor: $r("app.color.ibest_text_color_3")
}