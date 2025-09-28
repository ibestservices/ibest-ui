interface IBestSegmentedColorType{
    bgColor: ResourceColor
    inactiveTextColor: ResourceColor
    activeTextColor: ResourceColor
}

export const IBestSegmentedColor: IBestSegmentedColorType = {
    bgColor: $r("app.color.ibest_segmented_background"),
    inactiveTextColor: $r("app.color.ibest_segmented_inactive_text_color"),
    activeTextColor: $r("app.color.ibest_segmented_active_text_color")
}