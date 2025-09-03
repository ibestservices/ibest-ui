interface IBestSectorProgressColorType {
    bgColor: ResourceColor
    textColor: ResourceColor
}

export const IBestSectorProgressColor: IBestSectorProgressColorType = {
    bgColor: $r("app.color.ibest_sector_progress_background"),
    textColor: $r("app.color.ibest_sector_progress_text_color")
}