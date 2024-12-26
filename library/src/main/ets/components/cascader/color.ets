interface IBestCascaderColorType {
    textColor: ResourceColor
    bgColor: ResourceColor
}

export const IBestCascaderColor: IBestCascaderColorType = {
    textColor: $r("app.color.ibest_text_color"),
    bgColor: $r("app.color.ibest_cascader_background"),
}