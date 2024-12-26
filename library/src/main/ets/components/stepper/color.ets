interface IBestStepperColorType {
    bg: ResourceColor
    disabledBg: ResourceColor
    textColor: ResourceColor
    disabledTextColor: ResourceColor
}

export const IBestStepperColor: IBestStepperColorType = {
    bg: $r("app.color.ibest_stepper_background"),
    disabledBg: $r("app.color.ibest_stepper_disabled_background"),
    textColor: $r("app.color.ibest_text_color"),
    disabledTextColor: $r("app.color.ibest_stepper_disabled_text_color")
}