interface IBestGuideColorType {
    bgColor: ResourceColor
    fontColor: ResourceColor
}

export const IBestGuideColor: IBestGuideColorType = {
    bgColor: $r("app.color.ibest_popover_background"),
    fontColor: $r("app.color.ibest_guide_text_color")
}