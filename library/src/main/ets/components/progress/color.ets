interface IBestProgressColorType {
    bgColor: ResourceColor
    textColor: ResourceColor
}

export const IBestProgressColor: IBestProgressColorType = {
    bgColor: $r("app.color.ibest_progress_background"),
    textColor: $r("app.color.ibest_text_color")
}