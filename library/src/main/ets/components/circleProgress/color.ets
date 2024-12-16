interface IBestCircleProgressColorType {
    textColor: ResourceColor
    bgColor: ResourceColor
    whiteColor: ResourceColor
}

export const IBestCircleProgressColor: IBestCircleProgressColorType = {
    textColor: $r("app.color.ibest_text_color"),
    bgColor: $r("app.color.ibest_white"),
    whiteColor: $r("app.color.ibest_white")
}