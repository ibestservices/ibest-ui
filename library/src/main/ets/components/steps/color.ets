interface IBestStepsColorType {
    bgColor: ResourceColor,
    inactiveColor: ResourceColor,
    activeColor: ResourceColor,
    borderColor: ResourceColor
}

export const IBestStepsColor: IBestStepsColorType = {
    bgColor: $r("app.color.ibest_step_background_color"),
    inactiveColor: $r("app.color.ibest_step_text_color"),
    activeColor: $r("app.color.ibest_step_active_color"),
    borderColor: $r("app.color.ibest_border_color")
}