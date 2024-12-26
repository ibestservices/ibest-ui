interface IBestCircleProgressColorType {
    textColor: ResourceColor
    bgColor: ResourceColor
}

export const IBestCircleProgressColor: IBestCircleProgressColorType = {
    textColor: $r("app.color.ibest_circle_progress_text_color"),
    bgColor: $r("app.color.ibest_circle_progress_background")
}